# frozen_string_literal: true

module CryptReboot
  module Luks
    class Dumper
      # Parse LUKS2
      class LuksV2Parser
        ParsingError = Class.new StandardError

        def call(lines)
          data = parse_lines(lines)
          instantiate(data.to_h)
        end

        private

        def instantiate(args)
          data_class.new(**args)
        rescue ArgumentError => e
          raise ParsingError, 'Parsing failed because of missing data', cause: e
        end

        def parse_lines(lines)
          map_generator.call.tap do |result|
            section_found = false
            lines.each do |line|
              if section_found
                break if line =~ /^\w/

                update_result!(result, line: line)
              end
              line =~ /^Data segments:/ && section_found = true
            end
          end
        end

        def update_result!(result, line:)
          case line
          when /offset:\s+(\d+) \[bytes\]/
            result[:offset] = Regexp.last_match(1).to_i
          when /cipher:\s+([\w-]+)$/
            result[:cipher] = Regexp.last_match(1)
          when /sector:\s+(\d+) \[bytes\]/
            result[:sector_size] = Regexp.last_match(1).to_i
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
