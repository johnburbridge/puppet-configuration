class jetty {
    package { "jetty":
        ensure => "latest"
    }
    service { "jetty":
        ensure => "running",
        enable => "true",
        require => Package["jetty"],
    }
}
