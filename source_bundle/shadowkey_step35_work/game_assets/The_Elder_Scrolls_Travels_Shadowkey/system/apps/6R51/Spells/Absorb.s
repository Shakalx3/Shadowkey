{
	Init[ (s)
	{
		SetUseText(2397);
		SetName(2397);
		SetRating(1);
		SetItemDescription(2398);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetCost(2900);
		SetMarketValue(1015);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2399);
		}
		else
		{
			SetUseText(2400);
		}
		SetMPUsable(true);
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target, 0);
	} ]
}