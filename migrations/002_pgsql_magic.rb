Sequel.migration do
  up do
    run "
    CREATE LANGUAGE 'plpgsql';
    CREATE OR REPLACE FUNCTION range(from_lat numeric, from_lon numeric, to_lat numeric, to_lon numeric)
  RETURNS numeric AS
$BODY$declare
    range numeric;
BEGIN

select (abs((atan((sqrt((pow(cos((pi()*from_lon)/180)*sin(abs(((pi()*to_lat)/180)-((pi()*from_lat)/180))),2))+(pow(cos((pi()*to_lon)/180)*sin((pi()*from_lon)/180)-sin((pi()*to_lon)/180)*cos((pi()*from_lon)/180)*cos(abs(((pi()*to_lat)/180)-((pi()*from_lat)/180))),2))))/(sin((pi()*to_lon)/180)*sin((pi()*from_lon)/180)+cos((pi()*to_lon)/180)*cos((pi()*from_lon)/180)*cos(abs(((pi()*to_lat)/180)-((pi()*from_lat)/180))))))*20925524.9))/5249.34 into range;
return range;

END;$BODY$
  LANGUAGE 'plpgsql' VOLATILE;"
  end

  down do
    run "DROP FUNCTION range(numeric, numeric, numeric, numeric);"
  end
end

