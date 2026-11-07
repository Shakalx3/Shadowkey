{
	Init[()
	{
		AddStaticItem(1424);
		AddStaticItem(179, false);
		AddMenuItem(1361, "TakeAll");
		AddMenuItem(445, "Quit");
	}]
	TakeAll[()
	{
		Item = Level.CreateEntity(4735);
		GetPlayer().PickupItem(Item);

		Item = Level.CreateEntity(4735);
		GetPlayer().PickupItem(Item);

		Item = Level.CreateEntity(4500);
		GetPlayer().PickupItem(Item);

		GetOpener().saved_Opened = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]
}