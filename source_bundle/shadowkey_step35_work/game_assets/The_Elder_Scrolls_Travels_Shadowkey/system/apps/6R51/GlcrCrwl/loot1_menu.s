{
	Init[()
	{
		AddStaticItem(1556);
		AddStaticItem(179);
		AddMenuItem(444, "Take");
	}]
	Take[()
	{
		Item = Level.CreateEntity(918);
		GetPlayer().PickupItem(Item);
		Quit();
	}]
}