{
	Loot_Bag4[0]
	Init[ (s)
	{
		SetUseText(2670);
		SetUsable(true);
		SetName(864);
	} ]

	OnUse[ (s)
	{
		if( Loot_Bag4 = 0)
		{
		OpenMenu("twilite\\\\Loot6");
		}
		else
		{
		OpenMenu("NoLoot");
		}
	} ]
}