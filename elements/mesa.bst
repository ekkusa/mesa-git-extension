kind: meson

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/appstream-glib.bst
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:components/glslang.bst
- freedesktop-sdk.bst:components/llvm.bst
- freedesktop-sdk.bst:components/m4.bst
- freedesktop-sdk.bst:components/spirv-llvm-translator.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/python3-mako.bst
- freedesktop-sdk.bst:components/rust.bst
- freedesktop-sdk.bst:components/rust-bindgen.bst
- freedesktop-sdk.bst:components/spirv-tools.bst
- freedesktop-sdk.bst:components/vulkan-headers.bst
- freedesktop-sdk.bst:components/wayland-protocols.bst
- freedesktop-sdk.bst:components/zstd.bst


depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/libdrm.bst
- freedesktop-sdk.bst:components/libva.bst
- freedesktop-sdk.bst:components/opencl.bst
- freedesktop-sdk.bst:components/xorg-lib-xfixes.bst
- freedesktop-sdk.bst:components/xorg-lib-xrandr.bst
- freedesktop-sdk.bst:components/xorg-lib-xshmfence.bst
- freedesktop-sdk.bst:components/xorg-lib-xxf86vm.bst
- freedesktop-sdk.bst:components/vulkan-icd-loader.bst
- freedesktop-sdk.bst:components/wayland.bst
- freedesktop-sdk.bst:components/libglvnd.bst
- freedesktop-sdk.bst:components/libvdpau.bst
- freedesktop-sdk.bst:components/libunwind.bst
- freedesktop-sdk.bst:components/zstd.bst
- freedesktop-sdk.bst:extensions/mesa/libclc.bst
- freedesktop-sdk.bst:extensions/mesa/llvm.bst
- libdrm.bst


(@):
- freedesktop-sdk.bst:elements/extensions/mesa/config.yml

environment:
  PKG_CONFIG_PATH: "%{libdir}/pkgconfig:%{datadir}/pkgconfig"
  CXXFLAGS: "%{target_flags} -std=gnu++17"

variables:
  intel-clc: "disabled"

  (?):
  - target_arch == "i686" or target_arch == "x86_64":
      gallium_drivers: iris,crocus,nouveau,r300,r600,radeonsi,svga,swrast,virgl,zink,i915
      vulkan_drivers: amd,intel,intel_hasvk,swrast,virtio
      libunwind: enabled
      intel-rt: enabled
  - target_arch == "arm" or target_arch == "aarch64":
      gallium_drivers: asahi,etnaviv,freedreno,kmsro,lima,nouveau,panfrost,swrast,tegra,virgl,v3d,vc4,zink,r600,r300,radeonsi
      vulkan_drivers: freedreno,broadcom,panfrost,swrast,amd
      libunwind: disabled
      intel-rt: disabled
  - target_arch in ("ppc64le", "ppc64", "riscv64"):
      gallium_drivers: nouveau,r600,r300,radeonsi,swrast,virgl
      vulkan_drivers: amd
      libunwind: disabled
      intel-rt: disabled

  optimize-debug: "false"
  app-id: >-
    org.freedesktop.Platform.GL.mesa-git
    org.freedesktop.Platform.GL32.mesa-git

  meson-lto-flags: ''
  meson-local: >-
    -Db_ndebug=true
    -Ddri3=enabled
    -Degl=enabled
    -Dgallium-drivers=%{gallium_drivers}
    -Dgallium-nine=true
    -Dgallium-omx=disabled
    -Dgallium-rusticl=true
    -Dgallium-va=enabled
    -Dgallium-vdpau=enabled
    -Dgallium-xa=disabled
    -Dgbm=enabled
    -Dgbm-backends-path="/usr/lib/%{gcc_triplet}/GL/lib/gbm"
    -Dgles1=disabled
    -Dgles2=enabled
    -Dglvnd=true
    -Dglx=auto
    -Dlibunwind=%{libunwind}
    -Dllvm=enabled
    -Dlmsensors=disabled
    -Dmicrosoft-clc=disabled
    -Dandroid-libbacktrace=disabled
    -Dosmesa=false
    -Dplatforms=x11,wayland
    -Dselinux=false
    -Dshared-glapi=enabled
    -Dvalgrind=disabled
    -Dvulkan-layers=device-select,overlay
    -Dvulkan-drivers=%{vulkan_drivers}
    -Dvulkan-icd-dir="%{libdir}/vulkan/icd.d"
    -Dxlib-lease=enabled
    -Dzstd=enabled
    -Dvideo-codecs=h264dec,h264enc,h265dec,h265enc,vc1dec
    -Dintel-clc=%{intel-clc}
    -Drust_std=2021
    -Dintel-rt=%{intel-rt}

