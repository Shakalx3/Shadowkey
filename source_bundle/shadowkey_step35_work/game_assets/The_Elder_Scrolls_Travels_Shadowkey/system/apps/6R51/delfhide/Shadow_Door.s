{
	Init[ (s)
	{
		SetUseText(3403);
	}]

	OnUse[ (s)
	{
		key = Level.GetPlayer().FindInventory("skey1");
		if (key != null)
		{
			OpenMenu("delfhide\\\\Shadow_open");
		}
		else
		{
			OpenMenu("delfhide\\\\ShadowDoorLcked");
		}
	}]
	MenuQuit[ (s)
	{
		Quit();
	}]
}

