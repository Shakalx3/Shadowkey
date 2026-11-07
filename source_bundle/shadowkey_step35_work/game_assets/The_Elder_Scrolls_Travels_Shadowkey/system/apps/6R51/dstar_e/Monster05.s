{
	Init[ (s)
	{
		SetMaxHealth(300);
		SetSkin(5);
		SetExpWorth(1200);

		SetName(945);
		SetLevel(14);
		SetAggressive(true);
		SetAttack(50);
		SetDefense(10);
		SetSpellcast(10);
		SetMagicResistance(10);
		SetDamageMin(20);
		SetDamageMax(30);
		SetArmorValue(10);
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

		SetMob(1, 7);
	} ]

	OnDecay[()
	{
		if( not Level.IsMultiplayerClient() )
		{
			GetPlayer().OpenMenu("dstar_e\\\\Pit_Boss_reward");
			Level.saved_pitopen = 5;
			Level.saved_CountMonster = 5;
		}
	}]

}