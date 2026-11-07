{
	Init[ (s)
	{
		SetName(2155);
		SetSkin(0);
		SetID("yeln");
		SetUseText(2155);
		SetUsable(true);
		SetExpWorth(280);
		SetAggressive(false);
		SetLevel(6);
		SetAttack(125);
		SetDefense(225);
		SetSpellcast(30);
		SetMagicResistance(3);
		SetDamageMin(4);
		SetDamageMax(18);
		SetArmorValue(3);
		SetMaxHealth(35);
		SetWimpy(5);
		SetChaseRadius(18000);
		//SetAttackRange(3000);
		
		SetAttackNoise(3); //6
		SetDeathNoise(0);
		SetIsHitNoise(38);

		SetWalkAnimation(4);
		SetSwingAnimation(3);
		SetDeathAnimation(6);
		PlayAnimationOffset(8);
		SetIdleAnimation(8);
		SetLoot( 300, "loot_gold25-35");

		//Item = Level.CreateEntity( 50 );
		//AddSpell( Item, 75 );
		//Item.SetLevel(6);
		//Item = Level.CreateEntity( 4010 );
		//AddSpell( Item, 100 );
		//Item.SetLevel(10);

		SetMob(1, 2);
		SetBoss(true);

	} ]

	OnUse[ (s)
	{
		if ((Level.saved_Dead_Wulfbris = 1) and (GetPlayer().QuestCompleted(35)=true))
		{
			GetPlayer().OpenMenu("raiders\\\\yeln_convo2");
		}
		else
		{
			if ((Level.saved_NoQuest_Wulfbris = 1) and (GetPlayer().QuestAssigned(35)=false))
			{
				GetPlayer().OpenMenu("raiders\\\\yeln_convo2");
			}
			else
			{
				GetPlayer().OpenMenu("raiders\\\\yeln_convo");
			}
		}
	}]
	OnDecay[ (s)
	{
		Level.saved_NoQuest_Yelnicin = 1;
		GetPlayer().SetQuestSolved(34);
		if (GetPlayer().QuestAssigned(35)=true)
		{

			GetPlayer().SetQuestCompleted(35);
		}
	}]

	OnHit[ (s)
	{
		SetUsable(false);
	}]
}