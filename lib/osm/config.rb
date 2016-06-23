require "redis"
require "redis-objects"
require 'connection_pool'
require 'active_support'
require 'active_support/core_ext'
require 'yaml'
require_relative 'object_class_generator'

module Osm
  module Config
    mattr_accessor :redis_host, :redis_port, :redis_db, :connection_pool_size, :connection_pool_timeout

    @@objects_config_file_path = ''

    def self.objects_config_file_path=(file_path)
      raise ArgumentError, "File not found at #{file_path}" unless File.exists?(file_path)

      @@objects_config_file_path = file_path
      ObjectClassGenerator.generate_classes
    end

    def self.objects_config_file_path
      @@objects_config_file_path
    end
  end

  InputFileFormat = YAML.load_file(File.expand_path('config/input_file_format.yml', File.dirname(__FILE__)) ).deep_symbolize_keys

  RedisDB = Redis.new(:host =>  (Config.redis_host || '127.0.0.1'), :port => (Config.redis_port || 6379), :db => (Config.redis_db || 2))
  Redis::Objects.redis = ConnectionPool.new(size: (Config.connection_pool_size || 5), timeout: (Config.connection_pool_timeout || 5)) { RedisDB }
end


