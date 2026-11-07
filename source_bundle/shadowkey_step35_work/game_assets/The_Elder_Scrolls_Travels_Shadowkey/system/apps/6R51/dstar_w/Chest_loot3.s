{
	ChestLoot3 [0]
	Init[ (s)
	{
		SetUseText(368);
	} ]

	OnUse[ (s)
	{

		if( ChestLoot3 = 0)
		{
		OpenMenu("dstar_w\\\\loot3");
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