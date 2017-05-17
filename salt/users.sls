# ------------------------------------------------------------
# - Create the user "{{ pillar['myuser'] }}" on all hosts
# -
create_myuser:
  user:
    - name: {{ pillar['myuser'] }}
    - present
    - gid: 100
    - fullname: {{ pillar['myuser_fullname'] }}
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
# - For the user above, create a "development" directory
# -
development_directory:
  file.directory:
    - name: /home/{{ pillar['myuser'] }}/development
    - user: {{ pillar['myuser'] }}
    - group: users
    - mode: 755

# ------------------------------------------------------------
# - Clone the oh-my-zsh repository
# -
clone_ohmyzsh_repo:
  require:
    - pkg : git
  git.latest:
    - name : https://github.com/robbyrussell/oh-my-zsh.git
    - target : /home/{{ pillar['myuser'] }}/.oh-my-zsh
    - user: {{ pillar['myuser'] }}

# ------------------------------------------------------------
# - Clone my own zshrc repo
# -
clone_zshrc_repo:
  require:
    - pkg : git
    - file : development_directory
  git.latest:
    - name : ssh://git@gitlab.ks.whyrl.fr:2222/Whyrl/zshrc.git
    - target : /home/{{ pillar['myuser'] }}/development/zshrc
    - user: {{ pillar['myuser'] }}

# ------------------------------------------------------------
# - Clone my own zsh-powerline repo
# -
clone_zsh_powerline_repo:
  require:
    - pkg : git
    - file : development_directory
  git.latest:
    - name : ssh://git@gitlab.ks.whyrl.fr:2222/Whyrl/zsh-powerline.git
    - target : /home/{{ pillar['myuser'] }}/development/zsh-powerline
    - user: {{ pillar['myuser'] }}

# ------------------------------------------------------------
# - Clone my own vimrc repo
# -
clone_vim_repo:
  require:
    - pkg : git
    - file : development_directory
  git.latest:
    - name : ssh://git@gitlab.ks.whyrl.fr:2222/Whyrl/vimrc.git
    - target : /home/{{ pillar['myuser'] }}/development/vimrc
    - user: {{ pillar['myuser'] }}

# ------------------------------------------------------------
# - Symlink all repo file
# -
symlink_zshrc:
  require:
    - git : clone_zshrc_repo
  file.symlink:
    - name : /home/{{ pillar['myuser'] }}/.zshrc
    - target : /home/{{ pillar['myuser'] }}/development/zshrc/zshrc
    - user : {{ pillar['myuser'] }}
    - group: users

symlink_vimrc:
  require:
    - git : clone_vim_repo
  file.symlink:
    - name : /home/{{ pillar['myuser'] }}/.vimrc
    - target : /home/{{ pillar['myuser'] }}/development/vimrc/vimrc
    - user : {{ pillar['myuser'] }}
    - group: users

symlink_vim_directory:
  require:
    - git : clone_vim_repo
  file.symlink:
    - name : /home/{{ pillar['myuser'] }}/.vim
    - target : /home/{{ pillar['myuser'] }}/development/vimrc/vim
    - user : {{ pillar['myuser'] }}
    - group: users
