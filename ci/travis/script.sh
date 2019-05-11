if [[ "$TRAVIS_JOB_TO_DO" == "RUNTESTS" ]]
then
    ./ci/travis/runtests.sh
else
    ./ci/travis/snapshots.sh
fi
