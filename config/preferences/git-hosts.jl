import Snapshots

if ENV["GIT_HOST"] == "GITHUB"
    const GITHUB_SRC_ORGANIZATION = "UnofficialJuliaMirror"
    const GITHUB_DST_ORGANIZATION = "UnofficialJuliaMirrorSnapshots"
    const GITHUB_BOT_USERNAME = "UnofficialJuliaMirrorBot"
    const GITHUB_BOT_PERSONAL_ACCESS_TOKEN =
        ENV["GITHUB_BOT_PERSONAL_ACCESS_TOKEN"]
    const src_provider =
        Snapshots.Hosts.GitHubSrcHost.new_github_session(
            ;
            github_organization = GITHUB_SRC_ORGANIZATION,
            github_bot_username = GITHUB_BOT_USERNAME,
            github_bot_personal_access_token =
                GITHUB_BOT_PERSONAL_ACCESS_TOKEN,
            )
    const dst_provider =
        Snapshots.Hosts.GitHubDstHost.new_github_session(
            ;
            github_organization = GITHUB_DST_ORGANIZATION,
            github_bot_username = GITHUB_BOT_USERNAME,
            github_bot_personal_access_token =
                GITHUB_BOT_PERSONAL_ACCESS_TOKEN,
            )
elseif ENV["GIT_HOST"] == "GITLAB"
    const GITLAB_SRC_GROUP = "UnofficialJuliaMirror"
    const GITLAB_DST_GROUP = "UnofficialJuliaMirrorSnapshots"
    const GITLAB_BOT_USERNAME = "UnofficialJuliaMirrorBot"
    const GITLAB_BOT_PERSONAL_ACCESS_TOKEN =
        ENV["GITLAB_BOT_PERSONAL_ACCESS_TOKEN"]
    const src_provider =
        Snapshots.Hosts.GitLabSrcHost.new_gitlab_session(
            ;
            gitlab_group = GITLAB_SRC_GROUP,
            gitlab_bot_username = GITLAB_BOT_USERNAME,
            gitlab_bot_personal_access_token =
                GITLAB_BOT_PERSONAL_ACCESS_TOKEN,
            )
    const dst_provider =
        Snapshots.Hosts.GitLabDstHost.new_gitlab_session(
            ;
            gitlab_group = GITLAB_DST_GROUP,
            gitlab_bot_username = GITLAB_BOT_USERNAME,
            gitlab_bot_personal_access_token =
                GITLAB_BOT_PERSONAL_ACCESS_TOKEN,
            )
elseif ENV["GIT_HOST"] == "BITBUCKET"
    const BITBUCKET_SRC_TEAM = "UnofficialJuliaMirror"
    const BITBUCKET_DST_TEAM = "UnofficialJuliaMirrorSnapshots"
    const BITBUCKET_BOT_USERNAME = "UnofficialJuliaMirrorBot"
    const BITBUCKET_BOT_APP_PASSWORD =
        ENV["BITBUCKET_BOT_APP_PASSWORD"]
    const src_provider =
        Snapshots.Hosts.BitbucketSrcHost.new_bitbucket_session(
            ;
            bitbucket_team = BITBUCKET_SRC_TEAM,
            bitbucket_bot_username = BITBUCKET_BOT_USERNAME,
            bitbucket_bot_app_password = BITBUCKET_BOT_APP_PASSWORD,
            )
    const dst_provider =
        Snapshots.Hosts.BitbucketDstHost.new_bitbucket_session(
            ;
            bitbucket_team = BITBUCKET_DST_TEAM,
            bitbucket_bot_username = BITBUCKET_BOT_USERNAME,
            bitbucket_bot_app_password = BITBUCKET_BOT_APP_PASSWORD,
            )
else
end
