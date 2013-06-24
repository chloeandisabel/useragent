class UserAgent
  module Browsers
    module All
      include Comparable

      def <=>(other)
        if respond_to?(:browser) && other.respond_to?(:browser) &&
            browser == other.browser
          version <=> other.version
        else
          false
        end
      end

      def eql?(other)
        self == other
      end

      def to_s
        to_str
      end

      def to_str
        join(" ")
      end

      def application
        first
      end

      def browser
        application.product
      end

      def version
        application.version
      end

      def platform
        nil
      end

      def os
        nil
      end

      def respond_to?(symbol)
        detect_product(symbol) ? true : super
      end

      def method_missing(method, *args, &block)
        detect_product(method) || super
      end

      def webkit?
        false
      end

      def mobile?
        if browser == 'webOS'
          true
        elsif platform == 'Symbian'
          true
        elsif detect_product('Mobile')
          true
        elsif application && application.comment &&
            application.comment.detect { |k, v| k =~ /^IEMobile/ }
          true
        else
          false
        end
      end
      
      def robot?
        !!(browser =~ /(google|bot|yahoo|spider|archiver|curl|python|nambu|twitt|perl|sphere|PEAR|java|wordpress|radian|crawl|yandex|eventbox|monitor|mechanize|facebookexternal|crawler)/i)
      end
      

      private
        def detect_product(product)
          detect { |useragent| useragent.product.to_s.downcase == product.to_s.downcase }
        end
    end
  end
end
