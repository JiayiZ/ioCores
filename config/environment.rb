# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.default :content_type => "text/html"
ActionMailer::Base.smtp_settings = {
  :user_name => '31429620@qq.com',
  :password => '802343zhou',
  :domain => 'qq.com',
  :address => 'smtp.qq.com',
  :port => 587,
  :authentication => :login,
  :enable_starttls_auto => true
}
#ActionMailer::Base.raise_delivery_errors = true
