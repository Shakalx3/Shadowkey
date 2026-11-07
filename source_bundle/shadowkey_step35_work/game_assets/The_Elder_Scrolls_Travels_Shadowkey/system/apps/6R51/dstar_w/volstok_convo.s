{
	Init[()
	{
		ClearMenu();
		if(Level.saved_VisitVolstok = 1)
		{
			AddStaticItem(1217);
			AddStaticItem(179, false);
			AddMenuItem(182, "More1");
		}
		else
		{
			AddStaticItem(1218);
			AddStaticItem(179, false);
			AddMenuItem(1219, "MenuQuit");
			AddMenuItem(1220, "MenuQuit");
		}
	}]

	MenuQuit[()
	{
		Quit();
	}]

	More1[()
	{
		ClearMenu();
		AddStaticItem(1221);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]

	More2[()
	{
		ClearMenu();
		AddStaticItem(1222);
		AddStaticItem(179, false);
		AddMenuItem(1223, "More3");
	}]

	More3[()
	{
		ClearMenu();
		AddStaticItem(1224);
		AddStaticItem(1225);
		AddStaticItem(179, false);
		AddMenuItem(182, "More4");
	}]

	More4[()
	{
		ClearMenu();
		AddStaticItem(1226);
		AddStaticItem(179, false);
		AddMenuItem(1227, "Lovely");
		AddMenuItem(1228, "Inaccurate");

	}]

	Lovely[()
	{
		ClearMenu();
		AddStaticItem(1229);
		AddStaticItem(1230);
		AddStaticItem(179, false);
		AddMenuItem(182, "Done");
	}]

	Inaccurate[()
	{
		ClearMenu();
		AddStaticItem(1231);
		AddStaticItem(1232);
		AddStaticItem(179, false);
		AddMenuItem(182, "Done");
	}]

	Done[()
	{
		ClearMenu();
		AddStaticItem(1233);
		AddStaticItem(1234);
		AddStaticItem(179, false);
		AddMenuItem(755, "MenuQuit");
		Level.saved_NoMoreVolstok = 1;
		Level.saved_VisitVolstok = 0;
		GetPlayer().SetGold( GetPlayer().GetGold() + 2200 );
	}]
}