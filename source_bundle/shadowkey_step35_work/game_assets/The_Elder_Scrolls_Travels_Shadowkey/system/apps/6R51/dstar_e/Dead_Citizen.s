{
	saved_Looted[0]
	Init[()
	{
		SetUseText(1437);
		SetUsable(false);
		SetInvulnerable(true);
		SetAggressive(false);
		SetDeathAnimation(3);
		PlayAnimation(6, 127, 0);
		AiSleep();
	}]

	OnUse[()
	{
		if(saved_Looted = 0)
		{
			OpenMenu("ghstpass\\\\loot1");
		}
		else
		{
			OpenMenu("NoLoot");
		}
	}]
}