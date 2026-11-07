{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2702);
		AddStaticItem(179, false);
		AddMenuItem(182, "TasteThis1");
	}]

	TasteThis1[()
	{
		ClearMenu();
		AddStaticItem(2703);
		AddStaticItem(179, false);
		AddMenuItem(182, "TasteThis2");
	}]

	TasteThis2[()
	{
		ClearMenu();
		AddStaticItem(2704);
		AddStaticItem(179, false);
		AddMenuItem(2705, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}