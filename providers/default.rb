#
# Cookbook Name:: postfix
# Provider:: default
#
# Author:: LLC Express 42 (info@express42.com)
#
# Copyright (C) LLC 2012 Express 42
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
# of the Software, and to permit persons to whom the Software is furnished to do
# so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

action :create do
  package 'postfix'

  instances_list = []
  run_context.resource_collection.all_resources.map { |resource| instances_list << resource.name if resource.resource_name == :postfix }
  instances_list.sort!

  options = Chef::Mixin::DeepMerge.merge(node['postfix']['options'], new_resource.options)
  master_options = Chef::Mixin::DeepMerge.merge(node['postfix']['master_options'], new_resource.master_options)

  if instances_list.first == new_resource.name

    instance_prefix = ''
    instance = '-'

    unless instances_list.count == 1
      options[:multi_instance_directories] = instances_list.map { |instance| "/etc/postfix-#{instance}" unless instance == new_resource.name }.compact.join(' ')
      options[:multi_instance_enable] = 'yes'
    end

  else

    instance_prefix = "-#{new_resource.name}"
    instance = "postfix#{instance_prefix}"

    options[:multi_instance_enable] = 'yes'
    options[:multi_instance_name] = "postfix#{instance_prefix}"

  end

  options[:queue_directory] = "/var/spool/postfix#{instance_prefix}"
  options[:data_directory] = "/var/lib/postfix#{instance_prefix}"

  service "postfix#{instance_prefix}" do
    action :nothing
    start_command "postmulti -i #{instance} -p start"
    stop_command "postmulti -i #{instance} -p stop"
    restart_command "postmulti -i #{instance} -p stop && postmulti -i #{instance} -p start"
    reload_command "postmulti -i #{instance} -p reload"
    status_command "postmulti -i #{instance} -p status"
    supports status: true, restart: true, reload: true
  end

  # spool directory
  directory "/var/spool/postfix#{instance_prefix}"

  # config directory
  directory "/etc/postfix#{instance_prefix}"

  # cache directory
  directory "/var/spool/postfix#{instance_prefix}/cache" do
    owner 'postfix'
    group 'root'
  end

  # main config
  template "/etc/postfix#{instance_prefix}/main.cf" do
    source 'main.cf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    cookbook new_resource.cookbook
    variables(options: options)
    notifies :restart, "service[postfix#{instance_prefix}]", :delayed
  end

  # master config
  template "/etc/postfix#{instance_prefix}/master.cf" do
    source 'master.cf.erb'
    owner 'root'
    group 'root'
    mode '0644'
    cookbook new_resource.cookbook
    variables(master_options: master_options)
    notifies :restart, "service[postfix#{instance_prefix}]", :delayed
  end

  link "/etc/postfix#{instance_prefix}/dynamicmaps.cf" do
    to '/etc/postfix/dynamicmaps.cf'
    not_if { instance_prefix.empty? }
  end

  execute "postfix -c /etc/postfix#{instance_prefix} check" do
    creates "/var/spool/postfix#{instance_prefix}/active"
  end

  new_resource.updated_by_last_action(true)
end
