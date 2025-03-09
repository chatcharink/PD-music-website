require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PdmusicWebsite
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.active_storage.variant_processor = :mini_magick
    config.active_record.default_timezone = :local
    config.time_zone = 'Bangkok'
    config.to_prepare do
      ActionText::ContentHelper.allowed_tags << "iframe"
    end
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
