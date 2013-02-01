require 'psych/helper'

module Psych
  class TestScalarScannerWithWhitelist < TestCase
    attr_reader :ss

    def setup
      super
      @ss = Psych::WhitelistedScalarScanner.new(['Integer', 'String'])
    end

    def test_scan_symbol
      ex = assert_raises(WhitelistError) do
        ss.tokenize(':foo')
      end

      assert_equal 'Symbol', ex.class_name
    end

  end
end
