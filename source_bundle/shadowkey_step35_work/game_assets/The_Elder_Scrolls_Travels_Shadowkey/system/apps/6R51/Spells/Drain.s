{
	Init[ (s)
	{
		SetUseText(2440);
		SetName(2440);
		SetRating(12);
		SetItemDescription(2441);
		RestrictUse(2, 4, 7, 6);
		SetIcon( 209 );
		SetCost(500);
		SetMarketValue(175);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2442);
		}
		else
		{
			SetUseText(2443);
		}
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target, 8);
	} ]

}