load 'deploy' if respond_to?(:namespace) # cap2 differentiator

# Git/Github setup
set :scm, :git
set :repository, "git@github.com:jicksta/desk-pbx.git"

# Project-related variables
set :project_deploy_to_root, "/usr/local/desk_pbx"

# Rails-related variables
set :rails_deploy_to, project_deploy_to_root + "/pbx-gui"

# Adhearsion-related variables
set :ahn_repository, 'http://svn.adhearsion.com/trunk'
set :ahn_install_dir, "/usr/local/adhearsion"

set :ahn_deploy_to, project_deploy_to_root + "/pbx"

# Capistrano setup
set :application, "pbx" # Why is this needed?
set :user, "jicksta"
set :deploy_to, ahn_deploy_to

role :app, "jicksta.com"

depend :remote, :command, "git"
depend :remote, :command, "svn" # Used for Adhearsion trunk
depend :remote, :command, "asterisk"
depend :remote, :directory, project_deploy_to_root
depend :remote, :directory, '/etc/asterisk'
depend :remote, :match, "ruby -v", /1\.8\.6/
depend :remote, :gem, "rails", ">= 2.0.2"
depend :remote, :gem, "haml", ">= 1.8.2"
depend :remote, :gem, "activerecord", ">= 2.0.2"
depend :remote, :gem, "activesupport", ">= 2.0.2"
depend :remote, :gem, "hoe", ">= 1.5.0"
depend :remote, :gem, "rubigen", ">= 1.1.1"
depend :remote, :gem, "log4r", ">= 1.0.5"
depend :remote, :gem, "tzinfo", ">= 0.3.7"
depend :remote, :gem, "sqlite3-ruby", ">= 1.2.1"
depend :remote, :gem, "daemons", ">= 1.0.10"
depend :remote, :gem, "thin", ">= 0.7.1"

before 'deploy', 'ahn:update'
after 'deploy', :update_path_to_rails
after 'deploy:setup', :create_engineyard_folder
after 'deploy:setup', 'ahn:init'
after 'deploy:setup', :chmod_adhearsion_folder

task :chmod_adhearsion_folder do
  sudo "chown -R #{user} /usr/local/adhearsion"
  sudo "chgrp -R #{group} /usr/local/adhearsion"
end

task :create_engineyard_folder do
  sudo 'mkdir /usr/local/engineyard'
  sudo "chown -R #{user} /usr/local/engineyard"
  sudo "chgrp -R #{group} /usr/local/engineyard"
end

before 'deploy', 'ahn:stop'
after  'deploy', 'ahn:start'

# after 'deploy', :update_path_to_rails
task :update_path_to_rails do
  run "echo #{rails_deploy_to}/current > #{ahn_deploy_to}/current/.path_to_gui"
end

namespace :deploy do
  
  task :restart do
    # This is already handled by the before/after hooks above
  end
  
end

namespace :ahn do
  
  task :init do
    run "svn co #{ahn_repository} #{ahn_install_dir}"
  end
  
  task :update do
    run "svn update #{ahn_install_dir}"
  end
  
  task :start do
    run "#{ahn_install_dir}/bin/ahnctl start #{ahn_deploy_to}/current"
    run '/etc/init.d/ahn_queue_fetcher start'
  end
  
  task :stop do
    run '/etc/init.d/ahn_queue_fetcher stop || true'
    run "#{ahn_install_dir}/bin/ahnctl stop #{ahn_deploy_to}/current || true"
  end
  
  task :restart do
    stop
    start
  end
end

namespace :asterisk do
  task :reload do
    run "asterisk -rx reload"
  end
  
  task :stop do
    run "asterisk -rx 'stop now'"
  end
  
  task :start do
    run 'asterisk'
  end
  
  task :restart do
    stop
    start
  end
end

namespace :debian do
  
  task :update_packages do
    run "apt-get update"
  end
  
  namespace :monit do
    task :install do
      update_packages
      run "apt-get install -y monit"
    end
  end
  
  namespace :mysql do
    
    task :install do
      update_packages
      run "apt-get install -y mysql-server-5.0"
      run "apt-get install -y mysql-client-5.0"
    end
    
    task :status do
      run "/etc/init.d/mysql status"
    end
    
  end
end