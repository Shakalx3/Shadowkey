{
	Init[ (s)
	{
		SetName(2101);
		SetSkin(4);
		SetUseText(2101);
		SetUsable(true);
		SetInvulnerable(true);
		SetExpWorth(320);
		SetAttachedWeapon(224);
		SetLevel(7);
		SetAggressive(false);
		SetAttack(4);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(5);
		SetDamageMin(6);
		SetDamageMax(8);
		SetArmorValue(2);
		SetMaxHealth(40);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimationOffset(0);

		SetMob(1);
	} ]

	OnUse[(s)
	{
		OpenMenu("broken1\\\\makor_temp_convo");
	}]

	OnDecay[ (s)
	{
		GetPlayer().SetQuestCompleted(233);
	}]
}
