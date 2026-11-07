{
	Init[ (s)
	{ 
		SetUseText(2126);
		SetSkin(4);
		SetWalkAnimation(1);
                SetSwingAnimation(2);
                SetDeathAnimation(3);
                SetIdleAnimation(7);
		PlayAnimation(7);

		SetInvulnerable( true );
	} ]

	OnUse[ (s)
	{
		//OpenMenu("Acolyte Menlin");
		OpenMenu("delfhide\\\\UndrielConvo1");
	} ]
}