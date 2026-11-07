{
	Shadow_Axe [0]
	Shadow_Mana [0]
	ShadowLoot [0]
	Init[ (s)
	{
		SetUseText(2215);
		SetName(368);
	}]

	OnUse[ (s)
	{
		OpenMenu("raiders\\\\ShadowLoot");
	} ]

	GetMana[(s)
	{
		Item = Level.CreateEntity( 808 );
		AddObject( Item );
		OpenMenu("raiders\\\\ShadowLootMana");
	}]
	GetAxe[(s)
	{
		Item = Level.CreateEntity( 573 );
		AddObject( Item );
		OpenMenu("raiders\\\\ShadowLootAxe");
	}]
}
