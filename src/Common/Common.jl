##### Beginning of file

module Common # Begin submodule Snapshots.Common

__precompile__(true)

import ..Types
import ..Utils

import ArgParse
import Dates
import HTTP
import Pkg
import TimeZones

function _toml_file_to_package(
        packagetoml_file_filename::String,
        )::Types.Package
    toml_file_text::String = read(packagetoml_file_filename, String)
    toml_file_parsed::Dict{String,Any}=Pkg.TOML.parse(toml_file_text)
    pkg_name::String = toml_file_parsed["name"]
    pkg_uuid::String = toml_file_parsed["uuid"]
    pkg_source_url::String = toml_file_parsed["repo"]
    pkg::Types.Package = Types.Package(
        ;
        name=pkg_name,
        uuid=pkg_uuid,
        source_url=pkg_source_url,
        )
    return pkg
end

function _get_uuid_from_toml_file(toml_file_filename::String)::String
    toml_file_text::String = read(toml_file_filename, String)
    toml_file_parsed::Dict{String,Any}=Pkg.TOML.parse(toml_file_text)
    uuid::String = toml_file_parsed["uuid"]
    return uuid
end

function _add_trailing_spaces(x::AbstractString, n::Integer)::String
    temp::String = strip(convert(String, x))
    if length(temp) >= n
        result::String = temp
    else
        deficit::Int = n - length(temp)
        result = string(temp, repeat(" ", deficit))
    end
    return result
end

function _names_that_fall_in_interval(
        list_of_names::Vector{T},
        interval::Types.AbstractInterval,
        ) where T <: AbstractString
    stripped_list_of_names = String[]
    for i = 1:length(list_of_names)
        push!(
            stripped_list_of_names,
            strip(convert(String, list_of_names[i],)),
            )
    end
    unique!(stripped_list_of_names)
    sort!(stripped_list_of_names)
    jth_name_falls_in_interval::Vector{Bool} = Vector{Bool}(
        undef,
        length(stripped_list_of_names),
        )
    for j = 1:length(stripped_list_of_names)
        jth_name = stripped_list_of_names[j]
        jth_name_falls_in_interval[j] = _interval_contains_x(
            interval,
            jth_name,
            )
    end
    sublist::Vector{String} = list_of_names[
        jth_name_falls_in_interval
        ]
    unique!(sublist)
    sort!(sublist)
    return sublist
end

function _interval_contains_x(
        interval::Types.NoBoundsInterval,
        x::AbstractString,
        )::Bool
    result::Bool = true
    return result
end

function _interval_contains_x(
        interval::Types.LowerAndUpperBoundInterval,
        x::AbstractString,
        )::Bool
    x_stripped::String = strip(convert(String, x))
    left::String = strip(interval.left)
    right::String = strip(interval.right)
    result::Bool = (left <= x_stripped) && (x_stripped < right)
    return result
end

function _interval_contains_x(
        interval::Types.LowerBoundOnlyInterval,
        x::AbstractString,
        )::Bool
    x_stripped::String = strip(convert(String, x))
    left::String = strip(interval.left)
    result::Bool = left <= x_stripped
    return result
end

function _interval_contains_x(
        interval::Types.UpperBoundOnlyInterval,
        x::AbstractString,
        )
    x_stripped::String = strip(convert(String, x))
    right::String = strip(interval.right)
    result::Bool = x_stripped < right
    return result
end

