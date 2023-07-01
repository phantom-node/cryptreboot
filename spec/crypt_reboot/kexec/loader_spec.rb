# frozen_string_literal: true

module CryptReboot
  module Kexec
    RSpec.describe Loader do
      subject(:loader) do
        described_class.new(lazy_tool: -> { 'kexec' }, runner: runner)
      end

      let(:runner) { spy }

      let(:boot_config_obj) { BootConfig.new(**boot_config) }

      context 'with kernel only' do
        context 'with custom command line' do
          let :boot_config do
            { kernel: 'kernel', cmdline: 'cmdline' }
          end

          it 'executes kexec with correct arguments' do
            loader.call(boot_config_obj)
            expect(runner).to have_received(:call).with('kexec', '-al', 'kernel', '--append', 'cmdline')
          end
        end

        context 'without custom command line' do
          let :boot_config do
            { kernel: 'kernel' }
          end

          it 'executes kexec with correct arguments' do
            loader.call(boot_config_obj)
            expect(runner).to have_received(:call).with('kexec', '-al', 'kernel', '--reuse-cmdline')
          end
        end
      end

      context 'with kernel and initramfs' do
        context 'with custom command line' do
          let :boot_config do
            { kernel: 'kernel', initramfs: 'initramfs', cmdline: 'cmdline' }
          end

          it 'executes kexec with correct arguments' do
            loader.call(boot_config_obj)
            expect(runner).to have_received(:call).with('kexec', '-al', 'kernel', '--initrd',
                                                        'initramfs', '--append', 'cmdline')
          end
        end

        context 'without custom command line' do
          let :boot_config do
            { kernel: 'kernel', initramfs: 'initramfs' }
          end

          it 'executes kexec with correct arguments' do
            loader.call(boot_config_obj)
            expect(runner).to have_received(:call).with('kexec', '-al', 'kernel', '--initrd',
                                                        'initramfs', '--reuse-cmdline')
          end
        end
      end
    end
  end
end
