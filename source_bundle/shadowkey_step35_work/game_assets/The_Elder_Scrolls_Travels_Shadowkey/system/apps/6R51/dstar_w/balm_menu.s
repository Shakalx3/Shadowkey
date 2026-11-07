{
	Init[ ()
	{

		if (Level.save_Blind01 = 0)
		{
			ClearMenu();
			AddStaticItem(1129);
			AddStaticItem(179, false);
			AddMenuItem(757, "MenuQuit");
			AddMenuItem(1130, "Give");
		}
		else
		{
			ClearMenu();
			AddStaticItem(1131);
			AddStaticItem(179, false);
			AddMenuItem(1132, "MenuQuit");
		}
	}]

	Give[ ()
	{
		CBlind = GetPlayer().FindInventory("c_blind");
		if (CBlind = null)
		{
			ClearMenu();
			AddStaticItem(1133);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
		}
		else
		{
			ClearMenu();
			AddStaticItem(1134);
			AddStaticItem(1135);
			AddStaticItem(179, false);
			AddMenuItem(386, "MenuQuit");
			GetPlayer().AddExperience(1000);
			GetPlayer().RemoveItem(CBlind);
			Level.save_Blind01 = 1;
		}
	}]

	MenuQuit[ ()
	{
		Quit();
	}]
}