function _snapshot_repo!!(
        repo_name;
        src_provider,
        dst_provider,
        include_branches,
        exclude_branches,
        git_user_name,
        git_user_email,
        time_zone::Dates.TimeZone,
        is_dry_run::Bool,
        )::Nothing
    original_directory = pwd()
    @debug(
        "Snapshotting repo: $(repo_name)",
        )
    git::String = Utils._get_git_binary_path()
    dst_provider(:create_repo)(
        Dict(
            :repo_name => convert(String, repo_name),
            )
        )
    dst_url_with_auth = dst_provider(:get_destination_url)(
        ;
        repo_name = convert(String, repo_name),
        credentials = :with_auth,
        )
    dst_url_with_redacted_auth = dst_provider(:get_destination_url)(
        ;
        repo_name = convert(String, repo_name),
        credentials = :with_redacted_auth,
        )
    dst_url_without_auth = dst_provider(:get_destination_url)(
        ;
        repo_name = convert(String, repo_name),
        credentials = :without_auth,
        )
    temp_initialize_dst_parent = mktempdir()
    temp_initialize_dst_dir = joinpath(
        temp_initialize_dst_parent,
        "TMP_INIT_DST_DIR",
        )
    mkpath(temp_initialize_dst_dir)
    cd(temp_initialize_dst_dir)
    run(`$(git) init`)
    touch(".gitignore")
    Utils.git_add_all!()
    Utils.git_commit!(
        ;
        message = "First commit",
        committer_name = git_user_name,
        committer_email = git_user_email,
        allow_empty = false,
        )
    run(`$(git) remote add origin $(dst_url_with_auth)`)
    try
        run(`$(git) push origin master`)
    catch e
        @warn("ignoring exception: ", e,)
    end
    cd(original_directory)
    rm(
        temp_initialize_dst_parent;
        force = true,
        recursive = true,
        )
    dst_repo_parent = mktempdir()
    dst_repo_dir = joinpath(dst_repo_parent, "DSTREPO",)
    cd(dst_repo_parent)
    dst_repo_git_clone_command = `$(git) clone $(dst_url_without_auth) DSTREPO`
    Utils.command_ran_successfully!!(
        dst_repo_git_clone_command;
        )
    cd(dst_repo_dir)
    run(`$(git) remote set-url origin --push $(dst_url_with_auth)`)

    src_repo_parent = mktempdir()
    src_repo_dir = joinpath(src_repo_parent, "SRCREPO",)
    cd(src_repo_parent)
    src_url_without_auth = src_provider(:get_src_url)(
        ;
        repo_name = convert(String, repo_name),
        credentials = :without_auth,
        )
    src_repo_git_clone_command = `$(git) clone $(src_url_without_auth) SRCREPO`
    @info(
        "Attempting to run command",
        src_repo_git_clone_command,
        pwd(),
        ENV["PATH"],
        )
    when_src_cloned = Dates.now(TimeZones.localzone(),)
    Utils.command_ran_successfully!!(
        src_repo_git_clone_command;
        )
    cd(src_repo_dir)
    default_branch = Utils.get_current_branch()
    branches_to_snapshot::Vector{String} =
        Utils.make_list_of_branches_to_snapshot(
            ;
            default_branch = default_branch,
            include = include_branches,
            exclude = exclude_branches,
            )
    unique!(branches_to_snapshot)
    sort!(branches_to_snapshot)
    m = length(branches_to_snapshot)
    for j = 1:m
        temp_transition_parent = mktempdir()
        temp_transition_dir = joinpath(
            temp_transition_parent,
            "TEMPTRANSITIONDIR",
            )
        mkpath(temp_transition_dir)
        branch::String = branches_to_snapshot[j]
        @debug("Branch: \"$(branch)\" ($(j) of $(m))")
        cd(src_repo_dir)
        try
            Utils.checkout_branch!(branch)
        catch e
            @warn("ignoring exception: ", e,)
        end
        if lowercase(strip(Utils.get_current_branch())) ==
                lowercase(strip(branch))
            for file_or_directory in readdir(src_repo_dir)
                if strip(lowercase(file_or_directory)) != ".git"
                    cp(
                        joinpath(src_repo_dir, file_or_directory,),
                        joinpath(temp_transition_dir, file_or_directory,);
                        force = false,
                        )
                end
            end
            cd(temp_transition_dir)
            Utils.delete_only_dot_git!(temp_transition_dir)
            cd(dst_repo_dir)
            Utils.checkout_branch!(
                branch;
                create = true
                )
            if lowercase(strip(Utils.get_current_branch())) !=
                    lowercase(strip(branch))
                error("an error occured when trying to create branch in dst")
            end
            Utils.delete_everything_except_dot_git!(dst_repo_dir)
            for file_or_directory in readdir(temp_transition_dir)
                if strip(lowercase(temp_transition_dir)) != ".git"
                    cp(
                        joinpath(temp_transition_dir, file_or_directory,),
                        joinpath(dst_repo_dir, file_or_directory,);
                        force = false,
                        )
                end
            end
            _when::String = ""
            date_time_string::String = ""
            if isa(when_src_cloned, TimeZones.ZonedDateTime)
                _when = strip(
                    string(TimeZones.astimezone(when_src_cloned,time_zone,))
                    )
            else
                _when = strip(
                    string(when_src_cloned)
                    )
            end
            Utils.git_add_all!()
            commit_message = string(
                "Snapshot of branch $(branch)",
                " taken on $(_when)",
                " from \"$(src_url_without_auth)\"",
                )
            Utils.git_commit!(
                ;
                message = commit_message,
                committer_name = git_user_name,
                committer_email = git_user_email,
                allow_empty = false,
                )
            Utils.git_add_all!()
            Utils.git_commit!(
                ;
                message = "Snapshot commit",
                committer_name = git_user_name,
                committer_email = git_user_email,
                allow_empty = false,
                )
        end
        rm(
            temp_transition_parent;
            force = true,
            recursive = true,
            )
    end
    if is_dry_run
        @info("Skipping push, because this is a dry run.")
    else
        cd(dst_repo_dir)
        run(`$(git) push -u --all`)
        when_pushed_to_dst = Dates.now(TimeZones.localzone(),)
        args1_gen_provider_description = Dict(
            :source_url => src_url_without_auth,
            :when => when_pushed_to_dst,
            :time_zone => time_zone,
            )
        repo_description_default::String = Utils.default_repo_description(
            ;
            from = src_url_without_auth,
            when = when_pushed_to_dst,
            time_zone = time_zone,
            )
        repo_description_provider::String = try
            dst_provider(
                :generate_new_repo_description)(
                args1_gen_provider_description)
        catch exception
            @warn(
                string("ignoring exception: "),
                exception,
                )
            ""
        end
        new_repo_description::String = ""
        if length(
                strip(
                    repo_description_provider
                    )
                ) == 0
            new_repo_description = strip(
                repo_description_default
                )
        else
            new_repo_description = strip(
                repo_description_provider
                )
        end
        @debug(
            string("Repo descriptions: "),
            repo_description_default,
            repo_description_provider,
            new_repo_description,
            )
        args2_update_dst_description = Dict(
            :repo_name =>
                convert(String, repo_name),
            :new_repo_description =>
                convert(String, new_repo_description),
            )
        @info(
            string(
                "Attempting to update ",
                "repo description.",
                ),
            repo_name,
            new_repo_description,
            )
        dst_provider(:update_repo_description)(
            args2_update_dst_description
            )
    end
    cd(original_directory)
    rm(
        src_repo_parent;
        force = true,
        recursive = true,
        )
    rm(
        dst_repo_parent;
        force = true,
        recursive = true,
        )
    return nothing
end

end # End submodule Snapshots.Common

##### End of file
