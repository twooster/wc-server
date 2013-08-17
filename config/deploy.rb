set :application, 'whatcrop-server'
set :user,        'whatcropaccount'
set :repository,  'git://github.com/twooster/wc-server'
set :deploy_to,   '/home/whatcropaccount/v2.whatcrop.org'

set :scm, :git
set :use_sudo, false
set :git_enable_submodules, 1

server 'v2.whatcrop.org', :web, :app, :db, :primary => true

after 'deploy:restart', 'deploy:cleanup'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
