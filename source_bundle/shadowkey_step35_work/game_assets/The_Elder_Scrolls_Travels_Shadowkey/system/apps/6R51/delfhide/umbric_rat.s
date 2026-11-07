{
	Init[ (s)
	{
		SetSkin(2);
		SetAggressive(true);
		SetName(913);
		SetID("urat");
		SetExpWorth(175);
		SetAttack(4);
		SetDefense(8);
		SetSpellcast(0);
		SetMagicResistance(0);
		SetDamageMin(3);
		SetDamageMax(8);
		SetArmorValue(4);
		SetMaxHealth(12);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(15);
		SetDeathNoise(16);
		SetIsHitNoise(17);
		SetWalkAnimation(1);
                SetSwingAnimation(2);
                SetDeathAnimation(3);
                SetIdleAnimation(0);
		PlayAnimation(0);

		AiDetect();


		SetLoot( 300, "loot_umbricfur", 1, 3);
	}]


}