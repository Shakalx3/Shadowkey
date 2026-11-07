{
	Init[ (s)
	{
		SetName(406);
		SetExpWorth(160);
		SetLevel(3);
		SetAggressive(true);
		SetAttack(3);
		SetDefense(5);
		SetSpellcast(5);
		SetMagicResistance(5);
		SetDamageMin(2);
		SetDamageMax(6);
		SetArmorValue(2);
		SetMaxHealth(30);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(6);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
		SetSwingAnimation(3);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(8);
		SetPlaySpellCasting(true);

		//add blaze and blind spells
		Item = Level.CreateEntity( 50 );
		AddSpell( Item, 50 );
		Item.SetLevel(4);
		Item = Level.CreateEntity( 4010 );
		AddSpell( Item, 50 );
		Item.SetLevel(8);

		SetLoot( 300, "Loot_Gold", 1, 2);
		SetMob(2);

	} ]

	OnKilled [ (s)
	{
		GetPlayer().AddMonsterKilled(101);
		if (GetPlayer().MonstersKilled(101) >= 7)
		{
			GetPlayer().SetQuestSolved(31);
		}
	} ]
}