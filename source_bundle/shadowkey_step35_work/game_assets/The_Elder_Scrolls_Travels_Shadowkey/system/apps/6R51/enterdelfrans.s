{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem(1252);
		AddStaticItem(1253);
		AddStaticItem(1254);
		AddStaticItem(1255);
		AddStaticItem(1256);
		AddStaticItem(179, false);
		AddMenuItem(182, "MoreResponse");



	}]
	MoreResponse [ (s)
	{
		ClearMenu();
		AddStaticItem(1257);
		AddStaticItem(1258);
		AddStaticItem(1259);
		AddStaticItem(1260);
		AddStaticItem(179, false);
		AddMenuItem(195, "MenuQuit");

	} ]


	MenuQuit[ (s)
	{
		Quit();
	}]
}