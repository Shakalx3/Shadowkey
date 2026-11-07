{
	Init[ (s)
	{
		SetUseText(3403);

	}]

	OnUse[ (s)
	{
		ring = Level.GetPlayer().FindInventory("skey3");
		if (ring != null)
		{
			OpenMenu("twilite\\\\Shadow_open");
			Level.saved_SSdoor=1;
		}
		else
		{
			OpenMenu("twilite\\\\ShadowDoorLcked");
		}
	}]
	MenuQuit[ (s)
	{
		Quit();
	}]
}

