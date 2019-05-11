if [[ "$TRAVIS_JOB_TO_DO" == "RUNTESTS" ]]
then
    ./runtests.sh
else
    ./snapshots.sh
fi
