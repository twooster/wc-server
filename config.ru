ENV['GEM_HOME'] = File.expand_path('~/.gems')
ENV['GEM_PATH'] = ENV['GEM_HOME'] + ':/usr/lib/ruby/gems/1.8'

if ENV['RACK_ENV'] == 'production'
  FileUtils.mkdir_p 'log' unless File.exists?('log')
  log = File.new("log/sinatra.log", "a")
  $stdout.reopen(log)
  $stderr.reopen(log)
end

require File.dirname(__FILE__) + '/app.rb'

map '/' do
  run WhatCrop::UserApp.new
end

map '/admin' do
  run WhatCrop::AdminApp.new
end
