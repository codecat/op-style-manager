namespace Window::Index
{
	void RenderInfo()
	{
		if (SelectedStyleUpdating) {
			UI::Text("Fetching style info..");
			return;
		}

		if (SelectedStyleInfo is null) {
			UI::Text("\\$f00" + Icons::ExclamationCircle + "\\$z Unable to fetch style info");
			return;
		}

		UI::PushFont(g_fontHeader);
		UI::Text(SelectedStyle.m_name + " \\$777by " + SelectedStyle.m_author);
		UI::PopFont();

		if (SelectedStyleInfo.m_version != "") {
			UI::Text("\\$777Version " + SelectedStyleInfo.m_version);
		}

		if (UI::Button(Icons::PaintBrush + " Use style")) {
			startnew(CoroutineFunc(SelectedStyleInfo.UseStyleAsync));
		}
		UI::SameLine();
		if (UI::Button(Icons::Github + " Repository")) {
			OpenBrowserURL(SelectedStyle.Url());
		}

		UI::Separator();

		if (SelectedStyleInfo.m_description != "") {
			UI::TextWrapped(SelectedStyleInfo.m_description);
		}

		for (uint i = 0; i < SelectedStyleInfo.m_screenshots.Length; i++) {
			auto texture = SelectedStyleInfo.m_screenshots[i];
			vec2 imageSize = texture.GetSize();
			imageSize *= UI::GetContentRegionAvail().x / imageSize.x;
			UI::Image(texture, imageSize);
		}
	}
}
