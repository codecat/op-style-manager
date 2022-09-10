namespace Window::Index
{
	RemoteStyle@ SelectedStyle = null;
	RemoteStyleInfo@ SelectedStyleInfo = null;

	bool SelectedStyleUpdating = false;

	void SetSelectedStyleAsync(ref@ refStyle)
	{
		auto style = cast<RemoteStyle>(refStyle);

		SelectedStyleUpdating = true;
		@SelectedStyle = style;
		@SelectedStyleInfo = null;

		auto reqInfo = Net::HttpGet(style.RawUrl("info.json"));
		while (!reqInfo.Finished()) {
			yield();
		}

		int responseCode = reqInfo.ResponseCode();
		if (responseCode != 200) {
			error("Unable to get info for style! (Response code " + responseCode + ")");
			SelectedStyleUpdating = false;
			return;
		}

		auto js = Json::Parse(reqInfo.String());
		if (js.GetType() != Json::Type::Object) {
			error("Unable to get info for style! (Json is not an object)");
			SelectedStyleUpdating = false;
			return;
		}

		@SelectedStyleInfo = RemoteStyleInfo(style, js);
		startnew(CoroutineFunc(SelectedStyleInfo.DownloadScreenshotsAsync));

		SelectedStyleUpdating = false;
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
