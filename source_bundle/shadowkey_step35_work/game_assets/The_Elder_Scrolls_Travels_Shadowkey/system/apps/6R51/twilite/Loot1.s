{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2671);
		AddStaticItem(179, false);
		AddMenuItem(2672, "Read");
	}]

	Read[()
	{
		ClearMenu();
		AddStaticItem(2673);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
		Level.GetEntity("dawn1").SetInvulnerable(false);
		Level.GetEntity("dawn2").SetInvulnerable(false);

		//Level.GetEntity("dawn1").SetScale(256);
		//Level.GetEntity("dawn2").SetScale(256);
                //
		//Level.GetEntity("dawn1").SetSkin(0);
		//Level.GetEntity("dawn2").SetSkin(0);
		Level.saved_zombieQuest = 1;
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(2674);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
		GetOpener().Loot1 = 1;
		GetOpener().DestroyObject();
		Item = Level.CreateEntity( 715 );
		GetPlayer().PickupItem( Item );
	}]

	MenuQuit[()
	{
		Quit();
	}]
}