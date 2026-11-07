{
	Init[()
	{
		Level.Log("Menu one.... here");
		ClearMenu();
		AddStaticItem(3695);
		AddStaticItem(179, false);
		AddMenuItem(3696, "Take");

		funtext=AddFloatingTextJustify(4078, 176, 195, true,32767);
		funtext.SetFontNum(1);
	}]

	Take[ ()
	{
		ClearMenu();
		AddStaticItem(3698);
		AddStaticItem(179, false);
		AddMenuItem(182, "More01");
		Level.saved_Chest08 = 1;
	}]

	More01[ ()
	{
		ClearMenu();
		max = GetPlayer().GetMaxHealth();
		max = max - 5;
		GetPlayer().SetMaxHealth(max);
		s = GetPlayer().GetStrength();
		ag = GetPlayer().GetAgility();
		s = s +10;
		ag = ag + 10;
		GetPlayer().SetStrength(s);
		GetPlayer().SetAgility(ag);
		AddStaticItem(3699);
		AddStaticItem(179, false);
		AddMenuItem(3590, "MenuQuit");
	}]

	MenuQuit[()
	{
		Quit();
	}]

	Loot_Chest08Back[()
	{
		// handle the right softkey
		MenuQuit();
	}]
}