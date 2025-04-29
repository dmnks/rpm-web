# RPM.org Website

This repository holds the [Jekyll](https://jekyllrb.com/) source files used to
generate the official [homepage](https://rpm.org/) of the RPM project.

The website features RPM releases and other news related to the RPM project. It
also links to the in-tree
[documentation](https://rpm-software-management.github.io/rpm/) which is
generated from the upstream
[repository](https://github.com/rpm-software-management/rpm).

## Adding a release

RPM releases are represented as a Jekyll
[collection](https://jekyllrb.com/docs/collections/) in the `_releases/`
directory.  Each document represents an RPM release (or prerelease) and has a
YAML front matter describing the release's properties.  The body of the file
contains the (optional) release notes in Markdown format.

### Required fields

* `version` - RPM version
* `date` - Release date (`YYYY-MM-DD`)
* `baseline` - Which RPM version the release notes compare against
