##### Beginning of file

module Run # Begin submodule OrganizationSnapshots.Run

__precompile__(true)

import ArgParse
import Dates
import HTTP
import Pkg
import TimeZones

import ..Types
import ..Utils
import ..Common

function run_organization_snapshots!!(
        ;
        src_provider,
        dst_provider,
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
    @info("Running OrganizationSnapshots.Run.run_organization_snapshots!!")

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
        error("\"$(task)\" is not a valid task")
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
        if !startswith(repo_name, "Predict")
        else
            Common._snapshot_repo!!(
                repo_name;
                src_provider = src_provider,
                dst_provider = dst_provider,
                )
        end
    end

    # if task == "all" || Types._is_interval(task)
    #     @info("Starting stage 2...")
    #     if has_gist_description
    #         correct_gist_content_stage2::String = ""
    #         @info("looking for the correct gist")
    #         args = Dict(
    #             :gist_description => gist_description,
    #             )
    #         for p = 1:length(git_hosting_providers)
    #             @info(
    #                 string(
    #                     "Git hosting provider ",
    #                     "$(p) of $(length(git_hosting_providers))",
    #                     ),
    #                 )
    #             provider = git_hosting_providers[p]
    #             if length(correct_gist_content_stage2) == 0
    #                 @info(
    #                     string(
    #                         "Searching git hosting provider $(p) ",
    #                         "for the correct gist.",
    #                         )
    #                     )
    #                 correct_gist_content_stage2 = try
    #                     provider(:retrieve_gist)(args)
    #                 catch exception
    #                     @warn("Ignored exception", exception,)
    #                     ""
    #                 end
    #             end
    #         end
    #         if length(strip(correct_gist_content_stage2)) == 0
    #             error("I could not find the correct gist on any host")
    #         end
    #         all_repos_to_mirror_stage2 =
    #             Common._string_to_src_dest_pair_list(
    #                 correct_gist_content_stage2
    #                 )
    #     else
    #         @info("no need to download any gists: I already have the list")
    #         all_repos_to_mirror_stage2 =
    #             all_repos_to_mirror_stage1
    #     end
    #     @info(
    #         string(
    #             "The full list has ",
    #             "$(length(all_repos_to_mirror_stage2)) ",
    #             "unique pairs.",
    #             )
    #         )
    #     if Types._is_interval(task)
    #         task_interval::Types.AbstractInterval =
    #             Types._construct_interval(task)
    #         @info(
    #             string("Using interval for stage 2: "),
    #             task_interval,
    #             )
    #         selected_repos_to_mirror_stage2 =
    #             Common._pairs_that_fall_in_interval(
    #                 all_repos_to_mirror_stage2,
    #                 task_interval,
    #                 )
    #     else
    #         selected_repos_to_mirror_stage2 =
    #             all_repos_to_mirror_stage2
    #     end
    #     @info(
    #         string(
    #             "The selected subset of the list ",
    #             "for this particular job has ",
    #             "$(length(selected_repos_to_mirror_stage2)) ",
    #             "unique pairs.",
    #             )
    #         )
    #     Common._push_mirrors!!(
    #         ;
    #         src_dest_pairs = selected_repos_to_mirror_stage2,
    #         git_hosting_providers = git_hosting_providers,
    #         is_dry_run = is_dry_run,
    #         do_not_try_url_list =
    #             do_not_try_url_list,
    #         try_but_allow_failures_url_list =
    #             try_but_allow_failures_url_list,
    #         do_not_push_to_these_destinations =
    #             do_not_push_to_these_destinations,
    #         time_zone = time_zone,
    #         )
    #     @info("SUCCESS: Stage 2 completed successfully.")
    # end



    @info(
        string(
            "SUCCESS: run_organization_snapshots completed ",
            "successfully :) Good-bye!",
            )
        )

    return nothing
end

end # End submodule OrganizationSnapshots.Run

##### End of file
