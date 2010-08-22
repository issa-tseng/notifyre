begin
  # use already-installed bundle
  require ::File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  # apparently we haven't bundled yet.
  require 'rubygems'
  require 'bundler'
  Bundler.setup
end

require 'model/connection_manager'
require 'notifyre'

use Rack::Session::Cookie, :secret => 'uW6kntnyhzJ7QGHdZFwoS0la7i2irxqryhTr8JQ6gWiOqwHZEONumLsgX8SEfMG'
use ConnectionManager

use Rack::Static, :urls => ['/images', '/javascripts', '/styles'], :root => 'public'

use Warden::Manager do |manager|
  manager.default_strategies :notifyre_user
  manager.failure_app = Notifyre
end

run Notifyre

