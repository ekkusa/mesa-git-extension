kind: flatpak_repo

build-depends:
- freedesktop-sdk.bst:components/flatpak.bst
- mesa-extension.bst

config:
  arch: "%{flatpak_arch}"
  repo-mode: archive
  branch: '%{branch}'
  environment:
  - components/flatpak.bst
  (?):
  - target_arch == 'i686':
      copy-refs:
      - src: runtime/org.freedesktop.Platform.GL.mesa-git/%{flatpak_arch}/%{branch}
        dest: runtime/org.freedesktop.Platform.GL32.mesa-git/x86_64/%{branch}
