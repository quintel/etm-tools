# frozen_string_literal: true

module CPScenario
  Input = Struct.new(:key, :unit, :min, :max, :default, :user) do
    # Inputs units whose values should not be scaled.
    UNSCALEABLE_UNITS = %w[
      %
      COP
      degC
      dollar
      euro
      euro/kWh
      gCO2/KWh
      hours
      kWh
      kg
      m^2K/W
      x
    ].freeze

    # Public: Create a new Input with data from the ETEngine API.
    #
    # For example:
    #
    #   Input.from_api(code: 'abc', min: 0, max: 100, ...)
    #
    # Returns an Input.
    def self.from_api(data)
      data = data.transform_keys(&:to_sym)
      from_hash(data.merge(key: data[:code]))
    end

    # Public: Create a new Input with data from a hash.
    #
    # For example:
    #
    #   Input.from_hash(key: 'abc', min: 0, max: 100, ...)
    #
    # Returns an Input.
    def self.from_hash(data)
      new(*data.values_at(*members))
    end

    # Public: The user value, bounded by the input min and max.
    #
    # A user value larger than the max will return the max instead, and smaller
    # than the min will return the min.
    #
    # Returns a numeric, or nil if no user value is set.
    def user_bounded
      return nil if user.nil?

      if user > max
        max
      elsif user < min
        min
      else
        user
      end
    end

    # Public: Returns if the input value should be scaled.
    #
    # Returns true or false.
    def scaleable?
      !UNSCALEABLE_UNITS.include?(unit)
    end
  end
end
