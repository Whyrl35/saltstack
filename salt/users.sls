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
# - SSH authorized_keys for user
# -
ssh_key_vps:
  ssh_auth.present:
    - user: {{ pillar['account_name'] }}
    - source: salt://ssh/keys/id_rsa_vps001.pub
    - config: '%h/.ssh/authorized_keys'

ssh_key_ks001:
  ssh_auth.present:
    - user: {{ pillar['account_name'] }}
    - source: salt://ssh/keys/id_rsa_ks001.pub
    - config: '%h/.ssh/authorized_keys'

ssh_key_srv001:
  ssh_auth.present:
    - user: {{ pillar['account_name'] }}
    - source: salt://ssh/keys/id_rsa_srv001.pub
    - config: '%h/.ssh/authorized_keys'

ssh_key_ovhdesk:
  ssh_auth.present:
    - user: {{ pillar['account_name'] }}
    - source: salt://ssh/keys/id_rsa_ovhdesk.pub
    - config: '%h/.ssh/authorized_keys'

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

# ------------------------------------------------------------
# - Clone my own zshrc repo
# -
clone_zshrc_repo:
  require:
    - pkg : git
    - pkg : zsh
    - file : development_directory
  git.latest:
    - name : ssh://git@gitlab.ks.whyrl.fr:2222/Whyrl/zshrc.git
    - target : /home/{{ pillar['account_name'] }}/development/zshrc
    - user: {{ pillar['account_name'] }}
    - identity: /home/{{ pillar['account_name'] }}/.ssh/id_rsa

# ------------------------------------------------------------
# - Clone my own zsh-powerline repo
# -
clone_zsh_powerline_repo:
  require:
    - pkg : git
    - pkg : zsh
    - file : development_directory
  git.latest:
    - name : ssh://git@gitlab.ks.whyrl.fr:2222/Whyrl/zsh-powerline.git
    - target : /home/{{ pillar['account_name'] }}/development/zsh-powerline
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
    - name : ssh://git@gitlab.ks.whyrl.fr:2222/Whyrl/vimrc.git
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
