# frozen_string_literal: true

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
# Rails.application.config.assets.precompile += %w( application.css )

# This was required to ensure that Grape API could be integrated into Rails 7.0.z releases
# Ultimately, this should probably be cleaned with the removal of Grape entirely
gem_paths = Gem.path
gem_paths.each do |gem_path|
  resolved = File.join(gem_path, "gems", "grape-swagger-rails")
  if File.directory?(resolved)
    assets_path = File.join(resolved, "assets")
    Rails.application.config.assets.paths << assets_path
  end
end

Rails.application.config.dartsass.builds = {
  "application.scss" => "application.css"
}
