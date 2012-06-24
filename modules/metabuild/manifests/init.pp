class metabuild {

	class {'artifactory':
		url => "http://repo.metabuild.net:8081/artifactory"
	}

	artifactory::artifact {'metabuild':
		gav => "org.metabuild:www:$metabuildSiteVersion:war",
#		ensure => present,
		output => "/var/lib/jetty/webapps/root.war"
	}
}
