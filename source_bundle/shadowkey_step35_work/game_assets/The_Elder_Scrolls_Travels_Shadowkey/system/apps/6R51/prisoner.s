{
	Init[ (s)
	{ 
		SetUseText(2147);
		SetSkin(0);
		SetWalkAnimation(1);
                SetSwingAnimation(2);
                SetDeathAnimation(3);
                SetIdleAnimation(7);
		PlayAnimation(7);
	} ]

	OnUse[ (s)
	{
		//OpenMenu("Acolyte Menlin");
		GetPlayer().OpenMenu("delfhide\\\\RescueConvo");
	} ]
}