{
	saved_aggro[0]

	Init[ (s)
	{
		if (saved_aggro = 0)
		{
			SetAggressive(false);
			SetUsable(true);
			AiDetect();
		}

		SetSkin(0);
		SetName(905);
		SetID("grell");
		SetExpWorth(140);
		SetAttack(5);
		SetDefense(5);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(3);
		SetDamageMax(8);
		SetArmorValue(3);
		SetMaxHealth(35);
		SetWimpy(0);
		SetChaseRadius(9000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
		SetSwingAnimation(1);
		SetDeathAnimation(6);
		SetIdleAnimation(8);
		PlayAnimation(8);

		SetAttachedWeapon(226);
		SetUseText(906);

		SetLoot( 300, "Loot_Gold");
	}]


	OnUse[ (s)
	{
		GetPlayer().OpenMenu("delfhide\\\\Grell_Convo");
	} ]

	OnHit[ (s)
	{
		SetAggressive(true);
		SetUsable(false);
		saved_aggro=1;
	}]
}