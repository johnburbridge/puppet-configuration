# Class: jetty8
#
# This module manages jetty8
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
class jetty8 (
    $jetty_version = '8.1.5.v20120716',
    $jetty_port = 8081
) {

    $jetty_download_url = "http://dist.codehaus.org/jetty/deb/${jetty_version}/jetty-deb-${jetty_version}.deb"

    file { '/root/repo':
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => '755',
    }
    
    exec { 'download_jetty':
        command => "wget $jetty_download_url",
        cwd => "/root/repo",
        creates => "/root/repo/jetty-deb-${jetty_version}.deb",
        path => ["/usr/bin"],
        require => File['/root/repo'],
    }
    
    package { 'jetty-hightide-server':
        provider => dpkg,
        ensure => latest,
        require => [Exec['download_jetty'], Package['openjdk-6-jdk']],
        source => "/root/repo/jetty-deb-${jetty_version}.deb",
    }
    
    package { 'openjdk-6-jdk': 
        ensure => latest,
    }
    
    file { "/opt/jetty/start.ini":
        owner => 'root',
        require => Package['jetty-hightide-server'],
        notify => Service['jetty'],
        content => template('jetty8/start.ini.erb')
    }
    
    file { "/opt/jetty/contexts/hightide.xml":
        ensure => absent
    }
    
    service { 'jetty':
        ensure => running,
        hasstatus => false,
        require => Package['jetty-hightide-server'],
    }
    
}
