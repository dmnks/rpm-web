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

Crafting a maintenance release is inherently a manual process which starts by
selecting suitable commits from the master branch to cherry-pick or backport
into the respective stable branch.

While you can obviously do this directly in git from the start, it is
recommended that you first create a text file where you list all commits on the
master branch since the last release and mark those that you intend to pick.
This approach allows you to:

* Keep track of which commits you've reviewed so far

* Ensure that commits are always picked in chronological order

* Email the plan to the team to get early feedback

* Tweak the plan easily, without having to (re)do any conflict resolution

* Use a shell script to automate the cherry-picking

* Try out different variants of the plan to see which apply cleanly

The rest of this section describes a workflow that involves keeping such a text
file (called a "plan"), one per stable branch, and a helper script.

### Installing the script

Download the script from here, make it executable and from your RPM checkout,
add a git alias for it:

```
$ git config alias.cherry-plan '!/path/to/script'
```

### Initializing a plan

To create a plan file for a stable branch (e.g. `rpm-4.17.x`), run:

```
$ git checkout <stable>
$ git cherry-plan init
```

This will create a file with a chronological list of commits on the master
branch since the branching point, marking those that have been cherry-picked or
backported already with an `*`.  To edit the file in your `$EDITOR`, run:

```
$ git cherry-plan edit
```

The file uses a patch-like format and is stored as
`$HOME/.cherry-plan/<stable>.patch`.  The extension ensures you'll get nice
color highlighting out-of-the-box in any sensible text editor.

To pull new commits from the master branch into the plan, use:

```
$ git cherry-plan pull
```

This will print the new commits, too.

### Editing a plan

The next step is to go through the unmarked commits and mark those that you
intend to pick for the release with a `+`.  For each commit you review, ask
yourself:

* Does it change the ABI or API in an incompatible way?

    Generally adding entirely new APIs is okay, any other change is not, except
    of course to fix behavior bugs.

* Does it affect package building in an incompatible way?

    For example, adding new types of requires within stable releases is not a
    good idea (but provides are mostly harmless). New spec sanity checks may
    seem obvious, but unless its a crasher, chances are somebody is actually
    (ab)using it and will be unhappy if the package no longer builds. New
    warnings are generally okay, hard errors often are not.

    As a rule of thumb: If a package was buildable with rpm-X.Y.Z then it
    should also be buildable without changes on rpm-X.Y.Z+1, even if it relies
    on buggy behavior.

* Does it affect package installation in an incompatible way?

    Rpm is commonly used to install much older and also newer packages built
    with other versions than the running version, installation compatibility is
    hugely important always and even more so within stable branches.

    As a rule of thumb: If a package was installable with rpm-X.Y.Z then it
    should also be installable without changes on rpm-X.Y.Z+1, even if it
    relies on buggy behavior.

If the answer to any of the above is "yes" then it's almost certainly not
appropriate for a stable maintenance release.  Mark such a commit with a `-`.

#### Choosing a starting point

If this is a new plan file, you may want to skip any unmarked commits that were
likely reviewed as part of the previous release (if any).  In that case, the
last marked commit is a good cutting point, but you should still look a bit
further back, in case some otherwise eligible commits were skipped due to
[budget](#choosing-a-commit-budget) constraints and such.  In particular,
regression updates (e.g. 4.17.1.1) usually include very specific cherry-picks,
leaving a gap behind that may contain useful material for the next stable
release.

Otherwise, if you're editing an existing plan file, simply start at the first
unmarked commit.

Once you've chosen your starting point, bookmark it by inserting the following
line above the respective commit, where `<release>` is the release you're
preparing, e.g. 4.17.2:

```
@@ <release> @@
```

This will come in handy when you [ask](#sharing-a-plan) for feedback later.

In the case of a new plan, you can now also mark all preceding commits with a
`-` like so:

```
$ git cherry-plan start <release>
```

#### Choosing a commit budget

A useful tool to help you pick and, in particular, *not* pick stuff, is a
"commit budget".  Normally, 50 is a good one for a typical maintenance release.
Of course, this number is just a ballpark figure and you may want to tweak it
as necessary.

Generally speaking, the budget is for code changes *only*, so any test and
documentation additions or updates do *not* count and should always be picked
if possible.

You can check how you're doing in terms of budget spending by running:

```
$ git cherry-plan status
Your plan is up to date with 'master'.

Candidate commits: 72
   Picked commits: 23/50
```

The budget number is taken from the `Budget:` line at the top of the file and
defaults to 50 for newly created plans.  As a little perk, if you add `#test`
or `#docs` on a commit line in the file, that commit won't be counted against
the budget here.

### Sharing a plan

Once you're satisfied with your picks, send the plan as a plain-text email to
the TBD mailing list and ask for feedback.  That way, people can reply directly
to the individual commits inline.  Based on the feedback, make sure to update
your local copy of the plan accordingly.

You may need to do another round of review as new commits appear on the master
branch, in which case delineate the new commits with a `@@ batch 2 @@` line.
For any subsequent rounds, do the same and bump the number accordingly.

If the email gets too long, feel free to just strip the no longer relevant `@@`
"hunks" in it.  In your local copy, though, make sure to keep the full history
as it's useful.

### Applying a plan

Once the plan is ready, apply it to the branch by running:

```
$ git cherry-plan apply
```

This will go through each commit marked with a `+` and run `git cherry-pick -x`
on it.

In case a commit doesn't apply cleanly, the process will stop and a message
will be printed.  At that point, proceed with conflict resolution as usual and
when committing the changes, make sure to replace the "(cherry-picked from
commit" line into "Backported from commit".  Then, run:

```
$ git cherry-plan update
```

This will update the `*` marks in the file so that they reflect the actual
branch, i.e. any cherry-picks that were applied successfully above.  Continue
the process by re-running `git cherry-plan apply`.  If another conflict occurs,
repeat the same process until the plan is applied completely.

It can be handy to also try this out from time to time while you're preparing
the plan, to make sure you're not missing some pre-requisite commit(s).  You
can either do this on the stable branch itself, or check out a throwaway one
and just delete it when done.  The advantage of the latter is that, as you work
your way through conflicts and run `git cherry-plan update`, the original plan
file won't be touched.  To do this, run:

```
$ git checkout -b test-picks
$ git cherry-plan init <stable>
```

This will copy the existing plan from the `<stable>` branch instead of creating
a new one.  To get a fresh copy, just delete the plan with `git cherry-plan rm`
while on the `test-picks` branch and then re-init it the same way.

Alternatively, if you just wish to get a chronological list of picks (only
commit hashes) to apply later by yourself, use:

```
$ git cherry-plan list > cherry-picks.txt
```

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
