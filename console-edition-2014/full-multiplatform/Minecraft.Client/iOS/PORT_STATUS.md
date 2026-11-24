# Minecraft.Client iOS port status

## Verified shared initialization path

`Windows64_Minecraft.cpp::WinMain` performs platform startup, then calls
`Minecraft::main`.  The common path is:

```text
Minecraft::main
  -> MinecraftWorld_RunStaticCtors
  -> entity/tile/user/tutorial/UI static constructors
  -> Minecraft::start
  -> Minecraft::startAndConnectTo
  -> Minecraft::run
```

The iOS application must complete renderer/UI, input, profile/storage,
networking, and per-thread pool setup before entering that sequence.  Merely
using UIKit's `UIApplicationMain` is insufficient.

## Reuse boundary

Reusable source roots are `Minecraft.World` and the platform-neutral files in
`Minecraft.Client`.  `SharedCoreSources.cmake` inventories those real sources
and excludes Windows64, Xbox, Durango, PS3, Orbis, and Vita implementations.

| System | Existing implementation | iOS work required |
| --- | --- | --- |
| Entry/lifecycle | `Windows64_Minecraft.cpp` / `WinMain` | UIKit lifecycle, suspend/resume coordination |
| World/client core | `Minecraft.World`, `Minecraft.cpp` | Windows compatibility and threading adaptation |
| Rendering | D3D11 `C4JRender`, D3D11 Iggy backend | Metal `C4JRender` and Iggy-compatible backend |
| Audio | Miles calls in `Common/Audio/SoundEngine.cpp` | Audio abstraction plus AVAudioEngine backend |
| Input | 4J input + XInput mappings | UIKit touch translator and GameController adapter |
| Storage | 4J storage manager | Application Support-backed save implementation |
| Networking | common socket and stub platform manager | POSIX/BSD socket validation, iOS lifecycle handling |

## Current milestone

Milestone 1 is implemented only: a native arm64 UIKit target creates a real
Metal device/command queue, an iOS Application Support save directory, and
captures UIKit touch and controller connection events.  It explicitly reports
that shared-core boot is blocked; it does **not** report a Minecraft launch,
main menu, renderer, gameplay, input, or audio milestone.

## Current blockers

1. Shared headers depend on Win32 types, TLS, synchronization, and threads.
2. `C4JRender` and Iggy are D3D11-coupled; no Metal implementation exists.
3. The repository contains no iOS Miles library.  The 133-byte Windows
   `mss64.lib` is invalid, and it cannot be reused on iOS.
4. 4J profile/storage/render/input libraries have only console/Windows binary
   variants, so their iOS implementations must be ported rather than stubbed.
