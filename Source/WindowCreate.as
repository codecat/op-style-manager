namespace Window::Create
{
	class @StyleVar
	{
		UI::StyleVar m_var;
		string m_name;

		StyleVar(UI::StyleVar var)
		{
			m_var = var;
			m_name = tostring(var);
		}

		bool ShouldSerialize() { return false; }
		string Serialize() { return ""; }
		void FromCurrent() {}
		void Reset() {}
		void Push() {}
		void Render() {}
	}

	class @FloatStyleVar : StyleVar
	{
		float m_def;
		float m_value;
		float m_step = 1.0f;

		FloatStyleVar(UI::StyleVar var, float def)
		{
			super(var);
			m_value = m_def = def;

			switch (var) {
				case UI::StyleVar::Alpha:
					m_step = 0.05f;
					break;
			}
		}

		bool ShouldSerialize() override { return m_value != m_def; }
		string Serialize() override { return Text::Format("%g", m_value); }
		void FromCurrent() override { m_value = UI::GetStyleVarFloat(m_var); }
		void Reset() override { m_value = m_def; }
		void Push() override { UI::PushStyleVar(m_var, m_value); }
		void Render() override { m_value = UI::InputFloat(m_name, m_value, m_step); }
	}

	class @Vec2StyleVar : StyleVar
	{
		vec2 m_def;
		vec2 m_value;

		Vec2StyleVar(UI::StyleVar var, const vec2 &in def)
		{
			super(var);
			m_value = m_def = def;
		}

		bool ShouldSerialize() override { return m_value.x != m_def.x || m_value.y != m_def.y; }
		string Serialize() override { return "[ " + Text::Format("%g", m_value.x) + ", " + Text::Format("%g", m_value.y) + " ]"; }
		void FromCurrent() override { m_value = UI::GetStyleVarVec2(m_var); }
		void Reset() override { m_value = m_def; }
		void Push() override { UI::PushStyleVar(m_var, m_value); }
		void Render() override { m_value = UI::InputFloat2(m_name, m_value); }
	}

	array<vec4> DefaultColors = {
		Text::ParseHexColor("#FFFFFF"),   // Text
		Text::ParseHexColor("#656565"),   // TextDisabled
		Text::ParseHexColor("#0F0F0FF7"), // WindowBg
		Text::ParseHexColor("#FFFFFF00"), // ChildBg
		Text::ParseHexColor("#232323F7"), // PopupBg
		Text::ParseHexColor("#AAAAAA00"), // Border
		Text::ParseHexColor("#00000018"), // BorderShadow
		Text::ParseHexColor("#000000EA"), // FrameBg
		Text::ParseHexColor("#4296F963"), // FrameBgHovered
		Text::ParseHexColor("#4296F9A7"), // FrameBgActive
		Text::ParseHexColor("#0A0A0A"),   // TitleBg
		Text::ParseHexColor("#2D2D2D"),   // TitleBgActive
		Text::ParseHexColor("#0000007F"), // TitleBgCollapsed
		Text::ParseHexColor("#232323"),   // MenuBarBg
		Text::ParseHexColor("#05050584"), // ScrollbarBg
		Text::ParseHexColor("#4F4F4F"),   // ScrollbarGrab
		Text::ParseHexColor("#686868"),   // ScrollbarGrabHovered
		Text::ParseHexColor("#828282"),   // ScrollbarGrabActive
		Text::ParseHexColor("#4296F9"),   // CheckMark
		Text::ParseHexColor("#3D84E0"),   // SliderGrab
		Text::ParseHexColor("#4296F9"),   // SliderGrabActive
		Text::ParseHexColor("#4296F963"), // Button
		Text::ParseHexColor("#4296F9"),   // ButtonHovered
		Text::ParseHexColor("#0F87F9"),   // ButtonActive
		Text::ParseHexColor("#4296F94D"), // Header
		Text::ParseHexColor("#4296F9C7"), // HeaderHovered
		Text::ParseHexColor("#4296F9"),   // HeaderActive
		Text::ParseHexColor("#9B9B9B"),   // Separator
		Text::ParseHexColor("#4296F9C2"), // SeparatorHovered
		Text::ParseHexColor("#4296F9"),   // SeparatorActive
		Text::ParseHexColor("#0000007C"), // ResizeGrip
		Text::ParseHexColor("#4296F9A7"), // ResizeGripHovered
		Text::ParseHexColor("#4296F9ED"), // ResizeGripActive
		Text::ParseHexColor("#2D5993D7"), // Tab
		Text::ParseHexColor("#4296F9C7"), // TabHovered
		Text::ParseHexColor("#3268AD"),   // TabActive
		Text::ParseHexColor("#111A25F3"), // TabUnfocused
		Text::ParseHexColor("#22426C"),   // TabUnfocusedActive
		Text::ParseHexColor("#4296F9AE"), // DockingPreview
		Text::ParseHexColor("#CCCCCC"),   // DockingEmptyBg
		Text::ParseHexColor("#9B9B9B"),   // PlotLines
		Text::ParseHexColor("#FF6D59"),   // PlotLinesHovered
		Text::ParseHexColor("#E5B200"),   // PlotHistogram
		Text::ParseHexColor("#FF9800"),   // PlotHistogramHovered
		Text::ParseHexColor("#000000A2"), // TableHeaderBg
		Text::ParseHexColor("#000000"),   // TableBorderStrong
		Text::ParseHexColor("#4296F9"),   // TableBorderLight
		Text::ParseHexColor("#FFFFFF00"), // TableRowBg
		Text::ParseHexColor("#0000000E"), // TableRowBgAlt
		Text::ParseHexColor("#4296F957"), // TextSelectedBg
		Text::ParseHexColor("#FFFF00E0"), // DragDropTarget
		Text::ParseHexColor("#4296F9"),   // NavHighlight
		Text::ParseHexColor("#000000AE"), // NavWindowingHighlight
		Text::ParseHexColor("#32323231"), // NavWindowingDimBg
		Text::ParseHexColor("#000000E5")  // ModalWindowDimBg
	};

	string SaveName = "Unnamed";
	bool SaveSetCurrent = false;
	array<vec4> Colors = DefaultColors;
	array<StyleVar@> Vars = {
		FloatStyleVar(UI::StyleVar::Alpha, 1.0f),
		Vec2StyleVar(UI::StyleVar::WindowPadding, vec2(8, 8)),
		FloatStyleVar(UI::StyleVar::WindowRounding, 2),
		FloatStyleVar(UI::StyleVar::WindowBorderSize, 0),
		Vec2StyleVar(UI::StyleVar::WindowMinSize, vec2(32, 32)),
		Vec2StyleVar(UI::StyleVar::WindowTitleAlign, vec2(0, 0.5f)),
		FloatStyleVar(UI::StyleVar::ChildRounding, 2),
		FloatStyleVar(UI::StyleVar::ChildBorderSize, 1),
		FloatStyleVar(UI::StyleVar::PopupRounding, 0),
		FloatStyleVar(UI::StyleVar::PopupBorderSize, 1),
		Vec2StyleVar(UI::StyleVar::FramePadding, vec2(6, 4)),
		FloatStyleVar(UI::StyleVar::FrameRounding, 3),
		FloatStyleVar(UI::StyleVar::FrameBorderSize, 0),
		Vec2StyleVar(UI::StyleVar::ItemSpacing, vec2(10, 6)),
		Vec2StyleVar(UI::StyleVar::ItemInnerSpacing, vec2(4, 4)),
		Vec2StyleVar(UI::StyleVar::CellPadding, vec2(4, 2)),
		FloatStyleVar(UI::StyleVar::IndentSpacing, 22),
		FloatStyleVar(UI::StyleVar::ScrollbarSize, 16),
		FloatStyleVar(UI::StyleVar::ScrollbarRounding, 3),
		FloatStyleVar(UI::StyleVar::GrabMinSize, 10),
		FloatStyleVar(UI::StyleVar::GrabRounding, 2),
		FloatStyleVar(UI::StyleVar::TabRounding, 4),
		Vec2StyleVar(UI::StyleVar::ButtonTextAlign, vec2(0.5f, 0.5f)),
		Vec2StyleVar(UI::StyleVar::SelectableTextAlign, vec2(0, 0))

		// Not available in UI::StyleVar (unpreviewable)
		//StyleVar(DisabledAlpha = 0.6),
		//StyleVar(WindowMenuButtonPosition = "Left"),
		//StyleVar(TouchExtraPadding = [ 0, 0 ]),
		//StyleVar(ColumnsMinSpacing = 6),
		//StyleVar(LogSliderDeadzone = 4),
		//StyleVar(TabBorderSize = 0),
		//StyleVar(TabMinWidthForCloseButton = 0),
		//StyleVar(ColorButtonPosition = "Right"),
		//StyleVar(DisplayWindowPadding = [ 19, 19 ]),
		//StyleVar(DisplaySafeAreaPadding = [ 3, 3 ]),
		//StyleVar(AntiAliasedLines = true),
		//StyleVar(AntiAliasedLinesUseTex = true),
		//StyleVar(AntiAliasedFill = true),
		//StyleVar(CurveTessellationTol = 1.25),
		//StyleVar(CircleTessellationMaxError = 0.3)
	};

	string SerializeColor(const vec4 &in v)
	{
		string ret = "#";
		ret += Text::Format("%02X", uint8(v.x * 255.0f));
		ret += Text::Format("%02X", uint8(v.y * 255.0f));
		ret += Text::Format("%02X", uint8(v.z * 255.0f));
		if (v.w < 1.0f) {
			ret += Text::Format("%02X", uint8(v.w * 255.0f));
		}
		return ret;
	}

	bool IsColorDefault(int index)
	{
		vec4 col = Colors[index];
		vec4 def = DefaultColors[index];
		return
			uint8(col.x * 255) == uint8(def.x * 255) &&
			uint8(col.y * 255) == uint8(def.y * 255) &&
			uint8(col.z * 255) == uint8(def.z * 255) &&
			uint8(col.w * 255) == uint8(def.w * 255);
	}

	void SaveStyle()
	{
		auto path = IO::FromDataFolder("OverlayStyles");
		if (!IO::FolderExists(path)) {
			IO::CreateFolder(path, false);
		}

		path += "/" + SaveName + ".toml";
		IO::File f;
		f.Open(path, IO::FileMode::Write);
		f.WriteLine("# Generated with Overlay Style Manager " + Meta::ExecutingPlugin().Version);
		f.WriteLine();
		f.WriteLine("[Style]");
		for (uint i = 0; i < Vars.Length; i++) {
			auto var = Vars[i];
			if (var.ShouldSerialize()) {
				f.WriteLine(var.m_name + " = " + var.Serialize());
			}
		}
		f.WriteLine();
		f.WriteLine("[Colors]");
		for (uint i = 0; i < Colors.Length; i++) {
			if (IsColorDefault(i)) {
				continue;
			}
			vec4 color = Colors[i];
			string name = UI::GetStyleColorName(UI::Col(i));
			f.WriteLine(name + " = \"" + SerializeColor(color) + "\"");
		}
		f.Close();

		if (SaveSetCurrent) {
			Meta::LoadOverlayStyle(path);
		}
	}

	void Render()
	{
		if (UI::Button(Icons::PlusCircle + " Create new")) {
			Colors = DefaultColors;
			for (uint i = 0; i < Vars.Length; i++) {
				Vars[i].Reset();
			}
		}
		UI::SameLine();
		if (UI::Button(Icons::Clipboard + " Create from current")) {
			for (uint i = 0; i < Colors.Length; i++) {
				Colors[i] = UI::GetStyleColor(UI::Col(i));
			}
			for (uint i = 0; i < Vars.Length; i++) {
				Vars[i].FromCurrent();
			}
		}
		UI::SameLine();
		if (UI::Button(Icons::FloppyO + " Save")) {
			SaveSetCurrent = false;
			UI::OpenPopup("Save style");
		}

		if (UI::BeginPopupModal("Save style", UI::WindowFlags::NoCollapse | UI::WindowFlags::NoMove | UI::WindowFlags::NoResize | UI::WindowFlags::AlwaysAutoResize)) {
			UI::Text("Type the name of the style to save to.");

			UI::PushItemWidth(300);
			SaveName = UI::InputText("##SaveName", SaveName);
			UI::PopItemWidth();

			SaveSetCurrent = UI::Checkbox("Set as current overlay style", SaveSetCurrent);

			if (UI::Button(Icons::FloppyO + " Save")) {
				SaveStyle();
				UI::CloseCurrentPopup();
			}
			UI::SameLine();
			if (UI::Button("Cancel")) {
				UI::CloseCurrentPopup();
			}

			UI::EndPopup();
		}

		UI::BeginTabBar("Create");

		if (UI::BeginTabItem("Colors")) {
			if (UI::BeginChild("Colors")) {
				RenderColors();
				UI::EndChild();
			}
			UI::EndTabItem();
		}

		if (UI::BeginTabItem("Variables")) {
			if (UI::BeginChild("Variables")) {
				RenderVars();
				UI::EndChild();
			}
			UI::EndTabItem();
		}

		UI::EndTabBar();
	}

	void RenderColors()
	{
		for (uint i = 0; i < Colors.Length; i++) {
			Colors[i] = UI::InputColor4(tostring(UI::Col(i)), Colors[i]);
		}
	}

	void RenderVars()
	{
		for (uint i = 0; i < Vars.Length; i++) {
			Vars[i].Render();
		}
	}
}
