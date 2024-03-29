name              'postfix'
maintainer        'LLC Express 42'
maintainer_email  'cookbooks@express42.com'
license           'MIT'
description       'Installs and configures postfix and DKIM. Provides LWRPs for managing multiple instances.'
version           '0.1.1'

recipe            'postfix::default', 'Do nothing.'
recipe            'postfix::default_server', 'Installs and configures default postfix instance.'

supports          'ubuntu'
