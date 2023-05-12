kind: flatpak_repo

build-depends:
- freedesktop-sdk.bst:components/flatpak-minimal.bst
- filename: flatpak-repo-deps.bst
  config:
    flatpak-stack: True

config:
  arch: "%{flatpak_arch}"
  repo-mode: archive
  branch: '%{branch}'

  (?):
  - target_arch == 'i686':
      copy-refs:
      - src: runtime/org.freedesktop.Platform.GL.mesa-git/%{flatpak_arch}/%{branch}
        dest: runtime/org.freedesktop.Platform.GL32.mesa-git/x86_64/%{branch}
      - src: runtime/org.freedesktop.Platform.GL.Debug.mesa-git/%{flatpak_arch}/%{branch}
        dest: runtime/org.freedesktop.Platform.GL32.Debug.mesa-git/x86_64/%{branch}
