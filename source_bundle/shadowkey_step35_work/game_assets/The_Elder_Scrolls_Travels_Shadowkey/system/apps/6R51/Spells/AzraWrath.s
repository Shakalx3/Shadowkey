{
	Init[ (s)
	{
		SetUseText(3558);
		SetName(3558);
		SetItemDescription(3559);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetRating(27);
		SetCost(5000);
		SetMarketValue(1910);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2399);
		}
		else
		{
			SetUseText(2400);
		}
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target, 15);
	} ]
}