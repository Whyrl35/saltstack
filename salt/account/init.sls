# ------------------------------------------------------------
# - Create the user "{{ pillar['account_name'] }}" on all hosts
# -
create_account_name:
  user.present:
    - name: {{ pillar['account_name'] }}
    - password: {{ pillar['account_password'] }}
    - enforce_password: True
    - mindays: 0
    - maxdays: 99999
    - inactdays: -1
    - warndays:
    - expire: -1
    - gid: 100
    - allow_gid_change: True
    - fullname: {{ pillar['account_fullname'] }}
    - shell: /usr/bin/zsh
    - gid_from_name: False
    - groups:
      - users
      - sudo
    - optional_groups:
      - docker
      - www-data
    - require:
      - pkg : zsh

# ------------------------------------------------------------
# - SSH generate a ssh key for user if needed
# -
ssh_key_generate:
  cmd.run:
    - name: ssh-keygen -q -N '' -f /home/{{ pillar['account_name'] }}/.ssh/id_rsa
    - runas: {{ pillar['account_name'] }}
    - unless: test -f /home/{{ pillar['account_name'] }}/.ssh/id_rsa

# ------------------------------------------------------------
# - For the user above, create a "development" directory
# -
development_directory:
  file.directory:
    - name: /home/{{ pillar['account_name'] }}/development
    - user: {{ pillar['account_name'] }}
    - group: users
    - mode: "0755"

# ------------------------------------------------------------
# - Clone the oh-my-zsh repository
# -
clone_ohmyzsh_repo:
  require:
    - pkg : git
    - pkg : zsh
  git.latest:
    - name : https://github.com/robbyrussell/oh-my-zsh.git
    - target : /home/{{ pillar['account_name'] }}/.oh-my-zsh
    - user: {{ pillar['account_name'] }}

ohmyzsh_custom_theme:
  file.managed:
    - name : /home/{{ pillar['account_name'] }}/.oh-my-zsh/custom/themes/whyrl.zsh-theme
    - source: salt://account/whyrl.zsh-theme
    - replace: False
    - user: {{ pillar['account_name'] }}
    - group: users
    - mode: "0644"
    - require:
      - pkg : zsh

ohmyzsh_custom_theme_{{ grains['host'] }}:
  file.blockreplace:
    - name : /home/{{ pillar['account_name'] }}/.oh-my-zsh/custom/themes/whyrl.zsh-theme
    - marker_start: "# ---- START Managed Zone, do-not-edit ----"
    - marker_end: "# ---- END Managed Zone ----"
    - source: salt://account/whyrl.zsh-theme.host-color.jinja
    - template: jinja
    - prepend_if_not_found: True

ohmyzsh_custom_plugin_highlight:
  require:
    - pkg : git
    - pkg : zsh
  git.latest:
    - name : https://github.com/zsh-users/zsh-syntax-highlighting.git
    - target : /home/{{ pillar['account_name'] }}/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
    - user: {{ pillar['account_name'] }}

# ------------------------------------------------------------
# - Clone my own zshrc repo
# -
clone_zshrc_repo:
  require:
    - pkg : git
    - pkg : zsh
    - file : development_directory
  git.latest:
    - name : https://github.com/Whyrl35/zshrc.git
    - target : /home/{{ pillar['account_name'] }}/development/zshrc
    - user: {{ pillar['account_name'] }}
    - identity: /home/{{ pillar['account_name'] }}/.ssh/id_rsa

# ------------------------------------------------------------
# - Clone my own vimrc repo
# -
clone_vim_repo:
  require:
    - pkg : git
    - pkg : vim
    - file : development_directory
  git.latest:
    - name : https://github.com/Whyrl35/vimrc.git
    - target : /home/{{ pillar['account_name'] }}/development/vimrc
    - user: {{ pillar['account_name'] }}
    - identity: /home/{{ pillar['account_name'] }}/.ssh/id_rsa

# ------------------------------------------------------------
# - Symlink all repo file
# -
symlink_zshrc:
  require:
    - git : clone_zshrc_repo
  file.symlink:
    - name : /home/{{ pillar['account_name'] }}/.zshrc
    - target : /home/{{ pillar['account_name'] }}/development/zshrc/zshrc
    - user : {{ pillar['account_name'] }}
    - group: users

symlink_vimrc:
  require:
    - git : clone_vim_repo
  file.symlink:
    - name : /home/{{ pillar['account_name'] }}/.vimrc
    - target : /home/{{ pillar['account_name'] }}/development/vimrc/vimrc
    - user : {{ pillar['account_name'] }}
    - group: users

symlink_vim_directory:
  require:
    - git : clone_vim_repo
  file.symlink:
    - name : /home/{{ pillar['account_name'] }}/.vim
    - target : /home/{{ pillar['account_name'] }}/development/vimrc/vim
    - user : {{ pillar['account_name'] }}
    - group: users
