#import <Foundation/Foundation.h>
#import <GameController/GameController.h>

#include "MCIOSPlatform.h"

MCIOSPlatform& MCIOSPlatform::shared()
{
    static MCIOSPlatform platform;
    return platform;
}

void MCIOSPlatform::launch()
{
    if (launched_)
        return;

    NSArray<NSURL*>* directories = [[NSFileManager defaultManager]
        URLsForDirectory:NSApplicationSupportDirectory
        inDomains:NSUserDomainMask];
    NSURL* root = directories.firstObject;
    NSURL* saveRoot = [root URLByAppendingPathComponent:@"MinecraftClient" isDirectory:YES];
    NSError* error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtURL:saveRoot
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error]) {
        sharedCoreBlocker_ = "Unable to create the iOS Application Support save directory.";
        return;
    }

    saveDirectory_ = saveRoot.path.UTF8String;
    active_ = true;
    launched_ = true;

    // This must remain explicit until the source inventory builds as a real
    // library.  The host never reports a game boot that did not occur.
    sharedCoreBlocker_ =
        "Shared Minecraft.Client/Minecraft.World initialization is blocked by "
        "the unported Windows compatibility, D3D11/Iggy, and Miles layers.";
}

void MCIOSPlatform::suspend() { active_ = false; }
void MCIOSPlatform::resume() { active_ = true; }
void MCIOSPlatform::terminate() { active_ = false; }

void MCIOSPlatform::updateTouch(std::uint64_t identifier, float x, float y, bool active)
{
    if (active) {
        activeTouches_[identifier] = {x, y};
    } else {
        activeTouches_.erase(identifier);
    }
}

void MCIOSPlatform::controllerConnected() { controllerConnected_ = true; }
void MCIOSPlatform::controllerDisconnected() { controllerConnected_ = false; }

const std::string& MCIOSPlatform::saveDirectory() const { return saveDirectory_; }
bool MCIOSPlatform::isActive() const { return active_; }
const std::string& MCIOSPlatform::sharedCoreBlocker() const { return sharedCoreBlocker_; }
