#!/usr/bin/ruby
require 'puppet'
require 'yaml'
require 'rugged'

config = YAML.load_file("../conf/config.yml")
