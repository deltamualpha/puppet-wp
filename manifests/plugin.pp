define wp::plugin (
	$slug = $title,
	$location,
	$ensure = enabled,
	$networkwide = false
) {
	include wp::cli

	case $ensure {
		enabled: {
			if ( $networkwide ) {
				$command = "plugin activate ${slug} --network"
			} else {
				$command = "plugin activate ${slug}"
			}

			wp::command { "plugin install ${slug}":
				command  => "plugin install ${slug}",
				unless   => "plugin is-installed ${slug}",
				location => $location,
				before   => Wp::Command["plugin activate ${slug}"],
			}

			wp::command { "plugin activate ${slug}":
				command  => $command,
				location => $location,
			}
		}
		disabled: {
			if ( $networkwide ) {
				$command = "plugin deactivate ${slug} --network"
			} else {
				$command = "plugin deactivate ${slug}"
			}

			wp::command { "plugin deactivate ${slug}":
				command  => $command,
				location => $location,
			}
		}
		default: {
			fail("Invalid ensure for wp::plugin")
		}
	}
}
