require_relative 'object_class_generator'

module Osm
  module Ost
    class ObjectStateTracker

      class << self
        def track(args = {})
          args = args.deep_symbolize_keys
          validate_input(args)
          key = "#{args[:object_type]}_#{args[:object_id]}"
          sorted_set = Redis::SortedSet.new(key, :marshal => true)
          to = args[:to] || args[:from]
          result = sorted_set.rangebyscore(args[:from].to_i, to.to_i)
          puts result.inspect
          result
        end

        private
          def validate_input(args = {})
            allowed_keys = [:object_type, :object_id, :from, :to, :limit ]
            required_keys = [:object_type, :object_id, :from]
            optonal_keys  = [:to, :limit]

            input_keys = args.keys
            valid_object_types = ObjectClassGenerator.get_class_names
            raise ArgumentError, "Input fields are missing, required fields : #{required_keys}" if input_keys.count == 0
            raise ArgumentError, "Wrong number of input fields, required fields : #{required_keys}" if input_keys.count < required_keys.count
            raise ArgumentError, "Wrong number of input fields, allowed fields : #{allowed_keys}" if input_keys.count > allowed_keys.count
            raise ArgumentError, "Missing required input fields, required fields : #{required_keys}" if (required_keys - input_keys).count >= 1
            raise ArgumentError, "Invalid object_type value, valid values : #{valid_object_types}" unless valid_object_types.include?(args[:object_type].to_sym)
          end
      end
    end
  end
end
