---
layout: default
title: rpm.org - Home
---
## RPM Package Manager

The RPM Package Manager (RPM) is a powerful package management system
capable of

* building computer software from source into easily distributable
  packages
* installing, updating and uninstalling packaged software
* querying detailed information about the packaged software, whether
  installed or not
* verifying integrity of packaged software and resulting software installation

## News
#### RPM 4.19.1 released (Dec 06 2023)
* This is a bug fix release with a few minor enhancements.
* See [release notes](wiki/Releases/4.19.1) for details and download information
* Highlights include:


#### RPM 4.18.2 released (Nov 13 2023)
* This is a bug fix release with a few minor enhancements.
* See [release notes](wiki/Releases/4.18.2) for details and download information
* Highlights include:
    * New `%{rpmversion}` and `%{_iconsdir}` macros
    * New `rpmspec(8)` aliases for weak dependency queries
    * Add libmagic exceptions for HTML, SVG and PNG
    * Fix `SOURCE_DATE_EPOCH=0` regression
    * Fix various `rpm2archive(8)` issues
    * Fix various Lua interface issues
    * Various regression fixes
    * Numerous documentation fixes and improvements

#### RPM 4.19.0 released (Sep 19 2023)
* See [release notes](wiki/Releases/4.19.0) for details and download information
* Highlights include:
    * New spec snippet [support](https://rpm-software-management.github.io/rpm/manual/dynamic_specs.html) for dynamic spec generation
    * New `sysusers.d(5)` [integration](https://rpm-software-management.github.io/rpm/manual/users_and_groups.html) for automated user and group handling
    * Proper shell-like globbing and escaping in `%files` and CLI
    * Memory and address-space aware build resource allocation
    * Platform detection fixes and improvements for x86 CPUs
    * Chroot handling fixes
    * New CMake build system
    * Export of RPM libraries for CMake's `find_package()`
    * Adoption of Linux containers in the test-suite, replacing `fakechroot(1)`
    * New Python binding usage examples
    * Translations [split off](https://github.com/rpm-software-management/rpm-l10n/)
    * Removal of various deprecated and/or unused APIs
    * Various internal code cleanups

#### RPM 4.19.0 RC1 released (Sep 04 2023)
* This is a release candidate with minor enhancements and bug fixes since BETA.
* See [draft release notes](wiki/Releases/4.19.0) for details and download information
* Highlights include:
    * New `rpmspec` aliases for weak dependency queries
    * More consistent behavior with `%optflags` and noarch builds
    * Test-suite fixes and tweaks to the new container-based backend
    * Export our libraries as a CMake `find_package()` config
    * Default to C.UTF-8 locale in CMake
    * Other CMake fixes and tweaks

#### CI migrated from SemaphoreCI Classic to GitHub Actions (Aug 03 2023)
* Due to the planned [discontinuation](https://semaphoreci.com/blog/semaphore-classic-deprecation)
  of SemaphoreCI Classic starting in early September 2023, we have moved to
  GitHub Actions for our CI needs
  (see [#2569](https://github.com/rpm-software-management/rpm/issues/2569) for more details).

#### RPM 4.19.0 BETA released (Aug 02 2023)
* This is a feature-complete pre-release with a number of bug fixes since ALPHA2.
* See [draft release notes](wiki/Releases/4.19.0) for details and download information
* Highlights include:
    * New `sysusers.sh` script as a drop-in replacement for `systemd-sysusers(8)`
    * New `%{specpartsdir}` macro for configuring the spec snippet location
    * New `%{rpmversion}` macro for obtaining the running RPM version
    * New Python binding usage examples
    * Adoption of Linux containers in the test-suite, replacing `fakechroot(1)`
    * Platform detection fixes and improvements for x86 CPUs
    * Chroot handling fixes

#### RPM 4.19.0 ALPHA2 released (Jun 09 2023)
* This is a bug fix update to address a couple of issues found by the early
  adopters of ALPHA1, mostly related to some bits and pieces missed during the
  CMake transition.
* See [draft release notes](wiki/Releases/4.19.0) for details and download information

#### RPM 4.19.0 ALPHA released (Apr 13 2023)
* See [draft release notes](wiki/Releases/4.19.0) for details and download information
* Highlights include:
    * New spec snippet [support](https://rpm-software-management.github.io/rpm/manual/dynamic_specs.html) for dynamic spec generation
    * New `sysusers.d(5)` [integration](https://rpm-software-management.github.io/rpm/manual/users_and_groups.html) for automated user and group handling
    * Memory and address-space aware build resource allocation
    * Proper shell-like globbing and escaping in `%files` and CLI
    * New CMake build system
    * Translations [split off](https://github.com/rpm-software-management/rpm-l10n/)
    * Removal of various deprecated and/or unused APIs
    * Various internal code cleanups

#### RPM 4.18.1 released (Mar 13 2023)
* This is a bug fix release addressing a number of regressions and other issues.
* See [release notes](wiki/Releases/4.18.1) for details and download information
* Highlights include:
  * Preserve packages bit-by-bit again when adding and then removing signatures
  * Fix install of block and character special files
  * Disable `debuginfod` server lookups during package builds
  * Plugin fixes (fapolicyd and selinux)
  * Various OpenPGP and macro parser fixes

#### RPM v6 package format draft published (Jan 30 2023)
* The initial v6 format draft is now [up for discussion](https://github.com/rpm-software-management/rpm/discussions/2374)

#### RPM 4.18.0 released (Sep 20 2022)
* See [release notes](wiki/Releases/4.18.0) for details and download information
* Highlights include:
  * Big file handling rework to address a class of symlink vulnerabilities
    during install, restore and erasure
  * More intuitive conditional builds macro `%bcond`
  * Weak dependencies accept qualifiers like `meta` and `pre` now
  * New Sequoia-based OpenPGP backend
  * New interactive shell for working with macros (`rpmspec --shell`) and embedded Lua (`rpmlua`)
  * New `%conf` spec section for build configuration
  * New `rpmuncompress` cli tool simplifies unpacking multiple sources
  * Numerous macro improvements and fixes
  * Numerous internal OpenPGP parser correctness and security fixes

#### POPT 1.19 released (Sep 20 2022)
* See [release notes](https://github.com/rpm-software-management/popt/releases/tag/popt-1.19-release) for full details and download information
* Highlights since popt 1.18 include
  * Two regressions from 1.18 fixed
  * Code cleanups and fixes
  * License clarification

For older news, head over to [RPM timeline](timeline.html).
