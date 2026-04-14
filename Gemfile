source "https://rubygems.org"

ruby "3.2.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 8.0.2"
# Use postgres as the database for Active Record
gem "pg"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"

gem "devise"
gem "devise-jwt"
gem "active_model_serializers"

gem "wicked_pdf"
gem "wkhtmltopdf-binary"
gem "activeadmin", "~> 3.3"
gem "arctic_admin", "~> 4.3.3"
# gem "sassc-rails" # ensure SCSS support with Rails 8 + Propshaft
# gem "sprockets-rails"
# Needed for Propshaft or Sprockets (Rails 8)
gem "propshaft" # default for Rails 8
gem "turbo-rails"
gem "stimulus-rails"

# Authorization
gem "pundit"
# Pagination
# gem "kaminari"

# Role Management
gem "rolify"
gem "pry"
gem "aws-sdk-s3"
gem "dotenv-rails"

# gem "ruby-vips", "~> 2.2"
gem "countries"
gem "tzinfo"
gem "money"
gem "phony"
gem "phony_rails"
gem "mime-types"
gem "numbers_and_words"
gem "kaminari"
gem "importmap-rails"
gem "streamio-ffmpeg"
gem "rails_sortable"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw mswin x64_mingw ], require: "debug/prelude"
  # gem "pry"

  gem "bullet"
  # gem 'rspec-rails'
  # gem 'rswag'
  # gem 'factory_bot_rails'
  # gem 'faker'
  # gem 'city-state'
  gem "byebug"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false
end

group :production do
  gem "rspec-rails"
  gem "rswag"
  gem "factory_bot_rails"
  gem "faker"
  # gem 'streamio-ffmpeg'
  gem "city-state"
end

gem "sassc", "~> 2.4"

gem "ruby-vips", "~> 2.2"
gem "paper_trail"
gem "paper_trail-association_tracking"
