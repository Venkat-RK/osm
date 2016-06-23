require 'yaml'
require 'active_support'
require 'active_support/core_ext'

module Osm
  module ObjectClassGenerator

    class Base
      attr_accessor :object_changes

      def update(other_object)
        other_object_hash = other_object.to_hash
        other_object_hash.delete(:object_changes)
        current_object_hash = self.to_hash

        new_changes = current_object_hash.delete_if { |key, value| value.to_s.strip == '' }
        updated_object_hash = other_object_hash.merge(new_changes)
        new_changes.delete(:id)

        updated_object_hash = updated_object_hash.merge({:object_changes => new_changes})

        updated_object_hash.keys.each do |key|
          self.instance_variable_set("@#{key.to_s}", updated_object_hash[key])
        end
        self
      end

      def to_hash
        hash = {}
        instance_variables.each {|var| hash[var.to_s.delete("@").to_sym] = instance_variable_get(var) }
        hash
      end
    end

    class << self
      def get_object_class_format
        YAML.load_file(Osm::Config.objects_config_file_path).deep_symbolize_keys unless Osm::Config.objects_config_file_path.blank?
      end

      def get_classes_with_attr
        @object_class_format ||= get_object_class_format || {}
        @object_class_format[:classes] || {}
      end

      def get_class_names
        get_classes_with_attr.keys
      end

      def generate_classes
        ObjectClassGenerator.get_classes_with_attr.each do |name, attributes|
          fields = Hash[attributes.zip []]
          klass = object_class(fields)
          ObjectClassGenerator.const_set name, klass
        end
      end

      def object_class(fields)
        names = fields.keys

        Class.new((Base)) do
          attr_accessor *names

          define_method :initialize do |fields|
            fields.each { |name, value| instance_variable_set("@#{name}", value) }
          end
        end
      end      
    end    
  end
end

