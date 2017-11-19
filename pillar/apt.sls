apt:
  repositories:
    metrics:
      distro: stretch
      url: http://last.public.ovh.metrics.snap.mirrors.ovh.net/debian/
      comps: [main]
      arch: [amd64, i386]
      keyid: A7F0D217C80D5BB8
      keyserver: hkp://pgp.mit.edu:80
    saltstack:
      distro: stretch
      url: https://repo.saltstack.com/apt/debian/9/amd64/latest
      comps: [main]
      arch: [amd64, i386]
      keyid: 0E08A149DE57BFBE
      keyserver: hkp://pgp.mit.edu:80
    {% if 'container' in grains['roles'] %}
    docker:
      distro: debain-stretch
      url: https://apt.dockerproject.org/repo
      comps: [main]
      arch: [amd64, i386]
      keyid: F76221572C52609D
      keyserver: hkp://pgp.mit.edu:80
    {% endif %}
