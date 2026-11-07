{
	Init[ (s)
	{
		//SetModel(202);
		SetSkin(0);
		SetAggressive(true);
		SetName(868);
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

		SetUseText(868);

		SetLoot( 300, "delfhide\\\\Loot_KeyB_33" );
		SetMob(1, 2);

	}]

}