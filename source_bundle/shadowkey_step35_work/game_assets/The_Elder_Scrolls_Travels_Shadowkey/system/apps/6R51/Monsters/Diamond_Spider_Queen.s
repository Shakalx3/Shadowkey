{
	Init[ (s)
	{
		SetName(2050);
		SetUseText(2050);
		SetExpWorth(400);
		SetLevel(9);
		SetSkin(0);
		SetAggressive(true);
		SetAttack(24);
		SetDefense(60);
		SetSpellcast(0);
		SetMagicResistance(30);
		SetDamageMin(12);
		SetDamageMax(18);
		SetArmorValue(1);
		SetMaxHealth(100);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(15);
		SetDeathNoise(16);
		SetIsHitNoise(17);
		SetWalkAnimation(0);
		SetSwingAnimation(1);
		SetDeathAnimation(2);
		SetIdleAnimation(1);
		PlayAnimationOffset(0);
		SetSpider(true);
		SetBoss(true);

	} ]

	OnKilled[ (s)
	{
		GetPlayer().SetQuestSolved(5);
	} ]
}
