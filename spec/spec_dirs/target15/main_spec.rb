puts ("==============================")
puts ("Role test")
puts ("openstack_rabbitmq: #{ ENV['CONN_NAME'] }")
puts ("==============================")

system("cd spec && rm -rf host_vars")
system("cd spec && cp -r host_vars_dirs/host_vars_01 host_vars")
system("cd spec && ansible-playbook -i inventory site.yml")

require 'spec_helper'
file_dir = File.dirname(__FILE__)

describe ("check rabbitmq-server package is installed") do
  describe package("rabbitmq-server") do
    it { should be_installed }
  end
end

describe ("check rabbitmq-server service is enabled and started") do
  describe service("rabbitmq-server") do
    it { should be_running }
    it { should be_enabled }
  end
end

describe ("check rabbitmq user 'openstack' exists") do
  describe command("rabbitmqctl list_users") do
    its(:stdout) { should match /^openstack\s.*$/}
  end
end

describe ("check rabbitmq user 'openstack' has free access permission for vhost '/'") do
  describe command("rabbitmqctl list_permissions") do
    its(:stdout) { should match /^openstack\s+\.\*\s+\.\*\s+\.\*$/ }
  end
end

