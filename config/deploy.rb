set :application, 'whatcrop-server'
set :user,        'whatcropaccount'
set :repository,  'git://github.com/twooster/wc-server'
set :deploy_to,   '/home/whatcropaccount/v2.whatcrop.org'

server 'v2.whatcrop.org', :web, :app, :db, :primary => true

set :scm, :git
set :git_enable_submodules, 1

set :use_sudo, false
set :default_shell, "sh -l" # Use login shell for appropriate PATH

set :shared_children, %w(log tmp system)

set :rake, 'bundle exec rake'

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :bundle_update, :roles => :app do
    run "cd #{current_path} && bundle check || bundle install"
  end
end

after 'deploy:restart', 'deploy:cleanup'
after 'deploy:finalize_update', 'deploy:bundle_update'
