namespace Window
{
	bool Visible = false;

	void Render()
	{
		if (!Visible) {
			return;
		}

		bool previewOpen = false;

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
					previewOpen = true;
					Window::Create::Render();
					UI::EndChild();
				}
				UI::EndTabItem();
			}

			UI::EndTabBar();
		}
		UI::End();

		if (previewOpen) {
			Window::Preview::Render();
		}
	}
}
