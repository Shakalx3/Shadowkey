{
	Init[ (s)
	{
		SetName(1842);
		SetExpWorth(750);
		SetLevel(10);
		SetAggressive(false);
		SetAttack(30);
		SetDefense(70);
		SetSpellcast(10);
		SetMagicResistance(50);
		SetDamageMin(15);
		SetDamageMax(25);
		SetArmorValue(1);
		SetMaxHealth(150);
		SetWimpy(5);
		SetChaseRadius(18000);
		SetAttackNoise(18);
		SetDeathNoise(19);
		SetIsHitNoise(20);
		SetWalkAnimation(3);
		SetSwingAnimation(6);
		SetDeathAnimation(8);
		SetIdleAnimation(1);
		PlayAnimationOffset(0);
		//SetUseText(1842);
		SetSkin(0);
		SetScale(256);
		SetPlaySpellCasting(true);
		//AiDetect();

		Item = Level.CreateEntity( 4009 ); //absorb
		Item.SetLevel(10);
		AddSpell( Item, 75 ); //25% of the time
		Item = Level.CreateEntity( 4025 ); //paralyze
		Item.SetLevel(5);
		AddSpell( Item, 100 ); //50%

		SetMeleeRoll(60);
		SetBoss(true);
	} ]

	OnDetect[ ()
	{
		SetAggressive(true);
		GetPlayer().OpenMenu("twilite\\\\pergan_convo");
		//SetUsable(false);
		//SetInvulnerable(false);
		SetAggressive(true);
		//AiSleep();
	}]

	OnDecay[(s)
	{	
		GetPlayer().SetQuestSolved(20);
		if (not IsMultiplayerClient())
		{
			if (GetPlayer().IsMenuActive() = false)
			{
				GetPlayer().OpenMenu("twilite\\\\pergan_convo2");
			}
			else
			{
				//just give the host the items and set his quest complete				
				Item = Level.CreateEntity( 910 );
				GetPlayer().PickupItem( Item );
			}
		}
		else
		{
			GetPlayer().OpenMenu("twilite\\\\pergan_convo2");
		}
	}]
}
