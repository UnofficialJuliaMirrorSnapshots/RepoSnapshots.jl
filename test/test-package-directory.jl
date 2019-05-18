##### Beginning of file

Test.@test( isdir(RepoSnapshots.package_directory()) )

Test.@test( isdir(RepoSnapshots.package_directory("ci")) )

Test.@test( isdir(RepoSnapshots.package_directory("ci", "travis")) )

Test.@test( isdir(RepoSnapshots.package_directory(TestModuleA)) )

Test.@test( isdir(RepoSnapshots.package_directory(TestModuleB)) )

Test.@test(
    isdir( RepoSnapshots.package_directory(TestModuleB, "directory2",) )
    )

Test.@test(
    isdir(
        RepoSnapshots.package_directory(
            TestModuleB, "directory2", "directory3",
            )
        )
    )

Test.@test_throws(
    ErrorException,RepoSnapshots.package_directory(TestModuleC),
    )

##### End of file

