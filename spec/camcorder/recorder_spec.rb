require 'spec_helper'


describe Camcorder::Recorder do
  
  subject{ Camcorder::Recorder.new(filename) }
  
  describe '.transaction' do
    
    let(:key) { 'key' }
    
    context 'when recording exists' do
      
      let(:filename) { 'spec/fixtures/should_exist.yml'}
      
      it 'should return recorded value' do
        subject.transaction do
          result = subject.record 'key' do
            raise 'should not get here'
          end
          expect(result).to eq('dis be da result')
        end
      end
      
      it 'should error on unknown key' do
        expect {
          subject.transaction do
            result = subject.record 'another-key' do
              raise 'should not get here'
            end
          end
        }.to raise_error
      end
      
    end
    
    context 'when no recording exists' do
      
      let(:filename) { 'spec/fixtures/should_not_exist.yml'}
      
      after do
        File.delete(filename)
      end
      
      it 'should create recording' do
        
        expect(File.exists?(filename)).to be_false
        subject.transaction do
          subject.record 'key' do
            'dis be da result'
          end
        end
        expect(File.exists?(filename)).to be_true
        
      end
      
    end
    
  end
  
end
