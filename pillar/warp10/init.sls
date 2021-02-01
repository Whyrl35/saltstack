warp10:
  lookup:
    archive:
      bintray:
        version: '2.7.3'
        uri: 'https://dl.bintray.com/senx/generic/io/warp10/warp10'
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
