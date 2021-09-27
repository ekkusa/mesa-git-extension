kind: meson

depends:
- freedesktop-sdk.bst:bootstrap-import.bst
- freedesktop-sdk.bst:components/glslang.bst
- freedesktop-sdk.bst:components/m4.bst
- freedesktop-sdk.bst:components/appstream-glib.bst
- freedesktop-sdk.bst:components/llvm.bst
- freedesktop-sdk.bst:components/libdrm.bst
- freedesktop-sdk.bst:components/libglvnd.bst
- freedesktop-sdk.bst:components/libunwind.bst
- freedesktop-sdk.bst:components/libva.bst
- freedesktop-sdk.bst:components/libvdpau.bst
- freedesktop-sdk.bst:components/opencl.bst
- freedesktop-sdk.bst:components/wayland.bst
- freedesktop-sdk.bst:components/xorg-lib-xdamage.bst
- freedesktop-sdk.bst:components/xorg-lib-xfixes.bst
- freedesktop-sdk.bst:components/xorg-lib-xrandr.bst
- freedesktop-sdk.bst:components/xorg-lib-xshmfence.bst
- freedesktop-sdk.bst:components/xorg-lib-xxf86vm.bst
- freedesktop-sdk.bst:extensions/mesa/libclc.bst
- freedesktop-sdk.bst:extensions/mesa/libdrm.bst

build-depends:
- freedesktop-sdk.bst:public-stacks/buildsystem-meson.bst
- freedesktop-sdk.bst:components/bison.bst
- freedesktop-sdk.bst:components/flex.bst
- freedesktop-sdk.bst:components/python3.bst
- freedesktop-sdk.bst:components/python3-mako.bst
- freedesktop-sdk.bst:components/wayland-protocols.bst

environment:
  PKG_CONFIG_PATH: "%{libdir}/pkgconfig:%{datadir}/pkgconfig"
  CXXFLAGS: "%{target_flags} -std=gnu++17"

variables:
  lib: "lib"
  debugdir: "/usr/lib/debug"

  (?):
  - target_arch == "i686" or target_arch == "x86_64":
      gallium_drivers: iris,nouveau,r300,r600,radeonsi,svga,swrast,virgl
      dri_drivers: i915,i965,nouveau,r100,r200
      vulkan_drivers: amd,intel
      enable_libunwind: 'true'
  - target_arch == "arm" or target_arch == "aarch64":
      gallium_drivers: etnaviv,freedreno,kmsro,lima,nouveau,panfrost,swrast,tegra,virgl,v3d,vc4
      dri_drivers: ''
      vulkan_drivers: ''
      enable_libunwind: 'false'
  - target_arch == "powerpc64le":
      gallium_drivers: nouveau,r600,r300,radeonsi,swrast,virgl
      dri_drivers: r100,r200,nouveau
      vulkan_drivers: amd
      enable_libunwind: 'false'

  optimize-debug: "false"
  app-id: org.freedesktop.Platform.GL.mesa-git
  appstream-xml: "%{app-id}.appdata.xml"


  meson-local: >-
    -Db_ndebug=true
    -Ddri3=true
    -Ddri-drivers=%{dri_drivers}
    -Degl=true
    -Dgallium-drivers=%{gallium_drivers}
    -Dgallium-nine=true
    -Dgallium-omx=disabled
    -Dgallium-opencl=icd
    -Dgallium-va=true
    -Dgallium-vdpau=true
    -Dgallium-xa=false
    -Dgallium-xvmc=false
    -Dgbm=true
    -Dgles1=false
    -Dgles2=true
    -Dglvnd=true
    -Dglx=auto
    -Dlibunwind=%{enable_libunwind}
    -Dllvm=true
    -Dlmsensors=false
    -Dosmesa=false
    -Dplatforms=x11,wayland
    -Dselinux=false
    -Dshared-glapi=true
    -Dvalgrind=false
    -Dvulkan-overlay-layer=true
    -Dvulkan-drivers=%{vulkan_drivers}
    -Dvulkan-icd-dir="%{libdir}/vulkan/icd.d"
    -Dxlib-lease=true
    -Dmicrosoft-clc=disabled

config:
  build-commands:
    (>):
    - |
      set -e
      CURRENT_REF=$(git describe --match *branchpoint*)
      TIMESTAMP=$(git log -1 --format="%at" ${CURRENT_REF})
      VERSION_DATE=$(date -d @"$TIMESTAMP" -Idate)
      m4 -D__VERSION__=${CURRENT_REF} -D__VERSION_DATE__=${VERSION_DATE} \
      %{appstream-xml}.in > %{appstream-xml}

  install-commands:
    (>):
    - |
      mkdir -p %{install-root}%{datadir}/appdata
      install %{appstream-xml} %{install-root}%{datadir}/appdata
      appstream-compose --basename=%{app-id} --prefix=%{install-root}%{prefix} \
      --origin=flatpak %{app-id}

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

sources:
- kind: git_tag
  url: freedesktop:mesa/mesa.git
  ref: master
- kind: local
  path: files/mesa/org.freedesktop.Platform.GL.mesa-git.appdata.xml.in
- kind: patch
  path: patches/mesa/mesa_libdrm_deps.patch
