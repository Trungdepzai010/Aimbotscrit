#include "imgui.h"
#include <string>
#include <chrono>

// ==== Struct settings ====

struct ESPSettings {
    bool lineESP = false;
    bool boxESP = false;
    bool espName = false;
};

struct MainSettings {
    bool flingEnabled = false;
    bool noclipEnabled = false;
    bool flyEnabled = false;
    float flySpeed = 10.0f;
    float aimFOV = 90.0f;

    bool hitboxEnabled = false;
    float hitboxSize = 5.0f;
};

struct PlayerSettings {
    bool godmode = false;
    float moveSpeed = 1.0f;
    float jumpHeight = 1.0f;
};

struct OtherSettings {
    bool showFPS = true;
    bool crosshair = false;
    bool nightMode = false;
    bool antiAFK = false;
};

struct UserSettings {
    char nickname[32] = "Player";
    bool useCustomName = false;
    char customName[32] = "";

    uint32_t playTimeSeconds = 0;
};

ESPSettings esp;
MainSettings mainMenu;
PlayerSettings player;
OtherSettings other;
UserSettings user;

// ==== Playtime update ====

auto lastUpdateTime = std::chrono::steady_clock::now();

void UpdatePlayTime() {
    auto now = std::chrono::steady_clock::now();
    auto elapsed = std::chrono::duration_cast<std::chrono::seconds>(now - lastUpdateTime).count();
    if (elapsed >= 1) {
        user.playTimeSeconds += elapsed;
        lastUpdateTime = now;
    }
}

std::string FormatPlayTime(uint32_t seconds) {
    uint32_t h = seconds / 3600;
    uint32_t m = (seconds % 3600) / 60;
    uint32_t s = seconds % 60;
    char buffer[16];
    snprintf(buffer, sizeof(buffer), "%02u:%02u:%02u", h, m, s);
    return std::string(buffer);
}

// ==== Menu rendering ====

void RenderESPMenu() {
    ImGui::Begin("ESP");

    ImGui::Checkbox("Line ESP", &esp.lineESP);
    ImGui::Checkbox("Box ESP", &esp.boxESP);
    ImGui::Checkbox("Show ESP Name", &esp.espName);

    ImGui::End();
}

void KillAllEnemies(); // Prototype for KillAll

void RenderMainMenu() {
    ImGui::Begin("trungdz");

    ImGui::Text("Main Features");

    ImGui::Checkbox("Enable Fling", &mainMenu.flingEnabled);
    ImGui::Checkbox("Enable NoClip", &mainMenu.noclipEnabled);

    ImGui::Separator();

    ImGui::Checkbox("Enable Fly", &mainMenu.flyEnabled);
    if (mainMenu.flyEnabled) {
        ImGui::SliderFloat("Fly Speed", &mainMenu.flySpeed, 1.0f, 100.0f, "%.0f");
    }

    ImGui::Separator();

    ImGui::SliderFloat("Aim FOV", &mainMenu.aimFOV, 10.0f, 360.0f, "%.0f");

    ImGui::Separator();

    ImGui::Checkbox("Enable Hitbox", &mainMenu.hitboxEnabled);
    if (mainMenu.hitboxEnabled) {
        ImGui::SliderFloat("Hitbox Size", &mainMenu.hitboxSize, 5.0f, 50.0f, "%.2f");
    }

    ImGui::Separator();

    if (ImGui::Button("Kill All")) {
        KillAllEnemies();
    }

    ImGui::End();
}

void RenderPlayerMenu() {
    ImGui::Begin("Player");

    ImGui::Checkbox("Godmode", &player.godmode);
    ImGui::SliderFloat("Move Speed", &player.moveSpeed, 1.0f, 10.0f, "%.1f");
    ImGui::SliderFloat("Jump Height", &player.jumpHeight, 1.0f, 10.0f, "%.1f");

    ImGui::End();
}

void RenderOtherMenu() {
    ImGui::Begin("Other");

    ImGui::Checkbox("Show FPS", &other.showFPS);
    ImGui::Checkbox("Crosshair", &other.crosshair);
    ImGui::Checkbox("Night Mode", &other.nightMode);
    ImGui::Checkbox("Anti-AFK", &other.antiAFK);

    ImGui::End();
}

void RenderUserMenu() {
    ImGui::Begin("User");

    ImGui::InputText("Nickname", user.nickname, IM_ARRAYSIZE(user.nickname));
    ImGui::Checkbox("Use Custom Name", &user.useCustomName);
    if (user.useCustomName) {
        ImGui::InputText("Custom Name", user.customName, IM_ARRAYSIZE(user.customName));
    }

    std::string timeStr = FormatPlayTime(user.playTimeSeconds);
    ImGui::Text("Playtime: %s", timeStr.c_str());

    if (ImGui::Button("Reset Playtime")) {
        user.playTimeSeconds = 0;
    }

    ImGui::End();
}

// ==== Example KillAllEnemies function (to implement as per game) ====

void KillAllEnemies() {
    // TODO: Implement game-specific logic here
    // For example: iterate all enemies and set health = 0
}

// ==== Main render loop ====

void RenderMenu() {
    UpdatePlayTime();

    // You can use tab bar or render menus separately
    ImGui::Begin("trungdz Menu");

    if (ImGui::BeginTabBar("MainTabs")) {
        if (ImGui::BeginTabItem("ESP")) {
            RenderESPMenu();
            ImGui::EndTabItem();
        }
        if (ImGui::BeginTabItem("Main")) {
            RenderMainMenu();
            ImGui::EndTabItem();
        }
        if (ImGui::BeginTabItem("Player")) {
            RenderPlayerMenu();
            ImGui::EndTabItem();
        }
        if (ImGui::BeginTabItem("Other")) {
            RenderOtherMenu();
            ImGui::EndTabItem();
        }
        if (ImGui::BeginTabItem("User")) {
            RenderUserMenu();
            ImGui::EndTabItem();
        }
        ImGui::EndTabBar();
    }

    ImGui::End();
}