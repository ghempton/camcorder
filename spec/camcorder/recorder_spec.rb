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
            # Manually recorded
            'dis be da result'
            #raise 'should not get here'
          end
          expect(result).to eq('dis be da result')
        end
      end

      context 'when recordings with same key return different results' do

        after { File.delete(filename) }

        let(:filename) { 'spec/fixtures/bad_verification.yml'}

        it 'raises' do
          expect {
            subject.transaction do
              subject.record 'key' do
                'dis be da result'
              end
              subject.record 'key' do
                'dis be a diff result'
              end
            end
          }.to raise_error(Camcorder::RecordingError)
        end

        context 'when verify_recordings: false' do

          before { Camcorder.config.verify_recordings = false }
          after { Camcorder.config.verify_recordings = true }

          it 'does not raise' do
            expect {
              subject.transaction do
                subject.record 'key' do
                  'dis be da result'
                end
                subject.record 'key' do
                  'dis be a diff result'
                end
              end
            }.to_not raise_error
          end

        end


        context 'when verify_recordigs is a proc' do
          before { Camcorder.config.verify_recordings = -> (a,b) { a.value[0..3] == b.value[0..3] } }
          after { Camcorder.config.verify_recordings = true }

          it 'does not raise' do
            expect {
              subject.transaction do
                subject.record 'key' do
                  'dis be da result'
                end
                subject.record 'key' do
                  'dis be a diff result'
                end
              end
            }.to_not raise_error
          end

        end

      end

      it 'should error on unknown key' do
        expect {
          subject.transaction do
            subject.record 'another-key' do
              raise 'should not get here'
            end
          end
        }.to raise_error(Camcorder::PlaybackError)
      end

    end

    context 'when block raises' do

      let(:filename) { 'spec/fixtures/haz_errorz.yml'}

      it 'should reraise from recording' do
        expect {
          subject.transaction do
            subject.record 'key-with-error' do
              # Manually recorded
              raise StandardError.new('errorz')
            end
          end
        }.to raise_error(StandardError)
      end

    end

    context 'when no recording exists' do

      let(:filename) { 'spec/fixtures/should_not_exist.yml'}

      after do
        File.delete(filename)
      end

      it 'should create recording' do

        expect(File.exists?(filename)).to be_falsey
        subject.transaction do
          subject.record 'key' do
            'dis be da result'
          end
        end
        expect(File.exists?(filename)).to be_truthy

      end

    end

  end

end
