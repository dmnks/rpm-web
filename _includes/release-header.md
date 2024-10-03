{% if page.snaptag == "final" %}
# RPM {{ page.version }} Release Notes
{% assign snapver = page.version %}
{% assign dirname = page.series %}
{% else %}
# RPM {{ page.version }} {{ page.snaptag | upcase }} Release Notes (DRAFT)
{% assign snapver = page.snapver %}
{% assign dirname = "testing" %}
{% endif %}

## Download
* Source: [rpm-{{ snapver }}.tar.bz2](https://ftp.osuosl.org/pub/rpm/releases/{{ dirname }}/rpm-{{ snapver }}.tar.bz2)
* SHA256SUM: {{ page.checksum }}

## Changes From {{ page.last }}
