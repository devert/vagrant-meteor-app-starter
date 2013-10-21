#
# Cookbook Name:: meteor
# Recipe:: default
# 

include_recipe "apt"
include_recipe "build-essential"
include_recipe "nodejs"
include_recipe "nodejs::npm"
include_recipe "curl"

# install chef and leave a trail to prevent reinstalling each run
bash "install_meteor" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOF
  curl https://install.meteor.com | sudo sh
  touch #{Chef::Config[:file_cache_path]}/meteor_installed_by_chef
  EOF
  not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/meteor_installed_by_chef") }
end

Chef::Log.info("Install Meteorite: #{node['meteor']['install_meteorite']}")
Chef::Log.info("Meteor Command: #{node['meteor']['meteor_command']}")

#Chef::Log.info("Env: #{node['meteor']['env']}")
Chef::Log.info("Config: #{node['meteor']['config']}")

if node['meteor']['install_meteorite']
  bash "install_meteorite" do
    cwd Chef::Config[:file_cache_path]
    code <<-EOF
    npm install -g meteorite
    touch #{Chef::Config[:file_cache_path]}/meteorite_installed_by_chef
    EOF
    not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/meteorite_installed_by_chef") }
  end
end

# Create home and sync directories
directory "#{node['meteor']['sync_directory']}" do
  action :create
  recursive true
  owner node['meteor']['owner']
  group node['meteor']['group']
end

directory "#{node['meteor']['home_directory']}" do
  action :create
  recursive true
  owner node['meteor']['owner']
  group node['meteor']['group']
end

apps = node['meteor']['apps']

apps.each do |app|
  Chef::Log.info("Creating Meteor App: #{app}")

  # Create Destination folder for the database symlink mount of the created app
  directory "#{node['meteor']['home_directory']}/#{app}" do
    action :create
    recursive true
    owner node['meteor']['owner']
    group node['meteor']['group']
  end

  # Create the Meteor App, move the hidden .meteor directory, and leave a breadcrumb to prevent recreating the app each run
  bash "meteor_create_#{app}" do
    cwd node['meteor']['sync_directory']
    code <<-EOF
    #{node['meteor']['meteor_command']} create #{app}
    mv #{node['meteor']['sync_directory']}/#{app}/.meteor #{node['meteor']['home_directory']}/#{app}/.meteor
    touch #{Chef::Config[:file_cache_path]}/meteor_#{app}_created_by_chef
    EOF
    not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/meteor_#{app}_created_by_chef") }
  end

  # Re-Create the .meteor directory in order to map the symlink
  directory "#{node['meteor']['sync_directory']}/#{app}/.meteor" do
    action :create
    recursive true
    owner node['meteor']['owner']
    group node['meteor']['group']
  end

  # Create a mount symlink from the sync directory to the home directory
  # This is required to move the Mongo DB location to a non-synced folder
  mount "#{node['meteor']['sync_directory']}/#{app}/.meteor" do
    device "#{node['meteor']['home_directory']}/#{app}/.meteor"
    fstype "none"
    options "bind,rw"
    action [:mount]
  end

  if node['meteor']['install_meteorite']
    # Create the meteorite packages directories in order to map the symlink
    directory "#{node['meteor']['sync_directory']}/#{app}/packages" do
      action :create
      recursive true
      owner node['meteor']['owner']
      group node['meteor']['group']
    end

    directory "#{node['meteor']['home_directory']}/#{app}/packages" do
      action :create
      recursive true
      owner node['meteor']['owner']
      group node['meteor']['group']
    end    

    # Create a mount symlink from the sync directory to the home directory
    # This is required to allow meteorite to create its own symlinks
    mount "#{node['meteor']['sync_directory']}/#{app}/packages" do
      device "#{node['meteor']['home_directory']}/#{app}/packages"
      fstype "none"
      options "bind,rw"
      action [:mount]
    end  
  end

  # This worked really well to start meteorite or meteor and add packages, but I couldn't get it to send a SIGINT (ctrl + c) to the process on the VM rather than try to stop vagrant ssh
  # Create convenience script to pass commands into vagrant ssh
  #if node['meteor']['create_cmd_files']
  #  template "#{node['meteor']['sync_directory']}/#{app}/#{node['meteor']['meteor_command']}.cmd" do
  #    source "mrt.cmd.erb"
  #    owner node['meteor']['owner']
  #    group node['meteor']['group']
  #    variables({
  #      :appname => app
  #    })
  #  end
  #end
end

# Install ACPI Support Package and Power Button
if node['meteor']['install_acpipowerbutton']

  package "acpi-support" do
    action :install
  end

  template "#{node['meteor']['sync_directory']}/acpipowerbutton.cmd" do
    source "acpi.cmd.erb"
    owner node['meteor']['owner']
    group node['meteor']['group']
  end
end