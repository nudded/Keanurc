class CommandBase

  attr_accessor :sender

  class << self
    attr_accessor :params
    def params
      @params ||= {}
    end
  end

end
