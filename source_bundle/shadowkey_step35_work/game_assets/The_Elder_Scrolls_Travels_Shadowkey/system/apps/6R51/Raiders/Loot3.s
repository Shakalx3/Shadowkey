{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2202);
		AddStaticItem(179, false);
		AddMenuItem(517, "Take");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 719 );
		GetPlayer().PickupItem( Item );
		GetOpener().SetUsable(false);
		Quit();
	}]
}