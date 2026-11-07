{

	Init[ (s)
	{

		ClearMenu();
		AddStaticItem(2281);
		AddStaticItem(2282);
		AddStaticItem(2283);
		AddStaticItem(2284);
		AddStaticItem(179, false);
		AddMenuItem( 528, "MenuQuit" );

	} ]



	MenuQuit[ (s)
	{
		Quit();
	} ]
}