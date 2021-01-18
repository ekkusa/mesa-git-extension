kind: junction

sources:
- kind: git_tag
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: 'master'
  track-tags: false
  submodules:
    utils/buildstream-abi-checker:
      url: gitlab:freedesktop-sdk/buildstream-abi-checker.git
      checkout: false
  ref: freedesktop-sdk-20.08rc.1-603-g065c14aa64fc178230125fbe727403a3737f1c22

config:
  options:
    bootstrap_build_arch: "%{arch}"
    target_arch: "%{arch}"
    (?):
    - target_arch == 'i686':
        bootstrap_build_arch: 'x86_64'
    - target_arch == 'arm':
        bootstrap_build_arch: 'aarch64'
