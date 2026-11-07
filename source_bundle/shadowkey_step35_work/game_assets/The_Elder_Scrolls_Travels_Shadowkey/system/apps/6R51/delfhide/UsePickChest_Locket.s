{
	Init[ (s)
	{
		ClearMenu();
		AddStaticItem("The chest is Locked.");
		AddStaticItem("Attemt to Lock pick?");
		AddStaticItem(179, false);
		AddMenuItem(1389, "Quit");
		AddMenuItem(434, "Pick");
	}]

	Pick[ (s)
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