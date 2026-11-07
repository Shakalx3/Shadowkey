{
	Init[ (s)
	{
		SetMaxHealth(100);
		SetSkin(2);
		SetExpWorth(440);

		SetName(945);
		SetLevel(8);
		SetAggressive(true);
		SetAttack(7);
		SetDefense(7);
		SetSpellcast(0);
		SetMagicResistance(7);
		SetDamageMin(8);
		SetDamageMax(18);
		SetArmorValue(7);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(2);
		SetDeathNoise(3);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetAttachedWeapon( 226 );

		SetMob(1, 2);
	} ]

	OnDecay[()
	{
		if( not Level.IsMultiplayerClient() )
		{
			GetPlayer().OpenMenu("dstar_e\\\\Pit_Boss_reward");
			Level.saved_pitopen = 2;
			Level.saved_CountMonster = 2;
		}
	}]

}