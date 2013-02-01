require 'psych/whitelist_error'

module Psych
  module Whitelisted
    # The default whitelist of class names to allow
    DEFAULT_WHITELIST = %w[
      NilClass TrueClass FalseClass
      Numeric Integer Fixnum Bignum Float
      Rational Complex Range
      String
      Regexp
      Time Date DateTime
      Array Hash
    ]

    # The whitelist of class names
    attr_reader :whitelist

    #
    # Returns +true+ if the Class +name+ is in the whitelist.
    #
    def whitelisted?(name)
      @whitelist.nil? or @whitelist.include?(name)
    end

    private

    #
    # Controls whether Symbols are allowed to be created.
    #
    def whitelist_symbol(string)
      if whitelisted?('Symbol')
        string.to_sym
      else
        raise(WhitelistError.new('Symbol',@whitelist))
      end
    end

    #
    # Controls whether a Class name is allowed to be resolved.
    #
    def whitelist_class(name)
      if whitelisted?(name)
        name
      else
        raise(WhitelistError.new(name,@whitelist))
      end
    end
  end
end
