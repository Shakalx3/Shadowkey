{
	Init[ (s)
	{
		SetUseText(3403);
	}]

	OnUse[ (s)
	{
		ring = Level.GetPlayer().FindInventory("skey5");
		if (ring != null)
		{
			OpenMenu("Raiders\\\\Shadow_open");
		}
		else
		{
			OpenMenu("Raiders\\\\ShadowDoorLcked");
		}
	}]
	MenuQuit[ (s)
	{
		Quit();
	}]
}

