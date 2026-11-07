{
	Init[ (s)
	{
		AddStaticItem(1305);
		AddStaticItem(179, false);
		AddMenuItem(182, "Take");
	}]

	Take[ (s)
	{
		ClearMenu();
		AddStaticItem(1306);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
	}]

	More[ (s)
	{
		ClearMenu();
		AddStaticItem(1307);
		AddStaticItem(179, false);
		AddMenuItem(444, "TakeMap");
		AddMenuItem(445, "MenuQuit");

	} ]

	TakeMap[ (s)
	{
		GetOpener().LootChest();
	}]
	MenuQuit[ (s)
	{
		Quit();
	}]
}