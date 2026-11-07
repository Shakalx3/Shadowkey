{
	Init[ (s)
	{
		if( GetPlayer().HasItem( "skey1" ) )
		{
			AddStaticItem(797);
			AddStaticItem(179, false);
			AddMenuItem(798, "HasKeyMore");
		}
		else
		{
			AddStaticItem(799);
			AddStaticItem(800);
			AddStaticItem(179, false);
			AddMenuItem(528, "Quit");
		}
	} ]

	HasKeyMore[ (s)
	{
		ClearMenu();
		AddStaticItem(801);
		AddStaticItem(179, false);
		AddMenuItem(528, "Quit");
	} ]

}