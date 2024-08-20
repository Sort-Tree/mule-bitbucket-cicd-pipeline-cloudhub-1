#!/bin/bash
git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
git remote update
git fetch --all
git checkout master
echo "Merging '$BITBUCKET_BRANCH' to master..."
git merge $BITBUCKET_BRANCH
git push --set-upstream origin master 