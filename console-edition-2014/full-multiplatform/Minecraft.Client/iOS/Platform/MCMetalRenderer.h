#pragma once

#import <MetalKit/MetalKit.h>

// This owns an actual Metal device and command queue.  It is intentionally
// separate from the future C4JRender Metal backend; it does not emulate the
// D3D11/Iggy renderer or claim to render Minecraft content.
@interface MCMetalRenderer : NSObject <MTKViewDelegate>
- (instancetype)initWithView:(MTKView*)view;
@end
