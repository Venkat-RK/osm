$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'osm'
require 'minitest/autorun'

module TestHelper
  include Osm

  def setup
  end

  def teardown
  end

  def tmp_objects_config_file_path
    "#{File.dirname(__FILE__)}/test_data/objects.yml"
  end
end
