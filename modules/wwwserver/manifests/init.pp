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

    $repo_url = 'http://repo.metabuild.net/artifactory/libs-snapshot-local'
    $www_version = '1.1-SNAPSHOT'
    $www_download_url = "${repo_url}/org/metabuild/www/${www_version}/www-${www_version}.war"
    
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
    
    exec { 'download_www_war':
        command => "wget -O www.war ${www_download_url}",
        cwd => "/tmp",
        creates => "/tmp/www.war",
        path => ["/usr/bin"],
        require => Class['aws_client'],
        notify => Exec['purge_old_root'],
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
        source => '/tmp/www.war',
        require => Exec['download_www_war'],
    }
    
}
