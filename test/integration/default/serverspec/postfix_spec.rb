require 'spec_helper'

describe package('postfix') do
  it { should be_installed }
end

describe file('/etc/postfix') do
  it { should be_directory }
end

describe file('/var/spool/postfix') do
  it { should be_directory }
end

describe file('/var/spool/postfix/cache') do
  it { should be_directory }
end

describe file('/etc/postfix/main.cf') do
  it { should be_file }
end

describe file('/etc/postfix/master.cf') do
  it { should be_file }
end

describe service('postfix') do
  it { should be_enabled }
  it { should be_running }
end

describe port(25) do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end

describe package('opendkim') do
  it { should be_installed }
end

describe service('opendkim') do
  it { should be_enabled }
  it { should be_running }
end

describe port(8891) do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end

describe file('/etc/opendkim') do
  it { should be_directory }
end

describe file('/etc/opendkim/keys') do
  it { should be_directory }
end

describe file('/etc/opendkim.conf') do
  it { should be_file }
end

describe file('/etc/opendkim/internalhosts') do
  it { should be_file }
end

describe file('/etc/opendkim/keytable') do
  it { should be_file }
end

describe file('/etc/opendkim/signingtable') do
  it { should be_file }
end

describe file('/etc/postfix-test1') do
  it { should be_directory }
end

describe file('/var/spool/postfix-test1') do
  it { should be_directory }
end

describe file('/var/spool/postfix-test1/cache') do
  it { should be_directory }
end

describe file('/etc/postfix-test1/main.cf') do
  it { should be_file }
end

describe file('/etc/postfix-test1/master.cf') do
  it { should be_file }
end

describe port(125) do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end

describe file('/etc/postfix-test2') do
  it { should be_directory }
end

describe file('/var/spool/postfix-test2') do
  it { should be_directory }
end

describe file('/var/spool/postfix-test2/cache') do
  it { should be_directory }
end

describe file('/etc/postfix-test2/main.cf') do
  it { should be_file }
end

describe file('/etc/postfix-test2/master.cf') do
  it { should be_file }
end

describe port(225) do
  it { should be_listening.on('127.0.0.1').with('tcp') }
end
