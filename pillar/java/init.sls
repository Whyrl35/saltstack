# -*- coding: utf-8 -*-
# vim: ft=yaml
---
java:
  release: 8 #11
  provider: adopt

  adopt:
    jvm: hotspot
    javaversion: 8u275-b01 #11.0.9.1+1
    pkg:
      #name: OpenJDK11U-jdk
      #uri: https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-
      archive:
        # yamllint disable-line rule:line-length
        source_hash: 06fb04075ed503013beb12ab87963b2ca36abe9e397a0c298a57c1d822467c29
