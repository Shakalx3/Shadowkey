{
	Init[ (s)
	{
		SetName(777);
		SetExpWorth(300);
		SetLevel(4);
		SetSkin(0);
		//SetAttachedWeapon(222);
		SetAggressive(false);
		SetAttack(24);
		SetDefense(70);
		SetSpellcast(0);
		SetMagicResistance(25);
		SetDamageMin(6);
		SetDamageMax(12);
		SetArmorValue(1);
		SetMaxHealth(90);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);

		SetBoss(true);

		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(0);
		PlayAnimationOffset(8);
	} ]

	OnUse[ (s)
	{
		OpenMenu("DelfSpeech");
	}]


	OnDetect[ (s)
	{
		if (Level.saved_DelfSpeech = 0)
		{
			OpenMenu("DelfSpeech");
			AiSleep();
		}
	}]

}