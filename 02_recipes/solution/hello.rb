#
# Recipe:: hello.rb
#
# Copyright:: 2019, The Authors, All Rights Reserved.
#
# This recipe should be executed on the provided Windows 2016 training environment

file 'c:\users\administrator\hello.txt' do
  content 'hello, world!'
end

# notice in the above file resource the action is excluded.
# what is the default action for the file resource?

windows_package 'firefox' do
  source 'http://archive.mozilla.org/pub/firefox/releases/66.0.3/win64/en-US/Firefox%20Setup%2066.0.3.msi'
  action :install
end

windows_package 'c:\users\administrator\7zip\7z938-x64.msi'

# in the above examples, notice you can exclude the action :install and the 'do' block entirely when taking default actions.
# these statements are equivilant, but for maintenance and readability it's recommended to be explicit

windows_service 'wuauserv' do
  action :stop
  startup_type :manual
end

# when configuring windows services the above resource is more useful
# this is because it has the startup_type property built-in, but often the service resource can still be used, as seen below

service 'w32time' do
  action [:start, :enable]
end

# To take multiple actions, they must be passed within an array.
# to be clear, this does NOT work:
#
# service 'w32time' do
#   action :start
#   action :enable
# end
#
# Usually you will only find yourself taking multiple actions with the service resource.
# Also, what is the default action for the service resource? Does this make sense?