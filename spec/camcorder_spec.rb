require 'spec_helper'

describe Camcorder do
  
  describe 'constructor interception' do
    
    before do
      Camcorder.intercept_constructor(TestObject)
    end
    
    after do
      Camcorder.deintercept_constructor(TestObject)
    end
    
    describe '.new' do
    
      it 'should return a proxy' do
        obj = TestObject.new
        expect(obj).to be_a(Camcorder::Proxy)
        expect(obj.simple_method).to eql(['A', 'B', 'C'])
      end
      
    end
    
    context 'with multiple classes' do
      
      before do
        Camcorder.intercept_constructor(TestObject2)
      end
      
      after do
        Camcorder.deintercept_constructor(TestObject2)
      end
      
      describe '.new' do
      
        it 'should return proxies' do
          obj = TestObject.new
          obj2 = TestObject2.new(2)
          
          expect(obj2).to be_a(Camcorder::Proxy)
          expect(obj2.simple_method).to eql([1, 2, 3])
          
          expect(obj).to be_a(Camcorder::Proxy)
          expect(obj.simple_method).to eql(['A', 'B', 'C'])
        end
        
      end
      
    end
    
  end
  
  describe '.use recordings' do
    it 'should return a proxy' do
      Camcorder.use_recordings(TestObject, 'use_recordings_should_return_a_proxy') do
        obj = TestObject.new
        expect(obj).to be_a(Camcorder::Proxy)
      end
    end
    
    it 'should have recorder set' do
      Camcorder.use_recordings(TestObject, 'use_recordings_should_have_recorder_set') do
        obj = TestObject.new
        expect(obj.recorder).to be_a(Camcorder::Recorder)
      end
    end
  end
end
