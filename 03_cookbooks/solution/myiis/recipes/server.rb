#
# Cookbook:: myiis
# Recipe:: server
#
# Copyright:: 2019, The Authors, All Rights Reserved.

powershell_script 'Install IIS' do
  code 'add-windowsfeature Web-Server'
end
  
file 'c:\inetpub\wwwroot\Default.htm' do
  content 'Hello, world!'
end

service 'w3svc' do
  action [:enable, :start]
end