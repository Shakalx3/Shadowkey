{
	Init[ (s)
	{
		SetName(1061);
		SetSkin(9);
		SetExpWorth(360);
		SetAggressive(false);
		SetLevel(8);
		SetAttack(7);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(5);
		SetDamageMax(19);
		SetArmorValue(5);
		SetMaxHealth(40);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(3);
		SetDeathNoise(4);
		SetIsHitNoise(5);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetAttachedWeapon( 222 );
		SetLoot( 300, "Bounder_Skin", 1, 4);
		AiDetect();
		SetMob(1);

		if(Level.saved_Guard = 0)
		{
			SetInvulnerable(true);
		}
		else
		{
			SetInvulnerable(false);
		}
	}]

	OnDetect[ (s)
	{
		if(GetPlayer().saved_Dstar_Pass = 1 )
		{
			SetAggressive(true);
		}
	}]
}
