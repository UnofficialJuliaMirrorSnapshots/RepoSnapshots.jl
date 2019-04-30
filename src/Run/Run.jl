##### Beginning of file

module Run # Begin submodule Snapshots.Run

__precompile__(true)

import ArgParse
import Dates
import HTTP
import Pkg
import TimeZones

import ..Types
import ..Utils
import ..Common

import ..delayederror
import ..process_delayed_error_list

function run_snapshots!!(
        ;
        src_provider,
        dst_provider,
        git_user_name,
        git_user_email,
        include_branches,
        exclude_branches,
        task::String = "all",
        is_dry_run::Bool = false,
        do_not_push_to_these_destinations::Vector{String} =
            String[],
        do_not_try_url_list::Vector{String} =
            String[],
        try_but_allow_failures_url_list::Vector{String} =
            String[],
        time_zone::Dates.TimeZone =
            Dates.TimeZone("America/New_York"),
        )::Nothing
    @info("Running Snapshots.Run.run_snapshots!!")

    all_src_organization_repos::Vector{String} = src_provider(:list_all_repos)()

    unique!(all_src_organization_repos)
    sort!(all_src_organization_repos)
    @debug(
        string(
            "All repos in the source organization ",
            "($(length(all_src_organization_repos))):",
            )
        )
    for i = 1:length(all_src_organization_repos)
        @debug(
            "$(i). $(all_src_organization_repos[i])"
            )
    end

    if task == "all"
        task_src_repos = all_src_organization_repos
    elseif Types._is_interval(task)
        task_interval::Types.AbstractInterval = Types._construct_interval(
            task
            )
        @info(string("Using interval for stage 2: "),task_interval,)
        task_src_repos = Common._names_that_fall_in_interval(
            all_src_organization_repos,
            task_interval,
            )
    else
        @warn("not a valid task: ", task,)
        delayederror("\"$(task)\" is not a valid task")
    end

    unique!(task_src_repos)
    sort!(task_src_repos)
    @debug(
        string(
            "Source repos in the task interval ",
            "($(length(task_src_repos))):",
            )
        )
    for i = 1:length(task_src_repos)
        @debug(
            "$(i). $(task_src_repos[i])"
            )
    end

    n = length(task_src_repos)
    for i = 1:n
        repo_name = strip(task_src_repos[i])
        @debug(
            string(
                "Processing \"$(repo_name)\" ",
                "(repo $(i) of $(n))",
                )
            )
        if false
        else
            if repo_name in do_not_push_to_these_destinations
            else
                Common._snapshot_repo!!(
                    repo_name;
                    src_provider = src_provider,
                    dst_provider = dst_provider,
                    include_branches = include_branches,
                    exclude_branches = exclude_branches,
                    git_user_name = git_user_name,
                    git_user_email = git_user_email,
                    time_zone = time_zone,
                    is_dry_run = is_dry_run,
                    )
            end
        end
    end

    @info(
        string(
            "SUCCESS: run_snapshots completed ",
            "successfully :) Good-bye!",
            )
        )

    process_delayed_error_list()
    return nothing
end

end # End submodule Snapshots.Run

##### End of file
