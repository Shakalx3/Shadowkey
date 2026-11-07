{
	saved_Talked[0]
	Init[()
	{
		SetUseText(2513);
		SetUsable(false);
		SetInvulnerable(true);
		SetAggressive(false);

		SetSkin(10);

	}]

	OnUse[()
	{
		OpenMenu("StoutTP\\\\OldTrinketConvo3");
	}]
	
	ShowOG[()
	{
			ShowEntity(true);
			SetUsable(true);	
			MirrorMethod("ShowOG");
	}]	
}