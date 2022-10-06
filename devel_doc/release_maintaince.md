---
layout: default
title: rpm.org - RPM Maintenance
---
TODO: Update according to modification/redesign of rpm.org

# RPM Maintenance

## Git branches

Rpm development takes place in the git master branch, but releases are created from stable branches, created when a development cycle is coming to an end. 
Alfa tarball is traditionally cut from master, but prior to beta release
the tree is branched and beta and later releases are *always* created
from a branch, not master.

* rpm-4.15.x branch from which all 4.15.x versions are cut from
* rpm-4.14.x branch from which all 4.14.x versions are cut from
* ...

When pulling fixes from git master to stable branches, always use -x to get the automatic cherry-pick commit marker. This way its easier to see which patches come from master, and which commit exactly. If a cherry-pick conflicts,
see if it's resolvable with a suitable upstream commit and if not, when
fixing manually change the "cherry-picked from" message into "Backported from
commit hash" to mark the difference.

## Selecting commits

Crafting a maintenance update is inherently a manual process which starts by
selecting suitable commits from the master branch to cherry-pick or backport
into the respective maintenance branch.  While it's possible to do this work
directly in git from the start, it's usually better to first create a
plain-text file listing all the commits you're considering, share it with the
team via email to get early feedback, and once that's polished enough, proceed
with the actual cherry-picking and backporting in your git checkout.  This
allows for easy per-commit discussion without having to go through a
full-fledged PR review process and repeat any manual conflict resolution when a
commit is added or removed in the process.

The format of the text file is up to you, we've had success with one that's
inspired by the interactive git rebase:

```
pick <abbrev-hash> <subject>
pick <abbrev-hash> <subject>
drop <abbrev-hash> <subject>
[...]
```

The advantage of this format is that you can then automate the cherry-picking
in git with a simple shell script.

### Getting started

In order to start the selection process, you need to know *where* to start
looking, that is, which is the oldest commit on the master branch that wasn't
released in the previous maintenance update and thus needs to be reviewed
first.  As a rule of thumb, that should be the commit denoted in a
`(cherry-picked from <hash>)` line in the latest commit on the maintenance
branch, if that branch exists.  Of course, there could be additional commits on
the maintenance branch which weren't taken from master, as well as some commits
older than `<hash>` that might be worth considering in the release, so use your
best judgement.

### Creating a plan

Once you have that commit identified, you can generate a text file in the above
format with the following command (replace `<hash>` with the commit hash):

```
git log --reverse --format="     %h %s" <hash>..master > gitplan
```

As you go through the commits one by one (e.g. using `git show` in a separate
terminal), you make a note next to the respective commit in the `gitplan` file
by entering either `pick` or `drop` into the empty space at the beginning of
the line.  Lines without a keyword indicate the commits that you haven't
reviewed yet, which can serve as a "bookmark".

### Reviewing commits

This is the actual 

### Applying the plan

From time to time, you may want to test-drive your `gitplan` file to see if the
selected commits apply cleanly and even do some preliminary backporting work if
you wish.  To do that, you can run the following script:

```
```

### Sharing the plan

Once you're satisfied with your selection, send `gitplan` as a plain-text email
to the RPM mailing list (TBD), asking for feedback.

### Opening a PR

Once there's a consensus about the plan, open a pull request




### 


For each fix or other change you consider cherry-picking, ask yourself:

* Does it change the ABI or API in an incompatible way?

    Generally adding entirely new APIs is okay, any other change is not, except of course to fix behavior bugs.

* Does it affect package building in an incompatible way?

    For example, adding new types of requires within stable releases is not a good idea (but provides are mostly harmless). New spec sanity checks may seem obvious, but unless its a crasher, chances are somebody is actually (ab)using it and will be unhappy if the package no longer builds. New warnings are generally okay, hard errors often are not.

    As a rule of thumb: If a package was buildable with rpm-X.Y.Z then it should also be buildable without changes on rpm-X.Y.Z+1, even if it relies on buggy behavior.

* Does it affect package installation in an incompatible way?

    Rpm is commonly used to install much older and also newer packages built with other versions than the running version, installation compatibility is hugely important always and even more so within stable branches.

    As a rule of thumb: If a package was installable with rpm-X.Y.Z then it should also be installable without changes on rpm-X.Y.Z+1, even if it relies on buggy behavior.

If the answer to any of the above is "yes" then its almost certainly not appropriate for stable maintenance release.

## Cutting a release

1. Prepare preliminary release notes at https://rpm.org/wiki/Releases/X.Y.Z

    * Not every commit needs a corresponding release notes entry, eg
      internal refactoring and cleanup should not be detailed, and 
      often a new feature consists of multiple commits that deserve exactly
      on entry in the notes
    * Follow common style in the text, git commit messages are rarely good
      as-is. Start with what it does: add/fix/remove/change/optimize,
      followed by concise description. Group and sort by types of change.
    * Not all releases need the same exact subtitle groups, use common sense.
    * Upstream GH tickets can use #ticketno shortcut, references to external
      bugzillas follow naming conventions: RhBug:bugno, SuseBug:bugno,
      MgaBug:bugno (optimally make these actual links)

2. Prepare the sources:

    * Bump the version in configure.ac
    * Bump rpm_version_info (ie library soname version info) in rpm.am. Basic libtool guidelines for maintenance updates to stable versions:
        * consult the [libtool manual](https://www.gnu.org/software/libtool/manual/html_node/Updating-version-info.html)
        * soname bumps can only occur at the first version of a new branch (ie alpha/beta)

    * Update the sources for the above (Makefiles, .po regeneration and all): ```make dist```
    * Commit the changes from the previous step with something like 'Preparing for X.Y.Z' as message 

3. Generate the final release tarball:

    ```make distcheck```

4. Check that the previous step does not introduce any new changes (eg 'git diff')

5. Unpack the tarball next to the previous version and inspect the differences (something like 'diff -uNr rpm-<X.Y.Z> rpm-<X.Y.Z+1>') and watch out for unexpected material. If you find any, STOP, figure it out and go back as many steps as required.

6. Submit the whole lot as a pull-request to the branch in question

    * In case of maintenance releases, leave it up for commenting for at
      least a week to allow for community feedback
    * Review needs a different mindset than new code: look for compatibility
      and stability issues in particular, as per "selecting commits"
      above

7. Tag the release. Something like:

    git tag -a -m "RPM X.Y.Z release" rpm-X.Y.Z-release

8. Push the tag. This is the point of no return for a given release.

    git push --tags

9. Upload the bz2 tarball
   * scp to rpm@ftp-osl.osuosl.org to the appropriate per-branch directory in ~/ftp/releases/
   * run ./trigger-rpm script in the rpm home directory to start mirror process

9. Make the release official:

    * add tarball checksum and download location to the release notes
    * add a new item to https://rpm.org/wiki/News and https://rpm.org/timeline
    * send an announcement mail to rpm-announce@lists.rpm.org and rpm-maint@lists.rpm.org (and why not rpm-list@lists.rpm.org too) 
