{% from 'warp10/common.jinja' import defaults %}
{% set version = defaults.version %}

warp10:
  lookup:
    provider: github
    archive:
      github:
        version: {{ version }} # '2.11.0' # '2.9.0'
        uri: 'https://github.com/senx/warp10-platform/releases/download'
    service:
      enable: true
    config:
      in_memory:
        accelerator: true
        accelerator.ephemeral: false
        accelerator.chunk.length: 300000000
        accelerator.chunk.count: 6
        accelerator.preload: true
        accelerator.preload.poolsize: 8
        accelerator.preload.batchsize: 1000
      extensions:
        warpscript.extension.logEvent: io.warp10.script.ext.logging.LoggingWarpScriptExtension
      warp:
        cors.headers: content-type
    warpfleet:
      plugins:
        warp10-plugin-warpstudio:
          repository: io.warp10
          version: latest
          file_to_check: warp10-plugin-warpstudio-1.0.40.jar
