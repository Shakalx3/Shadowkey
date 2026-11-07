{
	saved_Looted[0]
	Init[()
	{
		SetUseText(1437);
		SetUsable(true);
	}]

	OnUse[()
	{
		if(saved_Looted = 0)
		{
			OpenMenu("ghstpass\\\\loot1");
			SetUsable(false);
		}
		else
		{
			OpenMenu("NoLoot");
		}
	}]
}