{
	Init[ (s)
	{
		SetUseText(1937);
		SetExpWorth(0);
		SetLevel(5);
		SetAggressive(false);
		SetAttack(0);
		SetDefense(0);
		SetSpellcast(0);
		SetMagicResistance(0);
		SetDamageMin(0);
		SetDamageMax(0);
		SetArmorValue(0);
		SetMaxHealth(0);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(2);
		SetDeathNoise(3);
		SetWalkAnimation(0);
		SetSwingAnimation(0);
		SetDeathAnimation(0);
		SetIdleAnimation(0);
		PlayAnimationOffset(0);
		SetInvulnerable(true);
	}]

	OnUse[ (s)
	{

		if (Level.saved_AssQuest44 = 1)
		{
			OpenMenu("lothna\\\\get_quest400_convo");
		}

		if (Level.saved_DeadGone = 1)
		{
			OpenMenu("lothna\\\\get_quest44_convo");
		}

		if (Level.saved_TookQuest43 = 1)
		{
			OpenMenu("lothna\\\\pilgrim_convo");
		}
		if (Level.saved_Quest43Done = 0)
		{
			OpenMenu("lothna\\\\get_quest43_convo");
		}

	}]
}
