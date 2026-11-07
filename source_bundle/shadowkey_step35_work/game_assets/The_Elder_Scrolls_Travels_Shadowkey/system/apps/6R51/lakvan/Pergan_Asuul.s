{
	saved_aggro[0]

	Init[ (s)
	{
		if (saved_aggro = 0)
		{
			SetAggressive(false);
			SetInvulnerable(true);
			SetUsable(true);
			SetUseText(1842);
		}

		SetName(1842);
		SetExpWorth(1500);
		SetLevel(13);
		SetAttack(60);
		SetDefense(90);
		SetSpellcast(20);
		SetMagicResistance(55);
		SetDamageMin(35);
		SetDamageMax(45);
		SetArmorValue(1);
		SetMaxHealth(250);
		SetWimpy(5);
		SetSkin(1);
		SetScale(256);
		SetChaseRadius(18000);
		SetAttackNoise(18);
		SetDeathNoise(19);
		SetIsHitNoise(20);
		SetWalkAnimation(3);
		SetSwingAnimation(6);
		SetDeathAnimation(8);
		SetIdleAnimation(1);
		PlayAnimationOffset(0);
		SetPlaySpellCasting(true);

		Item = Level.CreateEntity( 4024 ); //ignite foe
		Item.SetLevel(10);
		AddSpell( Item, 25 ); //25% of the time
		Item = Level.CreateEntity( 4009 ); //absorb
		Item.SetLevel(12);
		AddSpell( Item, 50 ); //25% of the time
		Item = Level.CreateEntity( 4025 ); //paralyze
		Item.SetLevel(5);
		AddSpell( Item, 100 ); //50%

		SetMeleeRoll(75);
		SetBoss(true);
	} ]

	OnUse[ ()
	{
		OpenMenu("lakvan\\\\pergan_convo2");
		SetInvulnerable(true);
		SetAggressive(false);
		SetUsable(false);
		saved_aggro=1;
	}]

	OnDecay[(s)
	{
		GetPlayer().OpenMenu("lakvan\\\\pergan_killed");
	}]
}
