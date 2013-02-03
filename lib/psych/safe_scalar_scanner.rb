require 'psych/scalar_scanner'
require 'psych/whitelisted'

module Psych
  class SafeScalarScanner < ScalarScanner

    include Whitelisted

    # Whitelist of Scalar Classes
    attr_reader :whitelist

    def initialize whitelist = nil
      super()
      @whitelist = whitelist
    end

    def parse_symbol string
      whitelist_symbol string
    end

  end
end
