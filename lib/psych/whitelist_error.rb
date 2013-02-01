require 'psych/syntax_error'

module Psych
  class WhitelistError < Error

    attr_reader :class_name

    attr_reader :whitelist

    def initialize(class_name,whitelist)
      message = "%p was not included in the whitelist" % class_name

      @class_name = class_name
      @whitelist  = whitelist
      super(message)
    end

  end
end
