class jetty {
    package { "jetty":
        ensure => "absent"
    }
    package { "libjetty-extra":
        ensure => "absent"
    }
    service { "jetty":
        ensure => "stopped",
        enable => "false"
    }
}
