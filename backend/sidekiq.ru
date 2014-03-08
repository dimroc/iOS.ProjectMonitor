require_relative 'bootstrap'
require 'sidekiq/web'
run Sidekiq::Web
