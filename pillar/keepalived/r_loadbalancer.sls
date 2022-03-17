{% set secret = salt['vault'].read_secret('secret/salt/keepalived/auth_pass') %}

keepalived:
  config:
    global_defs:
      notification_email:
        - ludovic@whyrl.fr
      notification_email_from: loadbalancer@whyrl.fr
      smtp_server: smtp.whyrl.fr
      smtp_connect_timeout: 30
      router_id: LVS_DEVEL
      enable_script_security: 1
      script_user: root

    vrrp_script:
      check_haproxy:
        script: '"/usr/bin/killall -0 haproxy"'
        interval: 5
        weight: 20
        user: root root

    vrrp_instance:
      VI_LB_1:
        state: {% if grains['host'] == 'lb01' %}MASTER{% else %}BACKUP{% endif %}
        interface: ens4
        virtual_router_id: 50
        priority: {% if grains['host'] == 'lb01' %}100{% else %}90{% endif %}
        advert_int: 1
        authentication:
          auth_type: PASS
          auth_pass: {{ secret['vip_lb_1'] }}
        unicast_peer:
          {%- for server, addrs in salt.saltutil.runner('mine.get', tgt='roles:loadbalancer', fun='network.ip_addrs', tgt_type='grain').items() %}
          {%- if server != grains['id'] %}
          {%- for addr in (addrs | ipv4)  %}
          {%- if(addr | is_ip(options='private')) %}
          - {{ addr }}
          {%- endif %}
          {%- endfor %}
          {%- endif %}
          {%- endfor %}
        virtual_ipaddress:
          - 46.105.37.68/32 dev ens3 label ens3:lb_1
        track_script:
            - check_haproxy
        notify_master: /etc/keepalived/attach_lb1.py

      VI_LB_2:
        state: {% if grains['host'] == 'lb01' %}BACKUP{% else %}MASTER{% endif %}
        interface: ens4
        virtual_router_id: 60
        priority: {% if grains['host'] == 'lb01' %}90{% else %}100{% endif %}
        advert_int: 1
        authentication:
          auth_type: PASS
          auth_pass: {{ secret['vip_lb_2'] }}
        unicast_peer:
          {%- for server, addrs in salt.saltutil.runner('mine.get', tgt='roles:loadbalancer', fun='network.ip_addrs', tgt_type='grain').items() %}
          {%- if server != grains['id'] %}
          {%- for addr in (addrs | ipv4)  %}
          {%- if(addr | is_ip(options='private')) %}
          - {{ addr }}
          {%- endif %}
          {%- endfor %}
          {%- endif %}
          {%- endfor %}
        virtual_ipaddress:
          - 178.33.71.84/32 dev ens3 label ens3:lb_2
        track_script:
            - check_haproxy
        notify_master: /etc/keepalived/attach_lb2.py
