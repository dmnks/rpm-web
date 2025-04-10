---
layout: default
title: rpm.org - Download
---

## Current stable releases (supported)
{% for support in site.data.support %}
### {{ support.title }}
{% assign releases = site.releases |
    where: "series", support.series | where: "snapshot", false |
    where: "draft", false | sort: "date" | reverse %}
{% for release in releases -%}
* [{{ release.title }}]({{ release.tarball }})
  ([Release notes](releases/{{ release.slug }}))
{% endfor %}
{% if releases == empty %}
* N/A
{% endif %}
{% endfor %}

## Current test releases
{% assign found = false %}
{% for support in site.data.support %}
{% assign release = site.releases |
    where: "series", support.series | where: "draft", false |
    sort: "date" | last %}
{% if release.snapshot -%}
{% assign found = true -%}
* [{{ release.title }}]({{ release.tarball }})
  ([Release notes](releases/{{ release.version }}))
{% endif %}
{% endfor %}
{% if found == false %}
* N/A
{% endif %}

## Old releases (no longer supported)

For older releases, head over to [RPM timeline](timeline.html).

### POPT

* [POPT 1.19](https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/popt-1.19.tar.gz) ([Release notes](https://github.com/rpm-software-management/popt/releases/tag/popt-1.19-release))
