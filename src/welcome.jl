##### Beginning of file

function _print_welcome_message()::Nothing
    organizationsnapshots_version::VersionNumber = version()
    organizationsnapshots_pkgdir::String = package_directory()
    @info(string("This is RepoSnapshots, version ",organizationsnapshots_version,),)
    @info(string("For help, please visit https://github.com/UnofficialJuliaMirrorSnapshots/RepoSnapshots.jl",),)
    @debug(string("RepoSnapshots package directory: ",organizationsnapshots_pkgdir,),)
    return nothing
end

##### End of file

