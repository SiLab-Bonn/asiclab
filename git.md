# Github Contribution Workflow

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




