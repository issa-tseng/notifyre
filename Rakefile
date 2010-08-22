require 'sequel'
require 'sequel/extensions/migration'

namespace :db do
  task :migrate do
    db = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://notifyre.db')
    Sequel::Migrator.apply(db, 'migrations')
    db.disconnect

    puts "migrated successfully."
  end
end

namespace :admin do
  task :create_user do
#    ConnectionManager.manual_connect!

#    user = (User.find 'engineering@socrata.com') || User.create({ :email => 'engineering@socrata.com', :password => 'password' })
#    puts "successfully created an admin user with email 'engineering@socrata.com' and password '#{user.reset_password!}'."

#    user.save
  end
end

