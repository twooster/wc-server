ENV['GEM_HOME'] = File.expand_path('~/.gems')
ENV['GEM_PATH'] = ENV['GEM_HOME'] + ':/usr/lib/ruby/gems/1.8'

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)

require File.dirname(__FILE__) + '/secrets.rb' rescue nil
require File.dirname(__FILE__) + '/app.rb'

run WhatCrop::App.new
