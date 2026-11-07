{
	Loot8 [0]
	Init[ (s)
	{
		SetUseText(368);
	} ]

	OnUse[ (s)
	{

		if( Loot8 = 0)
		{
		OpenMenu("lakvan\\\\Loot8");
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