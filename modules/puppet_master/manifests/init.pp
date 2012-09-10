# Class: puppet_master
#
# This module manages puppet_master
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
class puppet_master {
    
    $path_to_environments = '/etc/puppetlabs/puppet/environments'
    $base_repo_url = 'http://repo.metabuild.net/artifactory'
    $snapshot_repo_url = "${base_repo_url}/libs-snapshot-local"
    $release_repo_url = "${base_repo_url}/libs-release-local"
    
    $www_dev_version = $::www_dev_version
    $www_uat_version = $::www_uat_version
    $www_prod_version = $::www_prod_version
    
    package { 'wget':
        ensure => latest,
    }
    
    exec { 'download_wwwserver_development_war':
        command => "wget -O 'www-${www_dev_version}.war' '${snapshot_repo_url}/org/metabuild/www/${www_dev_version}/www-${$www_dev_version}.war'",
        cwd => "${path_to_environments}/development/modules/wwwserver/files",
        creates => "${path_to_environments}/development/modules/wwwserver/files/www-${www_dev_version}.war",
        path => ["/usr/bin"],
        require => Package['wget'],
    }
    
    exec { 'download_wwwserver_uat_war':
        command => "wget -O 'www-${www_uat_version}.war' '${snapshot_repo_url}/org/metabuild/www/${www_dev_version}/www-${$www_uat_version}.war'",
        cwd => "${path_to_environments}/testing/modules/wwwserver/files",
        creates => "${path_to_environments}/testing/modules/wwwserver/files/www-${www_uat_version}.war",
        path => ["/usr/bin"],
        require => Package['wget'],
    }
    
    exec { 'download_wwwserver_prod_war':
        command => "wget -O 'www-${www_prod_version}.war' '${release_repo_url}/org/metabuild/www/${www_prod_version}/www-${$www_prod_version}.war'",
        cwd => "${path_to_environments}/production/modules/wwwserver/files",
        creates => "${path_to_environments}/production/modules/wwwserver/files/www-${www_prod_version}.war",
        path => ["/usr/bin"],
        require => Package['wget'],
    }
}

