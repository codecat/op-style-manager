namespace Window
{
	bool Visible = true;

	void Render()
	{
		if (!Visible) {
			return;
		}

		bool createOpen = false;

		UI::SetNextWindowSize(750, 500, UI::Cond::FirstUseEver);
		int windowFlags = UI::WindowFlags::NoCollapse;
		if (UI::Begin(Icons::PaintBrush + " Overlay Style Manager###OverlayStyleManager", Visible, windowFlags)) {
			UI::BeginTabBar("Tabs");

			if (UI::BeginTabItem(Icons::List + " Index")) {
				if (UI::BeginChild("Index")) {
					Window::Index::Render();
					UI::EndChild();
				}
				UI::EndTabItem();
			}

			if (UI::BeginTabItem(Icons::PaintBrush + " Create")) {
				if (UI::BeginChild("Create")) {
					createOpen = true;
					Window::Create::Render();
					UI::EndChild();
				}
				UI::EndTabItem();
			}

			UI::EndTabBar();
		}
		UI::End();

		if (createOpen) {
			Window::Preview::Render();
		}
	}
}
