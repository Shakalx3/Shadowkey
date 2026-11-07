{
	Init[ ()
	{
		ClearMenu();
		AddStaticItem(3652);
		AddStaticItem(179, false);
		AddMenuItem(1389, "Quit");
		AddMenuItem(434, "Pick");
	}]

	Pick[ ()
	{
		if (GetPlayer().CanDisarmTrap(GetOpener().resistDisarm) = true)
		{
			GetOpener().OpenChest();
		}
		else
		{
			GetOpener().MagicDamage();
		}
	}]
}