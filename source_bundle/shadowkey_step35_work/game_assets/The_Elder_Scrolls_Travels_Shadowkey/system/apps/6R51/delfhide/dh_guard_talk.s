{
	Init[ (s)
	{
		SetUseText(400);
		SetSkin(0);
		SetName(399);
		SetAttack(5);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(2);
		SetDamageMax(8);
		SetArmorValue(2);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(18000);

		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);

		SetWalkAnimation(5);
                SetSwingAnimation(1);
                SetDeathAnimation(6);
                SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetAttachedWeapon(223);
		SetAggressive(true);
		AiDetect();
		SetMob(1);

	}]

	OnUse[ (s)
	{
		OpenMenu("Talker");
	}]

	OnDetect[ (s)
	{
		OpenMenu("Talker");
	}]

}


