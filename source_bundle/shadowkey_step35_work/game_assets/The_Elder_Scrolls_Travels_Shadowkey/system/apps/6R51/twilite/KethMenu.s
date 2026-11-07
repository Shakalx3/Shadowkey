{
	Init[()
	{
		SetUseText(2668);
		SetUsable(true);
	}]

	OnUse[()
	{
		GetPlayer().OpenMenu("twilite\\\\KethMenu_Use");
	}]
}