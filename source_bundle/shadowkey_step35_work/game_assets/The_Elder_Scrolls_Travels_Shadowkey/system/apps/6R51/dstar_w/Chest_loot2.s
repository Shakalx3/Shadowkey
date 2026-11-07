{
	ChestLoot2 [0]
	Init[ (s)
	{
		SetUseText(368);
	} ]

	OnUse[ (s)
	{
		if( ChestLoot2 = 0)
		{
		OpenMenu("dstar_w\\\\loot2");
		}
		else
		{
		OpenMenu("NoLoot");
		}

	} ]

	MenuQuit[()
	{
		Quit();
	}]
}