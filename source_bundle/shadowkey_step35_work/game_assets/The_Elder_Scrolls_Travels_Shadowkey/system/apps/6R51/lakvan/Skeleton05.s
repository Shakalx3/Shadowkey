{
	Loot5 [0]
	Init[ (s)
	{
		SetUseText(1871);
		Level.Log("We need a Ring of Thuderblows for Loot5");
	} ]

	OnUse[ (s)
	{

		if( Loot5 = 0)
		{
		OpenMenu("lakvan\\\\Loot5");
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