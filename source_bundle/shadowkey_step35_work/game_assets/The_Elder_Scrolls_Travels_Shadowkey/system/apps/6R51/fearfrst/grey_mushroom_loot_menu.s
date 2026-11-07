{
	Init[()
	{
		AddStaticItem(1338);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "Quit");
		AddMenuItem(1335, "Eat");
	}]
	Take[()
	{
		Item = Level.CreateEntity(4731);
		GetPlayer().PickupItem(Item);
		GetOpener().DestroyObject(GetOpener());
		Quit();
	}]
	Eat[()
	{
		ClearMenu();
		AddStaticItem(1339);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
	}]
	MenuQuit[()
	{
		GetPlayer().SetSpeed(GetPlayer().GetSpeed() + 1);
		GetPlayer().PlaySound(87);
		GetOpener().DestroyObject(GetOpener());
		Quit();
	}]
}