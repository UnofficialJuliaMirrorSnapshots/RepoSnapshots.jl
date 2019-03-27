##### Beginning of file

module GitHubSrcHost # Begin submodule Snapshots.Hosts.GitHubSrcHost

__precompile__(true)

import ..Types
import ..Utils

import Dates
import GitHub
import TimeZones

function new_github_session(
        ;
        github_organization::AbstractString,
        github_bot_username::AbstractString,
        github_bot_personal_access_token::AbstractString,
        )::Function

    _github_organization::String = strip(
        convert(String, github_organization)
        )
    _provided_github_bot_username::String = strip(
        convert(String, github_bot_username,)
        )
    _github_bot_personal_access_token::String = strip(
        convert(String, github_bot_personal_access_token)
        )
    function _get_github_username(auth::GitHub.Authorization)::String
        user_information::AbstractDict = GitHub.gh_get_json(
            GitHub.DEFAULT_API,
            "/user";
            auth = auth,
            )
        username::String = user_information["name"]
        username_stripped::String = strip(username)
        return username_stripped
    end

    @info("Attempting to authenticate to GitHub...")
    auth::GitHub.Authorization = GitHub.authenticate(
        _github_bot_personal_access_token
        )
    _github_username::String = _get_github_username(auth)
    if lowercase(strip(_github_username)) !=
            lowercase(strip(_provided_github_bot_username))
        error(
            string(
                "Provided GitHub username ",
                "(\"$(_provided_github_bot_username)\") ",
                "does not match ",
                "actual GitHub username ",
                "(\"$(_github_username)\").",
                )
            )
    else
        @info(
            string(
                "Provided GitHub username matches ",
                "actual GitHub username.",
                ),
            _provided_github_bot_username,
            _github_username,
            )
    end
    @info("Successfully authenticated to GitHub :)")

    @info(
        string(
            "GitHub username: ",
            "$(_get_github_username(auth))",
            )
        )
    @info(
        string(
            "GitHub organization: ",
            "$(_github_organization)",
            )
        )

    repository_owner = GitHub.owner(
        _github_organization,
        true;
        auth = auth,
        )

    function _list_all_repos()::Vector{String}
        @info("Loading the list of all of repos in the organization")
        full_repo_list::Vector{GitHub.Repo} = GitHub.Repo[]
        need_to_continue::Bool = true
        current_page_number::Int = 1
        while need_to_continue
            repos, page_data = GitHub.repos(
                _github_organization,
                true;
                auth = auth,
                page_limit = 1,
                params = Dict(
                    "per_page" => 100,
                    "page" => current_page_number,
                    ),
                )
            if length(repos) == 0
                need_to_continue = false
            else
                append!(
                    full_repo_list,
                    repos,
                    )
                need_to_continue = true
                current_page_number += 1
            end
        end
        unique_repo_list::Vector{GitHub.Repo} = unique(full_repo_list)
        unique_name_list = [x.name for x in unique_repo_list]
        unique!(unique_name_list)
        sort!(unique_name_list)
        return unique_name_list
    end

    function _repo_name_with_org(
            ;
            repo::AbstractString,
            org::AbstractString,
            )::String
        repo_name_without_org::String = _repo_name_without_org(
            ;
            repo = repo,
            org = org,
            )
        org_stripped::String = strip(
            strip(strip(strip(strip(convert(String, org)), '/')), '/')
            )
        result::String = string(
            org_stripped,
            "/",
            repo_name_without_org,
            )
        return result
    end

    function _repo_name_without_org(
            ;
            repo::AbstractString,
            org::AbstractString,
            )::String
        repo_stripped::String = strip(
            strip(strip(strip(strip(convert(String, repo)), '/')), '/')
            )
        org_stripped::String = strip(
            strip(strip(strip(strip(convert(String, org)), '/')), '/')
            )
        if length(org_stripped) == 0
            result = repo_stripped
        else
            repo_stripped_lowercase::String = lowercase(repo_stripped)
            org_stripped_lowercase::String = lowercase(org_stripped)
            org_stripped_lowercase_withtrailingslash::String = string(
                org_stripped_lowercase,
                "/",
                )
            if startswith(repo_stripped_lowercase,
                    org_stripped_lowercase_withtrailingslash)
                index_start =
                    length(org_stripped_lowercase_withtrailingslash) + 1
                result = repo_stripped[index_start:end]
            else
                result = repo_stripped
            end
        end
        return result
    end

    function _get_src_url(
            ;
            repo_name::String,
            credentials::Symbol,
            )::String
        repo_name_without_org::String = _repo_name_without_org(
            ;
            repo = repo_name,
            org = _github_organization,
            )
        result::String = ""
        if credentials == :with_auth
            result = string(
                "https://",
                _github_username,
                ":",
                _github_bot_personal_access_token,
                "@",
                "github.com/",
                _github_organization,
                "/",
                repo_name_without_org,
                )
        elseif credentials == :with_redacted_auth
            result = string(
                "https://",
                _github_username,
                ":",
                "*****",
                "@",
                "github.com/",
                _github_organization,
                "/",
                repo_name_without_org,
                )
        elseif credentials == :without_auth
            result =string(
                "https://",
                "github.com/",
                _github_organization,
                "/",
                repo_name_without_org,
                )
        else
            error("$(credentials) is not a supported value for credentials")
        end
        return result
    end

    function _github_provider(task::Symbol)::Function
        if task == :list_all_repos
            return _list_all_repos
        elseif task == :get_src_url
            return _get_src_url
        else
            error("$(task) is not a valid task")
        end
    end

    return _github_provider
end

end # End submodule Snapshots.Hosts.GitHubSrcHost

##### End of file
