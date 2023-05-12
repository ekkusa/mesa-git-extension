kind: flatpak_image

build-depends:
- mesa.bst

config:
  include:
  - runtime
  exclude:
  - debug
  - devel
  directory: "%{prefix}"
  metadata:
    Runtime:
      name: org.freedesktop.Platform.GL.mesa-git
      runtime: org.freedesktop.Platform/x86_64/%{branch}
      sdk: org.freedesktop.Sdk/%{arch}/%{branch}
