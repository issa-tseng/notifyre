class Alert < Sequel::Model
  many_to_one :user

  def self.trigger(point)

  end
end

__END__

SELECT
  id,
  aname,
  ahuman_address,
  latitude,
  longitude,
  radius,
  user_id,
  ((abs((atan((sqrt((pow(cos((pi()*#{point.longitude})/180)*sin(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))),2))+(pow(cos((pi()*a.longitude)/180)*sin((pi()*#{point.longitude})/180)-sin((pi()*longitude)/180)*cos((pi()*#{point.longitude})/180)*cos(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))),2))))/(sin((pi()*longitude)/180)*sin((pi()*#{point.longitude})/180)+cos((pi()*longitude)/180)*cos((pi()*#{point.longitude})/180)*cos(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))))))*20925524.9))/1600) as distance
FROM alerts a
WHERE
  ((abs((atan((sqrt((pow(cos((pi()*#{point.longitude})/180)*sin(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))),2))+(pow(cos((pi()*longitude)/180)*sin((pi()*#{point.longitude})/180)-sin((pi()*longitude)/180)*cos((pi()*#{point.longitude})/180)*cos(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))),2))))/(sin((pi()*longitude)/180)*sin((pi()*#{point.longitude})/180)+cos((pi()*longitude)/180)*cos((pi()*#{point.longitude})/180)*cos(abs(((pi()*latitude)/180)-((pi()*#{point.latitude})/180))))))*20925524.9))/1600) <= a.radius;
