{
	victim

	Init[ (s)
	{
		SetUseText(2401);
		SetName(2401);
		SetRating(3);
		SetItemDescription(2402);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetCost(1600);
		SetMarketValue(560);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2403);
		}
		else
		{
			SetUseText(2404);
		}
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target, 3);
	} ]
}