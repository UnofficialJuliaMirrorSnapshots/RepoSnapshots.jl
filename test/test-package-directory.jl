##### Beginning of file

Test.@test( isdir(Snapshots.package_directory()) )

Test.@test( isdir(Snapshots.package_directory("ci")) )

Test.@test( isdir(Snapshots.package_directory("ci", "travis")) )

Test.@test( isdir(Snapshots.package_directory(TestModuleA)) )

Test.@test( isdir(Snapshots.package_directory(TestModuleB)) )

Test.@test(
    isdir( Snapshots.package_directory(TestModuleB, "directory2",) )
    )

Test.@test(
    isdir(
        Snapshots.package_directory(
            TestModuleB, "directory2", "directory3",
            )
        )
    )

Test.@test_throws(
    ErrorException,Snapshots.package_directory(TestModuleC),
    )

##### End of file

