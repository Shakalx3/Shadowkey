{
	Init[()
	{
		ClearMenu();
		AddStaticItem(2203);
		AddStaticItem(179, false);
		AddMenuItem(517, "Take");
	}]

	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity( 718 );
		GetPlayer().PickupItem( Item );
		GetOpener().SetUsable(false);
		Quit();
	}]
}