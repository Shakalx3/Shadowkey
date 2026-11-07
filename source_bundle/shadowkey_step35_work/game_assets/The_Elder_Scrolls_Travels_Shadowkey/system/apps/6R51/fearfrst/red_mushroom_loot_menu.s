{
	Init[()
	{
		AddStaticItem(1376);
		AddStaticItem(179, false);
		AddMenuItem(444, "Take");
		AddMenuItem(445, "Quit");
		AddMenuItem(1335, "Eat");
	}]
	Take[()
	{
		Item = Level.CreateEntity(4732);
		GetPlayer().PickupItem(Item);
		GetOpener().DestroyObject(GetOpener());
		Quit();
	}]
	Eat[()
	{
		ClearMenu();
		AddStaticItem(1377);
		AddStaticItem(179, false);
		AddMenuItem(517, "MenuQuit");
	}]
	MenuQuit[()
	{
		GetPlayer().AddEffect(Timed, MaxHealth, Increment, 50, 300);
		GetPlayer().PlaySound(87);
		GetOpener().DestroyObject(GetOpener());
		Quit();
	}]
}