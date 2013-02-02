require 'psych/visitors/to_ruby'
require 'psych/whitelisted'
require 'psych/whitelisted_scalar_scanner'

module Psych
  module Visitors
    class WhitelistedToRuby < ToRuby
      include Whitelisted

      def initialize whitelist = true
        case whitelist
        when true
          @whitelist = DEFAULT_WHITELIST
        when Array
          @whitelist = whitelist.map do |klass|
            case klass
            when Class, Module
              klass.name
            else
              raise(TypeError,"#{klass.inspect} must be a Class or Module")
            end
          end
        else
          raise(TypeError,"whitelist must be true or an Array")
        end

        super(WhitelistedScalarScanner.new(@whitelist))
      end

      private

      def revive_symbol string
        whitelist_symbol string
      end

      def resolve_tag tag
        if klass = super(tag) and whitelist_class(klass.name)
          klass 
        end
      end

      def resolve_class klassname
        klass = super(klassname)

        if klass and whitelist_class(klass.name)
          klass
        end
      end

    end
  end
end
