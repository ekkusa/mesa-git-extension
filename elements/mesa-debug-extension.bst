kind: flatpak_image

build-depends:
- mesa.bst

(@):
- freedesktop-sdk.bst:elements/extensions/mesa/config.yml

config:
  include:
  - debug
  directory: "%{debugdir}%{prefix}"
  metadata:
    Runtime:
      name: org.freedesktop.Platform.GL.Debug.mesa-git
      runtime: org.freedesktop.Platform/x86_64/%{branch}
      sdk: org.freedesktop.Sdk/%{arch}/%{branch}
