require 'warden'
require 'model/user'

Warden::Manager.before_failure do |env, opts|
  # Sinatra is pretty sensitive to the request method;
  # since authentication could fail on any type of method, we need
  # to force it for the failure app so it is routed to the correct block
  env['REQUEST_METHOD'] = "GET"
end

use Warden::Manager do |manager|
  manager.serialize_into_session do |user|
    return user.nil? ? nil : user.email
  end
  manager.serialize_from_session do |email|
    return email.nil? ? nil : (User.find email)
  end
end

Warden::Strategies.add(:notifyre_user) do
  def valid?
    return params['email'] && params['password']
  end

  def authenticate!
    user = User.find params['email']

    if user.nil? or !(user.authenticate? params['password'])
      fail! "authentication failed"
    else
      success! user
    end
  end
end


