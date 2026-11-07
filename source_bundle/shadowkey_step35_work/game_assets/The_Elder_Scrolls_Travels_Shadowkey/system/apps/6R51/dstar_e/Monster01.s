{
	Init[ (s)
	{
		SetMaxHealth(50);
		SetSkin(0);
		SetExpWorth(340);

		SetName(945);
		SetLevel(6);
		SetAggressive(true);
		SetAttack(6);
		SetDefense(6);
		SetSpellcast(0);
		SetMagicResistance(6);
		SetDamageMin(4);
		SetDamageMax(12);
		SetArmorValue(6);
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

		SetMob(1);
	} ]

	OnDecay[()
	{
		Level.Log("On Decay reached.. Due your thing");
		if( not Level.IsMultiplayerClient() )
		{
			GetPlayer().OpenMenu("dstar_e\\\\Pit_Boss_reward");
			Level.saved_pitopen = 1;
			Level.saved_CountMonster = 1;
		}
	}]

}