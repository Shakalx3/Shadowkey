{
	Init[ (s)
	{
		//SetModel(202);
		SetSkin(1);
		SetAggressive(false);
		SetName(745);
		SetID("blanden");
		SetExpWorth(120);
		SetAttack(4);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(3);
		SetDamageMax(10);
		SetArmorValue(1);
		SetMaxHealth(44);
		SetWimpy(0);
		SetChaseRadius(18000);
		SetAttackNoise(3);
		SetDeathNoise(0);
		SetIsHitNoise(38);
		SetWalkAnimation(5);
                SetSwingAnimation(1);
                SetDeathAnimation(6);
                SetIdleAnimation(8);
		PlayAnimation(8);

		SetAttachedWeapon(224);

		AiDetect();

		SetUseText(745);
		SetUsable(true);
	}]

	OnHit[(s)
	{
		SetUsable(false);
	}

	OnUse[ (s)
	{
		GetPlayer().OpenMenu("delfhide\\\\Blanden_convo");
	} ]

	OnKilled[ (s)
	{
		Level.Log("Set Quest completed 12 -------------------------");
		GetPlayer().SetQuestCompleted(12);
		return;
	}]

	OnDecay{ (s)
	{
		Level.Log("On Decay-------------Set Quest completed 12 -------------------------");
		GetPlayer().SetQuestCompleted(12);
		return;
	}]
}