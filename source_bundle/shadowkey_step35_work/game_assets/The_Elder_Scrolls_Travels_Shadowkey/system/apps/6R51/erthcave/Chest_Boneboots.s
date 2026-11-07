{
	boneLoot [0]
	Init[ (s)
	{
		SetUseText(368);
	} ]

	OnUse[ (s)
	{

		if( boneLoot = 0)
		{
		OpenMenu("erthcave\\\\Loot_BoneBoots");
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