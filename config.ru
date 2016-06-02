require 'rubygems'
require 'bundler'
require 'sinatra'
require "sinatra/cookies"
require 'dotenv'
require 'rest-client'
require 'json'
require 'digest'
require 'digest/md5'
require 'open-uri'
require 'slack'
require 'git'

Bundler.require
Dotenv.load

# set up log levels
configure :test do
	set :logging, Logger::ERROR
end

configure :development do
	set :logging, Logger::DEBUG
end

configure :production do
	set :logging, Logger::INFO
end

Slack.configure do |config|
	config.token = ENV["SLACK_API_TOKEN"]
end


PARROT_GIT_URL="https://github.com/jmhobbs/cultofthepartyparrot.com.git"
unless File.directory?("/tmp/checkout/parrots")
	g = Git.clone(PARROT_GIT_URL, "parrots", :path => '/tmp/checkout')
end

# And run the app
require './app.rb'
run Sinatra::Application
