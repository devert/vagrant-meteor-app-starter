default['meteor']['install_meteorite'] = true
if !node['meteor']['install_meteorite']
  default['meteor']['meteor_command'] = 'meteor'
else
  default['meteor']['meteor_command'] = 'mrt'
end
#default['meteor']['create_cmd_files'] = true
default['meteor']['install_acpipowerbutton'] = false
default['meteor']['sync_directory'] = '/vagrant'
default['meteor']['home_directory'] = '/home/vagrant'
default['meteor']['owner'] = 'vagrant'
default['meteor']['group'] = 'vagrant'