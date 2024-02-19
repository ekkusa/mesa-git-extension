kind: pyproject

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-python-setuptools.bst

depends:
- freedesktop-sdk.bst:components/python3.bst

sources:
- kind: git_repo
  url: github:dabeaz/ply.git
  track: '*.*'
  ref: 3.11-0-g0f398b72618c1564d71f7dc0558e6722b241875a
