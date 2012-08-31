# Resource: artifactory::artifact
#
# This resource downloads Maven Artifacts from artifactory
#
# Parameters:
# [*gav*] : The artifact groupid:artifactid:version (mandatory)
# [*packaging*] : The packaging type (jar by default)
# [*classifier*] : The classifier (no classifier by default)
# [*repository*] : The repository such as 'public', 'central'...(mandatory)
# [*output*] : The output file (mandatory)
# [*ensure*] : If 'present' checks the existence of the output file (and downloads it if needed), if 'absent' deletes the output file, if not set redownload the artifact
#
# Actions:
# If ensure is set to 'present' the resource checks the existence of the file and download the artifact if needed.
# If ensure is set to 'absent' the resource deleted the output file.
# If ensure is not set or set to 'update', the artifact is re-downloaded.
#
# Sample Usage:
#  class artifactory {
#   url => http://edge.spree.de/artifactory,
#   username => user,
#   password => password
# }
#
define artifactory::artifact(
	$gav,
	$classifier = "",
	$output,
	$ensure = update
	) {
	
	include artifactory
	
	if ($artifactory::authentication) {
		$args = "-u ${::user} -p '${artifactory::pwd}'"
	} else {
		$args = ""
	}

	$cmd = "/opt/artifactory-script/artifactory-downloader.sh -a ${gav} -b ${artifactory::artifactory_url} -o ${output} $args -v"

	debug "download command: $cmd"	

	if $ensure == present {
		exec { "Download ${gav}":
			command => $cmd,
			unless  => "/usr/bin/test -f ${output}"
		}
	} elsif $ensure == absent {
		file { "Remove ${gav}":
			path   => $output,
			ensure => absent
		}
	} else {
		exec { "Download ${gav}":
			command => $cmd,
		}
	}
}
