{
	Init[ (s)
	{
		SetName(745);
		SetExpWorth(240);
		SetLevel(5);
		SetSkin(7);
		SetAggressive(false);
		SetAttack(4);
		SetDefense(7);
		SetSpellcast(0);
		SetMagicResistance(5);
		SetDamageMin(3);
		SetDamageMax(9);
		SetArmorValue(3);
		SetMaxHealth(35);
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
		SetUseText(745);
		SetUsable(true);

		SetMob(1);
	}]

	OnHit[ (s)
	{
		Level.Log("Blanden has been hit");
		SetUsable(false);
		SetAggressive(true);
		SetAttachedWeapon( 222 );
	}]

	OnUse[ (s)
	{
		Level.Log("Using On use goto Blanden_convo");
		GetPlayer().OpenMenu("delfhide\\\\Blanden_convo");
	}]

	OnKilled[ (s)
	{
		Level.Log("Set Quest completed 12 -------------------------");
		GetPlayer().SetQuestCompleted(12);
		return;
	}]

}