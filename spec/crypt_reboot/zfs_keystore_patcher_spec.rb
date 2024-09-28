# frozen_string_literal: true

module CryptReboot
  RSpec.describe ZfsKeystorePatcher do
    subject(:patcher) do
      described_class.new entries_generator: entries_generator, files_generator: files_generator
    end

    let :entries_generator do
      -> { [double] }
    end

    let :files_generator do
      ->(*_, **_) { { '/cryptreboot/zfs_crypttab' => '# Dummy file' } }
    end

    let :expected_patch do
      {
        '/cryptreboot/zfs_crypttab' => '# Dummy file',
        # rubocop:disable Layout/LineContinuationLeadingSpace
        '/scripts/zfs' => "# Simplified ZFS boot script\n" \
                          "CRYPTROOT=/scripts/local-top/cryptroot\n" \
                          "if [ true ]\n" \
                          "\n" \
                          "  # Following line has been added by cryptreboot\n" \
                          "  cp /cryptreboot/zfs_crypttab /cryptroot/crypttab\n" \
                          "\n" \
                          "  ${CRYPTROOT}\n" \
                          "fi\n"
        # rubocop:enable Layout/LineContinuationLeadingSpace
      }
    end

    it do
      patch = patcher.call('spec/fixtures/extracted_initramfs/zfs_keystore')
      expect(patch).to eq(expected_patch)
    end
  end
end
