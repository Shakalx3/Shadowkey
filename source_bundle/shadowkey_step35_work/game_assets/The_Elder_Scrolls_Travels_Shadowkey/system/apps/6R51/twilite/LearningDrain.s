{
	Loot9 [0]
	Init[ (s)
	{
		SetUseText(2670);
	} ]

	OnUse[ (s)
	{

		if( Loot9 = 0)
		{
		OpenMenu("twilite\\\\Loot9");
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