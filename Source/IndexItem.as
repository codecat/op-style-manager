class @IndexItem
{
	string m_name;
	string m_author;
	string m_repository;
	string m_branch;

	IndexInfo@ m_info;

	array<UI::Texture@> m_screenshots;

	string RawUrl(const string &in path)
	{
		return GetRawGithubUrl(m_repository, m_branch, path);
	}

	string Url()
	{
		return "https://github.com/" + m_repository;
	}

	void DownloadInfoAsync()
	{
		auto reqInfo = Net::HttpGet(RawUrl("info.json"));
		while (!reqInfo.Finished()) {
			yield();
		}

		int responseCode = reqInfo.ResponseCode();
		if (responseCode != 200) {
			error("Unable to get info for style! (Response code " + responseCode + ")");
			return;
		}

		auto js = Json::Parse(reqInfo.String());
		if (js.GetType() != Json::Type::Object) {
			error("Unable to get info for style! (Json is not an object)");
			return;
		}

		@m_info = IndexInfo(js);
	}

	void DownloadScreenshotsAsync()
	{
		m_screenshots.RemoveRange(0, m_screenshots.Length);

		for (uint i = 0; i < m_info.m_pathScreenshots.Length; i++) {
			if (i > 0) {
				yield();
			}

			string path = m_info.m_pathScreenshots[i];
			auto req = Net::HttpGet(RawUrl(path));
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
		}
	}

	void UseStyleAsync()
	{
		if (!Regex::IsMatch(m_info.m_pathStyle, "^[\\/A-Za-z0-9\\-_\\s]+\\.toml$")) {
			error("Invalid style path!");
			return;
		}

		if (m_info.m_pathStyle.StartsWith("/")) {
			error("Invalid style path!");
			return;
		}

		string filename = m_info.m_pathStyle;
		int slashIndex = filename.IndexOf("/");
		if (slashIndex != -1) {
			filename = filename.SubStr(slashIndex + 1);
		}

		string path = IO::FromStorageFolder(filename);

		auto req = Net::HttpGet(RawUrl(m_info.m_pathStyle));
		while (!req.Finished()) {
			yield();
		}
		req.SaveToFile(path);

		Meta::LoadOverlayStyle(path);
	}
}
