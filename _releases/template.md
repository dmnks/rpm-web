---
layout: default
title: rpm.org - Releases
permalink: /wiki/Releases/:slug/

# Change below ----------8<----------------
version: 4.20.0     # release version
last: 4.19.x        # previous version
stamp: Apr 01 2025  # release date
series: rpm-4.20.x  # branch name
snaptag: rc1        # snapshot name: alphaN, betaN, rcN or final (where N >= 1)
snapver: 4.19.93    # snapshot version (unused if snaptag is "final")
checksum:           # tarball checksum (SHA256SUM)
summary:
    title: This is primarily a bugfix release addressing a handful of
           regressions in RPM 4.20.0 as well as various other issues.
    highlights:
        - Support for fully locked user accounts in `sysusers.d(5)` files
        - Filter Lua deprecation warnings based on the originating RPM version
        - Fix regressions in `rpmsign(8)`, `rpmspec(8)`, `%debug_package` and more
        - Fix unmodified `%config` (and possibly other) files being removed in case of unpack failure
        - Fix IMA plugin causing transaction failures in rootless containers
        - Fix sqlite rpmdb growing over time
---
{% include release-header.md %}

## Compatibility Notes
