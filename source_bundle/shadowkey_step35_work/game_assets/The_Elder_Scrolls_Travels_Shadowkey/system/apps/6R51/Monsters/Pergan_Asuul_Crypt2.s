{
	Init[ (s)
	{
		SetName(1842);
		SetExpWorth(2500);
		SetLevel(22);
		SetAggressive(false);
		SetAttack(125);
		SetDefense(225);
		SetSpellcast(30);
		SetMagicResistance(175);
		SetDamageMin(60);
		SetDamageMax(75);
		SetArmorValue(1);
		SetMaxHealth(450);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(18);
		SetDeathNoise(19);
		SetIsHitNoise(20);
		SetWalkAnimation(3);
		SetSwingAnimation(6);
		SetDeathAnimation(8);
		SetIdleAnimation(1);
		PlayAnimationOffset(0);
		SetUseText(1842);
		SetUsable(true);
		SetSkin(2);
		SetScale(256);
		SetInvulnerable(true);

		Item = Level.CreateEntity( 4024 ); //ignite foe
		Item.SetLevel(12);
		AddSpell( Item, 35 ); //25% of the time
		Item = Level.CreateEntity( 4009 ); //absorb
		Item.SetLevel(14);
		AddSpell( Item, 70 ); //25% of the time
		Item = Level.CreateEntity( 4025 ); //paralyze
		Item.SetLevel(8);
		AddSpell( Item, 100 ); //50%

		SetBoss(true);
		SetMeleeRoll(60);;
	} ]

	OnUse[ ()
	{
		OpenMenu("crypt2\\\\PergunAsuul_Convo");
	}]

	OnKilled[()
	{
		Level.saved_PergunDeath = 1;
	}]
}
