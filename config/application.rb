require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module Pinpoint
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'London'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Lib contains things like our subdomain file
    config.autoload_paths << Rails.root.join('lib')

    # Need the secrets to set config stuff
    YAML.load_file("#{::Rails.root}/config/secrets.yml")[::Rails.env].each {|k,v| ENV[k] = v }

    config.action_mailer.delivery_method = :postmark
    config.action_mailer.postmark_settings = { :api_key => ENV['postmark_api_key'] }
    config.action_mailer.default_options = {
        from: "support@pinpointhq.com"
    }

    # Stripe config
    config.stripe.secret_key = ENV['stripe_api_key']
    config.stripe.publishable_key = ENV['stripe_public_key']

  end
end
