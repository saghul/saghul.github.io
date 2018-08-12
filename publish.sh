#!/bin/sh

if [[ $(git symbolic-ref --short HEAD) -ne "src" ]]
then
    echo "Incorrent branch, you must be in the 'src' branch."
    exit 1;
fi

if [[ $(git status -s) ]]
then
    echo "The working directory is dirty. Please commit any pending changes."
    exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out master branch into public"
git worktree add -B master public origin/master

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Restoring CNAME file"
cp CNAME public/

echo "Updating master branch"
cd public && git add --all && git commit -m "Update"

echo "Ready to push!"

