# Class: aws_client
#
# This module manages aws_client
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
class aws_client(
    $aws_dot_directory,
    $aws_files_owner
) {

    file { 'dot_folder':
        path => "${aws_dot_directory}/.aws",
        ensure => directory,
        owner => $aws_files_owner,
        group => $aws_files_owner,
        mode => '700',
    }
    
    file { 'aws_properties':
        path => "${aws_dot_directory}/.aws/aws.properties",
        content => template('aws_client/aws.properties.erb'),
        checksum => md5,
        replace => false,
        owner => $aws_files_owner,
        group => $aws_files_owner,
        mode => '640',
        ensure => present,
        require => File['dot_folder'],
    }
}
