default['postfix']['options']['myhostname'] = node['fqdn']
default['postfix']['options']['mydomain']   = node['domain']
default['postfix']['options']['myorigin']   = '$myhostname'
default['postfix']['options']['mydestination'] = "#{fqdn}, #{node['hostname']}, localhost.localdomain, localhost"
default['postfix']['options']['mynetworks'] = '127.0.0.0/8'
default['postfix']['options']['inet_interfaces'] = 'loopback-only'
default['postfix']['options']['inet_protocols'] = 'ipv4'
default['postfix']['options']['smtp_use_tls']    = 'yes'
default['postfix']['options']['smtpd_use_tls'] = 'yes'
default['postfix']['options']['smtpd_tls_cert_file'] = '/etc/ssl/certs/ssl-cert-snakeoil.pem'
default['postfix']['options']['smtpd_tls_key_file'] = '/etc/ssl/private/ssl-cert-snakeoil.key'
default['postfix']['options']['smtpd_tls_session_cache_database'] = 'btree:${queue_directory}/cache/smtpd_scache'
default['postfix']['options']['smtp_tls_session_cache_database'] = 'btree:${queue_directory}/cache/smtp_scache'
default['postfix']['options']['smtp_sasl_auth_enable'] = 'no'
default['postfix']['options']['alias_maps'] = 'hash:/etc/aliases'
default['postfix']['options']['alias_database'] = 'hash:/etc/aliases'

default['postfix']['master_options']['smtpd_port'] = 'smtp'
