{
	Init[ ()
	{
		ClearMenu();
		AddStaticItem(3920);
		AddStaticItem(3921);
		AddStaticItem(179, false);
		AddMenuItem(1389, "MenuQuit");
		AddMenuItem(434, "Pick");
	}]

	Pick[ ()
	{
		if (GetPlayer().CanDisarmTrap(GetOpener().resistDisarm) = true)
		{
			GetOpener().GetLoot();
			GetOpener().MirrorMethod("UnlockChest");
		}
		else
		{
			ClearMenu();
			AddStaticItem(3562);
			AddStaticItem(179, false);
			AddMenuItem(386, "Quit");
			GetPlayer().DoDamage(15);
			//GetPlayer().SetHealth(GetPlayer().GetHealth() - 15);
		}
	}]

	MenuQuit[ ()
	{
		Quit();
	}]

}
