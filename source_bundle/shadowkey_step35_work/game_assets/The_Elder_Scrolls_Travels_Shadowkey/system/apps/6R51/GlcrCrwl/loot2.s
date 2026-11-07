{
	Init[()
	{
		AddStaticItem(1557);
		AddStaticItem(179, false);
		AddMenuItem(182, "More");
		Item = Level.CreateEntity(714);
		GetPlayer().PickupItem(Item);
		Level.Log("About to run CountInventory");
		GetOpener().SetUsable(false);
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(2982);
		AddStaticItem(179, false);
		Level.Log("CountIventory launching");
		if(GetPlayer().CountInventory("stooth") = 7)
		{
			AddMenuItem(2983, "Quit");
			Level.Log("Menu Option 1 Successful");
		}
		else
		{
			AddMenuItem(2984, "Quit");
			Level.Log("Menu Option 2 Successful");
		}
		Level.Log("This is the end of my script");
	}]
}