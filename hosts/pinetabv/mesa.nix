# Mesa для riscv64 без LLVM/clang/Rusticl: только softpipe (CPU-рендер).
# Цепочка clang -> gcc-16 для riscv64 не собирается (libgcc target.lo),
# а PowerVR в Mesa не поддерживается, поэтому 3D на GPU всё равно недоступен.
{ mesa }:
let
  noLlvm = p: !(builtins.elem (p.pname or p.name or "") [
    "clang-wrapper" "clang" "clang-unwrapped" "llvm" "libllvm"
    "SPIRV-LLVM-Translator" "rust-bindgen" "rust-cbindgen" "rustc"
  ]);
  openclLines = [
    "mkdir -p $opencl/etc/OpenCL/vendors/"
    "echo $opencl/lib/libRusticlOpenCL.so > $opencl/etc/OpenCL/vendors/rusticl.icd"
    ''moveToOutput "lib/lib*OpenCL*" $opencl''
    "moveToOutput bin/spirv2dxil $spirv2dxil"
    ''moveToOutput "lib/libspirv_to_dxil*" $spirv2dxil''
  ];
in
(mesa.override {
  galliumDrivers = [ "softpipe" ];
  vulkanDrivers = [ ];
}).overrideAttrs (old: {
  outputs = builtins.filter (o: !(builtins.elem o [ "opencl" "spirv2dxil" ])) old.outputs;
  mesonFlags = (old.mesonFlags or [ ]) ++ [
    "-Dgallium-rusticl=false"
    "-Dllvm=disabled"
    "-Dgallium-va=disabled"
  ];
  buildInputs = builtins.filter noLlvm (old.buildInputs or [ ]);
  nativeBuildInputs = builtins.filter noLlvm (old.nativeBuildInputs or [ ]);
  postFixup = builtins.replaceStrings
    [ " $opencl/lib/libRusticlOpenCL.so" ]
    [ "" ]
    old.postFixup;
  postInstall = builtins.replaceStrings openclLines (map (_: ":") openclLines) old.postInstall;
})
