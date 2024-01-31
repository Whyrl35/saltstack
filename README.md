[![Build Status](https://drone.ingress.k8s.whyrl.fr/api/badges/whyrl/saltstack/status.svg)](https://drone.ingress.k8s.whyrl.fr/whyrl/saltstack)

# Saltstack repository

## Install salt on new minion :

	curl -L https://bootstrap.saltstack.com -o install_salt.sh
	sudo sh install_salt.sh -A <salt-server> -i fqdn

## salt directory

All salt.states : https://docs.saltstack.com/en/getstarted/config/functions.html

## pilar directory

All salt.pillar : https://docs.saltstack.com/en/getstarted/config/pillar.html

## formulas directory

Git clone of some formula (like forge for puppet) : https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html
List of formulas : https://github.com/saltstack-formulas?language=&page=2&q=&type=&utf8=%E2%9C%93
