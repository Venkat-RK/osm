require_relative "osm/version"
require_relative "osm/config"
require_relative 'osm/osr'
require_relative 'osm/ost'

module Osm
  class ObjectStateManager
    include Osr, Ost

    def self.record_objects(file_path: "")
      ObjectStateRecorder.record_object_states(file_path: file_path)
    end

    def self.search_object_state(args: {})
      ObjectStateTracker.track(args)
    end
  end
end
