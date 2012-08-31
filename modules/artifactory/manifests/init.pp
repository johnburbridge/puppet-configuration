# Class: artifactory
#
# This module manages artifactory
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class artifactory  {

    include tomcat
    
    file { '/var/lib/tomcat7/webapps/artifactory.war':
        ensure => present,
        source => '/tmp/artifactory.war',
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '700',
        require => File['/usr/share/tomcat7/.artifactory'],
    }
    
    file { '/usr/share/tomcat7/.artifactory':
        ensure => directory,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '700',
        require => Class['tomcat'],
    }
}
