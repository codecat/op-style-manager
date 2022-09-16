class @IndexInfo
{
	string m_description;
	string m_version;

	string m_pathStyle;

	array<string> m_pathScreenshots;

	IndexInfo(Json::Value@ js)
	{
		m_description = js.Get("description", "");
		m_version = js.Get("version", "");

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
}
