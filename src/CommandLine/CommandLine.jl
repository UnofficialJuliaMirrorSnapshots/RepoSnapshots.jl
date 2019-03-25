##### Beginning of file

module CommandLine # Begin submodule OrganizationSnapshots.CommandLine

__precompile__(true)

import ArgParse
import Dates
import HTTP
import Pkg
import TimeZones

import ..Types
import ..Utils
import ..Common
import ..Run

function run_organization_snapshots_command_line!!(
        ;
        arguments::Vector{String} = String[],
        src_provider,
        dst_provider,
        do_not_push_to_these_destinations::Vector{String} = String[],
        do_not_try_url_list::Vector{String} = String[],
        try_but_allow_failures_url_list::Vector{String} =
            String[],
        time_zone::TimeZones.TimeZone =
            TimeZones.TimeZone("America/New_York"),
        )::Nothing
    @info(
        string(
            "Running OrganizationSnapshots.CommandLine.",
            "run_organization_snapshots_command_line!!"
            )
        )
    @info("parsing command line arguments...")
    parsed_arguments::Dict = _parse_arguments(
        arguments
        )
    @info("processing parsed command line arguments...")
    processed_arguments::Dict = _process_parsed_arguments(
        parsed_arguments
        )
    task::String = processed_arguments[:task]
    is_dry_run::Bool = processed_arguments[:is_dry_run]
    Run.run_organization_snapshots!!(
        ;
        src_provider = src_provider,
        dst_provider = dst_provider,
        task = task,
        is_dry_run = is_dry_run,
        time_zone = time_zone,
        do_not_push_to_these_destinations =
            do_not_push_to_these_destinations,
        do_not_try_url_list =
            do_not_try_url_list,
        try_but_allow_failures_url_list =
            try_but_allow_failures_url_list,
        )
    return nothing
end

function _parse_arguments(arguments::Vector{String})::Dict
    s = ArgParse.ArgParseSettings()
    ArgParse.@add_arg_table s begin
        "--task"
            help = "which task to run"
            arg_type = String
            default = ""
        "--dry-run"
            help = "do everything except actually pushing the repos"
            action = :store_true
    end
    result::Dict = ArgParse.parse_args(arguments, s)
    return result
end

function _process_parsed_arguments(parsed_arguments::Dict)::Dict{Symbol, Any}
    task_argument::String = strip(
        convert(String, parsed_arguments["task"])
        )
    if length(task_argument) > 0
        task = task_argument
    else
        task = "all"
    end

    is_dry_run::Bool = parsed_arguments["dry-run"]

    result::Dict{Symbol, Any} = Dict{Symbol, Any}()
    result[:task] = task
    result[:is_dry_run]=is_dry_run
    return result
end

end # End submodule OrganizationSnapshots.CommandLine

##### End of file
