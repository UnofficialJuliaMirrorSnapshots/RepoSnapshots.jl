##### Beginning of file

Test.@test( Base.VERSION >= VersionNumber("1.0") )

Test.@test( Snapshots.version() > VersionNumber(0) )

Test.@test(
    Snapshots.version() ==
        Snapshots.version(Snapshots)
    )

Test.@test(
    Snapshots.version() ==
        Snapshots.version(first(methods(Snapshots.eval)))
    )

Test.@test(
    Snapshots.version() ==
        Snapshots.version(Snapshots.eval)
    )

Test.@test(
    Snapshots.version() ==
        Snapshots.version(Snapshots.eval, (Any,))
    )

Test.@test( Snapshots.version(TestModuleA) == VersionNumber("1.2.3") )

Test.@test( Snapshots.version(TestModuleB) == VersionNumber("4.5.6") )

Test.@test_throws(
    ErrorException,
    Snapshots._TomlFile(joinpath(mktempdir(),"1","2","3","4")),
    )

##### End of file

