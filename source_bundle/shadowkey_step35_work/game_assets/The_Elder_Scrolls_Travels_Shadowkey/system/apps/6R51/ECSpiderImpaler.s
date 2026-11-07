{

	Init[ (s)
	{

		ClearMenu();
		AddStaticItem(1244);
		AddStaticItem(1245);
		AddStaticItem(1246);
		AddStaticItem(1247);
		AddStaticItem(179, false);
		AddMenuItem( 1248, "MenuQuit" );




	} ]



	MenuQuit[ (s)
	{
		Quit();
	} ]
}