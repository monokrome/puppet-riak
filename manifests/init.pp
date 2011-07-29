class riak {
	$package_filename = "riak_0.14.2-1_${architecture}.deb"
	$package_location = "/opt/packages/${package_filename}"

	file {
		"/opt/packages":
			ensure => directory,
	}

	file {
		"${package_location}":
			ensure => present,
			mode => 660,
			source => "puppet:///riak/${package_filename}"
	}

	package {
		"riak":
			provider => "dpkg",
			ensure => latest,
			source => $package_location,
			require => File[$package_location],
	}

	service {
		"riak":
			ensure => running,
			require => Package["riak"],
			hasrestart => true,
			hasstatus => true,
	}

	file {
		"/etc/riak/app.config":
			ensure => present,
			mode => 644,
			source => "puppet:///riak/app.config",
			require => Package["riak"],
			notify => Service["riak"],
	}
}

