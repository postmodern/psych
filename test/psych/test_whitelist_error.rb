# coding: US-ASCII
require 'psych/helper'
require 'psych/whitelist_error'

module Psych
  class TestWhitelistError < TestCase

    def setup
      super

      @whitelist = %w[Integer String Array]
    end

    def test_initialize
      name = 'Object'
      ex   = WhitelistError.new(name,@whitelist)

      assert_equal ex.class_name, name
      assert_equal ex.whitelist,  @whitelist
      assert_equal ex.message, '"Object" was not included in the whitelist'
    end

    def test_should_escape_class_name
      ex = WhitelistError.new("evil\nuser\ninput",@whitelist)

      assert_equal ex.message,
                   '"evil\nuser\ninput" was not included in the whitelist'
    end

  end
end
