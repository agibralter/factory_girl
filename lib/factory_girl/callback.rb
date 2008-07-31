class Factory

  class CallbackDefinitionError < RuntimeError
  end
  
  class Callback #:nodoc:

    attr_reader :name

    def initialize (name, proc)
      @name = name.to_sym
      raise CallbackDefinitionError unless @name == :after_save || @name == :before_save
      @proc = proc
    end

    def execute(model_instance)
      @proc.call(model_instance)
    end

  end

end
