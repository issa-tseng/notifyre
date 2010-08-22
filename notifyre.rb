require 'rubygems'
require 'sinatra'
require 'socrata'

Rack::ConnectionManager.manual_connect!

require 'model/configuration'
#require 'model/point'
#require 'model/user'

class Notifyre < Sinatra::Base

  before do
  end

  get '/' do
    erb :index
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
                #:value => @last_pulled.value
                :value => (Time.now - 2 * 24 * 60 * 60).to_i
              }
            ]
          }
        ]
      }
    }

    # Get all the new fyres
    rows = socrata.view("kzjm-xkqj").filter(filter)
    @fyres = []
    rows.each do |row|
      @fyres << Fyre.new(row)
    end

    # See who might have a notification on this

    @last_pulled.value = Time.now.to_i
    @last_pulled.save

    erb :update
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
