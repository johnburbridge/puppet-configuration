# Class: jenkins
#
# This module manages jenkins
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
class jenkins ($jenkins_download_url = "http://mirrors.jenkins-ci.org/war/latest/jenkins.war") {

    include tomcat
    
    exec { 'download_jenkins_war':
        command => "wget $jenkins_download_url",
        cwd => "/var/lib/tomcat7/webapps",
        creates => "/var/lib/tomcat7/webapps/jenkins.war",
        path => ["/usr/bin"],
        require => File['/usr/share/tomcat7/.jenkins'],
    }
    
    file { '/var/lib/tomcat7/webapps/jenkins.war':
        ensure => present,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '644',
        require => Exec['download_jenkins_war'],
    }
    
    file { '/usr/share/tomcat7/.jenkins':
        ensure => directory,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '700',
        require => Class['tomcat'],
    }
}
