{
	Init[ (s)
	{
		SetUseText(3403);
	}]

	OnUse[ (s)
	{
		ring = Level.GetPlayer().FindInventory("skey8");
		if (ring != null)
		{
			OpenMenu("lothna\\\\Shadow_open");
		}
		else
		{
			OpenMenu("lothna\\\\ShadowDoorLcked");
		}
	}]
	MenuQuit[ (s)
	{
		Quit();
	}]
}

