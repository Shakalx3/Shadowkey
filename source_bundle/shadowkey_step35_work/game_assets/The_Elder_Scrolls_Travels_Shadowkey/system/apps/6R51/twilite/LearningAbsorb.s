{
	Loot3 [0]
	Init[ (s)
	{
		SetUseText(2583);
	} ]

	OnUse[ (s)
	{

		if( Loot3 = 0)
		{
		OpenMenu("twilite\\\\Loot3");
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