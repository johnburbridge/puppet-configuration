class metabuild {

	class {'artifactory':
		url => "http://repo.metabuild.net:8081/artifactory"
	}

	artifactory::artifact {'metabuild-war':
		gav => "org.metabuild:www:$metabuildSiteVersion:war",
		ensure => present,
		output => "/var/lib/tomcat6/webapps/ROOT.war",
		require => Package['tomcat6']
	}

#	file { '/var/lib/tomcat6/webapps/ROOT.war':
#		source => '/tmp/metabuild/ROOT.war',
#		checksum => md5,
#		replace => true,
#		owner => 'root',
#		group => 'root',
#		mode => '640',
#		ensure => present
#	}
}
