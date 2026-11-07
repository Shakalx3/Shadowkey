{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2182);
		AddStaticItem(179, false);
		AddMenuItem(992, "MenuQuit");
		AddMenuItem(2183, "Attacked");
	}]

	Attacked[()
	{
		ClearMenu();
		OpenMenu("Raiders\\\\devron_attacked");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}