{
	saved_Opened[0]
	Init[()
	{
		SetUseText(368);
		SetUsable(true);
	}]
	OnUse[()
	{
		if(saved_Opened = 0)
		{
			OpenMenu("glcrcrwl\\\\loot2");
			saved_Opened = 1;
		}
	}]
}