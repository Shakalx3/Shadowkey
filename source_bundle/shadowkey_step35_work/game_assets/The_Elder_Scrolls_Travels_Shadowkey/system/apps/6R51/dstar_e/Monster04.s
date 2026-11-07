{
	Init[ (s)
	{
		SetMaxHealth(200);
	        SetSkin(4);
	        SetExpWorth(220);

		SetName(2146);
		SetLevel(10);
		SetAggressive(true);
		SetAttack(9);
		SetDefense(9);
		SetSpellcast(9);
		SetMagicResistance(7);
		SetDamageMin(10);
		SetDamageMax(15);
		SetArmorValue(9);
		SetWimpy(2);
		SetChaseRadius(18000);
		SetAttackNoise(2);
		SetDeathNoise(3);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetAttachedWeapon( 226 );

		SetMob(1, 5);
	} ]

	OnDecay[()
	{
		if( not Level.IsMultiplayerClient() )
		{
			GetPlayer().OpenMenu("dstar_e\\\\Pit_Boss_reward");
			Level.saved_pitopen = 4;
			Level.saved_CountMonster = 4;
		}
	}]

}