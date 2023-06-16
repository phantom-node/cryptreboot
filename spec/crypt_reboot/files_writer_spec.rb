# frozen_string_literal: true

require 'tmpdir'

module CryptReboot
  RSpec.describe FilesWriter do
    subject(:writer) { described_class.new }

    let :files_spec do
      {
        'file1' => 'contents1',
        'dir1/dir2/file2' => 'contents2',
        'dir1/file3' => 'contents3',
        'file4' => 'contents4'
      }
    end

    let :expected_files do
      [
        '.',
        './file4',
        './file1',
        './dir1',
        './dir1/dir2',
        './dir1/dir2/file2',
        './dir1/file3'
      ]
    end

    it 'creates directory structure and files' do
      Dir.mktmpdir do |dir|
        writer.call(files_spec, dir)
        expect(`cd #{dir}; find`.split("\n")).to match_array(expected_files)
      end
    end

    it 'creates a file with content' do
      Dir.mktmpdir do |dir|
        writer.call({ 'file.txt' => 'my content' }, dir)
        content = File.read(File.join(dir, 'file.txt'))
        expect(content).to eq('my content')
      end
    end
  end
end
