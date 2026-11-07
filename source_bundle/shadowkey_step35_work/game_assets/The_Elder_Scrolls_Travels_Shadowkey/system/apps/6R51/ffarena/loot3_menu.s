{
	Init[()
	{
		AddStaticItem(1426);
		AddStaticItem(179, false);
		AddMenuItem(1361, "TakeAll");
		AddMenuItem(445, "Quit");
	}]
	TakeAll[()
	{
		Item = Level.CreateEntity(52);
		Item.SetQuantity(450);
		GetPlayer().PickupItem(Item);

		Item = Level.CreateEntity(703);
		GetPlayer().PickupItem(Item);

		GetOpener().saved_Opened = 1;
		GetOpener().SetUsable(false);
		Quit();
	}]
}