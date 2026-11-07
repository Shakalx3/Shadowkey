{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2237);
		AddStaticItem(179, false);
		AddMenuItem(2238, "MenuQuit");
		AddMenuItem(2239, "Attacked");
	}]

	Attacked[()
	{
		ClearMenu();
		OpenMenu("Raiders\\\\wulf_attacked");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}