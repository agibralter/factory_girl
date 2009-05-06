require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Factory, "callbacks" do

  before(:each) do
    @model_proxy = 'model-proxy'
    stub(@model_proxy).some_method { :some_result }
    stub(@model_proxy).another_method
  end

  describe "a factory callback" do

    before(:each) do
      @proc = Proc.new do |model|
        res = model.some_method
        model.another_method(res)
      end
      @callback = Factory::Callback.new(:after_save, @proc)
    end
    
    it "execute methods in the proc" do
      mock(@model_proxy).some_method { "COOL!" }
      mock(@model_proxy).another_method("COOL!")
      @callback.execute(@model_proxy)
    end

  end

  it "convert names to symbols for after_save" do
    Factory::Callback.new('after_save', nil).name.should == :after_save
  end

  it "convert names to symbols for before_save" do
    Factory::Callback.new('before_save', nil).name.should == :before_save
  end

  it "raise an error when not 1 of 2 types" do
    lambda {
      Factory::Callback.new('some_bad_type', nil)
    }.should raise_error(Factory::CallbackDefinitionError)
  end

end
