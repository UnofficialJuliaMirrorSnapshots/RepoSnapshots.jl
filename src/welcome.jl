##### Beginning of file

function _print_welcome_message()::Nothing
    organizationsnapshots_version::VersionNumber = version()
    organizationsnapshots_pkgdir::String = package_directory()
    @info(string("This is Snapshots, version ",organizationsnapshots_version,),)
    @info(string("For help, please visit https://github.com/UnofficialJuliaMirrorSnapshots/Snapshots.jl",),)
    @debug(string("Snapshots package directory: ",organizationsnapshots_pkgdir,),)
    return nothing
end

##### End of file

