##### Beginning of file

Test.@test( Base.VERSION >= VersionNumber("1.0") )

Test.@test( RepoSnapshots.version() > VersionNumber(0) )

Test.@test(
    RepoSnapshots.version() ==
        RepoSnapshots.version(RepoSnapshots)
    )

Test.@test(
    RepoSnapshots.version() ==
        RepoSnapshots.version(first(methods(RepoSnapshots.eval)))
    )

Test.@test(
    RepoSnapshots.version() ==
        RepoSnapshots.version(RepoSnapshots.eval)
    )

Test.@test(
    RepoSnapshots.version() ==
        RepoSnapshots.version(RepoSnapshots.eval, (Any,))
    )

Test.@test( RepoSnapshots.version(TestModuleA) == VersionNumber("1.2.3") )

Test.@test( RepoSnapshots.version(TestModuleB) == VersionNumber("4.5.6") )

Test.@test_throws(
    ErrorException,
    RepoSnapshots._TomlFile(joinpath(mktempdir(),"1","2","3","4")),
    )

##### End of file

