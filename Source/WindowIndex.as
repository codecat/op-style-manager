namespace Window::Index
{
	IndexItem@ SelectedStyle = null;
	bool SelectedStyleError = false;

	void SetSelectedStyleAsync(ref@ refStyle)
	{
		auto style = cast<IndexItem>(refStyle);

		@SelectedStyle = style;
		SelectedStyleError = false;

		if (style.m_info is null) {
			style.DownloadInfoAsync();
			if (style.m_info is null) {
				SelectedStyleError = true;
				return;
			}
		}

		if (style.m_screenshots.Length < style.m_info.m_pathScreenshots.Length) {
			style.DownloadScreenshotsAsync();
		}
	}

	void RenderIndex()
	{
		UI::Text("Available styles:");

		UI::PushItemWidth(-1);
		if (UI::BeginListBox("##StyleIndex", vec2(0, UI::GetContentRegionAvail().y - 40))) {
			if (Index::Updating) {
				UI::Text("\\$777" + Icons::Undo + " Updating style index..");
			} else {
				for (uint i = 0; i < Index::Items.Length; i++) {
					auto item = Index::Items[i];
					if (UI::Selectable(item.m_name + "\\$bbb by " + item.m_author, item is SelectedStyle)) {
						startnew(SetSelectedStyleAsync, item);
					}
				}
			}
			UI::EndListBox();
		}
		UI::PopItemWidth();

		if (UI::Button(Icons::Undo + " Default style")) {
			Meta::LoadOverlayStyle("");
		}
		UI::SameLine();
		if (UI::Button(Icons::PlusCircle + " Submit")) {
			OpenBrowserURL("https://openplanet.dev/link/discord");
		}
		if (UI::IsItemHovered()) {
			UI::BeginTooltip();
			UI::Text("Share your overlay style on Discord to get it added to this list.");
			UI::EndTooltip();
		}
	}

	void RenderInfo()
	{
		if (SelectedStyleError) {
			UI::Text("\\$f00" + Icons::ExclamationCircle + "\\$z Unable to fetch style info");
			return;
		}

		if (SelectedStyle.m_info is null) {
			UI::Text("Fetching style info..");
			return;
		}

		UI::PushFont(g_fontHeader);
		UI::Text(SelectedStyle.m_name + " \\$777by " + SelectedStyle.m_author);
		UI::PopFont();

		if (SelectedStyle.m_info.m_version != "") {
			UI::Text("\\$777Version " + SelectedStyle.m_info.m_version);
		}

		if (UI::Button(Icons::PaintBrush + " Use style")) {
			startnew(CoroutineFunc(SelectedStyle.UseStyleAsync));
		}
		UI::SameLine();
		if (UI::Button(Icons::Github + " Repository")) {
			OpenBrowserURL(SelectedStyle.m_repository.GetUrl());
		}

		UI::Separator();

		if (SelectedStyle.m_info.m_description != "") {
			UI::TextWrapped(SelectedStyle.m_info.m_description);
		}

		for (uint i = 0; i < SelectedStyle.m_screenshots.Length; i++) {
			auto texture = SelectedStyle.m_screenshots[i];
			vec2 imageSize = texture.GetSize();
			imageSize *= UI::GetContentRegionAvail().x / imageSize.x;
			UI::Image(texture, imageSize);
		}
	}

	void Render()
	{
		if (UI::IsWindowAppearing()) {
			@SelectedStyle = null;
			startnew(Index::UpdateAsync);
		}

		UI::BeginChild("Index", vec2(200, 0));
		RenderIndex();
		UI::EndChild();

		UI::SameLine();

		UI::BeginChild("Info", vec2(), false, UI::WindowFlags::NoScrollbar);
		if (SelectedStyle !is null) {
			RenderInfo();
		}
		UI::EndChild();
	}
}
