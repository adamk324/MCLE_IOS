#import <MetalKit/MetalKit.h>

#import "MCGameViewController.h"
#import "../Platform/MCMetalRenderer.h"
#include "../Platform/MCIOSPlatform.h"

@implementation MCGameViewController {
    MCMetalRenderer* _renderer;
    UILabel* _statusLabel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blackColor;

    MTKView* metalView = [[MTKView alloc] initWithFrame:self.view.bounds];
    metalView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:metalView];
    _renderer = [[MCMetalRenderer alloc] initWithView:metalView];
    metalView.delegate = _renderer;

    _statusLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.view.bounds, 32.0, 32.0)];
    _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _statusLabel.numberOfLines = 0;
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.textColor = UIColor.whiteColor;
    _statusLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    _statusLabel.text = [NSString stringWithUTF8String:MCIOSPlatform::shared().sharedCoreBlocker().c_str()];
    [self.view addSubview:_statusLabel];
}

- (void)touchesBegan:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [self updateTouches:touches active:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [self updateTouches:touches active:YES];
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [self updateTouches:touches active:NO];
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch*>*)touches withEvent:(UIEvent*)event
{
    [self updateTouches:touches active:NO];
    [super touchesCancelled:touches withEvent:event];
}

- (void)updateTouches:(NSSet<UITouch*>*)touches active:(BOOL)active
{
    for (UITouch* touch in touches) {
        CGPoint point = [touch locationInView:self.view];
        MCIOSPlatform::shared().updateTouch(
            reinterpret_cast<std::uintptr_t>((__bridge void*)touch),
            point.x,
            point.y,
            active);
    }
}

@end
