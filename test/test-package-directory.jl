##### Beginning of file

Test.@test( isdir(OrganizationSnapshots.package_directory()) )

Test.@test( isdir(OrganizationSnapshots.package_directory("ci")) )

Test.@test( isdir(OrganizationSnapshots.package_directory("ci", "travis")) )

Test.@test( isdir(OrganizationSnapshots.package_directory(TestModuleA)) )

Test.@test( isdir(OrganizationSnapshots.package_directory(TestModuleB)) )

Test.@test(
    isdir( OrganizationSnapshots.package_directory(TestModuleB, "directory2",) )
    )

Test.@test(
    isdir(
        OrganizationSnapshots.package_directory(
            TestModuleB, "directory2", "directory3",
            )
        )
    )

Test.@test_throws(
    ErrorException,OrganizationSnapshots.package_directory(TestModuleC),
    )

##### End of file

