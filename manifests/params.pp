# == Class: gradle::params
#
#
class gradle::params {
  $version  = '1.8'
  $base_url = 'http://services.gradle.org/distributions'
  $target   = '/opt'
  $imeout   = 360
  $daemon   = true
}
