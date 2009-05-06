class Factory
  class Proxy #:nodoc:
    class Create < Build #:nodoc:
      def initialize(klass)
        @instance = klass.new
        @callbacks = {
          :before_save => [],
          :after_save => []
        }
      end

      def result
        @callbacks[:before_save].each { |c| c.execute(@instance) }
        @instance.save!
        @callbacks[:after_save].each { |c| c.execute(@instance) }
        @instance
      end

      def add_callback(name, callback)
        @callbacks[name] << callback
      end
    end
  end
end
