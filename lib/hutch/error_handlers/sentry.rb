require 'hutch/logging'
require 'raven'

module Hutch
  module ErrorHandlers
    class Sentry
      include Logging

      def initialize
        unless Raven.respond_to?(:capture_exception)
          raise "The Hutch Sentry error handler requires Raven >= 0.4.0"
        end
      end

      def handle(properties, payload, consumer, ex)
        message_id = properties.message_id
        prefix = "message(#{message_id || '-'}):"
        logger.error "#{prefix} Logging event to Sentry"
        logger.error "#{prefix} #{ex.class} - #{ex.message}"
        Raven.capture_exception(ex, extra: { payload: payload })
      end
    end
  end
end
