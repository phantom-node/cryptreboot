# frozen_string_literal: true

module CryptReboot
  module Luks
    class Dumper
      # Parse LUKS1
      class LuksV1Parser
        ParsingError = Class.new StandardError

        def call(lines)
          data = parse_lines(lines)
          instantiate(data.to_h)
        end

        private

        SECTOR_SIZE = 512 # LUKS1 support only this sector size
        private_constant :SECTOR_SIZE

        def instantiate(raw)
          data_class.new(
            cipher: [raw.fetch(:cipher_name), raw.fetch(:cipher_mode)].join('-'),
            offset: raw.fetch(:offset),
            sector_size: SECTOR_SIZE
          )
        rescue KeyError => e
          raise ParsingError, 'Parsing failed because of missing data', cause: e
        end

        def parse_lines(lines)
          map_generator.call.tap do |result|
            lines.each do |line|
              update_result!(result, line: line)
            end
          end
        end

        def update_result!(result, line:)
          case line
          when /^Cipher name:\s+([\w-]+)$/
            result[:cipher_name] = Regexp.last_match(1)
          when /^Cipher mode:\s+([\w-]+)$/
            result[:cipher_mode] = Regexp.last_match(1)
          when /^Payload offset:\s+(\d+)$/
            # LUKS1 provides offset in sectors
            result[:offset] = Regexp.last_match(1).to_i * SECTOR_SIZE
          end
        rescue duplicate_exception => e
          raise ParsingError, "Parsing failed on: `#{line}`", cause: e
        end

        attr_reader :data_class, :map_generator, :duplicate_exception

        def initialize(data_class: Data,
                       map_generator: -> { SingleAssignRestrictedMap.new },
                       duplicate_exception: SingleAssignRestrictedMap::AlreadyAssigned)
          @data_class = data_class
          @map_generator = map_generator
          @duplicate_exception = duplicate_exception
        end
      end
    end
  end
end
