# == Class: gradle::params
#
# === Authors
#
# Jochen Schalanda <j.schalanda@gini.net>
#
# === Copyright
#
# Copyright 2012, 2013 smarchive GmbH, 2013 Gini GmbH
#
class gradle::params {
  $version  = '1.8'
  $base_url = 'http://services.gradle.org/distributions'
  $target   = '/opt'
  $timeout   = 360
  $daemon   = true
}
