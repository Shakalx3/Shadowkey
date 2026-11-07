{
	Init[ (s)
	{
		SetName(1821);
		SetExpWorth(400);
		SetLevel(9);
		SetSkin(5);

		SetAggressive(true);
		SetAttack(3);
		SetDefense(9);
		SetSpellcast(10);
		SetMagicResistance(10);
		SetDamageMin(0);
		SetDamageMax(0);
		SetArmorValue(4);
		SetMaxHealth(35);
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

		SetLoot( 300, "Loot_2MagickaPotion", 1, 2 );
		//add feeble blade and ignite foe spells
		Item = Level.CreateEntity( 4021 );
		AddSpell( Item, 50 );
		Item.SetLevel(10);
		Item = Level.CreateEntity( 4024 );
		AddInventoryItem( Item );
		AddSpell( Item, 50 );
		Item.SetLevel(8);
	} ]

	OnKilled[ (s)
	{
		GetPlayer().AddMonsterKilled(200);
		if (GetPlayer().MonstersKilled(200) >= 4)
		{
			GetPlayer().SetQuestSolved(155);
		}
	}]
}
