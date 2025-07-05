struct ESPSettings {
    bool enabled = false;           // Master toggle for ESP On/Off
    bool showLineAndBox = true;     // Toggle for showing both Line and Box together
    bool showNames = true;          // Toggle for showing player names separately
};

ESPSettings espSettings;

void RenderESPMenu() {
    ImGui::Begin("ESP Menu");

    ImGui::Checkbox("ESP On/Off", &espSettings.enabled);

    ImGui::BeginDisabled(!espSettings.enabled);
    ImGui::Checkbox("Show Line & Box", &espSettings.showLineAndBox);
    ImGui::Checkbox("Show Names", &espSettings.showNames);
    ImGui::EndDisabled();

    ImGui::End();
}

void RenderESPForPlayer(Player player) {
    if (!espSettings.enabled) return;

    Vector headScreenPos, feetScreenPos;
    if (!WorldToScreen(player.headPosition, headScreenPos)) return;
    if (!WorldToScreen(player.feetPosition, feetScreenPos)) return;

    if (espSettings.showLineAndBox) {
        // Draw line from bottom center of screen to player's feet
        DrawLine(ScreenWidth / 2, ScreenHeight, feetScreenPos.x, feetScreenPos.y, Color::Red);

        // Draw bounding box around the player
        float boxHeight = feetScreenPos.y - headScreenPos.y;
        float boxWidth = boxHeight / 2.0f;
        DrawBox(headScreenPos.x - boxWidth / 2, headScreenPos.y, boxWidth, boxHeight, Color::Green);
    }

    if (espSettings.showNames) {
        // Draw player name centered above the head
        DrawTextCentered(player.name.c_str(), headScreenPos.x, headScreenPos.y - 15, Color::White);
    }
}