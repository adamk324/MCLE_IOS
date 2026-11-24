#import "MCMetalRenderer.h"

@implementation MCMetalRenderer {
    id<MTLCommandQueue> _commandQueue;
}

- (instancetype)initWithView:(MTKView*)view
{
    self = [super init];
    if (self) {
        view.device = MTLCreateSystemDefaultDevice();
        NSAssert(view.device, @"Metal is required by the iOS target");
        _commandQueue = [view.device newCommandQueue];
        NSAssert(_commandQueue, @"Unable to create the Metal command queue");
        view.colorPixelFormat = MTLPixelFormatBGRA8Unorm;
        view.depthStencilPixelFormat = MTLPixelFormatDepth32Float;
        view.paused = NO;
        view.enableSetNeedsDisplay = NO;
    }
    return self;
}

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size
{
    (void)view;
    (void)size;
}

- (void)drawInMTKView:(MTKView*)view
{
    // Present a real Metal drawable while the C4JRender Metal backend is
    // under construction.  No game scene is submitted here.
    MTLRenderPassDescriptor* pass = view.currentRenderPassDescriptor;
    id<CAMetalDrawable> drawable = view.currentDrawable;
    if (!pass || !drawable)
        return;

    pass.colorAttachments[0].clearColor = MTLClearColorMake(0.04, 0.05, 0.08, 1.0);
    pass.colorAttachments[0].loadAction = MTLLoadActionClear;
    id<MTLCommandBuffer> commandBuffer = [_commandQueue commandBuffer];
    id<MTLRenderCommandEncoder> encoder = [commandBuffer renderCommandEncoderWithDescriptor:pass];
    [encoder endEncoding];
    [commandBuffer presentDrawable:drawable];
    [commandBuffer commit];
}

@end
