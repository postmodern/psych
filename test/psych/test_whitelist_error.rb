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

      assert_equal name, ex.class_name
      assert_equal @whitelist, ex.whitelist
      assert_equal '"Object" was not included in the whitelist', ex.message
    end

    def test_should_escape_class_name
      ex = WhitelistError.new("evil\nuser\ninput",@whitelist)

      assert_equal '"evil\nuser\ninput" was not included in the whitelist',
                   ex.message
                   
    end

  end
end
