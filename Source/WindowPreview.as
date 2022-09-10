namespace Window::Preview
{
	bool Checked = true;
	float SliderValue = 10.0f;
	string TextValue = "Hello, world!";

	void Render()
	{
		for (uint i = 0; i < Window::Create::Vars.Length; i++) {
			Window::Create::Vars[i].Push();
		}
		for (uint i = 0; i < Window::Create::Colors.Length; i++) {
			UI::PushStyleColor(UI::Col(i), Window::Create::Colors[i]);
		}

		bool open = true;
		if (UI::Begin(Icons::PaintBrush + " Style Creation Preview###StyleCreationPreview", open, UI::WindowFlags::MenuBar)) {
			if (UI::BeginMenuBar()) {
				if (UI::BeginMenu("File")) {
					UI::MenuItem(Icons::FileO + " New", "Ctrl + N");
					UI::MenuItem(Icons::Folder + " Open..", "Ctrl + O");
					UI::Separator();
					UI::MenuItem("Preferences");
					UI::MenuItem("Quit", "Ctrl + Q");
					UI::EndMenu();
				}
				if (UI::BeginMenu("Edit")) {
					UI::MenuItem("Copy");
					UI::MenuItem("Paste");
					UI::MenuItem("Enabled", "", true);
					UI::EndMenu();
				}
				UI::EndMenuBar();
			}

			UI::Text("Text");
			UI::TextDisabled("TextDisabled");
			if (UI::BeginChild("Child", vec2(0, 85), true)) {
				UI::Text("Scrollable child contents");
				for (int i = 2; i <= 10; i++) {
					UI::Text("Line " + i + "..");
				}
			}
			UI::EndChild();
			UI::Separator();
			UI::Text("Hover over me");
			if (UI::IsItemHovered()) {
				UI::BeginTooltip();
				UI::Text("Tooltip!");
				UI::EndTooltip();
			}
			Checked = UI::Checkbox("Checkbox", Checked);
			if (UI::RadioButton("Radio button", Checked)) {
				Checked = true;
			}
			SliderValue = UI::SliderFloat("Slider", SliderValue, 0, 20);

			UI::Button("Button");
			UI::SameLine();
			UI::Button("Button");
			UI::SameLine();
			UI::Button("Button");

			UI::BeginTabBar("Tabs");
			if (UI::BeginTabItem("First tab")) { UI::EndTabItem(); }
			if (UI::BeginTabItem("Second tab")) { UI::EndTabItem(); }
			UI::EndTabBar();

			UI::PlotLines("Line plot", { 0, 1, 2, 3, 4, 5, 6, 4, 5, 6, 1, 2, 3 });
			UI::PlotHistogram("Histogram", { 0, 1, 2, 3, 4, 5, 6, 4, 5, 6, 1, 2, 3 });

			if (UI::BeginTable("Table", 3, UI::TableFlags::Borders | UI::TableFlags::RowBg)) {
				UI::TableSetupColumn("ID", UI::TableColumnFlags::WidthStretch, 0.2f);
				UI::TableSetupColumn("Name", UI::TableColumnFlags::WidthStretch, 0.4f);
				UI::TableSetupColumn("Author", UI::TableColumnFlags::WidthStretch, 0.4f);
				UI::TableHeadersRow();

				UI::TableNextColumn();
				UI::Text("1");
				UI::TableNextColumn();
				UI::Text("Dashboard");
				UI::TableNextColumn();
				UI::Text("Miss");

				UI::TableNextColumn();
				UI::Text("2");
				UI::TableNextColumn();
				UI::Text("Ultimate Medals");
				UI::TableNextColumn();
				UI::Text("Phlarx");

				UI::EndTable();
			}

			TextValue = UI::InputText("Text", TextValue);
		}
		UI::End();

		UI::PopStyleColor(int(Window::Create::Colors.Length));
		UI::PopStyleVar(int(Window::Create::Vars.Length));
	}
}
