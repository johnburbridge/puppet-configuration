class metabuild {

	class {'artifactory':
		url => "http://repo.metabuild.net:8081/artifactory"
	}

	artifactory::artifact {'metabuild-war':
		gav => "org.metabuild:www:$metabuildSiteVersion:war",
		output => "/tmp/ROOT.war",
		require => Package['tomcat6']
	}

	file { '/var/lib/tomcat6/webapps/ROOT.war':
		source => '/tmp/ROOT.war',
		checksum => md5,
		replace => true,
		owner => 'tomcat6',
		group => 'tomcat6',
		mode => '640',
		ensure => present,
		require => artifactory::artifact['metabuild-war']
	}

	exec { 'deleteAfterDownload':
		user => 'root',
		path => '/bin:/usr/bin',
		command => 'rm -Rf /var/lib/tomcat6/webapps/ROOT',
		refreshonly => true,
		subscribe => File['/var/lib/tomcat6/webapps/ROOT.war']
	}
}
