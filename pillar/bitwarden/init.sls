#!jinja|yaml|gpg

{% set secret = salt['vault'].read_secret('secret/salt/vault/bitwarden') %}

bitwarden:
  base_url: warden.whyrl.fr
  sql_password: {{ secret['sql_password'] }}
  certificate_password: {{ secret['certificate_password'] }}
  identity_key: {{ secret['identity_key'] }}
  oidc_id_client_key: {{ secret['oidc_id_client_key'] }}
  duo_akey: {{ secret['duo_akey'] }}
  installation_id: {{ secret['installation_id'] }}
  installation_key: {{ secret['installation_key'] }}
  email_domain: whyrl.fr
