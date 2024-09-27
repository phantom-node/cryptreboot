# frozen_string_literal: true

module CryptReboot
  # Generate patch (files hash) from files in a directory containing uncompressed initramfs
  class ZfsKeystorePatcher
    def call(dir)
      crypttab_entries = entries_generator.call
      return {} if crypttab_entries.empty?

      files_generator
        .call(crypttab_entries, base_dir: dir, crypttab_path: tmp_crypttab_path)
        .merge(script_patch_files(dir))
    end

    private

    def script_patch_files(dir)
      path = File.join(dir, script_path)
      content = File.read(path)
      { script_path => patch_script(content) }
    rescue Errno::ENOENT
      {}
    end

    def patch_script(script)
      comment = '# Following line has been added by cryptreboot'
      patch = "cp #{tmp_crypttab_path} #{crypttab_path}"
      script.sub(/^(\s*)(\${CRYPTROOT})\s*$/, "\n\\1#{comment}\n\\1#{patch}\n\n\\1\\2")
    end

    attr_reader :crypttab_path, :tmp_crypttab_path, :script_path,
                :entries_generator, :files_generator

    def initialize(crypttab_path: '/cryptroot/crypttab',
                   tmp_crypttab_path: '/cryptreboot/zfs_crypttab',
                   script_path: '/scripts/zfs',
                   entries_generator: CryptTab::ZfsKeystoreEntriesGenerator.new,
                   files_generator: FilesGenerator.new)
      @crypttab_path = crypttab_path
      @tmp_crypttab_path = tmp_crypttab_path
      @script_path = script_path
      @entries_generator = entries_generator
      @files_generator = files_generator
    end
  end
end
