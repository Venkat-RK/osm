require 'test_helper'

class OsmTest < Minitest::Test
  include TestHelper

  def test_that_it_has_a_version_number
    refute_nil ::Osm::VERSION
  end

  def test_osm_input_file_format
    assert_instance_of(Hash, InputFileFormat, "InputFileFormat should be an Instance of Hash")
    assert_equal(',', InputFileFormat[:fields_seperator], "Failed as#{InputFileFormat[:fields_seperator]} != ','")
    assert_equal(4, InputFileFormat[:fields].keys.count, "Failed as #{InputFileFormat[:fields].keys.count} != '4'")
    assert_equal(%w(object_id object_type timestamp object_changes), InputFileFormat[:fields].values, "invalid field names #{ InputFileFormat[:fields].values}")
  end

  def test_objects_config_file_path_settings
    Config.objects_config_file_path = tmp_objects_config_file_path
    assert_equal(tmp_objects_config_file_path, Config.objects_config_file_path)

    assert_raises { Config.objects_config_file_path = '/sample_path' }
  end

  def test_redis_configuration
    redis_host = 'sample',
    redis_port = 6380,
    redis_db   = 5
    Config.redis_host = redis_host
    Config.redis_db = redis_db
    Config.redis_port = redis_port
    assert_equal(redis_host, Config.redis_host)
    assert_equal(redis_db, Config.redis_db)
    assert_equal(redis_port, Config.redis_port)
  end

  def test_connection_pool_configuration
    connection_pool_size = 6
    connection_pool_timeout = 6

    Config.connection_pool_size = connection_pool_size
    Config.connection_pool_timeout = connection_pool_timeout
    assert_equal(connection_pool_size, Config.connection_pool_size)
    assert_equal(connection_pool_timeout, Config.connection_pool_timeout)
  end

  def test_osm_methods_presence
    assert_respond_to(ObjectStateManager, :record_objects)
    assert_respond_to(ObjectStateManager, :search_object_state)

    assert_respond_to(Osr::ObjectStateRecorder, :record_object_states)

    assert_respond_to(ObjectClassGenerator, :get_object_class_format)
    assert_respond_to(ObjectClassGenerator, :get_classes_with_attr)
    assert_respond_to(ObjectClassGenerator, :get_class_names)
    assert_respond_to(ObjectClassGenerator, :generate_classes)
    assert_respond_to(ObjectClassGenerator, :object_class)
    assert_respond_to(Ost::ObjectStateTracker, :track)
  end
end
