require 'osm'
require 'sidekiq'

include Osm
Config.objects_config_file_path= "#{File.dirname(__FILE__)}/config/objects.yml"

class OsmWorker
  include Sidekiq::Worker

  def perform(file_path)
    ObjectStateManager.record_objects(file_path: file_path)
  end
end
