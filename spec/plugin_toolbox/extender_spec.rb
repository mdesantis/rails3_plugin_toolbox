require 'spec_helper'

def extend_unknown
  Rails3::PluginExtender.new do
    extend_rails :unknown do
      with MyAddition
    end
  end     
end  

describe Rails3::PluginExtender do
  describe '#extend_rails' do
    it "should NOT extend Unknown" do
      lambda { extend_unknown }.should raise_error    
    end
    
    it "should extend Active Record" do
      Rails3::PluginExtender.new do
        extend_rails :AR do
          with MyAddition
      
          after :initialize do
            MyAddition.say 'record me!'
          end      
        end
      end
    
      # Initialize the rails application
      Minimal::Application.initialize!    
    
      ActiveRecord::Base.instance_methods.grep(/zzz/).should_not be_empty
    
      MyAddition.heard.should == 'record me!'
    end     
  end
end