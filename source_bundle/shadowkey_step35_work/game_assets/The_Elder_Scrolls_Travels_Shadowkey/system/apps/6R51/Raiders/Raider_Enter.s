{
	Init[ (s)
	{
		SetName(945);
		SetUseText(945);
		SetSkin(0);
		SetExpWorth(240);
		SetAggressive(false);
		SetAttack(7);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(4);
		SetDamageMax(18);
		SetArmorValue(3);
		SetMaxHealth(35);
		SetWimpy(5);
		SetChaseRadius(10000);

		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);

		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(7);
		PlayAnimationOffset(8);
		SetAttachedWeapon( 226 );
		AiDetect();
		SetMob(1);

	} ]

	OnDetect[ (s)
	{
		if(Level.saved_EnterGuard = 0)
		{
			GetPlayer().OpenMenu("Raiders\\\\enter");
			AiSleep();
		}
	}]

	OnHit[ ()
	{
		SetAggressive(true);
		AM = GetPlayer().FindInventory("redam");
		if( AM != null )
		{
			return;
		}
		else
		{
			SetLoot( 300, "Raiders\\\\Loot_RedEnter" );
		}
	}]

}