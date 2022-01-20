# -*- coding: utf-8 -*-
# vim: ft=yaml
---
java:
  release: 17
  provider: adopt

  adopt:
    jvm: hotspot
    javaversion: 17.0.1+12 # 11.0.9.1+1
    pkg:
      name:  OpenJDK17U-jre # OpenJDK11U-jdk
      uri: https://github.com/adoptium/temurin17-binaries/releases/download/jdk-  # https://github.com/AdoptOpenJDK/openjdk17-binaries/releases/download/jdk-
      archive:
        # yamllint disable-line rule:line-length
        source_hash: 9d58cb741509a88e0ae33eb022334fb900b409b198eca6fe76246f0677b392ad
