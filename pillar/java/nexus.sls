# -*- coding: utf-8 -*-
# vim: ft=yaml
---
java:
  release: 8
  provider: adopt

  adopt:
    jvm: hotspot
    javaversion: 8u312-b07
    pkg:
      name: OpenJDK8U-jre #-jdk
      uri: https://github.com/adoptium/temurin8-binaries/releases/download/jdk  # https://github.com/AdoptOpenJDK/openjdk17-binaries/releases/download/jdk-
      archive:
        # yamllint disable-line rule:line-length
        #JDK: source_hash: 699981083983b60a7eeb511ad640fae3ae4b879de5a3980fe837e8ade9c34a08
        source_hash: 18fd13e77621f712326bfcf79c3e3cc08c880e3e4b8f63a1e5da619f3054b063
