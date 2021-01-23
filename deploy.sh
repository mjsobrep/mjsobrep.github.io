#!/bin/bash

# Taken from https://github.com/felixrieseberg/travis-jekyll-git/blob/master/scripts/deploy.sh
# and https://github.com/steveklabnik/automatically_update_github_pages_with_travis_example

# set to error if fail. Set to error if any unset variables
set -o errexit -o nounset


echo "deploying to master branch from deploy branch"
cd _site

git init
git config user.name "Travis CI"
git config user.email "mjsobrep@live.com"

git remote add upstream "https://$GH_TOKEN@github.com/mjsobrep/mjsobrep.github.io.git"
git fetch upstream
git checkout upstream/master -- otherFiles/MichaelSobrepera.pdf
git reset upstream/master # Make all of our changes off of the master branch
touch . # make all of the files look fresh


git add -A :/
git commit -m 'automated commit to publish from travis';
git push -q upstream HEAD:master

exit 0
