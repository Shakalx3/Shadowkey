{
	Init[ (s)
	{
		SetName(1262);
		SetExpWorth(160);
		SetAggressive(true);
		SetAttack(4);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(4);
		SetDamageMax(7);
		SetArmorValue(3);
		SetMaxHealth(35);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetSkin(4);
		SetAttackNoise(12);
		SetDeathNoise(31);
		SetIsHitNoise(14);
		SetScale(352);
		SetUndead(true);
		SetWalkAnimation(1);
		SetSwingAnimation(2);
		SetDeathAnimation(3);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		SetLoot(300, "Loot_Gold5-15", 1, 2 );

		if( Level.saved_zombieDusk = 0)
		{
			SetInvulnerable(true);
		}
		else
		{
			SetInvulnerable(false);
		}

		SetMob(3);
	}]

	OnKilled[ (s)
	{
		GetPlayer().AddMonsterKilled(170);
		if (GetPlayer().MonstersKilled(170) >= 2)
		{
			GetPlayer().SetQuestSolved(18);
		}
	}]

}
