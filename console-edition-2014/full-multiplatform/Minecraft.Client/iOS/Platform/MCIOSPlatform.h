#pragma once

#include <cstdint>
#include <string>
#include <unordered_map>

// Owns only platform lifecycle state.  It does not replace Minecraft's game
// loop or platform services with no-ops.
class MCIOSPlatform {
public:
    static MCIOSPlatform& shared();

    void launch();
    void suspend();
    void resume();
    void terminate();

    void updateTouch(std::uint64_t identifier, float x, float y, bool active);
    void controllerConnected();
    void controllerDisconnected();

    const std::string& saveDirectory() const;
    bool isActive() const;
    const std::string& sharedCoreBlocker() const;

private:
    struct TouchState {
        float x;
        float y;
    };

    MCIOSPlatform() = default;

    bool active_ = false;
    bool launched_ = false;
    bool controllerConnected_ = false;
    std::string saveDirectory_;
    std::string sharedCoreBlocker_;
    std::unordered_map<std::uint64_t, TouchState> activeTouches_;
};
