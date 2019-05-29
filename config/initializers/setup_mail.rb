ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default :charset => "utf-8"
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.sendgrid.net",
  :port                 => 465,
  :domain               => "sendgrid.net",
  :user_name            => "ny5BIP8rTcauwzqGJOvc2A",
  :password             => "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",
  :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = "localhost:3000"
Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
