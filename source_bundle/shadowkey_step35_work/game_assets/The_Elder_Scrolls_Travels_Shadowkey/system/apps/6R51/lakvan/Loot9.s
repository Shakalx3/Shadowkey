{
	Init[()
	{
		ClearMenu();
		AddStaticItem(3028);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "MenuQuit");
	}]

	Take[()
	{
		ClearMenu();
		GetOpener().MirrorMethod("RemoveContents");
		Item = Level.CreateEntity( 916 );
		GetPlayer().PickupItem( Item );
		Item = Level.CreateEntity( 714 );
		GetPlayer().PickupItem( Item );

		if(Level.saved_LakvanAgro = 0)
		{
			lakky = Level.GetEntity("lakvan");
			if( isObject( lakky ) )
			{
				lakky.SetAggressive(true);
				lakky.SetUsable(false);
			}
		}

		GetOpener().Loot9 = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}