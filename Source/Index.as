namespace Index
{
	array<IndexItem@> Items;
	bool Updating = false;

	void UpdateAsync()
	{
		Updating = true;

		Items.RemoveRange(0, Items.Length);

		string url = "https://openplanet.dev/plugin/stylemanager/config/";
		if (Setting_TestIndex) {
			url += "styles-test";
		} else {
			url += "styles";
		}

		auto req = Net::HttpGet(url);
		while (!req.Finished()) {
			yield();
		}

		const auto js = Json::Parse(req.String());
		for (uint i = 0; i < js.Length; i++) {
			Items.InsertLast(IndexItem(js[i]));
		}

		Updating = false;
	}
}
