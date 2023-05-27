# frozen_string_literal: true

module CryptReboot
  RSpec.describe SafeTempDir do
    subject(:tempdir) do
      described_class.new(mounter: null_mounter)
    end

    let :null_mounter do
      ->(_, &block) { block.call }
    end

    def return_tempdir_ignoring_exceptions
      dir = nil
      begin
        tempdir.call do |new_dir|
          dir = new_dir
          yield
        end
      rescue StandardError
        # ignore
      end
      dir
    end


    it 'allows to create a file in temp dir' do
      tempdir.call do |dir|
        file_path = File.join(dir, 'test.txt')
        File.open(file_path, 'w') {}
        expect(File).to exist(file_path)
      end
    end

    it 'removes the dir after block finishes' do
      dir = tempdir.call { |new_dir| new_dir }
      expect(File).not_to exist(dir)
    end

    it 'propagates exception' do
      expect do
        tempdir.call do
          raise StandardError
        end
      end.to raise_error(StandardError)
    end

    it 'ensures the dir is removed in case of exception' do
      dir = return_tempdir_ignoring_exceptions do
        raise StandardError
      end
      expect(File).not_to exist(dir)
    end
  end
end
