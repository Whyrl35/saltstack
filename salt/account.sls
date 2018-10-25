# ------------------------------------------------------------
# - Create the user "{{ pillar['account_name'] }}" on all hosts
# -
create_account_name:
  user:
    - name: {{ pillar['account_name'] }}
    - present
    - gid: 100
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
    - mode: 755

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
    - source: salt://account/whyrl.zsh-theme.jinja
    - user: {{ pillar['account_name'] }}
    - group: users
    - mode: 644
    - template: jinja
    - require:
      - pkg : zsh

# ------------------------------------------------------------
# - Clone my own zshrc repo
# -
clone_zshrc_repo:
  require:
    - pkg : git
    - pkg : zsh
    - file : development_directory
  git.latest:
    - name : git@github.com:Whyrl35/zshrc.git
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
    - name : git@github.com:Whyrl35/vimrc.git
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
