{
	Init[()
	{
		Skey3 = GetPlayer().FindInventory("skey3");
		if( Skey3 != null )
		{
			AddStaticItem(1843);
			AddStaticItem(179, false);
			AddMenuItem(182, "More");

		}
		else
		{
			AddStaticItem(1844);
			AddStaticItem(1845);
			AddStaticItem(179, false);
			AddMenuItem(1829, "MenuQuit");

		}
	}]

	More[()
	{
		ClearMenu();
		AddStaticItem(1846);
		AddStaticItem(179, false);
		AddMenuItem(1847, "Slain");
		AddMenuItem(1848, "Once");
	}]

	Once[()
	{
		ClearMenu();
		AddStaticItem(1849);
		AddStaticItem(179, false);
		AddMenuItem(1850, "Comfort");
		AddMenuItem(1851, "MenuQuit");
	}]

	Slain[()
	{
		ClearMenu();
		AddStaticItem(1852);
		AddStaticItem(1853);
		AddStaticItem(179, false);
		AddMenuItem(1829, "MenuQuit");

	}]

	Comfort[()
	{
		ClearMenu();
		AddStaticItem(1854);
		AddStaticItem(1855);
		AddStaticItem(179, false);
		AddMenuItem(1856, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
		Level.GetEntity("pasuul2").SetAggressive(true);
		Level.GetEntity("pasuul2").SetInvulnerable(false);
		Level.GetEntity("pasuul2").SetUsable(false);
		GetOpener().saved_aggro=1;
	}]
}