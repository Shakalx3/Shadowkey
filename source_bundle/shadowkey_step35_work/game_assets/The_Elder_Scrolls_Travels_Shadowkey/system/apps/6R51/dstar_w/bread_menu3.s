{
	Init[ ()
	{
		if (Level.saved_Bread3 = 0)
		{
			ClearMenu();
			AddStaticItem(1136);
			AddStaticItem(179, false);
			AddMenuItem(757, "MenuQuit");
			AddMenuItem(1137, "GiveBread");
		}
		else
		{
			ClearMenu();
			AddStaticItem(1138);
			AddStaticItem(179, false);
			AddMenuItem(1132, "MenuQuit");
		}
	}]

	GiveBread[ ()
	{
		Bread = GetPlayer().FindInventory("bread");
		if (Bread = null)
		{
			ClearMenu();
			AddStaticItem(1139);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
		}
		else
		{
			ClearMenu();
			AddStaticItem(1140);
			AddStaticItem(1141);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
			GetPlayer().AddExperience(300);
			GetPlayer().RemoveItem(Bread);
			Level.saved_Bread3 = 1;
		}
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}