##### Beginning of file

Test.@test( Base.VERSION >= VersionNumber("1.0") )

Test.@test( OrganizationSnapshots.version() > VersionNumber(0) )

Test.@test(
    OrganizationSnapshots.version() ==
        OrganizationSnapshots.version(OrganizationSnapshots)
    )

Test.@test(
    OrganizationSnapshots.version() ==
        OrganizationSnapshots.version(first(methods(OrganizationSnapshots.eval)))
    )

Test.@test(
    OrganizationSnapshots.version() ==
        OrganizationSnapshots.version(OrganizationSnapshots.eval)
    )

Test.@test(
    OrganizationSnapshots.version() ==
        OrganizationSnapshots.version(OrganizationSnapshots.eval, (Any,))
    )

Test.@test( OrganizationSnapshots.version(TestModuleA) == VersionNumber("1.2.3") )

Test.@test( OrganizationSnapshots.version(TestModuleB) == VersionNumber("4.5.6") )

Test.@test_throws(
    ErrorException,
    OrganizationSnapshots._TomlFile(joinpath(mktempdir(),"1","2","3","4")),
    )

##### End of file

