struct ESPSettings {
    bool enabled = false;           // On/Off tổng
    bool showLineAndBox = true;     // Line + Box gộp chung
    bool showNames = true;          // Tên riêng
};

ESPSettings espMenu;

void RenderESPMenu() {
    ImGui::Begin("ESP Menu");

    ImGui::Checkbox("ESP On/Off", &espMenu.enabled);

    ImGui::BeginDisabled(!espMenu.enabled);
    ImGui::Checkbox("Show Line & Box", &espMenu.showLineAndBox);
    ImGui::Checkbox("Show Names", &espMenu.showNames);
    ImGui::EndDisabled();

    ImGui::End();
}

void RenderESPForPlayer(Player player) {
    if (!espMenu.enabled) return;

    Vector headScreen, feetScreen;
    if (!WorldToScreen(player.headPosition, headScreen)) return;
    if (!WorldToScreen(player.feetPosition, feetScreen)) return;

    if (espMenu.showLineAndBox) {
        // Vẽ line
        DrawLine(ScreenWidth / 2, ScreenHeight, feetScreen.x, feetScreen.y, Color::Red);

        // Vẽ box
        float height = feetScreen.y - headScreen.y;
        float width = height / 2.0f;
        DrawBox(headScreen.x - width / 2, headScreen.y, width, height, Color::Green);
    }

    if (espMenu.showNames) {
        DrawTextCentered(player.name.c_str(), headScreen.x, headScreen.y - 15, Color::White);
    }
}