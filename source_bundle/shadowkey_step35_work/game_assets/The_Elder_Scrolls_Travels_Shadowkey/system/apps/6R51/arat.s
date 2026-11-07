{
	Init[ (s)
	{

		SetAggressive(true);
		SetName(201);
		SetID("arat");
		SetExpWorth(80);
		SetAttack(3);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(3);
		SetDamageMax(6);
		SetArmorValue(2);
		SetMaxHealth(12);
		SetWimpy(2);
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
		SetLoot( 300, "Loot_ratseye", 1, 8 );
		SetMob(1);


	}]
}






















}