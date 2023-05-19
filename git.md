## Fix for when a commit has been made in a detached head state, and you want to update the real branch to include this commit:

https://stackoverflow.com/questions/7124486/what-to-do-with-commit-made-in-a-detached-head

https://stackoverflow.com/questions/10228760/how-do-i-fix-a-git-detached-head

The latter page includes info about `git pop` and `git stash`



## Github Contribution Workflow

This explains why you should Fork a project you plan to contribute to, if you're not already a contributor in the direct project:

https://opensource.com/article/19/11/first-open-source-contribution-fork-clone

Once I have my own fork, this explains how I should go about making modifications to my Fork. Of course, I don't need to create a branch on my Fork, until i have have a change to make.

https://docs.github.com/en/get-started/quickstart/github-flow

I'm not sure where I'm going to run the latest versions of Jupiter Notebook, etc, with python, and so I should probably not install anything on my laptop or on the server. Let's just download the zip file from Github for now, and explore it.

How to install Git and Github-CLI:

https://github.com/git-guides/install-git

I need to understand:
Origin and Remote: These refer to remote repositories, which are pulled from with `clone` and `pull`, and pushed to with `push`.

Master (branch)
Branches (labels you put on commits)
commits
trees

HEAD is the 'you qqqare here' indicator. You get there by checking out a commit.

## To get back to to the master branches latest commit
`git checkout <branch name>` or `git switch <branch name>`

## To view remote origin repository:
`git remote -v`

## To report current branch
`git branch -v`

## Report commits, optionally filtered by branch:
`git log <branch>`

# The command to list all branches in local and remote repositories is:
`git branch -a`

## If you require only listing the remote branches from Git Bash then use this command:
`git branch -r`

## You may also use the show-branch command for seeing the branches and their commits as follows:
`git show-branch`

### Using Git to restore a deleted, uncommitted file:
If your changes have not been staged or committed: The command you should use in this scenario is `git restore FILENAME`

### View changes to unstaged files before staging and comitting, optinally filtering by a specific file
`git diff <filename>`

### Update information on remote repositories
`git fetch --all`

### View differences between state of current local repository, against a remote branch, for example "origin/develop"
`git diff origin/develop`

## If the remote repository has been updated, I can check for remote references updates with:
`git fetch --dry-run --verbose`

## To merge a remote branch with a local branch
`git checkout aLocalBranch` if not already on that branch (could just be master!)
`git merge origin/aRemoteBranch`

## Stage and commit changes
`git add -A && git commit -m "Your Message"`


## Recurse submodules
Getting the repository:
`git clone -b develop https://github.com/ucb-art/bag.git --recurse-submodules`


Figuring out what changes I've made to local:
git status
git log
git info


git fetch --dry-run
git fetch --dry-run --all
git remote update
git show-branch *develop

git config --global user.name "Kennedy Caisley"
git config --global user.email kcaisley@uni-bonn.de
git config --global core.editor vim

To copy down submodule, if forgot to do during cloning:
git submodule update --init --recursive --remote


To reset all unstaged/uncommitted change:
git checkout .


git pull = git fetch + git merge


Taking a local branch, and placing it on github, in a fresh repository is done via this instructions:

https://docs.github.com/en/get-started/importing-your-projects-to-github/importing-source-code-to-github/adding-locally-hosted-code-to-github

$ git remote add origin <REMOTE_URL>
# Sets the new remote, naming it as oriring, 
$ git remote -v
# Verifies the new remote URLc

In the last stage we do this:

The command git push -u origin main is used to push the local branch named "main" to a remote repository named "origin". The -u option is used to set the "upstream" relationship between the local branch and the remote branch.

Here's what happens when you run the command:

    The local branch "main" is pushed to the remote repository "origin".

    The "origin/main" branch is created on the remote repository.

    The local branch "main" is configured to track the remote branch "origin/main". This means that in the future, you can simply use the command git push to push your local changes to the remote branch, without having to specify the remote repository and branch names.

    The "upstream" relationship between the local branch "main" and the remote branch "origin/main" is established. This makes it easier for Git to determine the correct branch to merge with when pulling updates from the remote repository.

In summary, the git push -u origin main command is used to push a local branch to a remote repository and establish an upstream relationship between the local and remote branches. This makes it easier to keep the branches in sync and ensures that Git knows which branch to merge with when pulling updates from the remote repository.



The command `git push origin:develop develop` is used to push a local branch named "develop" to a remote repository named "origin", and create a remote branch named "develop". The colon (:) in origin: is used to delete the remote branch named "develop", if it already exists.

Here's what happens when you run the command:

    The remote branch named "develop" is deleted, if it already exists.

    The local branch named "develop" is pushed to the remote repository "origin".

    A remote branch named "develop" is created on the remote repository "origin".

In summary, the `git push origin:develop develop` command is used to delete the remote branch named "develop" (if it exists), and create a new remote branch named "develop" with the latest changes from the local branch named "develop". This can be useful when you want to force a fresh start for the remote branch, or when you want to create a new remote branch with the same name as a previously deleted branch.



The command `git push origin/develop develop` is used to push a local branch named "develop" to a remote branch named "develop". The "origin/develop" syntax is used to specify the remote branch to push to.

Here's what happens when you run the command:

    The local branch named "develop" is pushed to the remote branch named "develop" on the remote repository "origin".

    The remote branch "origin/develop" is updated with the latest changes from the local branch "develop".

In summary, the `git push origin/develop develop` command is used to push a local branch to a specific remote branch. This can be useful when you want to update a specific remote branch with the latest changes from a local branch, or when you want to create a new remote branch with the same name as a local branch.

# I can push anywhere I want, but if I want to be able to simply type git push, I have to specify which repo is the default to push to

fatal: The current branch develop_fedora has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin develop_fedora

To have this happen automatically for branches without a tracking


# Notes about using git submodules for dependency management:

A submodule always result into a specific SHA1 being recorded by the parent repo: it is called a gitlink (special entry in the index of the parent repo).

So simply add the repo as a submodule (it does not matter what branch/commit end up being actually recorded).

cd /path/to/parent/repo
git submodule add /url/of/submodule/repo

Then go into the submodule folder and checkout the exact sHA1 or tag you want (the one corresponding to a release)

cd mysubmodule
git checkout <SHA1_of_a_release>

Go back to the parent repo, add, commit and push: you will record the new submodule state (which is to say you will record the SHA1 you want)

 cd ..
 git add .
 git commit -m "set submodule to a release SHA1"
 git push

Whenever you will clone --recursive your parent repo, your submodule willbe checked out to that release SHA1 again.

