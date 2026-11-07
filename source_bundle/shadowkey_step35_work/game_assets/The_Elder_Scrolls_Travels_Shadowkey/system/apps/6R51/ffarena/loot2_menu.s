{
	Init[()
	{
		AddStaticItem(1425);
		AddStaticItem(179, false);
		AddMenuItem(1361, "TakeAll");
		AddMenuItem(445, "Quit");
	}]
	TakeAll[()
	{
		Item = Level.CreateEntity(561);
		GetPlayer().PickupItem(Item);

		Item = Level.CreateEntity(702);
		GetPlayer().PickupItem(Item);

		Item = Level.CreateEntity(702);
		GetPlayer().PickupItem(Item);

		GetOpener().saved_Opened = 1;
		GetOpener().DestroyObject(GetOpener());
		Quit();
	}]
}