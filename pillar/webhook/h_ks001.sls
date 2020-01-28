#!jinja|yaml|gpg
webhooks:
  files:
    - /opt/webhooks/actions/moviecat.sh:
      - source: salt://webhook/files/moviecat.sh
  configurations:
    - id: "moviecat-deployment"
      execute-command: "/opt/webhooks/actions/moviecat.sh"
      command-working-directory: "/srv/moviecat"
      reponses-message: "deploying moviecat..."
      trigger-rule:
        match:
          type: "payload-hash-sha1"
          secret: |
            -----BEGIN PGP MESSAGE-----

            hQIMA85QH7s0WVo+AQ//R0SmF7g3aV8rq2dFBQsNEtsLLyMg4ik/tRIO77FagRP7
            EiGhx1WwOOIb2qRLJx3iCaVi2hOYhruOdolFyoDpc6Zll4EjL7wi9rX0dlDz0tJr
            KwbeT4icMOq8yyipndojPeWTvsh2+vUbM6MJRlGffMphqIS2CG66kBolk/+SfaCo
            +UoLJqTMkJFusTtiV8pN8bEVMSBhg4zBNh6XZQEX3kuR7WbyQLr3ZMiCqAKXHS/V
            08gXrUkvqWENBVgk+CG4yRyGLgJbSjSZy24aC+STYa49TpJggmjdLroxRQMrZveB
            l2qUVq3dwhjy8NK/sonSCXT4P0ILrJAK4vh6eDs9q4PUi9u8oFyudTWzvLWcvhUV
            gro1lLxvQD8EN5qRS/j1p8ANSMV2gU9M8BD4O5B+qAHe3dOZ+6Tmhz44Kivhle27
            /UOI/D9EkG2hYszNAdEQw/fzRgY6wJk366MOFtUd0mwJqSx/NAxsZsdndQmq3vP7
            dmidWXAX/CVZWOKsnYeYL5Ucb5gawcFZZTS2oqMCWNmCr/zpnj7t3hV0wamrqnyf
            N8zAuCuPlnwg9xTXvnMXcBX1GfuwxtZqFgOVBVokLkdMP3R7ojH1i3eSzuQaZmJH
            a5PKPgQ6bgjk/LSNSQlDJlpVIsrEmaN6b5BnIYtm2+0KV0fZbksmG6B4PC81Y+3S
            WwGc6VHopi1ktcapeJEK2e7EEu+tka98MQe/+dJQAQItLEnfFpscSG2Iiudi5wjO
            VF0YX1oP1M9q5uD9SbDepFYJ9VCtBGDCvHUcdAz3DW7s0Q6GCR7iCs0B/zo=
            =3DA+
            -----END PGP MESSAGE-----
          parameter:
            source: "header"
            name: "X-Hub-Signature"

