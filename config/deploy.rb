require 'mina/multistage'
require 'mina/rails'
require 'mina/git'
require 'mina/rvm' 

set :application_name, 'empanadeitor'
set :repository, 'git@github.com:wecodeio/empanadeitor.git'

set :forward_agent, true     # SSH forward_agent.
set :term_mode, :pretty #nil
set :shared_dirs, fetch(:shared_dirs, []).push('public/system', 'log', 'tmp', 'storage')
set :shared_files, fetch(:shared_files, []).push('config/database.yml', 'config/secrets.yml', 'config/credentials.yml.enc', 'config/master.key', '.rails_env')

# This task is the environment that is loaded for all remote run commands, such as
# `mina deploy` or `mina rake`.
task :remote_environment do
  set :rvm_use_path, "/usr/local/rvm/scripts/rvm"
  invoke :'rvm:use', 'ruby-2.5.1@default'
end

# Put any custom commands you need to run at setup
# All paths in `shared_dirs` and `shared_paths` will be created on their own.
task :setup do
  # command %{rbenv install 2.3.0 --skip-existing}
end

desc "Deploys the current version to the server."
task :deploy do
  # uncomment this line to make sure you pushed your local branch to the remote origin
  # invoke :'git:ensure_pushed'
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    invoke :'deploy:cleanup'

    on :launch do
      in_path(fetch(:current_path)) do
        command %{mkdir -p tmp/}
        command %{touch tmp/restart.txt}
      end
    end
  end

  # you can use `run :local` to run tasks on local machine before of after the deploy scripts
  # run(:local){ say 'done' }
end

# For help in making your deploy script, see the Mina documentation:
#
#  - https://github.com/mina-deploy/mina/tree/master/docs
