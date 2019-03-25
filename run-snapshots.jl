##### Beginning of file

@info("Importing the OrganizationSnapshots module...")

import OrganizationSnapshots

import TimeZones

@info("Reading config files...")

include(joinpath("config","preferences","git-hosts.jl",))
include(joinpath("config","preferences","time-zone.jl",))

include(
    joinpath(
        "config",
        "repositories",
        "do-not-push-to-these-destinations.jl",
        )
    )
include(
    joinpath(
        "config",
        "repositories",
        "do-not-try-url-list.jl",
        )
    )
include(
    joinpath(
        "config",
        "repositories",
        "try-but-allow-failures-url-list.jl",
        )
    )

OrganizationSnapshots.CommandLine.run_mirror_updater_command_line!!(
    ;
    arguments = ARGS,
    src_provider = src_provider,
    dst_provider = dst_provider,
    do_not_try_url_list = DO_NOT_TRY_URL_LIST,
    do_not_push_to_these_destinations = DO_NOT_PUSH_TO_THESE_DESTINATIONS,
    try_but_allow_failures_url_list = TRY_BUT_ALLOW_FAILURES_URL_LIST,
    time_zone = TIME_ZONE,
    )

##### End of file
