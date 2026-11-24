# Minecraft Console Edition — iOS 15 port

This directory contains the original multi-platform Minecraft Console Edition
source archive and the in-progress native iOS port of **Minecraft.Client**.
`Minecraft.World` remains a required engine library; it is not the final iOS
product.

## Current status

The original Windows x64 client and `Minecraft.World` compile with the legacy
toolchain, but the final Windows link is blocked by the supplied 133-byte
`mss64.lib` Miles artifact. The iOS work is isolated in
[`Minecraft.Client/iOS`](Minecraft.Client/iOS): it has an arm64 UIKit/Metal
host, an iOS 15.0 deployment target, durable Application Support storage, and
a GitHub Actions build definition for Xcode 16.4.

The host does **not** claim to run the game yet. The shared
`Minecraft.Client`/`Minecraft.World` source inventory is preserved for the
next integration stage. Current blockers are the Win32 compatibility surface,
the D3D11/Iggy rendering backend, and the absence of an iOS Miles library.

## Build the iOS host

On macOS with Xcode 16.4:

```sh
cmake -S Minecraft.Client/iOS -B build-ios -G Xcode \
  -DCMAKE_OSX_SYSROOT=iphoneos \
  -DCMAKE_OSX_DEPLOYMENT_TARGET=15.0 \
  -DCMAKE_OSX_ARCHITECTURES=arm64
cmake --build build-ios --config Debug -- CODE_SIGNING_ALLOWED=NO
```

This builds the host foundation only. Its in-app diagnostic deliberately
states that shared-game initialization is pending; it is not a main menu or a
substitute implementation of Minecraft.

See [`Minecraft.Client/iOS/PORT_STATUS.md`](Minecraft.Client/iOS/PORT_STATUS.md)
for the verified initialization path, source boundary, and current milestones.
