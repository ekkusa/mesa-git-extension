kind: cmake

depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/llvm.bst

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-cmake.bst
- freedesktop-sdk.bst:components/spirv-headers.bst

variables:
  cmake-local: >-
    -DBUILD_SHARED_LIBS=ON
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    -DCMAKE_SKIP_RPATH=ON
    -DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR="%{prefix}"

config:
  install-commands:
    (>):
    - install -Dm755 -t "%{install-root}%{bindir}" "%{build-dir}/tools/llvm-spirv/llvm-spirv"

sources:
- kind: git_tag
  # This needs to be in sync with LLVM version
  track: llvm_release_150
  track-tags: false
  url: github:KhronosGroup/SPIRV-LLVM-Translator.git
  ref: v15.0.0-49-g67f12d5a0ea61a8b577b2bc7ad80dcd99a8eb41c
  match:
  - v*
