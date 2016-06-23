require_relative 'object_class_generator'

module Osm
  module Osr
    class ObjectStateRecorder

      class << self
        def record_object_states(file_path: '')
          raise ArgumentError, "File not found at #{file_path}" unless File.exists?(file_path)
          raise ArgumentError, "Configuration file is missing" unless File.exists?(Config.objects_config_file_path)
          perform(file_path)
        end

        private
          def perform(file_path)
            #Note : Right now support is added for single file so clear the db
            RedisDB.flushdb
            #TODO : Add support to accommodate multiple files
            File.open(file_path, 'r') do |f|
              f.each_line do |l|
                object_state = ObjectState.new(l)
                object_state.save
              end
            end
            process_object_states
          end

          def process_object_states
           RedisDB.keys.each do |key|
             class_name = key.split('_').first.to_s
             if class_name && ObjectClassGenerator.get_class_names.include?(class_name.to_sym)
               sorted_set = Redis::SortedSet.new(key, :marshal => true)
               last_object = nil #In case of multiple files fetch last object from first file
               sorted_set.members(:with_scores => true).each do |object_with_score|
                 object, score = object_with_score
                 unless last_object.nil?
                   sorted_set.delete(object)
                   updated_object = object.update(last_object)
                   sorted_set[updated_object] = score
                 end
                 last_object = object
               end
             end
           end
         end
      end
    end

    class ObjectState

      attr_reader :object_id, :object_type, :timestamp, :object_changes

      def initialize(record)
        file_format = Osm::InputFileFormat
        fields = record.strip.split(file_format[:fields_seperator])
        field_keys = file_format[:fields].keys

        field_types = fields.slice!(0..(field_keys.count - 2))
        object_string = fields.join(',')
        object_hash = eval(object_string)
        object_hash = object_hash.deep_symbolize_keys

        object_fields = file_format[:fields].invert.deep_symbolize_keys

        @object_id = field_types[object_fields[:object_id]]
        @object_type = field_types[object_fields[:object_type]]
        @timestamp = field_types[object_fields[:timestamp]]
        @object_changes = object_hash
      end

      def save
        object_class_format = ObjectClassGenerator.get_object_class_format
        fields = object_class_format[:classes][@object_type.to_sym]

        args = { id: @object_id }

        fields.each_with_index do |f, index|
          next if index == 0
          args.merge!(f => @object_changes[f.to_sym])
        end

        data_object = ObjectClassGenerator.const_get(@object_type.to_s).new(args)

        key = "#{@object_type}_#{@object_id}"
        rank = @timestamp.to_i

        sorted_set = Redis::SortedSet.new(key, :marshal => true)
        sorted_set[data_object] = rank
      end
    end
  end
end
