Sequel.migration do
  up do
    create_table :users  do
      primary_key :id
      String :email, :null => false, :unique => true
      String :password, :null => false
      String :salt, :null => false
      String :phone_number, :null => false
    end

    create_table :alerts do
      primary_key :id

      # User-specified name for this point
      String :name, :null => false

      # The address we geocoded to get our lat/lon
      String :human_address, :null => true

      # The actual location
      Float :latitude, :null => false
      Float :longitude, :null => false

      # Radius, in fractional statute miles
      Float :radius, :null => false

      foreign_key :user_id, :users
    end

    create_table :configurations do
      primary_key :id
      String :name, :null => false, :unique => true
      String :value, :null => false
    end
  end

  down do
    drop_table :users
    drop_table :alerts
    drop_table :configurations
  end
end

