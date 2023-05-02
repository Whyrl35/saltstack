---
wireguard:
  interfaces:
    wg0:
      Interface:
        ListenPort: 51820
        Address: 192.168.254.1/24
      Peers:
        FR-LAP10477:
          AllowedIPs: 192.168.254.5/32
          PublicKey: rjs9QaIRunHUfPLnKm0VAhdFjtLGLr2oIdeDufo7Wmw=
