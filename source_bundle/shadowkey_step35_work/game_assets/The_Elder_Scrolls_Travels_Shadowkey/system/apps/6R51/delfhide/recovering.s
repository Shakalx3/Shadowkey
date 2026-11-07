{
	Init[ (s)
	{
		SetUseText(893);
		SetWalkAnimation(1);
                SetSwingAnimation(2);
                SetDeathAnimation(3);
                SetIdleAnimation(7);
		PlayAnimationOffset(7);
		SetInvulnerable(true);
		SetAggressive(false);
	}]

	OnUse[ (s)
	{
		OpenMenu("delfhide\\\\DH_Menu5a");
	}]
}