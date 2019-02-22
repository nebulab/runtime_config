# frozen_string_literal: true

module RuntimeConfig
  class ConfParam
    attr_reader :conf, :exec, :opt, :parent

    def initialize(opt, parent, conf, exec = nil)
      @opt = opt
      @parent = parent
      @conf = conf
      @exec = exec
    end

    def set(value)
      @parent.send("#{@conf}=", value) if @parent
      @exec.call(value) if @exec
    end
  end
end
