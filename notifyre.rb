require 'rubygems'
require 'sinatra'
require 'sinatra/content_for'
require 'sinatra/flash'
require 'socrata'
require 'geokit'

Rack::ConnectionManager.manual_connect!

require 'model/configuration'
require 'model/alert'
require 'model/user'
require 'lib/tropo'

class Notifyre < Sinatra::Base
  helpers Sinatra::ContentFor
  register Sinatra::Flash

  get '/' do
    erb :index
  end

  get '/manage' do
    @user = env['warden'].user
    return error_permission_denied if @user.nil

    erb :manage
  end

  post '/signup' do
    begin
      user = User.create(params['user'])
      user.set_password(params['user']['password'])
      alert = Alert.create(params['alert'].merge({ :name => 'default', :radius => 0.5, :user_id => user.id }))
      user.alerts << alert
      user.save
    rescue
      flash[:notice] = 'Something went wrong when trying to sign you up. Are you sure you don\'t already have an account?'
      redirect '/', 302
    end

    flash[:notice] = 'A temporary password has been sent to your phone. Please check it to log in.'
    redirect '/', 302
  end

  get '/confirm_user' do
    begin
      user = User.first(:phone_number => params['user']['phone_number'])
      user.confirm!
      user.save
    rescue
      'fail'
    end
  end

  post '/signin' do
    env['warden'].authenticate(:notifyre_user)
    if env['warden'].authenticated?
      return env['warden'].user.data.to_json
    else
      return error_permission_denied
    end
  end

  get '/signout' do
    env['warden'].logout
    redirect '/', 302
  end

  get '/unauthenticated' do
    status 401

    flash[:notice] = 'Something went wrong when trying to sign you in. Are you sure you got everything right?'
    redirect '/', 302
  end

  get '/update' do
    # Figure out when we last pulled
    @last_pulled = Configuration.first(:name => "last_pulled")
    if @last_pulled.nil?
      # Never, I guess...
      @last_pulled = Configuration.new({:name => "last_pulled",
                                       :value => Time.now.to_i - 5*60})
    end

    socrata = Socrata.new({:base_uri => "http://data.seattle.gov/api"})

    filter = {
      :order_bys => [
        { :ascending => false,
          :expression => {
            :type => "column",
            :column_id => 2354168
          }
        }
      ],
      :filter_condition => {
        :type => "operator",
        :value => "AND",
        :children => [
          { :type => "operator",
            :value => "GREATER_THAN",
            :children => [
              { :type => "column",
                :column_id => 2354168
              },
              { :type => "literal",
                :value => params["demo"] ? (Time.now - 2*24*60*60).to_i : @last_pulled.value
              }
            ]
          }
        ]
      }
    }

    # Get all the new fyres
    rows = socrata.view("kzjm-xkqj").filter(filter)
    @fyres = []
    @matches = {}
    rows.each do |row|
      fyre = Fyre.new(row)
      alerts = Alert.trigger(fyre)
      if alerts.count > 0
        @matches[fyre] = alerts
        alerts.each do |alert|
          Tropo.make_call(alert.user.phone_number, ",,,There is a #{fyre.type} near #{alert.name}. Run for your life!")
        end
      end
      @fyres << fyre
    end

    @last_pulled.value = Time.now.to_i
    @last_pulled.save

    erb :update
  end

  get '/notadmin' do
    users = User.all
    erb :notadmin
  end

private
  def error_permission_denied
    status 401
    return { :error => 'permission denied' }.to_json
  end

end

class Fyre
  attr_accessor :address, :type, :time, :latitude, :longitude

  def initialize(row)
    @address = row[8]
    @type = row[9]
    @time = Time.at(row[10].to_i)
    @latitude = row[11]
    @longitude = row[12]
  end
end
