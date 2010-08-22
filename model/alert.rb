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

__END__

SELECT
  id,
  name,
  human_address,
  latitude,
  longitude,
  radius,
  user_id,
  ((abs((atan((sqrt((pow(cos((pi()*#{point.longitude})/180)*sin(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))),2))+(pow(cos((pi()*a.longitude)/180)*sin((pi()*#{point.longitude})/180)-sin((pi()*longitude)/180)*cos((pi()*#{point.longitude})/180)*cos(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))),2))))/(sin((pi()*longitude)/180)*sin((pi()*#{point.longitude})/180)+cos((pi()*longitude)/180)*cos((pi()*#{point.longitude})/180)*cos(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))))))*20925524.9))/1600) as distance
FROM alerts a
WHERE
  ((abs((atan((sqrt((pow(cos((pi()*#{point.longitude})/180)*sin(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))),2))+(pow(cos((pi()*longitude)/180)*sin((pi()*#{point.longitude})/180)-sin((pi()*longitude)/180)*cos((pi()*#{point.longitude})/180)*cos(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))),2))))/(sin((pi()*longitude)/180)*sin((pi()*#{point.longitude})/180)+cos((pi()*longitude)/180)*cos((pi()*#{point.longitude})/180)*cos(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))))))*20925524.9))/1600) <= a.radius;

((abs((atan((sqrt((pow(cos((pi()*#{point.longitude})/180)*sin(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))),2))+(pow(cos((pi()*longitude)/180)*sin((pi()*#{point.longitude})/180)-sin((pi()*longitude)/180)*cos((pi()*#{point.longitude})/180)*cos(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))),2))))/(sin((pi()*longitude)/180)*sin((pi()*#{point.longitude})/180)+cos((pi()*longitude)/180)*cos((pi()*#{point.longitude})/180)*cos(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))))))*20925524.9))/1600)

CREATE OR REPLACE FUNCTION range(from_lat float, from_lon float, to_lat float, to_lon float) RETURNS float AS $$
select (abs((atan((sqrt((pow(cos((pi()*from_lon)/180)*sin(abs(((pi()*to_lat)/180)-((pi()*from_lat)/180))),2))+(pow(cos((pi()*to_lon)/180)*sin((pi()*from_lon)/180)-sin((pi()*to_lon)/180)*cos((pi()*from_lon)/180)*cos(abs(((pi()*to_lat)/180)-((pi()*from_lat)/180))),2))))/(sin((pi()*to_lon)/180)*sin((pi()*from_lon)/180)+cos((pi()*to_lon)/180)*cos((pi()*from_lon)/180)*cos(abs(((pi()*to_lat)/180)-((pi()*from_lat)/180))))))*20925524.9))/1600
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION range(from_lat decimal, from_lon decimal, to_lat decimal, to_lon decimal)
  RETURNS decimal AS
$BODY$declare
    range float;
BEGIN

select (abs((atan((sqrt((pow(cos((pi()*from_lon)/180)*sin(abs(((pi()*to_lat)/180)-((pi()*from_lat)/180))),2))+(pow(cos((pi()*to_lon)/180)*sin((pi()*from_lon)/180)-sin((pi()*to_lon)/180)*cos((pi()*from_lon)/180)*cos(abs(((pi()*to_lat)/180)-((pi()*from_lat)/180))),2))))/(sin((pi()*to_lon)/180)*sin((pi()*from_lon)/180)+cos((pi()*to_lon)/180)*cos((pi()*from_lon)/180)*cos(abs(((pi()*to_lat)/180)-((pi()*from_lat)/180))))))*20925524.9))/5249.34 into range;
return range;

END;$BODY$
  LANGUAGE 'plpgsql' VOLATILE;
