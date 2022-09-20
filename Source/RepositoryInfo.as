enum RepositoryType
{
	Github,
	Gitea,
}

class @RepositoryInfo
{
	RepositoryType m_type;
	string m_server;
	string m_repository;
	string m_branch;

	RepositoryInfo(Json::Value@ js)
	{
		string type = js.Get("type", "github");
		if (type == "github") { m_type = RepositoryType::Github; }
		else if (type == "gitea") { m_type = RepositoryType::Gitea; }

		m_server = js.Get("server", "");
		if (m_server != "" && !m_server.EndsWith("/")) {
			m_server += "/";
		}

		m_repository = js.Get("repository", "");
		m_branch = js.Get("branch", "master");
	}

	string GetUrl()
	{
		switch (m_type) {
			case RepositoryType::Github: return "https://github.com/" + m_repository;
			case RepositoryType::Gitea: return m_server + m_repository;
		}

		return "unsupported-repository-type";
	}

	string GetRawUrl(string _path)
	{
		_path = Net::UrlEncode(_path).Replace("%2F", "/");

		switch (m_type) {
			case RepositoryType::Github:
				// jsDelivr caches for up to 12 hours
				return "https://cdn.jsdelivr.net/gh/" + m_repository + "@" + m_branch + "/" + _path;
				//return "https://raw.githubusercontent.com/" + m_repository + "/" + m_branch + "/" + _path;

			case RepositoryType::Gitea:
				return m_server + m_repository + "/raw/branch/" + m_branch + "/" + _path;
		}

		return "unsupported-repository-type";
	}
}
