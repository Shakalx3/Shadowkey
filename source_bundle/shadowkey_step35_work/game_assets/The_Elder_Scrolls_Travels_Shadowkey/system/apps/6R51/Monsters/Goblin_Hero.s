{
	Init[ (s)
	{
		SetName(1337);
		SetUseText(1337);
		SetExpWorth(600);
		SetLevel(10);
		SetSkin(2);
		SetAggressive(true);
		SetAttack(45);
		SetDefense(80);
		SetSpellcast(0);
		SetMagicResistance(40);
		SetDamageMin(20);
		SetDamageMax(30);
		SetArmorValue(1);
		SetMaxHealth(150);
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
		SetBoss(true);
		SetLoot( 300, "fearfrst\\\\skey4");
	} ]

	OnKilled[ (s)
	{
		GetPlayer().SetQuestSolved(25);
	}]
}
