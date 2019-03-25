import OrganizationSnapshots

if ENV["GIT_HOST"] == "GITHUB"
    const GITHUB_ORGANIZATION = "UnofficialJuliaMirror"
    const GITHUB_BOT_USERNAME = "UnofficialJuliaMirrorBot"
    const GITHUB_BOT_PERSONAL_ACCESS_TOKEN =
        ENV["GITHUB_BOT_PERSONAL_ACCESS_TOKEN"]
    const github_Src_provider =
        OrganizationSnapshots.Hosts.GitHubSrcHost.new_github_session(
            ;github_organization = GITHUB_ORGANIZATION,
            github_bot_username = GITHUB_BOT_USERNAME,
            github_bot_personal_access_token =
                GITHUB_BOT_PERSONAL_ACCESS_TOKEN,
            )
    const github_Dst_provider =
        OrganizationSnapshots.Hosts.GitHubDstHost.new_github_session(
            ;github_organization = GITHUB_ORGANIZATION,
            github_bot_username = GITHUB_BOT_USERNAME,
            github_bot_personal_access_token =
                GITHUB_BOT_PERSONAL_ACCESS_TOKEN,
            )
elseif ENV["GIT_HOST"] == "GITLAB"
    const GITLAB_GROUP = "UnofficialJuliaMirror"
    const GITLAB_BOT_USERNAME = "UnofficialJuliaMirrorBot"
    const GITLAB_BOT_PERSONAL_ACCESS_TOKEN =
        ENV["GITLAB_BOT_PERSONAL_ACCESS_TOKEN"]
    const gitlab_Src_provider =
        OrganizationSnapshots.Hosts.GitLabSrcHost.new_gitlab_session(
            ;gitlab_group = GITLAB_GROUP,
            gitlab_bot_username = GITLAB_BOT_USERNAME,
            gitlab_bot_personal_access_token =
                GITLAB_BOT_PERSONAL_ACCESS_TOKEN,
            )
    const gitlab_Dst_provider =
        OrganizationSnapshots.Hosts.GitLabDstHost.new_gitlab_session(
            ;gitlab_group = GITLAB_GROUP,
            gitlab_bot_username = GITLAB_BOT_USERNAME,
            gitlab_bot_personal_access_token =
                GITLAB_BOT_PERSONAL_ACCESS_TOKEN,
            )
elseif ENV["GIT_HOST"] == "BITBUCKET"
    const BITBUCKET_TEAM = "UnofficialJuliaMirror"
    const BITBUCKET_BOT_USERNAME = "UnofficialJuliaMirrorBot"
    const BITBUCKET_BOT_APP_PASSWORD =
        ENV["BITBUCKET_BOT_APP_PASSWORD"]
    const bitbucket_Src_provider =
        OrganizationSnapshots.Hosts.BitbucketSrcHost.new_bitbucket_session(
            ;bitbucket_team = BITBUCKET_TEAM,
            bitbucket_bot_username = BITBUCKET_BOT_USERNAME,
            bitbucket_bot_app_password = BITBUCKET_BOT_APP_PASSWORD,
            )
    const bitbucket_Dst_provider =
        OrganizationSnapshots.Hosts.BitbucketDstHost.new_bitbucket_session(
            ;bitbucket_team = BITBUCKET_TEAM,
            bitbucket_bot_username = BITBUCKET_BOT_USERNAME,
            bitbucket_bot_app_password = BITBUCKET_BOT_APP_PASSWORD,
            )
else
end
