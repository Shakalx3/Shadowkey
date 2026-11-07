{
	Init[ (s)
	{
		SetSkin(0);
		SetAggressive(true);
		SetName(867);
		SetID("bthug");
		SetExpWorth(148);
		SetAttack(5);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(3);
		SetDamageMax(8);
		SetArmorValue(3);
		SetMaxHealth(35);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
                SetSwingAnimation(1);
                SetDeathAnimation(6);
                SetIdleAnimation(8);
		PlayAnimation(8);
		SetAttachedWeapon( 222 );

		AiDetect();

		SetUseText(867);

		SetLoot( 300, "delfhide\\\\Loot_KeyA_33" );
		SetMob(1, 2);
	}]


}