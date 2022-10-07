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

While you can obviously do this directly in git from the start, it's advisable
to instead keep a plain-text file listing all the commits on the master branch
since the branching point, mark the desired commits and use that as a plan
first.  The advantage of this approach is that it allows you to:

* Keep track of which commits you've already reviewed, also when preparing the
  next release in the future

* Email the plan to the team to get early feedback

* Tweak the plan easily, without having to (re)do any conflict resolution

* Use a shell script to automate the cherry-picking and try different
  combinations of commits to see if they apply cleanly

The following text describes one specific workflow involving such a text file.
You're of course free to tweak it as you deem necessary or use a different
workflow that suits you better.

### Creating a plan

To create a plan file for a stable branch, use the following command, replacing
`<stable>` with the stable branch name, e.g. `rpm-4.17.x` (leave `<base>` out
for now):

```
$ git cherry -v <stable> master [<base>] | sed 's/^\-/\*/; s/^\+/ /' >> ~/<stable>.patch
```

This will generate a chronological list of commits on the master branch since
the common ancestor of both branches, and mark those that have been
cherry-picked already with an `*`.  The `.patch` extension will give you nice
color highlighting out-of-the-box in any sensible text editor, which will come
in handy [next](#editing-a-plan).

To update the plan with new commits on the master branch, just re-run the above
command with `<base>` replaced by the hash of the last commit in the file.

Note that backported commits (i.e. with a unique diff) will not be marked,
you'll need to mark those manually.  This can be automated, of course, since
all such commits are supposed to contain the "Backported from commit" line in
their commit messages, but that's beyond the scope of this guide.  Normally,
backported commits aren't as numerous so this shouldn't be a big deal.

### Editing a plan

The next step is to go through each commit that's unmarked and mark it with
either a `+` or `-` depending on whether you propose it for inclusion in the
release or not, respectively.

If this is not the first release on the stable branch, you may want to skip the
commits that were already reviewed in the past.  As a rule of thumb, the last
marked commit is a good indication of where the last release was cut.

In practice, it's a good idea to look a bit further back than the last marked
commit, as there could be useful commits that were skipped in the previous
release due to budget constraints and such.

Once you've chosen your starting point, mark it by inserting a line
`@@ <release> batch 1 @@` above it where `<release>` is the release you're
working on (e.g. `rpm-4.17.1`).

When reviewing a commit for inclusion, ask yourself:

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
appropriate for a stable maintenance release.

It's advisable to keep the plan file around for as long as the given stable
branch is in support so that the information about which commits have been
reviewed isn't lost.

### Sharing a plan

Once you're satisfied with your nominations, send a plain-text email containing
the plan to the TBD mailing list and ask for feedback.  That way, people can
reply directly to the individual commits inline.  Based on the feedback, make
sure to update your local copy of the plan accordingly.

Occasionally, you may need to do another round of review as new commits appear
on the master branch.  Before you [update](#creating-a-plan) the plan, append a
line `@@ <release> batch 2 @@` to the file to delineate the commits that need
feedback.  Of course, if you need even more rounds, repeat that and increment
the batch number.

If the file is already too long, feel free to just strip the no longer relevant
`@@` "hunks" in the email to make it less noisy.  In a local copy, it's helpful
to keep the full history, though.

### Applying a plan

Once the plan is ready, you can apply it using the following script:

```
TBD
```

At this point, you can turn all `+` lines into `*` in the file to make it
reflect the stable branch:

```
$ sed -i 's/^\+/\*/' <stable>.patch
```

This script is also useful when just crafting the plan as you can try it out to
see if it applies cleanly and then reset the branch to the original tip, such
as:

```
$ git reset --hard origin/<stable>
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
