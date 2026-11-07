{
	Init[ (s)
	{
		SetUseText(2428);
		SetName(2428);
		SetRating(10);
		SetItemDescription(2429);
		RestrictUse(4);
		SetIcon( 209 );
		SetCost(5300);
		SetMarketValue(1855);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2430);
		}
		else
		{
			SetUseText(2431);
		}
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target, 7);
	} ]

}