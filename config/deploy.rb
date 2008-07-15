require 'erb'
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

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
set :repository, "git@github-agilisto:agilisto/matchbox.git"
set :branch, "stable"
set :repository_cache, "git_cache"
set :deploy_via, :remote_cache

# This allows git to use your local private key and ssh agent
# See http://blog.new-bamboo.co.uk/2008/3/12/github-with-capistrano
set :ssh_options, { :forward_agent => true }

set :domain, 'matchbox.ads.agilisto.tr.co.za'
role :app, domain
role :web, domain
role :db,  domain, :primary => true

set :server_name, "matchbox.ads.agilisto.tr.co.za"
set :server_alias, "*." + "ads.agilisto.tr.co.za"

# Example dependancies
# depend :remote, :command, :gem
# depend :remote, :gem, :money, '>=1.7.1'
# depend :remote, :gem, :mongrel, '>=1.0.1'
# depend :remote, :gem, :image_science, '>=1.1.3'
# depend :remote, :gem, :rake, '>=0.7'
# depend :remote, :gem, :BlueCloth, '>=1.0.0'
# depend :remote, :gem, :RubyInline, '>=3.6.3'

desc "update vendor rails"

task :update_rails do
    # get the version of edge rails that the user is currently using
    #for entry in Dir.entries("./vendor/rails")
    #    puts entry.to_s
    #    if entry[/\REVISION_\d+/]
    #        local_revision  = entry.sub("REVISION_","")
    #    end
    #end
    
    local_revision = "8434"

    # update to that revision
    puts local_revision

    # get rid of the current rails dir
    if File.exist?("#{deploy_to}/shared/rails")

        # check current version
        for entry in Dir.entries("#{deploy_to}/shared/rails")
            if entry[/\REVISION_\d+/]
                deployed_revision  = entry.sub("REVISION_","")
            end
        end
        sudo "rm -rf #{deploy_to}/shared/rails"
    end

    # check out edge rails
    sudo "svn co http://dev.rubyonrails.org/svn/rails/trunk #{deploy_to}/shared/rails --revision=" + local_revision
end

desc "create symlinks from rails dir into project"
task :create_sym do
    sudo "ln -nfs #{shared_path}/rails #{release_path}/vendor/rails"
    #sudo "ln -nfs #{deploy_to}/shared//uploaded_images #{release_path}/public//uploaded_images"
    #sudo "chown -R mongrel:www  #{deploy_to} "
    #sudo "chown -R mongrel:www  #{shared_path} "	
    #sudo "chmod 775  #{deploy_to} "
end

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