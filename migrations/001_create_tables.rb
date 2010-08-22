Sequel.migration do
  up do
    create_table :users  do
      String :email, :null => false, :unique => true, :primary_key => true
      String :password, :null => false
      String :salt, :null => false
      String :phone_number, :null => false
    end

    create_table :points do
      primary_key :id
      String :name, :null => false
      String :human_address, :hull => true
      Float :latitude, :null => false
      Float :longitude, :null => false
      Float :radius, :null => false

      foreign_key :user_id, :users
    end
  end

  down do
    drop_table :users
    drop_table :points
  end
end

