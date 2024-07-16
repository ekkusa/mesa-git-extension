ARCH?=$(shell uname -m | sed "s/^i.86$$/i686/" | sed "s/^ppc/powerpc/")
REPO?=repo
ARCH_OPTS=-o target_arch $(ARCH)
BST=bst $(ARCH_OPTS)
CHECKOUT_ROOT=runtimes

build: elements
	$(BST) build flatpak-repo.bst

clean-repo:
	rm -rf $(REPO)

export-repo: clean-repo build
	mkdir -p $(CHECKOUT_ROOT)
	$(BST) artifact checkout flatpak-repo.bst --directory $(CHECKOUT_ROOT)/flatpak-repo.bst
	test -e $(REPO) || ostree init --repo=$(REPO) --mode=archive
	flatpak build-commit-from --src-repo=$(CHECKOUT_ROOT)/flatpak-repo.bst --subject $(GIT_DESCRIBE) $(REPO)
	rm -rf $(CHECKOUT_ROOT)/flatpak-repo.bst

.PHONY: build clean-repo export
