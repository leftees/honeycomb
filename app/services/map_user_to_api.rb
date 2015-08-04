class MapUserToApi
  attr_reader :user

  def self.call(user)
    new(user).map!
  end

  def initialize(user)
    @user = user
  end

  def map!
    map_attributes
    user
  rescue StandardError => exception
    notify_error(exception)
    user
  end

  private

  def map_attributes
    user.first_name = fetch("first_name")
    user.last_name = fetch("last_name")
    user.email = email
    user.display_name = fetch("full_name")
  end

  def api_attributes
    @api_attributes ||= HesburghAPI::PersonSearch.find(user.username)
  end

  def email
    contact_information.fetch("email", nil)
  end

  def contact_information
    fetch("contact_information", {})
  end

  def fetch(key, default = nil)
    api_attributes.fetch(key.to_s, default)
  end

  def notify_error(exception)
    NotifyError.call(exception: exception, parameters: { username: user.username }, component: self.class.to_s, action: "map!")
  end
end
