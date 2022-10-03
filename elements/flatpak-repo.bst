kind: flatpak_repo

build-depends:
- freedesktop-sdk.bst:components/flatpak-minimal.bst
- filename: mesa-extension.bst
  config:
    flatpak-image: True

(@): elements/config.yml

config:
  arch: "%{flatpak_arch}"
  repo-mode: archive
  branch: '%{branch}'

  (?):
  - target_arch == 'i686':
      copy-refs:
      - src: runtime/org.freedesktop.Platform.GL.mesa-git/%{flatpak_arch}/%{branch}
        dest: runtime/org.freedesktop.Platform.GL32.mesa-git/x86_64/%{branch}
