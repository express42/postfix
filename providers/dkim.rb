#
# Cookbook Name:: postfix
# Provider:: dkim
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

action :setup do

  package 'opendkim'

  service 'opendkim' do
    action [:enable, :start]
  end

  configuration = Chef::Mixin::DeepMerge.merge(node['postfix']['dkim'], new_resource.configuration)

  directory '/etc/opendkim'

  directory '/etc/opendkim/keys' do
    owner node['postfix']['dkim']['user']
    group node['postfix']['dkim']['user']
    mode '0500'
  end

  template '/etc/opendkim.conf' do
    source 'opendkim.conf.erb'
    mode '0644'
    cookbook new_resource.cookbook
    variables(options: configuration['options'])
    notifies :restart, 'service[opendkim]'
  end

  if new_resource.keys
    new_resource.keys.each do |_key, val|
      template "/etc/opendkim/keys/#{val['domain']}-#{val['selector']}.key" do
        source 'keys.erb'
        owner node['postfix']['dkim']['user']
        group node['postfix']['dkim']['user']
        mode '0400'
        cookbook new_resource.cookbook
        variables(key: val['key'])
        notifies :restart, 'service[opendkim]'
      end
    end
  end

  template configuration['internalhosts'] do
    source 'internalhosts.erb'
    mode '0644'
    cookbook new_resource.cookbook
    variables(internalhosts: new_resource.internalhosts)
    notifies :restart, 'service[opendkim]', :delayed
    only_if { new_resource.internalhosts }
  end

  template configuration['keytable'] do
    source 'keytable.erb'
    mode '0644'
    cookbook new_resource.cookbook
    variables(keys: new_resource.keys)
    notifies :restart, 'service[opendkim]', :delayed
    only_if { new_resource.keys }
  end

  template configuration['signingtable'] do
    source 'signingtable.erb'
    mode '0644'
    cookbook new_resource.cookbook
    variables(signers: new_resource.signers)
    notifies :restart, 'service[opendkim]', :delayed
    only_if { new_resource.signers }
  end

  new_resource.updated_by_last_action(true)

end
