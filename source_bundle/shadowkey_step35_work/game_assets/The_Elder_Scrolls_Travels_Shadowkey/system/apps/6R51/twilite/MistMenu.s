{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2697);
		AddStaticItem(2698);
		AddStaticItem(179, false);
		AddMenuItem(2699, "MenuQuit");
		GetPlayer().DoDamage(4);
	}]

	MenuQuit[()
	{
		Quit();
	}]
}