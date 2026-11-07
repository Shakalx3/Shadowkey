{

	Init[ (s)
	{
		AddStaticItem(2969);
		AddStaticItem(179, false);
		AddMenuItem(182, "Me");
	}]

	Me[ (s)
	{
		ClearMenu();
		AddStaticItem(2970);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	MenuQuit[ (s)
	{
		Quit();
	}]

}