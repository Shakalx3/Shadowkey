{
	Init[ (s)
	{
		SetUseText(368);
		SetUsable(true);
	}]

	OnUse[ (s)
	{
		if( Level.saved_Chest08 = 0)
		{
		GetPlayer().OpenMenu("lothna\\\\Loot_Chest08");
		SetUsable(false);
		}
		else
		{
		OpenMenu("NoLoot");
		}
	}]

	MenuQuit[()
	{
		Quit();
	}]
}