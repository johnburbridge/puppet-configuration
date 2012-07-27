# Class: buildserver
#
# This module manages the secrets for the build.metabuild.net server 
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
class buildserver {
    
    $jenkins_download_url = "http://mirrors.jenkins-ci.org/war/latest/jenkins.war"
    
    exec { "wget $jenkins_download_url":
        cwd => "/var/lib/tomcat7/webapps",
        creates => "/var/lib/tomcat7/webapps/jenkins.war",
        path => ["/usr/bin"],
        require => File['/usr/share/tomcat7/.jenkins'],
    }
    
    file { '/usr/share/tomcat7/.jenkins':
        ensure => directory,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '700',
        require => Package['tomcat7'],
    }

    
    # need to make sure the .git folder belongs to tomcat so that 
    # the jenkins git plug-in can write to it
    file { '/usr/share/tomcat7/.git':
        ensure => directory,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '755',
        require => Package['tomcat7'],
    }
    
    file { '/usr/share/tomcat7/.git/config':
        content => template('buildserver/git-config.erb'),
        checksum => md5,
        replace => false,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '644',
        ensure => present,
        require => File['/usr/share/tomcat7/.git'],
    }
    
    file { '/usr/share/tomcat7/.aws':
        ensure => directory,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '700',
        require => Package['tomcat7'],
    }
    
    file { '/usr/share/tomcat7/.aws/aws.properties':
        content => template('buildserver/aws.properties.erb'),
        checksum => md5,
        replace => false,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '640',
        ensure => present,
        require => File['/usr/share/tomcat7/.aws'],
    }

    file { '/usr/share/tomcat7/.gradle':
        ensure => directory,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '700',
        require => Package['tomcat7'],
    }

    file { '/usr/share/tomcat7/.gradle/gradle.properties':
        content => template('buildserver/gradle.properties.erb'),
        checksum => md5,
        replace => false,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '640',
        ensure => present,
        require => File['/usr/share/tomcat7/.gradle'],
    }
}
