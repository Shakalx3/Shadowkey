{
	Init[ ()
	{
		Skey7 = GetPlayer().FindInventory("skey6");
		if (Skey7 = null)
		{
			AddStaticItem(3449);
			AddStaticItem(179,false);
			AddMenuItem(591, "MenuQuit");
		}
		else
		{
			AddStaticItem(3450);
			AddStaticItem(179,false);
			AddMenuItem(182, "More");
		}
	}]

	More[ ()
	{
		ClearMenu();
		AddStaticItem(1053);
		AddStaticItem(1054);
		AddStaticItem(179,false);
		AddMenuItem(1055, "Int1");
		AddMenuItem(1056, "Will1");
	}]

	Int1[ ()
	{
		ClearMenu();
		AddStaticItem(3451);
		AddStaticItem(179,false);
		AddMenuItem(182, "Int2");
	}]

	Int2[ ()
	{
		ClearMenu();
		Intel = GetPlayer().GetIntelligence();
		Intel = Intel + 5;
		GetPlayer().SetIntelligence(Intel);
		AddStaticItem(1058);
		AddStaticItem(179,false);
		AddMenuItem(591, "MenuQuit");
		Level.saved_SkeyAttribute = 1;
	}]

	Will1[ ()
	{
		ClearMenu();
		Will = GetPlayer().GetWillpower();
		Will = Will + 5;
		GetPlayer().SetWillpower(Will);
		AddStaticItem(3452);
		AddStaticItem(3453);
		AddStaticItem(179,false);
		AddMenuItem(182, "Will2");
	}]

	Will2[ ()
	{
		ClearMenu();
		AddStaticItem(1060);
		AddStaticItem(179,false);
		AddMenuItem(591, "MenuQuit");
		Level.saved_SkeyAttribute = 1;
	}]
	MenuQuit[ ()
	{
		Quit();
	}]

}
