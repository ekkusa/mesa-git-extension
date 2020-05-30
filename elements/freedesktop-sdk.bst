kind: junction

sources:
- kind: git_tag
  url: gitlab:freedesktop-sdk/freedesktop-sdk.git
  track: '19.08'
  submodules:
    utils/buildstream-abi-checker:
      url: gitlab:freedesktop-sdk/buildstream-abi-checker.git
      checkout: False
  # Latest release version should be used to ensure efficient CAS
  # utilization even though we're only using it to get a shell, gcc and make. 
  ref: freedesktop-sdk-19.08.5-0-g3365dfefb4a2bbe89b6ad843280d165758b7223c

config:
  options:
    bootstrap_build_arch: "%{arch}"
    target_arch: "%{arch}"
    (?):
    - arch == 'i686':
        bootstrap_build_arch: 'x86_64'
    - arch == 'arm':
        bootstrap_build_arch: 'aarch64'
