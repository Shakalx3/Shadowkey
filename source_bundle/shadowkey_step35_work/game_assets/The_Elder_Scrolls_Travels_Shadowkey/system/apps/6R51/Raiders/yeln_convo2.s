{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2257);
		AddStaticItem(179, false);
		AddMenuItem(2258, "MenuQuit");
		AddMenuItem(2259, "Attacked");
	}]

	Attacked[()
	{
		ClearMenu();
		OpenMenu("Raiders\\\\yeln_attacked");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}