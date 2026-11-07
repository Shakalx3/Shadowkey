{
	Init[ (s)
	{
		SetMaxHealth(150);
		SetSkin(3);
		SetExpWorth(520);

		SetName(2122);
		SetLevel(8);
		SetAggressive(true);
		SetAttack(8);
		SetDefense(8);
		SetSpellcast(0);
		SetMagicResistance(8);
		SetDamageMin(9);
		SetDamageMax(15);
		SetArmorValue(20);
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

		SetMob(1, 3);
	} ]

	OnDecay[()
	{
		if( not Level.IsMultiplayerClient() )
		{
			GetPlayer().OpenMenu("dstar_e\\\\Pit_Boss_reward");
			Level.saved_pitopen = 3;
			Level.saved_CountMonster = 3;
		}
	}]

}