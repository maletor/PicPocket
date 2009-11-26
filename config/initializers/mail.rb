# These are wrong.
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address => "mail.spounce.com",
    :port => 25,
    :domain => "www.spounce.com",
    :authentication => :login,
    :user_name => "spounce",
    :password => "wrT18q"
}
