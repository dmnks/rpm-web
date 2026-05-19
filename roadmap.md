---
layout: default
title: rpm.org - Roadmap
---

# RPM Roadmap

An overview of the project's direction, with goals getting fuzzier the further
from the present. Both the dates and the content are tentative and subject to
change. Everything above the horizontal line is completed and only kept for
reference.

#### RPM 6.1 release (2026 Q2)
* Improved keystore locking
* Restored NSS user/group support
* Signature verification tweaks
* Literal and one-shot macros
* Usable syslog plugin
* New man pages
* Clean Clang builds
* New [release model](../2026/05/11/release-cycle.html)
* See the [release notes](../releases/6.1.0) for details

---

#### RPM 6.2 release (2026 Q3)
* Graceful handling of read-only mounts (#3400)
* Database parking (image reproducibility) (#2219)
* More man pages (dependencies, spec format)

#### RPM 6.3 release (2026 Q4)
* Filesystem capability checks (#2637)
* OverlayFS-compatible database rebuilds (#2355)
* More man pages

#### RPM 6.4 release (2027 Q1)
* Improved file triggers usability (systemd) (#4185)
* BuildSystem rough edges & shortcomings (#3965)
* Complete man page suite (#3612)

#### Mid-term plans (2027 Q2+)
* Durable, journal based transactions (#2950)
* Improved scriptlet ordering (#436)
* File classifier based actions (#2207)
* Arch-independent source archive format
* Container-native database format (#2005)

#### Long-term plans (2028+)
* Scriptlet-free transactions
* True multiarch support (#2197)
* Better soname dependencies (#2872)
* DVCS integration (packaging, `%config` file management)
* Policy based package permissions (#4186)
* Buildinfo subpackages

For further information and feedback, head over to our [discussion forum.](https://github.com/rpm-software-management/rpm/discussions/2982)
