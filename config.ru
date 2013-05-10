require 'sinatra'
require 'active_record'
require 'fileutils'
require 'rack-flash'

database = YAML.load_file(File.join('./config','database.yml'))
ActiveRecord::Base.establish_connection(database['assets_to'])

require "./main"

run Sinatra::Application
