{
	Init[ ()
	{
		AddStaticItem(1200);
		AddStaticItem(1201);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]

	More[ ()
	{
		ClearMenu();
		AddStaticItem(1202);
		AddStaticItem(1054);
		AddStaticItem(179, false);
		AddMenuItem(1203, "Speed1");
		AddMenuItem(1204, "Endurance1");
	}]

	Speed1[ ()
	{
		ClearMenu();
		AddStaticItem(1205);
		AddStaticItem(179, false);
		AddMenuItem(182, "Speed2");
	}]

	Speed2[ ()
	{
		ClearMenu();
		GetPlayer().SetSpeed( GetPlayer().GetSpeed() + 5 );
		AddStaticItem(1206);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]

	Endurance1[ ()
	{
		ClearMenu();
		GetPlayer().SetEndurance( GetPlayer().GetEndurance() + 5 );
		AddStaticItem(1207);
		AddStaticItem(179, false);
		AddMenuItem(182, "Endurance2");
	}]

	Endurance2[ ()
	{
		ClearMenu();
		AddStaticItem(1208);
		AddStaticItem(179, false);
		AddMenuItem(386, "MenuQuit");
	}]


	MenuQuit[ ()
	{
		Quit();
	}]

}
