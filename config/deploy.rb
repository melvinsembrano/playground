# require 'bundler/capistrano'
require 'fileutils'

set :application, "melvins-playground"
set :repository,  "git@github.com:melvinsembrano/playground.git"
set :domain, "www.melvinsplayground.com"

set :scm, :git
set :default_branch, :master
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, 'ams_deploy'
set :deploy_to, '/home/ams_deploy/melvinsplayground.com'

role :web, "melvinsplayground.com"                          # Your HTTP server, Apache/etc
role :app, "melvinsplayground.com"                          # This may be the same as your `Web` server
role :db,  "melvinsplayground.com", :primary => true # This is where Rails migrations will run
# role :db,  "your slave db-server here"

set :deploy_via, :copy
set :copy_cache, true
set :copy_exclude, [".git"]
set :keep_releases, 3

ssh_options[:paranoid] = false
default_run_options[:pty] = true

set :use_sudo, false

after "deploy:create_symlink" do
  cmd = []
  # cmd << "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  # cmd << "ln -nfs #{shared_path}/config/ebx.yml #{release_path}/config/ebx.yml"
  cmd << "ln -nfs #{shared_path}/bundle #{release_path}/vendor/bundle"

  run cmd.join(" && ")
end



# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:

 namespace :deploy do
   task :start do ; end
   task :stop do ; end
   task :restart, :roles => :app, :except => { :no_release => true } do
     run "touch #{File.join(current_path,'tmp','restart.txt')}"
   end
 end
