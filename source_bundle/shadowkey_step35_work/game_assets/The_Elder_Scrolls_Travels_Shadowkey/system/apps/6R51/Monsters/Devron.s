{
	Init[ ()
	{
		SetName(2049);
		SetSkin(11);
		SetID("devron");
		SetUseText(2049);
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

		SetAttachedWeapon(224);
		SetLoot( 300, "loot_gold25-35");

		SetMob(1);
	}]

	OnUse[ ()
	{
		if ((Level.saved_Dead_Yelnicin = 1) and (GetPlayer().QuestCompleted(34)=true))
		{
			GetPlayer().OpenMenu("raiders\\\\devron_convo2");
		}
		else
		{
			if ((Level.saved_NoQuest_Yelnicin = 1) and (GetPlayer().QuestAssigned(34)=false))
			{
				GetPlayer().OpenMenu("raiders\\\\devron_convo2");
			}
			else
		        {
				GetPlayer().OpenMenu("raiders\\\\devron_convo");
			}
		}
	}]

	OnDecay[ ()
	{
		Level.saved_NoQuest_Devron = 1;
		GetPlayer().SetQuestSolved(33);
		if (GetPlayer().QuestAssigned(33)=true)
		{
			GetPlayer().SetQuestCompleted(34);
		}
	}]

	OnHit[ ()
	{
		SetUsable(false);
	}]
}
