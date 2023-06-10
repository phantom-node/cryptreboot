# frozen_string_literal: true

module CryptReboot
  # Hash-like class allowing to assign value only once to a list of allowed keys
  class SingleAssignRestrictedMap
    AlreadyAssigned = Class.new StandardError

    def []=(field, value)
      raise AlreadyAssigned, "Value already assigned for `#{field}` field" if data.key? field

      data[field] = value
    end

    def to_h
      data
    end

    private

    attr_reader :data

    def initialize
      @data = {}
    end
  end
end
