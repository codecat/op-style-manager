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
