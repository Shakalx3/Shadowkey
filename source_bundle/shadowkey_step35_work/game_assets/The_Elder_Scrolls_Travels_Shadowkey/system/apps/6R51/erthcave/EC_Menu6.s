{
	Init[ (s)
	{
		skey2 = GetPlayer().FindInventory("skey2");
		if( skey2 != null )
		{
			AddStaticItem(1315);
			AddStaticItem(179, false);
			AddMenuItem(182,"HasKeyMore1");
			Level.saved_WardPassed = 1;
			Level.UnlockZone("ward_lock");
			skey2.MirrorMethod("UnlockWard");
		}
		else
		{
			AddStaticItem(1316);
			AddStaticItem(179, false);
			AddMenuItem(182, "NoKeyMore1");
			player = GetPlayer();
			player.SetPositionMirror(28975, 24706, 0);
		}
	} ]

	HasKeyMore1[ (s)
	{
		ClearMenu();
		AddStaticItem(1317);
		AddStaticItem(179, false);
		AddMenuItem(182, "HasKeyMore2");
	} ]

	HasKeyMore2[ (s)
	{
		ClearMenu();
		AddStaticItem(1318);
		AddStaticItem(179, false);
		AddMenuItem(528, "Quit");
	} ]

	NoKeyMore1[ (s)
	{
		ClearMenu();
		AddStaticItem(1319);
		AddStaticItem(179, false);
		AddMenuItem(182, "NoKeyMore2");
	} ]

	NoKeyMore2[ (s)
	{
		ClearMenu();
		AddStaticItem(1320);
		AddStaticItem(179, false);
		AddMenuItem(182, "NoKeyMore3");
	} ]

	NoKeyMore3[ (s)
	{
		ClearMenu();
		AddStaticItem(1321);
		AddStaticItem(179, false);
		AddMenuItem(528, "Quit");
	} ]

}