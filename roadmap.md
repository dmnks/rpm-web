---
layout: default
title: rpm.org - Roadmap
---

# RPM Roadmap

An overview of the project's direction and release plans, split into quarters.
Both the dates and the content are tentative and subject to change. Everything
above the horizontal line is completed and only kept for reference.

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

#### RPM 6.2 release (2026 Q4)

* Persistent transaction journal (#2950)
* Filesystem capability checks (#2637) & graceful abort (#3400)
* Better file triggers usability (for systemd) (#4185)
* BuildSystem rough edges & shortcomings (#3965)
* Database parking (#2219)
* OverlayFS-compatible database rebuilds (#2355)
* New man pages (dependencies, spec format)

#### RPM 6.3 release (2027 Q2)

* Durable transactions (journal based) (#2950)
* Improved ordering & delayed scriptlet execution (#436)
* File classifier based actions (#2207)
* Arch-independent source archive format
* Container-native database format (#2005)
* Complete man page suite (#3612)

#### Future releases (2027 Q4 and later)

* Scriptlet-free transactions
* True multiarch support (#2197)
* Better soname dependencies (#2872)
* DVCS integration (packaging, `%config` file management)
* Policy based package permissions (#4186)
* Buildinfo subpackages

For further information and feedback, head over to our [discussion forum.](https://github.com/rpm-software-management/rpm/discussions/2982)
