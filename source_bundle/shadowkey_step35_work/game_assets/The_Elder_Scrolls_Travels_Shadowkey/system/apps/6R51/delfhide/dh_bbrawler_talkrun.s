{
	Arrived01[0]

	Init[ (s)
	{
		SetUseText(401);
		SetSkin(0);
		SetName(399);
		SetID("bbrawler");
		SetAttack(5);
		SetDefense(3);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(2);
		SetDamageMax(8);
		SetArmorValue(2);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(28000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
                SetSwingAnimation(1);
                SetDeathAnimation(6);
                SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetAttachedWeapon(223);
		SetAggressive(false);
		SetLoot(300, "Loot_Gold6-10", 1, 2 );
	}]

	ReachedDestination[ (s)
	{
		Arrived01 = 1;
		SetAggressive( true );
		AiDetect();
	}]
}