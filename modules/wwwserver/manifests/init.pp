# Class: wwwserver
#
# This module manages wwwserver
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
class wwwserver {

    $www_version = $::www_version
    
    class { 'jetty8':
        jetty_port => 8085,
    }
    
    class { 'aws_client':
        aws_dot_directory => '/root',
        aws_files_owner => 'root',
        require => Class['jetty8'],
    }
    
    file { '/opt/jetty/contexts/root.xml':
        content => template('wwwserver/root.xml.erb'),
        checksum => md5,
        replace => true,
        owner => 'root',
        group => 'root',
        mode => '644',
        ensure => present,
        require => Class['jetty8'],
    }
    
    file { '/opt/jetty/etc/webdefault.xml':
        content => template('wwwserver/webdefault.xml.erb'),
        checksum => md5,
        replace => true,
        owner => 'root',
        group => 'root',
        mode => '644',
        ensure => present,
        require => Class['jetty8'],
    }
    
    exec { 'purge_old_root':
        command => 'rm -Rf root', 
        cwd => '/opt/jetty/webapps',
        path => ['/bin'],
        refreshonly => true
    }

    file { '/opt/jetty/webapps/root.war':
        ensure => present,
        owner => 'root',
        group => 'root',
        mode => '644',
        backup => false,
        source => "puppet:///modules/wwwserver/www-${www_version}.war",
        require => Exec['purge_old_root'],
        notify => Service['jetty'],
    }
    
}
