module CPScenario
  class Scaler
    def initialize(inputs, scaling_factor)
      @inputs = inputs
      @scaling_factor = scaling_factor
    end

    def inputs
      @inputs.map do |input|
        if input.scaleable?
          attrs = input.to_h
          attrs[:user] *= @scaling_factor

          Input.from_hash(attrs)
        else
          input.dup
        end
      end
    end
  end
end
