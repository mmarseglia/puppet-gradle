# == Class: gradle
#
# Install the Gradle build system from the official project site.
# The required Java runtime environment will not be installed automatically.
#
# Requires module staging, https://github.com/nanliu/puppet-staging
#
# Supported operating systems are:
#   - Fedora Linux
#   - Debian Linux
#   - Ubuntu Linux
#   - CentOS
#
# Supported puppet version
#   - Puppet > 2.6.2
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
# [*gradle_filename*]
#   Full name of the gradle archive we are going to download from the remote site.
#
# [*gradle_directory*]
#   Directory to extract the gradle archive into.
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
  $target   = $gradle::params::target,
  $timeout  = $gradle::params::timeout,
  $daemon   = $gradle::params::daemon,
) inherits gradle::params {

  include stdlib

  # input validation
  validate_string($version)
  validate_string($base_url)
  validate_string($target)

  # filename of the gradle archive to obtain from $base_url
  $gradle_filename = "gradle-${version}-all.zip"

  # directory to unpack the grade archive into
  $gradle_directory = "${target}/gradle-${version}"

  # install a default gradle profile for all users
  file { '/etc/profile.d/gradle.sh':
    ensure  => file,
    mode    => '0644',
    content => template("${module_name}/gradle.sh.erb"),
  }

  # download the gradle archive from the remote site
  staging::file { $gradle_filename :
    source  => "${base_url}/${gradle_filename}",
    timeout => $timeout,
  }

  # extract the archive into the target directory
  #staging::extract { $gradle_filename :
  #  target  => $target,
  #  creates => $gradle_directory,
  #  require => [ Staging::File[$gradle_filename] ],
  #}
  exec { 'extract_gradle' :
    cwd => '/opt',
    command => '/usr/bin/unzip -o /opt/staging/gradle/gradle-1.8-all.zip -d /opt',
    require => Staging::File[$gradle_filename],
  }
}
