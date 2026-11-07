{
	Loot_Bag3[0]
	Init[ (s)
	{
		SetUseText(2670);
		SetUsable(true);
		SetName(864);
	} ]

	OnUse[ (s)
	{
		if( Loot_Bag3 = 0)
		{
		OpenMenu("twilite\\\\Loot5");
		}
		else
		{
		OpenMenu("NoLoot");
		}
	} ]
}