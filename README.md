# Description

Installs and configures postfix and DKIM. Provides LWRPs for managing multiple instances

# Requirements

## Platform:

* Debian
* Ubuntu

## Cookbooks:

*No dependencies defined*

# Attributes

* `node['postfix']['options']['myhostname']` -  Defaults to `"fqdn"`.
* `node['postfix']['options']['mydomain']` -  Defaults to `"domain"`.
* `node['postfix']['options']['myorigin']` -  Defaults to `"$myhostname"`.
* `node['postfix']['options']['mydestination']` -  Defaults to `"\#{fqdn}, \#{node['hostname']}, localhost.localdomain, localhost"`.
* `node['postfix']['options']['mynetworks']` -  Defaults to `"127.0.0.0/8"`.
* `node['postfix']['options']['inet_interfaces']` -  Defaults to `"loopback-only"`.
* `node['postfix']['options']['inet_protocols']` -  Defaults to `"ipv4"`.
* `node['postfix']['options']['smtp_use_tls']` -  Defaults to `"yes"`.
* `node['postfix']['options']['smtpd_use_tls']` -  Defaults to `"yes"`.
* `node['postfix']['options']['smtpd_tls_cert_file']` -  Defaults to `"/etc/ssl/certs/ssl-cert-snakeoil.pem"`.
* `node['postfix']['options']['smtpd_tls_key_file']` -  Defaults to `"/etc/ssl/private/ssl-cert-snakeoil.key"`.
* `node['postfix']['options']['smtpd_tls_session_cache_database']` -  Defaults to `"btree:${queue_directory}/cache/smtpd_scache"`.
* `node['postfix']['options']['smtp_tls_session_cache_database']` -  Defaults to `"btree:${queue_directory}/cache/smtp_scache"`.
* `node['postfix']['options']['smtp_sasl_auth_enable']` -  Defaults to `"no"`.
* `node['postfix']['options']['alias_maps']` -  Defaults to `"hash:/etc/aliases"`.
* `node['postfix']['options']['alias_database']` -  Defaults to `"hash:/etc/aliases"`.
* `node['postfix']['master_options']['smtpd_port']` -  Defaults to `"smtp"`.
* `node['postfix']['dkim']['databag']` -  Defaults to `"postfix-dkim"`.
* `node['postfix']['dkim']['signingtable']` -  Defaults to `"/etc/opendkim/signingtable"`.
* `node['postfix']['dkim']['keytable']` -  Defaults to `"/etc/opendkim/keytable"`.
* `node['postfix']['dkim']['internalhosts']` -  Defaults to `"/etc/opendkim/internalhosts"`.
* `node['postfix']['dkim']['user']` -  Defaults to `"opendkim"`.
* `node['postfix']['dkim']['options']['SysLog']` -  Defaults to `"yes"`.
* `node['postfix']['dkim']['options']['Umask']` -  Defaults to `"002"`.
* `node['postfix']['dkim']['options']['Mode']` -  Defaults to `"s"`.
* `node['postfix']['dkim']['options']['UserID']` -  Defaults to `"opendkim:opendkim"`.
* `node['postfix']['dkim']['options']['Socket']` -  Defaults to `"inet:8891@localhost"`.
* `node['postfix']['dkim']['options']['Canonicalization']` -  Defaults to `"relaxed/simple"`.
* `node['postfix']['dkim']['options']['KeyTable']` -  Defaults to `"refile:\#{node['postfix']['dkim']['keytable']}"`.
* `node['postfix']['dkim']['options']['SigningTable']` -  Defaults to `"refile:\#{node['postfix']['dkim']['signingtable']}"`.
* `node['postfix']['dkim']['options']['InternalHosts']` -  Defaults to `"refile:\#{node['postfix']['dkim']['internalhosts']}"`.
* `node['postfix']['dkim']['options']['PidFile']` -  Defaults to `"/var/run/opendkim/opendkim.pid"`.

# Recipes

* postfix::default
* postfix::default_server

# Resources

* [postfix](#postfix)
* [postfix_dkim](#postfix_dkim)

## postfix

### Actions

- create:

### Attribute Parameters

- name:
- cookbook:  Defaults to <code>"postfix"</code>.
- options:  Defaults to <code>{}</code>.
- master_options:  Defaults to <code>{}</code>.

## postfix_dkim

### Actions

- setup:

### Attribute Parameters

- name:
- cookbook:  Defaults to <code>"postfix"</code>.
- configuration:  Defaults to <code>{}</code>.
- keys:  Defaults to <code>nil</code>.
- signers:  Defaults to <code>nil</code>.
- internalhosts:  Defaults to <code>nil</code>.

# License and Maintainer

Maintainer:: LLC Express 42 (<info@express42.com>)

License:: MIT
