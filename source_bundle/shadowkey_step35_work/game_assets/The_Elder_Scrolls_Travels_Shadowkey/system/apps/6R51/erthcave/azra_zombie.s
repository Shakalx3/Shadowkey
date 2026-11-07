{
	Init[ (s)
	{
		SetName(1262);
		SetLevel(4);
		SetExpWorth(200);
		SetLevel(4);
		SetAggressive(false);
		SetAttack(4);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(4);
		SetDamageMax(7);
		SetArmorValue(3);
		SetMaxHealth(35);
		SetWimpy(0);
		SetChaseRadius(14000);
		SetAttackNoise(27);
		SetDeathNoise(28);
		SetIsHitNoise(29);

		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		SetUndead(true);
		SetLoot(300, "Loot_Gold5-15", 1, 4 );

		AiDetect();
		SetMob(3);
	} ]

	OnDetect[ (s)
	{
		SetAggressive(true);
		GetPlayer().OpenMenu("erthcave\\\\EC_Menu7");
		AiSleep();
	} ]
}