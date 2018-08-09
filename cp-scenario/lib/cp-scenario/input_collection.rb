require 'forwardable'

module CPScenario
  # Stores all inputs for a scenario/dataset, including those with no user value
  # assigned.
  class InputCollection
    include Enumerable
    extend Forwardable

    def_delegator :@inputs, :each

    def initialize(array)
      @inputs = array
      @by_key = Hash[array.map { |input| [input.key, input] }]
    end

    def get(key)
      @by_key[key]
    end

    # Public: Takes an array of inputs and assigns the value of the inputs to
    # this collection.
    #
    # Returns self.
    def assign(new_inputs)
      new_inputs.each { |input| get(input.key).user = input.user }
      self
    end

    def user_values
      UserValues.new(@inputs.reject { |input| input.user.nil? })
    end

    def dup
      new(@inputs.map(&:dup))
    end
  end

  # Stores a list of inputs which have a custom user value. Serializes as a
  # hash of {key=>user_value} when converted to JSON.
  class UserValues < Array
    def to_h
      each_with_object({}) do |input, data|
        data[input.key] = input.user_bounded
      end
    end

    def to_json(*)
      to_h.to_json
    end
  end
end
