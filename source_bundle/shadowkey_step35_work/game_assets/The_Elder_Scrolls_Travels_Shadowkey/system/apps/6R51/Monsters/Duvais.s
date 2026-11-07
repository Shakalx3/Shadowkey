{
	Init[ (s)
	{
		SetName(2054);
		SetExpWorth(500);
		SetLevel(4);
		SetAggressive(false);
		SetAttack(60);
		SetDefense(85);
		SetSpellcast(0);
		SetMagicResistance(60);
		SetDamageMin(25);
		SetDamageMax(35);
		SetArmorValue(1);
		SetMaxHealth(225);
		SetWimpy(5);
		SetChaseRadius(18000);
		ShowEntity(false);
		SetPassable(true);
		SetUsable(false);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);

		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(0);
		PlayAnimationOffset(8);

		SetSkin(2);
		SetInvulnerable(true);
		SetLoot( 300, "Loot_ShadowKey8" );
		SetBoss(true);
		AiSleep();

	}]
	
	RevealSelf[ ()
	{
		ShowEntity(true);
		SetPassable(false);
		SetUsable(false);
		SetAggressive(true);
		SetInvulnerable(false);
		Level.saved_Wake = 1;	
	}]

	OnKilled[()
	{
		GetPlayer().SetQuestSolved(39);
	}]

	OnDetect[ (s)
	{
		OpenMenu("lothna\\\\Duvais_convo");
	}]

}
