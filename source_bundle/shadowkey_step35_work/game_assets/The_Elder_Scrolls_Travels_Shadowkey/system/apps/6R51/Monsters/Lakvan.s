{
	Init[ (s)
	{
		SetName(2096);
		SetUseText(2096);
		SetUsable(true);
		SetSkin(1);
		SetExpWorth(2500);
		SetLevel(13);
		SetAggressive(false);
		SetAttack(50);
		SetDefense(85);
		SetSpellcast(0);
		SetMagicResistance(45);
		SetDamageMin(22);
		SetDamageMax(32);
		SetArmorValue(1);
		SetMaxHealth(200);
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

		SetLoot(300, "lakvan\\\\loot10");
		SetBoss(true);

	} ]

	OnDetect[ ()
	{
		SetAggressive(true);
		GetPlayer().OpenMenu("lakvan\\\\lakvan_convo");
	}]

	OnKilled[ ()
	{
		Level.saved_LakvanAgro = 1;
	}]
}
