class jetty {
    package { "jetty":
        ensure => "latest"
    }
    package { "libjetty-extra":
        ensure => "latest",
        require => Package["jetty"]
    }
    service { "jetty":
        ensure => "running",
        enable => "true",
        require => Package["jetty"],
    }
}
