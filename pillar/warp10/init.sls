warp10:
  lookup:
    achive:
      bintray:
        version: '2.7.1'
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
