{
	Init[ ()
	{
		GetOpener().SetMagicDamage(50);
		GetOpener().SetDormant(true);
		ClearMenu();
		AddStaticItem(3922);
		AddStaticItem(3923);
		AddStaticItem(179, false);
		AddMenuItem(1389, "MenuQuit");
		AddMenuItem(434, "Pick");
	}]

	Pick[ ()
	{
		if (GetPlayer().CanDisarmTrap(GetOpener().resistDisarm) = true)
		{
			OpenChest();
		}
		else
		{
			ClearMenu();
			AddStaticItem(3562);
			AddStaticItem(179, false);
			AddMenuItem(386, "Quit");
			GetPlayer().SetHealth(GetPlayer().GetHealth() - 6);
		}
	}]

	OpenChest[ ()
	{
		GetOpener().SetUsable(false);
		Gold = Level.CreateEntity( 52 );
		GetPlayer().StatModGold(Gold);
		Gold.SetQuantity( Random( 12, 40 ) );
		GetPlayer().PickupItem(Gold);
		ClearMenu();
		AddStaticItem(3635);
		AddStaticItem(3924);
		AddStaticItem(179, false);
		AddMenuItem(591, "MenuQuit");

	}]

	MenuQuit[ ()
	{
		Quit();
	}]

}
