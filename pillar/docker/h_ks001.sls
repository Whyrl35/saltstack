#!jinja|yaml|gpg

docker-containers:
  lookup:
    grafana:
      image: "grafana/grafana:latest"
      cmd: ~
      #args:
      pull_before_start: true
      remove_on_stop: true
      runoptions:
        - "-p 8082:3000"
        - "--volume /data/grafana/lib:/var/lib/grafana"
        - "--volume /data/grafana/etc:/etc/grafana"
        - "--link warp10:warp10"
        - "--env GF_SECURITY_ADMIN_PASSWORD='-----BEGIN PGP MESSAGE-----\n\nhQIMA85QH7s0WVo+AQ/7BfgPzb/M7xLrzyfjy4+N8QqzFcm+U2QGCZNSbHdtPoj5\nhzwhPED7+bMJNgliR+K1VRLidrNStZiFG1uTB2kWBbLENn/24vp0kh6N0J+UeWy7\n0TdbxhE96jANkZki+R1xeUKezzZqThjt4bqlTfCBlAvitCl/cvvEtmP1vBiiJI+i\nZWSoicMFhAmtUenUr8LEdhO/UY4d3bzETRkuyKGZB3ydEjHHHXqfsB+3fMeCsKEK\nMlDDFQkoi9/hkgyjh2Qjw3cM7nU8S01JBDusXIUXNa1nsLuv2XEKl2t+jNV9hEGk\nrVk/hZa6Xmb5m5hx0XiTQDXZkARn7Fpz4wWCfIKDuv3dEGij7siyyD5C6/EqU/ZJ\nmq97Tr69sB5i2IeG+WOnNi+j5LVDuOW2zFHxml+FYQ/R9ZCUoxNl4ibfMYWCrHiO\nLZg16wOe8aUSPD3th9q6eC2goC3oRUlW7GQjw1gyUDVGpojUKba3fjJ7sxpQBHN/\nr6JZ+fVX59iPuujr15/P6HOqxoC/FXF7FmECRyT+hLH1tXTMvj6EHYmViv8mm2DH\nMeMfxMlTQpYy7xQrjySo7gl2tRSzQsHVG3x5aRy7piqFIJOJB95YlDtJi8Zo7CUo\nis730d/+yi1P/jOonwzQCVdB5XAQNRAHOjR8XLi9YV/EsfN73Y1wwHgqoT1cPkvS\nQwEHbgGAHJye5w0RJzJkEz9vrxbq9+pp6oNw7NOcVopd+f3gliRakDqEMJkPiCvn\ny5sNGLrqXPgi4wURNvDGjb+j6fI=\n=RGj5\n-----END PGP MESSAGE-----'"
    koel:
      image: "binhex/arch-koel"
      cmd: ~
      #args:
      pull_before_start: false
      remove_on_stop: true
      runoptions:
        - "-p 8050:8050"
        - "-p 8060:8060"
        - "-v /data/music:/media"
        - "-v /srv/koel:/config"
        - "-v /etc/localtime:/etc/localtime:ro"
        - "-e PHP_MEMORY_LIMIT=1024"
        - "-e FASTCGI_READ_TIMEOUT=6000"
        - "-e UMASK=000"
        - "-e PUID=0"
        - "-e PGID=0"
    warp10:
      image: "warp10io/warp10:1.2.7-rc2"
      cmd: ~
      #args:
      pull_before_start: false
      remove_on_stop: false
      runoptions:
        - "--hostname warp10"
        - "--publish 127.0.0.1:8180:8080"
        - "--publish 127.0.0.1:8181:8081"
        - "--publish 127.0.0.1:8190:8090"
        - "--volume /data/warp10:/data"

