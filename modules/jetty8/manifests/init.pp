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
class jetty8 ($jetty8_download_url = 'http://dist.codehaus.org/jetty/deb/8.1.5.v20120716/jetty-deb-8.1.5.v20120716.deb') {

    file { '/root/repo':
        ensure => directory,
        owner => 'root',
        group => 'root',
        mode => '755',
    }
    
    exec { 'download_jetty8':
        command => "wget $jetty8_download_url",
        cwd => "/root/repo",
        creates => "/root/repo/jetty-deb-8.1.5.v20120716.deb",
        path => ["/usr/bin"],
        require => File['/root/repo'],
    }
    
    package { 'jetty-hightide-server':
        provider => dpkg,
        ensure => latest,
        require => Exec['download_jetty8'],
        source => '/root/repo/jetty-deb-8.1.5.v20120716.deb',
    }
    
    service { 'jetty':
        ensure => running,
        hasstatus => false,
        require => Package['jetty-hightide-server'],
    }
    
}
