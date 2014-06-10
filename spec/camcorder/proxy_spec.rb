require 'spec_helper'


describe Camcorder::Proxy do
  
  subject{ Camcorder::Proxy.new(Camcorder.default_recorder, TestObject) }
  
  context 'when recording exists' do
  
    it 'should not call methods on actual instance' do
      
      expect_any_instance_of(TestObject).to_not receive(:simple_method)
      expect(subject.simple_method).to eql(['A', 'B', 'C'])
      
    end
    
    it 'should re-raise recorded errors' do
      
      expect_any_instance_of(TestObject).to_not receive(:broke_method)
      expect{subject.broke_method}.to raise_error(StandardError)
      
    end
    
  end
  
  context 'when recording does not exist' do
    
    after(:all) do
      File.delete('spec/recordings/Camcorder_Proxy/when_recording_does_not_exist/should_call_methods_on_actual_instance_and_record.yml')
    end
    
    it 'should call methods on actual instance and record' do
      
      expect_any_instance_of(TestObject).to receive(:simple_method).and_call_original
      expect(subject.simple_method).to eql(['A', 'B', 'C'])
      
    end
    
  end
  
  
  describe '.methods_with_side_effects' do
    
    subject {
      Class.new(Camcorder::Proxy) do
        methods_with_side_effects :method_with_side_effects
      end.new(Camcorder.default_recorder, TestObject)
    }
    
    it 'should re-record for each invocation' do
      
      a = subject.method_with_side_effects
      b = subject.method_with_side_effects
      expect(a).to_not eq(b)
      
    end
    
    
  end
  
  
  
end
