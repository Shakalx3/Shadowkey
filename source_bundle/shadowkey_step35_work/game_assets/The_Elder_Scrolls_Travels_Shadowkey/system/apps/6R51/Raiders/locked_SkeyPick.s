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
			OpenMenu("Raiders\\\\OpenSkey5");
			Level.saved_Openswdoor=1;
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

