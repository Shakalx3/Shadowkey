{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2675);
		AddStaticItem(179, false);
		AddMenuItem(2672, "Read");
	}]

	Read[()
	{
		ClearMenu();
		AddStaticItem(2676);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
		Level.GetEntity("dusk1").SetInvulnerable(false);
		Level.GetEntity("dusk2").SetInvulnerable(false);
		Level.GetEntity("dusk3").SetInvulnerable(false);
		Level.GetEntity("dusk4").SetInvulnerable(false);

		Level.saved_zombieDusk = 1;
		Item = Level.CreateEntity( 716 );
		GetPlayer().PickupItem( Item );
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(2677);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
		GetOpener().Loot2 = 1;
		GetOpener().DestroyObject();
	}]

	MenuQuit[()
	{
		Quit();
	}]
}