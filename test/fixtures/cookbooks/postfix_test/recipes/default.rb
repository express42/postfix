include_recipe 'apt'
include_recipe 'postfix::default_server'

postfix_dkim 'test'

postfix 'test1' do
  master_options(smtpd_port: 125)
  action :create
end

postfix 'test2' do
  master_options(smtpd_port: 225)
  action :create
end
