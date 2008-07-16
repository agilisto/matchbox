require 'erb'
require 'mongrel_cluster/recipes'
require 'config/opensolaris/accelerator_tasks'

set :application, "matchbox" #matches names used in smf_template.erb

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/home/993440e2/web/#{application}"

# Replace XXXXXXXX with the username provided by Joyent in your welcome email.

set :key_name, '993440e2' 
set :user, '993440e2'
set :password, 'p3nqu1n'
set :smf_process_user, 'root'
set :smf_process_group, 'root'
set :service_name, application
set :working_directory, "#{deploy_to}/current"
ssh_options[:paranoid] = false 

# This allows git to use your local private key and ssh agent
# See http://blog.new-bamboo.co.uk/2008/3/12/github-with-capistrano
set :ssh_options, { :forward_agent => true }
set :scm, :git
set :repository, "git@github.com:agilisto/matchbox.git"
set :repository_cache, "git_cache"
set :deploy_via, :remote_cache
#set :git_enable_submodules, 1
set :domain, 'matchbox.ads.agilisto.tr.co.za'

role :app, domain
role :web, domain
role :db,  domain, :primary => true

set :server_name, "matchbox.ads.agilisto.tr.co.za"
set :server_alias, "*.ads.agilisto.tr.co.za"

# Example dependancies
# depend :remote, :command, :gem
# depend :remote, :gem, :money, '>=1.7.1'
# depend :remote, :gem, :mongrel, '>=1.0.1'
# depend :remote, :gem, :image_science, '>=1.1.3'
# depend :remote, :gem, :rake, '>=0.7'
# depend :remote, :gem, :BlueCloth, '>=1.0.0'
# depend :remote, :gem, :RubyInline, '>=3.6.3'

desc "tasks to run after checkout"
task :after_update_code do
    #update_rails
    #create_sym
end

deploy.task :restart do
    accelerator.smf_restart
    accelerator.restart_apache
end

deploy.task :start do
    accelerator.smf_start
    accelerator.restart_apache
end

deploy.task :stop do
    accelerator.smf_stop
    accelerator.restart_apache
end

deploy.task :destroy do
    sudo "rm -rf #{deploy_to}"
end

task :tail_log, :roles => :app do
    stream "tail -f #{shared_path}/log/production.log"
end

after :deploy, 'deploy:cleanup'

task :chmod_tmp_folder do
  run "chmod -R 777 #{deploy_to}/current/tmp"
end

task :link_to_shared_database_yml do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

task :link_to_shared_production_app_config_yml do
  run "ln -nfs #{shared_path}/config/production_app_config.yml #{release_path}/config/production_app_config.yml"
end

task :configure_ultrasphinx do
  run "rake -f #{release_path}/Rakefile ultrasphinx:configure RAILS_ENV=production"
end

after "deploy:update", 'chmod_tmp_folder'
after "deploy:update", 'link_to_shared_database_yml'
after "deploy:update", 'link_to_shared_production_app_config_yml'
after "deploy:update", 'configure_ultrasphinx'
