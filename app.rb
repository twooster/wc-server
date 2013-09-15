begin
  require File.join(File.dirname(__FILE__), 'system', 'secrets.rb')
rescue LoadError => e
end

require 'rubygems'
require 'bundler/setup'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'haml'
require 'json'
require 'uri'

require './models'

module WhatCrop
  class BaseApp < Sinatra::Base
    register Sinatra::ActiveRecordExtension

    BASEDIR = File.dirname(File.expand_path(__FILE__))

    enable :sessions
    enable :logging
    set :session_secret, 'development secret'

    configure :development do
      enable :show_exceptions, :dump_errors
      disable :raise_errors, :clean_trace
      set :database, 'sqlite://development.db'

      before do
        headers 'Access-Control-Allow-Origin' => '*'
      end
    end

    configure :test do
      enable :logging, :raise_errors, :dump_errors
    end

    configure :production do
      set :sessions, :domain => '.whatcrop.org'
      set :session_secret, (ENV['SESSION_SECRET'] || raise)
    end

    # Shared public directory
    set :public_folder,  "#{BASEDIR}/public"
    set :static,         true
  end
end

require './admin/app'
require './frontend/app'
