{
	saved_Open[0]
	
	Init[ (s)
	{
		SetUseText(3403);
		if (saved_Open = 1)
		{
			UnlockZone("sdoor");
		}
	}]

	OnUse[ (s)
	{
		ring = Level.GetPlayer().FindInventory("skey9");
		if (ring != null)
		{
			OpenMenu("lakvan\\\\Shadow_open");
			saved_Open=1;
		}
		else
		{
			OpenMenu("lakvan\\\\ShadowDoorLcked");
		}
	}]
	MenuQuit[ (s)
	{
		Quit();
	}]
}

