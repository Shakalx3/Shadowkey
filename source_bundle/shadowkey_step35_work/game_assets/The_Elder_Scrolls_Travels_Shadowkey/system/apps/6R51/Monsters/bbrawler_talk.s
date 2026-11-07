{
	Init[ (s)
	{
		//SetModel(202);
		SetUseText(400);
		SetSkin(6);
		SetName(399);
		SetID("bbrawler");
		SetExpWorth(100);
		SetAttack(5);
		SetDefense(3);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(2);
		SetDamageMax(8);
		SetArmorValue(2);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(5); 	// Ratfury
		SetDeathNoise(6);	// Ratdies
		SetWalkAnimation(5);
                SetSwingAnimation(1);
                SetDeathAnimation(6);
                SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetLoot(300, "Loot_Gold6-10", 1, 2 );
		SetAttachedWeapon(226);

		// Try to detect the player, but do not attack.
		// Instead, if a non-aggressive NPC detects the player,
		// OnDetect will be called!
		SetAggressive(false);
		AiDetect();

		SetMob(1);
	} ]

	OnUse[ (s)
	{
		//OpenMenu("Acolyte Menlin");
		OpenMenu("Talker");
	} ]


	OnDetect[ (s)
	{
		// The player must be within my chase radius.
		// Talk to him, then kill him.
		OpenMenu("Talker");
		AiSleep();
	} ]

	MenuClosed[ (s)
	{
		SetAggressive( true );
		AiDetect();
	} ]






}