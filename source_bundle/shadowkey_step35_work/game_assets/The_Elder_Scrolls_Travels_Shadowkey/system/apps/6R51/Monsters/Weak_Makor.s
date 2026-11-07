{
	Init[ (s)
	{
		SetName(2148);
		SetExpWorth(280);
		SetAggressive(false);
		SetAttack(4);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(5);
		SetDamageMin(6);
		SetDamageMax(8);
		SetArmorValue(2);
		SetMaxHealth(40);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		SetSkin(4);
		SetUseText(459);
		SetUsable(true);
		SetInvulnerable(true);

		SetMob(1);
	} ]

	OnUse[ (s)
	{
		OpenMenu("delfhide\\\\Makor_Convo");
	} ]
}
