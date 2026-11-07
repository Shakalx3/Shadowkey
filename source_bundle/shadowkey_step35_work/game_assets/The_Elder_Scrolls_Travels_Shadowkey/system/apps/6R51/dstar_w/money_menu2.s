{
	Init[ ()
	{
		if (Level.saved_Money2 = 0)
		{
			ClearMenu();
			AddStaticItem(1164);
			AddStaticItem(179, false);
			AddMenuItem(757, "MenuQuit");
			AddMenuItem(1165, "Give25");
			AddMenuItem(1166, "Give100");
		}
		else
		{
			ClearMenu();
			AddStaticItem(1167);
			AddStaticItem(179, false);
			AddMenuItem(1132, "MenuQuit");
		}
	}]

	Give25[ ()
	{
		Gold25 = GetPlayer().GetGold();
		if (Gold25 < 25)
		{
			ClearMenu();
			AddStaticItem(1168);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
			Level.saved_Money2 = 1;
		}
		else
		{
			ClearMenu();
			AddStaticItem(1169);
			AddStaticItem(1170);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
			GetPlayer().AddExperience(100);
			Gold25 = Gold25 - 25;
			GetPlayer().SetGold(Gold25);
			Level.saved_Money2 = 1;

		}
	}]

	Give100[ ()
	{
		Gold100 = GetPlayer().GetGold();
		if (Gold100 < 100)
		{
			ClearMenu();
			AddStaticItem(1168);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
		}
		else
		{
			ClearMenu();
			AddStaticItem(1171);
			AddStaticItem(1172);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
			GetPlayer().AddExperience(425);
			Gold100 = Gold100 - 100;
			GetPlayer().SetGold(Gold100);
			Level.saved_Money2 = 1;
		}
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}