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
class artifactory ($artifactory_download_url = "http://repo.metabuild.net/artifactory/tools/artifactory/2.6.3/artifactory.war") {

    include tomcat

    exec { 'download':
        command => "wget $artifactory_download_url",
        cwd => "/var/lib/tomcat7/webapps",
        creates => "/var/lib/tomcat7/webapps/artifactory.war",
        path => ["/usr/bin"],
        require => File['/usr/share/tomcat7/.artifactory'],
    }
    
    file { '/var/lib/tomcat7/webapps/artifactory.war':
        ensure => present,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '644',
        require => Exec['download'],
    }
    
    file { '/usr/share/tomcat7/.artifactory':
        ensure => directory,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '700',
        require => Class['tomcat'],
    }
}
