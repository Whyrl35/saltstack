{% from 'nexus/common.jinja' import defaults %}
{% set version = defaults.version %}

nexus:
  java:
    home: '/usr/local/bin/'

  download:
    version: {{ version }}  # '3.37.3-02'
    httppath: 'https://download.sonatype.com/nexus/3/nexus-{{ version }}-unix.tar.gz'
    hash: 'https://sonatype-download.global.ssl.fastly.net/repository/downloads-prod-group/3/nexus-{{ version }}-unix.tar.gz.sha1'  # 'http://download.sonatype.com/nexus/3/latest-unix.tar.gz.sha1'
    hostpath: '/tmp/download'
  install:
    path: '/opt'
    datapath: '/srv/sonatype-work'
  user:
    name: 'nexus'
    group: 'nexus'
    environmentvariable: 'NEXUS_HOME="/opt/nexus"'
    home: '/home/nexus'
  file:
    nexus:
      limit: '65536'
      properties:
        applicationport: '8081'
        applicationhost: '127.0.0.1' #"{# salt.grains.get('ip4_interfaces:ens4:0', '0.0.0.0') #}"
        nexuscontextpath: '/'
      jetty:
        https:
          keystorepath: "keystore"
          keystorepassword: 'dummy'
          keymanagerpassword: 'dummy'
          truststorepath: "truststore"
          truststorepassword: 'dummy'
          certificate:
            commonname: 'dummy'
            ou: 'dummy'
            organisation: 'dummy'
            country: 'ZZ'
      rc:
        runasuser: 'nexus'
      vmoptions:
        addjavavariables:
          - 'Xms4096M'
          - 'Xmx4096M'
          - 'XX:MaxDirectMemorySize=4G'
          - 'XX:+UnlockDiagnosticVMOptions'
          - 'XX:+UnsyncloadClass'
          - 'XX:+LogVMOutput'
          - 'XX:LogFile=../sonatype-work/nexus3/log/jvm.log'
          - 'Djava.net.preferIPv4Stack=true'
          - 'Dkaraf.home=.'
          - 'Dkaraf.base=.'
          - 'Dkaraf.etc=etc/karaf'
          - 'Djava.util.logging.config.file=etc/karaf/java.util.logging.properties'
          - 'Dkaraf.data=../sonatype-work/nexus3'
          - 'Djava.io.tmpdir=../sonatype-work/nexus3/tmp'
          - 'Dkaraf.startLocalConsole=false'
          - 'Djava.util.prefs.userRoot=/home/nexus/.java'
