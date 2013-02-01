# coding: US-ASCII
require 'psych/helper'

module Psych
  module Visitors
    class TestWhitelistedToRuby < TestCase
      def setup
        super
        @visitor = WhitelistedToRuby.new
      end

      def test_initialize_with_true
        visitor = WhitelistedToRuby.new(true)

        assert_equal visitor.whitelist, WhitelistedToRuby::DEFAULT_WHITELIST
      end

      def test_initialize_with_array_of_classes
        visitor = WhitelistedToRuby.new([String, Integer, Array])

        assert_equal visitor.whitelist, %w[String Integer Array]
      end

      def test_initialize_with_array_of_strings
        ex = assert_raises(TypeError) do
          WhitelistedToRuby.new(['evil', 'user', 'input'])
        end

        assert_match '"evil" must be a Class or Module', ex.message
      end

      def test_initialize_with_other
        ex = assert_raises(TypeError) do
          WhitelistedToRuby.new(Object.new)
        end

        assert_equal 'whitelist must be true or an Array', ex.message
      end

    end

    class TestWhitelistedToRubyWithDefaultWhitelist < TestCase

      def setup
        super
        WhitelistedToRuby.class_eval { public :resolve_class }
        @visitor = WhitelistedToRuby.new(true)
      end

      def teardown
        WhitelistedToRuby.class_eval { private :resolve_class }
      end

      def test_resolve_class_with_numeric
        assert_equal Numeric, @visitor.resolve_class('Numeric')
      end

      def test_resolve_class_with_integer
        assert_equal Integer, @visitor.resolve_class('Integer')
      end

      def test_resolve_class_with_fixnum
        assert_equal Fixnum, @visitor.resolve_class('Fixnum')
      end

      def test_resolve_class_with_bignum
        assert_equal Bignum, @visitor.resolve_class('Bignum')
      end

      def test_resolve_class_with_float
        assert_equal Float, @visitor.resolve_class('Float')
      end

      def test_resolve_class_with_rational
        assert_equal Rational, @visitor.resolve_class('Rational')
      end

      def test_resolve_class_with_complex
        assert_equal Complex, @visitor.resolve_class('Complex')
      end

      def test_resolve_class_with_range
        assert_equal Range, @visitor.resolve_class('Range')
      end

      def test_resolve_class_with_string
        assert_equal String, @visitor.resolve_class('String')
      end

      def test_resolve_class_with_regexp
        assert_equal Regexp, @visitor.resolve_class('Regexp')
      end

      def test_resolve_class_with_time
        assert_equal Time, @visitor.resolve_class('Time')
      end

      def test_resolve_class_with_date
        assert_equal Date, @visitor.resolve_class('Date')
      end

      def test_resolve_class_with_date_time
        assert_equal DateTime, @visitor.resolve_class('DateTime')
      end

      def test_resolve_class_with_array
        assert_equal Array, @visitor.resolve_class('Array')
      end

      def test_resolve_class_with_hash
        assert_equal Hash, @visitor.resolve_class('Hash')
      end

      def test_resolve_class_with_unknown_class_name
        assert_raises(WhitelistError) do
          @visitor.resolve_class('Kernel')
        end
      end

      def test_ruby_symbol
        ex = assert_raises(WhitelistError) do
          Psych.safe_load('--- !ruby/symbol evil')
        end

        assert_equal 'Symbol', ex.class_name
      end

    end

    class TestWhitelistedToRubyWithCustomWhitelist < TestCase

      Struct.new('MyStruct',:x, :y)

      def setup
        super
        WhitelistedToRuby.class_eval { public :resolve_class }

        @whitelist = [String, Hash, Struct::MyStruct]
        @visitor   = WhitelistedToRuby.new(@whitelist)
      end

      def teardown
        WhitelistedToRuby.class_eval { private :resolve_class }
      end

      def test_resolve_class_with_whitelisted_class_name
        assert_equal String, @visitor.resolve_class('String')
        assert_equal Hash, @visitor.resolve_class('Hash')
        assert_equal Struct::MyStruct, @visitor.resolve_class('MyStruct')
      end

      def test_resolve_class_with_unknown_class_name
        assert_raises(WhitelistError) do
          @visitor.resolve_class('Float')
        end
      end

      def test_struct
        yaml = "--- !ruby/struct:MyStruct\n  x: 1\n  y: 2\n"

        ex = assert_raises(WhitelistError) do
          Psych.safe_load(yaml,nil,@whitelist)
        end

        assert_equal 'Symbol', ex.class_name
      end

      def test_anonymous_struct
        yaml = "--- !ruby/struct\nx: 1\ny: 2\n"

        ex = assert_raises(WhitelistError) do
          Psych.safe_load(yaml,nil,@whitelist)
        end

        assert_equal 'Symbol', ex.class_name
      end

    end
  end
end
