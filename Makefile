ARCH?=$(shell uname -m | sed "s/^i.86$$/i686/" | sed "s/^ppc/powerpc/")
REPO?=repo
ARCH_OPTS=-o target_arch $(ARCH)
BST=bst $(ARCH_OPTS)

build: elements
	$(BST) build flatpak-repo.bst

clean-repo:
	rm -rf $(REPO)

export-repo: clean-repo build
	$(BST) artifact checkout flatpak-repo.bst --directory $(REPO)

.PHONY: build clean-repo export
