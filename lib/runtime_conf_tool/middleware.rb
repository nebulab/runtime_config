# frozen_string_literal: true

module RuntimeConfTool
  LOGGER_SEVERITY = %w[debug info warn error fatal unknown].freeze # https://github.com/ruby/ruby/blob/trunk/lib/logger.rb

  # The middleware
  class Middleware
    def initialize(app, options = {})
      @app = app
      @params = {
        catch_errors:       ConfParam.new(:catch_errors, Rails.configuration, :consider_all_requests_local),
        assets_logs:        ConfParam.new(:assets_logs, Rails.configuration.assets, :quiet),
        verbose_query_logs: ConfParam.new(:verbose_query_logs, Rails.configuration.active_record, :verbose_query_logs),
      }
      @options = (options || {}).symbolize_keys
      @options[:path] ||= '/dev'
      Rails.configuration.after_initialize do
        params_load.each { |k, v| @params[k.to_sym].set v }
        params_reset
      end
    end

    def call(env)
      req = Rack::Request.new(env)
      return @app.call(env) unless req.path == @options[:path]

      @actions = []
      if req.params.include? 'restart'
        restart_server
        @actions.push 'Restarting server'
      end
      if LOGGER_SEVERITY.include?((req.params['log'] || '').downcase)
        level = "Logger::#{req.params['log'].upcase}"
        Rails.logger.level = level.constantize
        @actions.push "Logger level set to: #{level}"
      end
      if req.params.include? 'cache'
        Rails.application.load_tasks
        Rake::Task['dev:cache'].invoke
        @actions.push 'Invoked dev:cache'
      end
      # if req.params.include? 'assets_logs' # NOTE: not working
      #   # Rails.configuration.assets.quiet = false
      #   params_save(@params[:assets_logs], req.params['assets_logs'] == '1')
      #   @actions.push "assets_logs: #{req.params['assets_logs'] == '1'}"
      #   restart_server
      # end
      if req.params.include? 'catch_errors'
        params_save(@params[:catch_errors], req.params['catch_errors'] == '1')
        @actions.push "catch_errors: #{req.params['catch_errors'] == '1'}"
        restart_server
      end
      if req.params.include? 'cache_clear'
        Rails.cache.clear
        @actions.push "cache_clear: #{req.params['cache_clear'] == '1'}"
      end
      if req.params.include? 'verbose_query_logs'
        params_save(@params[:verbose_query_logs], req.params['verbose_query_logs'] == '1')
        @actions.push "verbose_query_logs: #{req.params['verbose_query_logs'] == '1'}"
        restart_server
      end

      [
        200,
        { 'Content-Type' => 'text/html' },
        [ERB.new(
          File.read(
            File.join(File.dirname(__FILE__), 'conf.html.erb')
          )
        ).result(binding)]
      ]
    end

    private

    def params_load
      JSON.parse Rails.root.join('tmp', '_runtime_conf_tool.txt').read
    rescue StandardError
      {}
    end

    def params_reset
      Rails.root.join('tmp', '_runtime_conf_tool.txt').unlink
    rescue StandardError
      nil
    end

    def params_save(param, value)
      Rails.root.join('tmp', '_runtime_conf_tool.txt').open('w') do |f|
        f.puts({ param.opt => value }.to_json)
      end
    end

    def restart_server
      FileUtils.touch Rails.root.join('tmp', 'restart.txt').to_s
    end
  end
end
