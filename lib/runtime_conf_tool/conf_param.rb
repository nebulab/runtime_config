# frozen_string_literal: true

module RuntimeConfTool
  class ConfParam
    attr_reader :conf, :opt, :parent

    def initialize(opt, parent, conf)
      @opt = opt
      @parent = parent
      @conf = conf
    end

    def set(value)
      @parent.send "#{@conf}=", value
    end
  end
end
