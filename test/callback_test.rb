require(File.join(File.dirname(__FILE__), 'test_helper'))

class CallbackTest < Test::Unit::TestCase

  def setup
    @model_proxy = mock('model-proxy')
    @model_proxy.stubs(:some_method).returns(:some_result)
    @model_proxy.stubs(:another_method)
  end

  context "a factory callback" do

    setup do
      @proc = Proc.new do |model|
        res = model.some_method
        model.another_method(res)
      end
      @callback = Factory::Callback.new(:after_save, @proc)
    end
    
    should "execute methods in the proc" do
      @model_proxy.expects(:some_method).returns("COOL!")
      @model_proxy.expects(:another_method).with("COOL!")
      @callback.execute(@model_proxy)
    end

  end

  should "convert names to symbols for after_save" do
    assert_equal :after_save, Factory::Callback.new('after_save', nil).name
  end
  
  should "convert names to symbols for before_save" do
    assert_equal :before_save, Factory::Callback.new('before_save', nil).name
  end
    
  
  should "raise an error when not 1 of 2 types" do
    assert_raise Factory::CallbackDefinitionError do
      Factory::Callback.new('some_bad_type', nil)
    end
  end

end
