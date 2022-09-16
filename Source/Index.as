namespace Index
{
	array<IndexItem@> Items;
	bool Updating = false;

	void UpdateCollectionAsync(ref@ refJs)
	{
		auto js = cast<Json::Value>(refJs);

		string repository = js.Get("repository", "");
		string branch = js.Get("branch", "");

		auto reqInfo = Net::HttpGet(GetRawGithubUrl(repository, branch, "info.json"));
		while (!reqInfo.Finished()) {
			yield();
		}

		int responseCode = reqInfo.ResponseCode();
		if (responseCode != 200) {
			error("Unable to get info for style collection! (Response code " + responseCode + ")");
			return;
		}

		auto jsCollectionInfo = Json::Parse(reqInfo.String());
		if (jsCollectionInfo.GetType() != Json::Type::Object) {
			error("Unable to get info for style collection! (Json is not an object)");
			return;
		}

		auto jsStyles = jsCollectionInfo.Get("styles");

		for (uint i = 0; i < jsStyles.Length; i++) {
			auto jsInfo = jsStyles[i];

			auto newStyle = IndexItem();
			newStyle.m_name = jsInfo.Get("name", js.Get("name", ""));
			newStyle.m_author = jsInfo.Get("author", js.Get("author", ""));
			newStyle.m_repository = repository;
			newStyle.m_branch = branch;
			@newStyle.m_info = IndexInfo(jsInfo);
			Items.InsertLast(newStyle);
		}
	}

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

		array<Meta::PluginCoroutine@> collectionUpdates;

		const auto js = Json::Parse(req.String());
		for (uint i = 0; i < js.Length; i++) {
			auto jsItem = js[i];

			if (bool(jsItem.Get("collection", false))) {
				collectionUpdates.InsertLast(startnew(UpdateCollectionAsync, jsItem));
			} else {
				auto newStyle = IndexItem();
				newStyle.m_name = jsItem.Get("name", "");
				newStyle.m_author = jsItem.Get("author", "");
				newStyle.m_repository = jsItem.Get("repository", "");
				newStyle.m_branch = jsItem.Get("branch", "");
				Items.InsertLast(newStyle);
			}
		}

		await(collectionUpdates);

		Updating = false;
	}
}
