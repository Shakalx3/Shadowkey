{
	Init[ (s)
	{
		SetName(2154);
		SetID("wulfbrs");
		SetSkin(12);
		SetUseText(2154);
		SetUsable(true);
		SetExpWorth(280);
		SetAggressive(false);
		SetLevel(6);
		SetAttack(7);
		SetDefense(4);
		SetSpellcast(0);
		SetMagicResistance(3);
		SetDamageMin(4);
		SetDamageMax(18);
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
		SetAttachedWeapon(226);
		SetLoot( 300, "loot_gold25-35");

		SetMob(1);
	} ]

	OnUse[ ()
	{
		if ((Level.saved_Dead_Devron = 1) and (GetPlayer().QuestCompleted(33)=true))
		{
			GetPlayer().OpenMenu("raiders\\\\wulfbris_convo2");
		}
		else
		{
			if ((Level.saved_NoQuest_Devron = 1) and (GetPlayer().QuestAssigned(33)=false))
			{
				GetPlayer().OpenMenu("raiders\\\\wulfbris_convo2");
			}
			else
			{
				GetPlayer().OpenMenu("raiders\\\\wulfbris_convo");
			}
		}
	}]
	OnDecay[ ()
	{
		Level.saved_NoQuest_Wulfbris = 1;
		GetPlayer().SetQuestSolved(35);
		if (GetPlayer().QuestAssigned(33)=true)
		{
			GetPlayer().SetQuestCompleted(33);
		}
	}]

	OnHit[ ()
	{
		SetUsable(false);
	}]
}
