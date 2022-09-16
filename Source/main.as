UI::Font@ g_fontHeader;

void Main()
{
	@g_fontHeader = UI::LoadFont("DroidSans.ttf", 26);
}

void RenderMenu()
{
	if (UI::MenuItem("\\$f39" + Icons::PaintBrush + "\\$z Overlay Style Manager", "", Window::Visible)) {
		Window::Visible = !Window::Visible;
	}
}

void RenderInterface()
{
	Window::Render();
}

string GetRawGithubUrl(const string &in repository, const string &in branch, const string &in path)
{
	return "https://raw.githubusercontent.com/" + repository + "/" + branch + "/" + Net::UrlEncode(path).Replace("%2F", "/");
}
