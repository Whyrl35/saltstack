#!jinja|yaml|gpg

beamium:
  scrapers:
    homeassistant:
      url: http://127.0.0.1:8123/api/prometheus
      period: 60s
      format: prometheus
      labels:
        host: homeassistant
      headers:
        Authorization: |
          -----BEGIN PGP MESSAGE-----

          hQIMA85QH7s0WVo+ARAAp6OcNKnzDnTJzayzprgxA8zeujbeDV6eis16o31UUy14
          P+OnGuT3sN5+k7M++qtSHaQ6Ocinls5jbUTaC8bLUJt/KViT3psY8/c2wWPDWuJ6
          ignA20x6ZS0Q0qJUzqtwN8se8W5HuyN4zbnWek1wk+lI/TUq7MJiK3yas5Nvmdob
          HxRYx+OufO/aX4gJrHIMS0JQtOUKWqKX5g6IQ24cF4CdUOudywbtieIUshn9uvoc
          weNwxKy9/Fnij2CVcwWYzaOcFxKto1FzO0GVdGvUFlJu0rx3GzqRERSAARUxaQ3v
          Bs4LV0RanqFlOCoOVx6g6sk/oNrYlhImGorWoh5Zdn4FXXYgMOu0YtYDJlC/DII2
          dYP4v4cOhwrSfwgyIopJJyRPL7QAZRoNMIrAG5fHmyBiFsFa/AqB394QBddGwKYl
          vcpNbeVHYBw1He7d1wFtLKLx0TpHOScj1Mjf3Y0jw7hD72CzS7Xevv65sI//xdJO
          aGhLYr7iyPVCeN6Lf+YsZCjr380Rr17fyovD3U76TSjLndUXywSBh1kDgkdM/qGd
          eKVdwyHDLkhhC2gW/xkLU88rtk7HQ4VfpiXcIxSqSMBU01S9QoiTukkL7iffeDVS
          Uh2ueQqFa1lZwQ4RyrIYU9KbUb/v8DXhq4oBlMS9Xaa5TolZszPa4+/OiGDaRCvS
          wCoBnXBJ4+QeNpBdSGkM2bInDFotkON/xOf7dqu2lX9sduNXAn6A3I3+2NlZ539g
          ItIkroUYl/mg5lRBemt1TcSAFH0GpXzDjnTcXUNSh4KJLhNJrmEGVXxQpZ4CT+Mz
          E+PTCY7TX96Z/QpVph0HLTatrTuKQrGmeQmDC0K8pRcgCWefstfiPIO/cA5CReiG
          fpx0hv9hAUrVKym04afGbDtUos/gxWySqG7mmxL1WI9uMLiX3bDDuxZkckjLsupD
          VZsqpFFGT9xtUBtgovoirerETOlJYFq+gfWCAgAcgkODX3E/ZI7ODSEA6aw=
          =fzg3
          -----END PGP MESSAGE-----
