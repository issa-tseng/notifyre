require 'rubygems'
require 'sinatra'

class Notifyre < Sinatra::Base

  get '/' do
    erb :index
  end

  get '/update' do
    socrata = Socrata.new({:base_uri => "http://data.seattle.gov/api"})
    fyres = socrata.view("kzjm-xkqj")
    fyres.rows({:max_rows => 5})
  end

end
