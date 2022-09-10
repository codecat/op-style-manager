class @RemoteStyle
{
	string m_name;
	string m_author;
	string m_repository;
	string m_branch;

	string RawUrl(const string &in path)
	{
		return "https://raw.githubusercontent.com/" + m_repository + "/" + m_branch + "/" + path;
	}

	string Url()
	{
		return "https://github.com/" + m_repository;
	}
}
