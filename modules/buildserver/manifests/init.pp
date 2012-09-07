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
    
    include jenkins
    include artifactory
    
    # need to make sure the . folders belongs to tomcat so that 
    # the jenkins can write to it them
    file { '/usr/share/tomcat7/.ssh':
        ensure => directory,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '700',
        require => Class['tomcat'],
    }
    
    file { '/usr/share/tomcat7/.m2':
        ensure => directory,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '700',
        require => Class['tomcat'],
    }
    
    file { '/usr/share/tomcat7/.git':
        ensure => directory,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '755',
        require => Class['tomcat'],
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
    
    file { '/usr/share/tomcat7/.gradle':
        ensure => directory,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '700',
        require => Class['tomcat'],
    }

    file { '/usr/share/tomcat7/.gradle/gradle.properties':
        content => template('buildserver/gradle.properties.erb'),
        checksum => md5,
        replace => true,
        owner => 'tomcat7',
        group => 'tomcat7',
        mode => '640',
        ensure => present,
        require => File['/usr/share/tomcat7/.gradle'],
    }
    
    # make sure that ip forwarding is enabled
    file { '/etc/sysctl.conf':
        content => template('buildserver/sysctl.conf.erb'),
        checksum => md5,
        replace => true,
        owner => 'root',
        group => 'root',
        mode => '644',
        ensure => present,
    }
}
