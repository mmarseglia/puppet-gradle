# == Class: gradle
#
# Install the Gradle build system from the official project site.
# The required Java runtime environment will not be installed automatically.
#
# Supported operating systems are:
#   - Fedora Linux
#   - Debian Linux
#   - Ubuntu Linux
#   - CentOS
#
# === Parameters
#
# [*version*]
#   Specify the version of Gradle which should be installed.
#
# [*base_url*]
#   Specify the base URL of the Gradle ZIP archive. Usually this doesn't
#   need to be changed.
#
# [*url*]
#   Specify the absolute URL of the Gradle ZIP archive. This overrides any
#   version which has been set before.
#
# [*target*]
#   Specify the location of the symlink to the Gradle installation on the local
#   filesystem.
#
# [*daemon*]
#   Specify if the Gradle daemon should be running
#
# === Variables
#
# The variables being used by this module are named exactly like the class
# parameters with the prefix 'gradle_', e. g. *gradle_version* and *gradle_url*.
#
# === Examples
#
#  class { 'gradle':
#    version => '1.8'
#  }
#
#
class gradle(
  $version  = $gradle::params::version,
  $base_url = $gradle::params::base_url,
  $url      = $gradle::params::url,
  $target   = $gradle::params::target,
  $timeout  = $gradle::params::timeout,
  $daemon   = $gradle::params::daemon,
) inherits gradle::params {

  include stdlib

  validate_string($version)
  validate_string($base_url)
  validate_string($target)

  $gradle_filename = "gradle-${version}-all.zip"
  $gradle_directory = "${target}/gradle-${version}"
  $url = "${base_url}/${gradle_filename}"

  file { '/etc/profile.d/gradle.sh':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/gradle.sh.erb"),
  }

  staging::file { $gradle_filename :
    source  => "${base_url}/${gradle_filename}",
    timeout => $timeout,
  }

  staging::extract { $gradle_filename :
    target  => $target,
    creates => $gradle_directory,
    require => [ Staging::File[$gradle_filename] ],
  }

}
