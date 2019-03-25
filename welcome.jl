##### Beginning of file

function _print_welcome_message()::Nothing
    mirrorupdater_version::VersionNumber = version()
    mirrorupdater_pkgdir::String = package_directory()
    @info(string("This is OrganizationSnapshots, version ",mirrorupdater_version,),)
    @info(string("For help, please visit https://github.com/UnofficialJuliaMirrorSnapshots/OrganizationSnapshots.jl",),)
    @debug(string("OrganizationSnapshots package directory: ",mirrorupdater_pkgdir,),)
    return nothing
end

##### End of file

