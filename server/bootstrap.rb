Env = ENV["RACK_ENV"] || 'development'
Bundler.require(:default, Env)
ActiveSupport::Dependencies.autoload_paths << File.join(File.dirname(__FILE__), "app")

require_all "config"
autoload_all "app"
require_all "initializers"
