class @RemoteStyleInfo
{
	RemoteStyle@ m_style;

	string m_version;
	string m_description;

	string m_pathStyle;

	array<string> m_pathScreenshots;
	array<UI::Texture@> m_screenshots;

	RemoteStyleInfo(RemoteStyle@ style, Json::Value@ js)
	{
		@m_style = style;

		m_version = js.Get("version", "");
		m_description = js.Get("description", "");

		m_pathStyle = js.Get("style", "");

		auto jsScreenshot = js.Get("screenshot");
		if (jsScreenshot !is null && jsScreenshot.GetType() == Json::Type::String) {
			m_pathScreenshots.InsertLast(jsScreenshot);
		}

		auto jsScreenshots = js.Get("screenshots");
		if (jsScreenshots !is null && jsScreenshots.GetType() == Json::Type::Array) {
			for (uint i = 0; i < jsScreenshots.Length; i++) {
				auto jsItem = jsScreenshots[i];
				if (jsItem.GetType() == Json::Type::String) {
					m_pathScreenshots.InsertLast(jsItem);
				}
			}
		}
	}

	void DownloadScreenshotsAsync()
	{
		m_screenshots.RemoveRange(0, m_screenshots.Length);

		for (uint i = 0; i < m_pathScreenshots.Length; i++) {
			string path = m_pathScreenshots[i];
			auto req = Net::HttpGet(m_style.RawUrl(path));
			while (!req.Finished()) {
				yield();
			}

			int responseCode = req.ResponseCode();
			if (responseCode != 200) {
				error("Unable to fetch screenshot at \"" + path + "\" (response code " + responseCode + ")");
				continue;
			}

			auto texture = UI::LoadTexture(req.Buffer());
			m_screenshots.InsertLast(texture);

			yield();
		}
	}

	void UseStyleAsync()
	{
		if (!Regex::IsMatch(m_pathStyle, "^[A-Za-z0-9\\-_]+\\.toml$")) {
			error("Invalid style path!");
			return;
		}

		string path = IO::FromStorageFolder(m_pathStyle);

		auto req = Net::HttpGet(m_style.RawUrl(m_pathStyle));
		while (!req.Finished()) {
			yield();
		}
		req.SaveToFile(path);

		Meta::LoadOverlayStyle(path);
	}
}