config:

  # Replicate meson subprojects download without internet.
  configure-commands:
    (<):
    - |
      cp subprojects/packagefiles/syn/* subprojects/syn-2.0.39
      cp subprojects/packagefiles/unicode-ident/* subprojects/unicode-ident-1.0.12
      cp subprojects/packagefiles/quote/* subprojects/quote-1.0.33
      cp subprojects/packagefiles/proc-macro2/* subprojects/proc-macro2-1.0.70

  install-commands:
    (>):
    - |
      set -e
      dest_dir=%{install-root}%{datadir}/appdata
      mkdir -p ${dest_dir}
      CURRENT_REF=$(git describe --match *branchpoint*)
      TIMESTAMP=$(git log -1 --format="%at" ${CURRENT_REF})
      VERSION_DATE=$(date -d @"$TIMESTAMP" -Idate)
      for app_id in %{app-id}
      do
        m4 -D__VERSION__=${CURRENT_REF} -D__VERSION_DATE__=${VERSION_DATE} \
        -D__APP_ID__=${app_id} \
        appdata.template > ${dest_dir}/${app_id}.appdata.xml
        appstream-compose --basename ${app_id} \
        --prefix=%{install-root}%{prefix} --origin=flatpak ${app_id}
      done

    - |
      mkdir -p "%{install-root}%{libdir}"
      mv "%{install-root}%{sysconfdir}/OpenCL" "%{install-root}%{libdir}/"
      ln -s libEGL_mesa.so.0 %{install-root}%{libdir}/libEGL_indirect.so.0
      ln -s libGLX_mesa.so.0 %{install-root}%{libdir}/libGLX_indirect.so.0
      rm -f "%{install-root}%{libdir}"/libGLESv2*
      rm -f "%{install-root}%{libdir}/libGLX_mesa.so"
      rm -f "%{install-root}%{libdir}/libEGL_mesa.so"
      rm -f "%{install-root}%{libdir}/libglapi.so"

    - |
      for dir in vdpau dri; do
        for file in "%{install-root}%{libdir}/${dir}/"*.so*; do
          soname="$(objdump -p "${file}" | sed "/ *SONAME */{;s///;q;};d")"
          if [ -L "${file}" ]; then
            continue
          fi
          if ! [ -f "%{install-root}%{libdir}/${dir}/${soname}" ]; then
            mv "${file}" "%{install-root}%{libdir}/${dir}/${soname}"
          else
            rm "${file}"
          fi
          ln -s "${soname}" "${file}"
        done
      done

    - |
      if [ -f "%{install-root}%{includedir}/vulkan/vulkan_intel.h" ]; then
        mkdir -p "%{install-root}%{includedir}/%{gcc_triplet}/vulkan"
        mv "%{install-root}%{includedir}/vulkan/vulkan_intel.h" "%{install-root}%{includedir}/%{gcc_triplet}/vulkan/"
      fi

    - |
      ln -sr '%{install-root}%{datadir}/glvnd' '%{install-root}%{prefix}/glvnd'
      mkdir -p '%{install-root}%{prefix}/vulkan'
      ln -sr '%{install-root}%{libdir}/vulkan/icd.d' '%{install-root}%{prefix}/vulkan/icd.d'
      ln -sr '%{install-root}%{datadir}/vulkan/explicit_layer.d' '%{install-root}%{prefix}/vulkan/explicit_layer.d'
      ln -sr '%{install-root}%{datadir}/vulkan/implicit_layer.d' '%{install-root}%{prefix}/vulkan/implicit_layer.d'
      ln -sr '%{install-root}%{libdir}/OpenCL' '%{install-root}%{prefix}/OpenCL'

public:
  bst:
    split-rules:
      devel:
        (>):
        - '%{libdir}/libgbm.so'
        - '%{libdir}/libglapi.so'
        - '%{libdir}/libwayland-egl.so'
        - '%{libdir}/libMesaOpenCL.so'
        - '%{libdir}/d3d/d3dadapter9.so'
  cpe:
    product: mesa
    vendor: mesa3d

sources:
- kind: git_repo
  url: freedesktop:mesa/mesa.git
  track: main
  ref: 24.0-branchpoint-3011-g493d5764e3e672ae86939dcaa918f844fcf5e0e4
- kind: patch
  path: patches/mesa/clang_res_path.patch
- kind: local
  path: files/mesa/appdata.template
# Rust dependencies:
- kind: tar
  directory: subprojects/syn-2.0.39
  url: https://crates.io/api/v1/crates/syn/2.0.39/download
  ref: 23e78b90f2fcf45d3e842032ce32e3f2d1545ba6636271dcbf24fa306d87be7a
- kind: tar
  directory: subprojects/unicode-ident-1.0.12
  url: https://crates.io/api/v1/crates/unicode-ident/1.0.12/download
  ref: 3354b9ac3fae1ff6755cb6db53683adb661634f67557942dea4facebec0fee4b
- kind: tar
  directory: subprojects/proc-macro2-1.0.70
  url: https://crates.io/api/v1/crates/proc-macro2/1.0.70/download
  ref: 39278fbbf5fb4f646ce651690877f89d1c5811a3d4acb27700c1cb3cdb78fd3b
- kind: tar
  directory: subprojects/quote-1.0.33
  url: https://crates.io/api/v1/crates/quote/1.0.33/download
  ref: 5267fca4496028628a95160fc423a33e8b2e6af8a5302579e322e4b520293cae
