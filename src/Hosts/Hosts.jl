##### Beginning of file

module Hosts # Begin submodule Snapshots.Hosts

__precompile__(true)

import ..Types
import ..Utils

include(joinpath("BitbucketSrcHost", "BitbucketSrcHost.jl"))
include(joinpath("BitbucketDstHost", "BitbucketDstHost.jl"))

include(joinpath("GitHubSrcHost", "GitHubSrcHost.jl"))
include(joinpath("GitHubDstHost", "GitHubDstHost.jl"))

include(joinpath("GitLabSrcHost", "GitLabSrcHost.jl"))
include(joinpath("GitLabDstHost", "GitLabDstHost.jl"))

end # End submodule Snapshots.Hosts

##### End of file
