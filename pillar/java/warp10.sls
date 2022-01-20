# -*- coding: utf-8 -*-
# vim: ft=yaml
---
java:
  release: 8 #11
  provider: adopt

  adopt:
    jvm: hotspot
    javaversion: 8u292-b10 #11.0.9.1+1
    pkg:
      #name: OpenJDK11U-jdk
      #uri: https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-
      archive:
        # yamllint disable-line rule:line-length
        source_hash: 0949505fcf42a1765558048451bb2a22e84b3635b1a31dd6191780eeccaa4ada
