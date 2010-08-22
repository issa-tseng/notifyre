begin
  # use already-installed bundle
  bundle_path = (ENV['RACK_ENV'] == 'development') ? '.bundle/environment' : '../.bundle/environment';
  require ::File.expand_path(bundle_path, __FILE__)
rescue LoadError
  # apparently we haven't bundled yet.
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

require 'rubygems'
require 'lib/connection_manager'
require 'notifyre'
require 'sinatra'
require 'warden'
require 'warden_notifyre'

use Rack::Session::Cookie, :secret => 'uW6kntnyhzJ7QGHdZFwoS0la7i2irxqryhTr8JQ6gWiOqwHZEONumLsgX8SEfMG'
use Rack::ConnectionManager

use Rack::Static, :urls => ['/images', '/javascripts', '/styles'], :root => 'public'

use Warden::Manager do |manager|
  manager.default_strategies :notifyre_user
  manager.failure_app = Notifyre
end

run Notifyre

