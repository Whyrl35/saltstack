wigo_package:
  pkg.installed:
    - pkgs:
      - wigo
    - require:
      - pkgrepo : deb wigo

{% if pillar['wigo']['extra']['packages'] %}
wigo-extra-pkg-install:
  pkg.installed:
    - names: {{ pillar['wigo']['extra']['packages'] }}
    - require:
      - pkg: wigo_package

{% endif %}

{% if pillar['wigo']['extra']['pip'] %}
{% for pip in pillar['wigo']['extra']['pip'] %}
wigo-extra-pip-{{ pip }}-install:
  pip.installed:
    - name: {{ pip }}
    - require:
      - pkg: wigo_package
{% endfor %}
{% endif %}
