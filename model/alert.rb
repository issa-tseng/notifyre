require 'geokit'

class Alert < Sequel::Model
  many_to_one :user

  def self.trigger(fyre)
    Alert.filter("range(cast(latitude as numeric), cast(longitude as numeric), cast(#{fyre.latitude} as numeric), cast(#{fyre.longitude} as numeric)) <= radius")
  end

  def before_save
    addr = Geokit::Geocoders::YahooGeocoder.geocode self.human_address

    if !addr.nil?
      self.latitude = addr.lat
      self.longitude = addr.lng
    end
  end
end

