{
	Init[ (s)
	{
		SetName(2129);
		SetSkin(9);
		SetExpWorth(280);
		SetAggressive(false);
		SetLevel(6);
		SetAttack(8);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(5);
		SetDamageMin(4);
		SetDamageMax(21);
		SetArmorValue(1);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(1);
		SetDeathNoise(0);
		SetIsHitNoise(2);
		SetWalkAnimation(5);
		SetSwingAnimation(2);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetAttachedWeapon( 225 );
		SetLoot(300, "Loot_DoubleBow", 1, 6 );
		AiDetect();
		SetMob(4);
	}]

	OnDetect[ (s)
	{
		if(GetPlayer().saved_Dstar_Pass = 1 )
		{
			SetAggressive(true);

		}
	}]
}
