{
	Init[()
	{
		AddStaticItem(3090);
		AddStaticItem(179, false);
		AddMenuItem(3091, "Help");
	}]

	Help[()
	{
		ClearMenu();
		AddStaticItem(3092);
		AddStaticItem(179, false);
		AddMenuItem(3093, "Open");
	}]

	Open[()
	{
		ClearMenu();
		AddStaticItem(3094);
		AddStaticItem(179, false);
		AddMenuItem(386, "Quit");
	}]
}