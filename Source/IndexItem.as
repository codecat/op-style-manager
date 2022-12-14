enum CollectionState
{
	NotFetched,
	Fetching,
	Fetched,
}

class @IndexItem
{
	string m_name;
	string m_author;

	RepositoryInfo@ m_repository;

	IndexInfo@ m_info;

	array<UI::Texture@> m_screenshots;

	bool m_collection = false;
	CollectionState m_collectionState = CollectionState::NotFetched;
	array<IndexItem@> m_subItems;

	IndexItem(IndexItem@ parent, IndexInfo@ info)
	{
		@m_info = info;

		m_name = (info.m_name != "" ? info.m_name : parent.m_name);
		m_author = info.m_author;

		@m_repository = parent.m_repository;

		m_collection = (info.m_subStyles.Length > 0);
		m_collectionState = CollectionState::Fetched;

		for (uint i = 0; i < info.m_subStyles.Length; i++) {
			auto subStyleInfo = info.m_subStyles[i];
			m_subItems.InsertLast(IndexItem(this, subStyleInfo));
		}
	}

	IndexItem(Json::Value@ js)
	{
		m_name = js.Get("name", "");
		m_author = js.Get("author", "");
		m_collection = js.Get("collection", false);
		@m_repository = RepositoryInfo(js);
	}

	void DownloadInfoAsync()
	{
		auto reqInfo = Net::HttpGet(m_repository.GetRawUrl("info.json"));
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
			auto req = Net::HttpGet(m_repository.GetRawUrl(path));
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

	void DownloadSubItemsAsync()
	{
		m_collectionState = CollectionState::Fetching;

		if (m_info is null) {
			DownloadInfoAsync();
		}

		for (uint i = 0; i < m_info.m_subStyles.Length; i++) {
			auto subStyleInfo = m_info.m_subStyles[i];
			m_subItems.InsertLast(IndexItem(this, subStyleInfo));
		}

		m_collectionState = CollectionState::Fetched;
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

		auto req = Net::HttpGet(m_repository.GetRawUrl(m_info.m_pathStyle));
		while (!req.Finished()) {
			yield();
		}
		req.SaveToFile(path);

		Meta::LoadOverlayStyle(path);
	}
}
