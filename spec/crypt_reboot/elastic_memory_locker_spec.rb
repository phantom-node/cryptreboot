# frozen_string_literal: true

module CryptReboot
  RSpec.describe ElasticMemoryLocker do
    subject :locker do
      described_class.new(insecure_memory_checker: -> { insecure_memory },
                          loader: loader,
                          load_error: load_error,
                          locker: real_locker,
                          lazy_locking_error: -> { locking_error })
    end

    let(:insecure_memory) { false }
    let(:loader) { spy }
    let(:load_error) { LoadError }
    let(:real_locker) { spy }
    let(:locking_error) { LocalJumpError }

    context 'when locking is disabled' do
      let(:insecure_memory) { true }

      it 'does not load real locker' do
        locker.call
        expect(loader).not_to have_received(:call)
      end

      it 'does not call real locker' do
        locker.call
        expect(real_locker).not_to have_received(:call)
      end
    end

    context 'when memory_locker is available' do
      context 'when memory_locker works' do
        it 'loads real locker' do
          locker.call
          expect(loader).to have_received(:call)
        end

        it 'calls real locker' do
          locker.call
          expect(real_locker).to have_received(:call)
        end
      end

      context 'when memory_locker does not work' do
        let :real_locker do
          -> { raise locking_error }
        end

        it 'raises exception' do
          expect do
            locker.call
          end.to raise_error(
            an_instance_of(described_class::LockingError).and(having_attributes(cause: locking_error))
          )
        end
      end
    end

    context 'when memory_locker is not available' do
      let :loader do
        -> { raise load_error }
      end

      it 'raises exception' do
        expect do
          locker.call
        end.to raise_error(
          an_instance_of(described_class::LockingError).and(having_attributes(cause: load_error))
        )
      end
    end
  end
end
