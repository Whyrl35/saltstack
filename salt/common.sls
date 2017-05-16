common_packages:
  pkg.installed:
    - pkgs:
      - {{ pillar['editor'] }}
      - zsh
