kind: flatpak_repo

build-depends:
- freedesktop-sdk.bst:public-stacks/flatpak-publish-tools.bst
- mesa-extension.bst

config:
  arch: "%{arch}"
  repo-mode: archive
  branch: '%{branch}'
  environment:
  - public-stacks/flatpak-publish-tools.bst
