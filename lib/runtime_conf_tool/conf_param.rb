# frozen_string_literal: true

module RuntimeConfTool
  class ConfParam
    attr_reader :exec, :conf, :opt, :parent

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
