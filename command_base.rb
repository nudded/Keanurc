class CommandBase
  class << self
    attr_accessor :params
    def params
      @params ||= {}
    end
  end
end
