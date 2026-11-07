{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2680);
		AddStaticItem(179, false);
		AddMenuItem(2681, "TakeScrolls");
		AddMenuItem(2682, "TakeCleaver");
		AddMenuItem(445, "MenuQuit");
	}]

	Again[()
	{
		ClearMenu();
		AddStaticItem(2680);
		AddStaticItem(179, false);
		if(GetOpener().saved_TakeScrolls = 0)
		{
			AddMenuItem(2681, "TakeScrolls");
		}
		if(GetOpener().saved_TakeCleaver = 0)
		{
			AddMenuItem(2682, "TakeCleaver");
		}
		AddMenuItem(445, "MenuQuit");
	}]

	TakeScrolls[()
	{
		ClearMenu();
		AddStaticItem(2683);
		AddStaticItem(179, false);
		Item = Level.CreateEntity( 4002 );
		GetPlayer().PickupItem( Item );
		Item = Level.CreateEntity( 4002 );
		GetPlayer().PickupItem( Item );
		GetOpener().saved_Chest04 = GetOpener().saved_Chest04 + 1;
		GetOpener().saved_TakeScrolls = 1;
		AddMenuItem(386, "Again");
	}]

	TakeCleaver[()
	{
		ClearMenu();
		AddStaticItem(2684);
		AddStaticItem(179, false);
		Item = Level.CreateEntity( 547 );
		GetPlayer().PickupItem( Item );
		GetOpener().saved_TakeCleaver = 1;
		AddMenuItem(386, "Again");
	}]

	MenuQuit[()
	{
		Quit();
	}]
}