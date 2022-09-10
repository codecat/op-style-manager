namespace Index
{
	array<RemoteStyle@> Items;
	bool Updating = false;

	void UpdateAsync()
	{
		Updating = true;

		Items.RemoveRange(0, Items.Length);

		string url = "https://openplanet.dev/plugin/stylemanager/config/styles";
		auto req = Net::HttpGet(url);
		while (!req.Finished()) {
			yield();
		}

		const auto js = Json::Parse(req.String());
		for (uint i = 0; i < js.Length; i++) {
			auto jsItem = js[i];

			auto newStyle = RemoteStyle();
			newStyle.m_name = jsItem["name"];
			newStyle.m_author = jsItem["author"];
			newStyle.m_repository = jsItem["repository"];
			newStyle.m_branch = jsItem["branch"];
			Items.InsertLast(newStyle);
		}

		Updating = false;
	}
}
