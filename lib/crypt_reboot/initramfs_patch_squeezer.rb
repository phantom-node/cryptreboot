# frozen_string_literal: true

module CryptReboot
  # Transform initramfs image into a patch (files hash)
  class InitramfsPatchSqueezer
    def call(initramfs_path)
      extractor.call(initramfs_path) do |tmp_dir|
        main_files(tmp_dir).merge zfs_files(tmp_dir)
      end
    end

    private

    def main_files(tmp_dir)
      full_crypttab_path = File.join(tmp_dir, crypttab_path)
      crypttab_entries = crypttab_deserializer.call(full_crypttab_path)
      files_generator.call(crypttab_entries, base_dir: tmp_dir, crypttab_path: crypttab_path)
    end

    def zfs_files(tmp_dir)
      crypttab_entries = zfs_keystore_entries_generator.call
      return {} if crypttab_entries.empty?
      files = files_generator.call(crypttab_entries, base_dir: tmp_dir, crypttab_path: zfs_crypttab_path)
      script_path = File.join(tmp_dir, zfs_script_path)
      script = File.read(script)
      files.merge(zfs_script_path => patch_zfs_script(script))
    end

    def patch_zfs_script(script)
      patch = "cp #{zfs_crypttab_path} #{crypttab_path}; ${CRYPTROOT}"
      script.sub(/^\s*\${CRYPTROOT}\s*$/, patch)
    end

    attr_reader :crypttab_path, :zfs_crypttab_path, :zfs_script_path, :extractor,
                :crypttab_deserializer, :zfs_keystore_entries_generator, :files_generator

    # rubocop:disable Metrics/ParameterLists
    def initialize(crypttab_path = '/cryptroot/crypttab',
                   zfs_crypttab_path = '/cryptreboot/zfs_crypttab',
                   zfs_script_path = '/scripts/zfs',
                   extractor: Initramfs::Extractor.new,
                   crypttab_deserializer: CryptTab::Deserializer.new,
                   zfs_keystore_entries_generator: CryptTab::ZfsKeystoreEntriesGenerator.new,
                   files_generator: FilesGenerator.new)
      @crypttab_path = crypttab_path
      @zfs_crypttab_path = zfs_crypttab_path
      @zfs_script_path = zfs_script_path
      @extractor = extractor
      @crypttab_deserializer = crypttab_deserializer
      @zfs_keystore_entries_generator = zfs_keystore_entries_generator
      @files_generator = files_generator
    end
    # rubocop:enable Metrics/ParameterLists
  end
end
