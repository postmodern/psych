require 'psych/helper'

module Psych
  class TestSafeScalarScanner < TestCase
    attr_reader :ss

    def setup
      super
      @ss = SafeScalarScanner.new(['Integer', 'String'])
    end

    def test_scan_symbol
      ex = assert_raises(WhitelistError) do
        ss.tokenize(':foo')
      end

      assert_equal 'Symbol', ex.class_name
    end

  end
end
