{
	Init[ (s)
	{
		SetName(2055);
		SetSkin(2);
		SetID("eglar");
		SetAttachedWeapon(222);
		SetExpWorth(280);
		SetAggressive(true);
		SetLevel(6);
		SetAttack(50);
		SetDefense(90);
		SetSpellcast(0);
		SetMagicResistance(40);
		SetDamageMin(20);
		SetDamageMax(30);
		SetArmorValue(1);
		SetMaxHealth(200);
		SetWimpy(5);
		SetChaseRadius(18000);

		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);

		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetBoss(true);
		SetLoot( 300, "Loot_ShadowKey5" );
		//SetUsable(true);
		//AiDetect();
	} ]

	//OnDetect[ ()
	//{
	//	if (Level.saved_Entrance = 0)
	//	{
	//		Level.saved_Entrance = 1;
	//		GetPlayer().OpenMenu("raiders\\\\eglar_convo");
	//	}
	//	AiSleep();
	//}]

	OnKilled[ (s)
	{
		GetPlayer().SetQuestSolved(32);
	}]
}
