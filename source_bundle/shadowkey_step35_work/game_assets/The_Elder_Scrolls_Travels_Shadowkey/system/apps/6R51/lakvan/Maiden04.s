{
	Loot4 [0]
	Init[ (s)
	{
		SetUseText(1841);
	} ]

	OnUse[ (s)
	{

		if( Loot4 = 0)
		{
		OpenMenu("lakvan\\\\Loot4");
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