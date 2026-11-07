{
	Init[ (s)
	{
		SetInvulnerable( true );
		SetName(1471);
		SetUseText(1471);
		SetExpWorth(0);
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
		SetWalkAnimation(0);
		SetSwingAnimation(0);
		SetDeathAnimation(0);
		SetIdleAnimation(0);
		PlayAnimation(0);
	} ]

	OnUse[ (s)
	{
		cameo = GetPlayer().FindInventory("cameo");
		if (cameo != null)
		{
			GetPlayer().SetQuestAssigned(17);
			GetPlayer().SetQuestCompleted(17);
			GetPlayer().RemoveItem(cameo);
		}
		
		GetPlayer().OpenMenu("ghstpass\\\\Violet_convo");		
	} ]
}
