{
	Sarc [0]
	Init[ (s)
	{
		SetUseText(612);
	} ]

	OnUse[ (s)
	{

		if(Sarc = 0)
		{
			Delay(1,1);
			Sarc = 1;
			SetUsable(false);
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
	
	DelayReached[ ()
	{
		Level.CreateEntity(272, GetPositionX() + 300, GetPositionY() + 300, GetPositionZ());
	}]
}