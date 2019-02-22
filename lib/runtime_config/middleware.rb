# frozen_string_literal: true

module RuntimeConfig
  LOGGER_SEVERITY = %w[debug info warn error fatal unknown].freeze # https://github.com/ruby/ruby/blob/trunk/lib/logger.rb

  class Middleware
    def initialize(app, options = {})
      @app = app
      @params = {
        assets_logs: ConfParam.new(:assets_logs, Rails.configuration.assets, :quiet),
        catch_errors: ConfParam.new(:catch_errors, Rails.configuration, :consider_all_requests_local),
        filter_logs: ConfParam.new(:filter_logs, nil, :filter_logs, ->(value) {
          regexp = Regexp.new value, Regexp::IGNORECASE
          Rails.logger = ActiveSupport::Logger.new STDOUT
          Rails.logger.formatter = proc do |_severity, _time, _progname, msg|
            "#{msg}\n" if msg =~ regexp
          end
        }),
        verbose_query_logs: ConfParam.new(:verbose_query_logs, Rails.configuration.active_record, :verbose_query_logs),
      }
      @options = (options || {}).symbolize_keys
      @options[:path] ||= '/dev'

      Rails.configuration.after_initialize do
        params_load.each do |k, v|
          @params[k.to_sym].set v
        end
        params_reset
      end
    end

    def call(env)
      req = Rack::Request.new(env)
      return @app.call(env) unless req.path == @options[:path]

      restart = false
      @actions = []
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
      if req.params.include? 'catch_errors'
        params_save(@params[:catch_errors], req.params['catch_errors'] == '1')
        @actions.push "catch_errors: #{req.params['catch_errors'] == '1'}"
        restart = true
      end
      if req.params.include? 'cache_clear'
        Rails.cache.clear
        @actions.push "cache_clear: #{req.params['cache_clear'] == '1'}"
        restart = true
      end
      if req.params.include? 'filter_logs'
        params_save(@params[:filter_logs], req.params['filter_logs'].strip)
        @actions.push "filter logs: #{req.params['filter_logs'].strip}"
        restart = true
      end
      if req.params.include? 'verbose_query_logs'
        params_save(@params[:verbose_query_logs], req.params['verbose_query_logs'] == '1')
        @actions.push "verbose_query_logs: #{req.params['verbose_query_logs'] == '1'}"
        restart = true
      end
      restart = true if req.params.include? 'restart'
      if restart
        restart_server
        @actions.push 'Restarting server'
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
      JSON.parse Rails.root.join('tmp', '_runtime_config.txt').read
    rescue StandardError
      {}
    end

    def params_reset
      Rails.root.join('tmp', '_runtime_config.txt').unlink
    rescue StandardError
      nil
    end

    def params_save(param, value)
      Rails.root.join('tmp', '_runtime_config.txt').open('w') do |f|
        f.puts({ param.opt => value }.to_json)
      end
    end

    def restart_server
      Rails.application.load_tasks
      Rake::Task['restart'].invoke
    end
  end
end
