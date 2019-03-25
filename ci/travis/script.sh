#!/bin/bash

##### Beginning of file

exit 1

set -ev

export JULIA_FLAGS="--check-bounds=yes --code-coverage=all --color=yes --compiled-modules=no --inline=no --project"
echo "JULIA_FLAGS=$JULIA_FLAGS"

export TASK="$1"

export FORCE_DRY_RUN_ARGUMENT="$2"
echo "FORCE_DRY_RUN_ARGUMENT=$FORCE_DRY_RUN_ARGUMENT"

if [[ "$FORCE_DRY_RUN_ARGUMENT" == "FORCE_DRY_RUN" ]]
then
    export DRY_RUN="--dry-run"
else
    if [[ "$TRAVIS_BRANCH" == "master" ]]
    then
        if [[ "$TRAVIS_PULL_REQUEST" == "false" ]]
        then
            export DRY_RUN=""
        else
            export DRY_RUN=""
        fi
    else
        export DRY_RUN="--dry-run"
    fi
fi

echo "DRY_RUN=$DRY_RUN"
echo "GIT_HOST=$GIT_HOST"
echo "TASK=$TASK"
echo "TRAVIS_BRANCH=$TRAVIS_BRANCH"
echo "TRAVIS_PULL_REQUEST=$TRAVIS_PULL_REQUEST"

julia $JULIA_FLAGS -e 'import Pkg; Pkg.resolve();'
julia $JULIA_FLAGS -e 'import Pkg; Pkg.build("OrganizationSnapshots");'
julia $JULIA_FLAGS run-mirror-updater.jl --delete-gists-older-than-minutes 10080 --gist-description "$GIST_DESCRIPTION" --task "$TASK" $DRY_RUN

cat Project.toml
cat Manifest.toml

julia $JULIA_FLAGS -e 'import Pkg; try Pkg.add("Coverage") catch end;'
julia $JULIA_FLAGS ci/travis/codecov-catch-errors.jl

##### End of file
