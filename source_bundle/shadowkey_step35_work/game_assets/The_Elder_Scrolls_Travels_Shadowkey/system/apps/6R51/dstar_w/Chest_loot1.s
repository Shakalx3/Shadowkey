{
	ChestLoot1 [0]
	Init[ (s)
	{
		SetUseText(368);
	} ]

	OnUse[ (s)
	{

		if( ChestLoot1 = 0)
		{
		OpenMenu("dstar_w\\\\loot1");
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