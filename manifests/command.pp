define wp::command (
	$location,
	$command,
	$unless = false
) {
	include wp::cli

	if ( $unless ) {
		$_unless = "/usr/bin/wp $unless"
	}

	exec {"$location wp $command":
		command => "/usr/bin/wp $command",
		cwd     => $location,
		user    => $::wp::user,
		require => [ Class['wp::cli'] ],
		onlyif  => '/usr/bin/wp core is-installed',
		unless  => $_unless,
	}
}
