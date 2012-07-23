class tomcat {

  $tomcat_port = 8080
  
  notice("Establishing http://$::hostname:$tomcat_port/")

  Package { # defaults
    ensure => latest,
  }

  package { 'tomcat7':
  }

  package { 'tomcat7-user':
    require => Package['tomcat7'],
  }
 
  package { 'tomcat7-admin':
    require => Package['tomcat7'],
  }

  package { 'libservlet3.0-java':
  }

  file { "/etc/tomcat7/tomcat-users.xml":
    owner => 'root',
    require => Package['tomcat7'],
    notify => Service['tomcat7'],
    content => template('tomcat/tomcat-users.xml.erb')
  }

  file { '/etc/tomcat7/server.xml':
    owner => 'root',
    require => Package['tomcat7'],
    notify => Service['tomcat7'],
    content => template('tomcat/server.xml.erb'),
  }

  service { 'tomcat7':
    ensure => running,
    require => Package['tomcat7'],
  }   

}

define tomcat::deployment($path) {
  include tomcat
  notice("Establishing http://$::hostname:${tomcat::tomcat_port}/$name/")

  file { "/var/lib/tomcat7/webapps/${name}.war":
    owner => 'root',
    source => $path,
  }
}
