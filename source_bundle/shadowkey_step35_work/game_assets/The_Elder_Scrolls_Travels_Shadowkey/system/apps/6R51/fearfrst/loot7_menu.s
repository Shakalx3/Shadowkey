{
	Init[()
	{
		AddStaticItem(1365);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "Quit");
	}]
	Take[()
	{
		ClearMenu();
		Item = Level.CreateEntity(4504);
		GetPlayer().PickupItem(Item);
		GetOpener().saved_Looted = 1;
		GetOpener().DestroyObject(GetOpener());
		Quit();
	}]
}