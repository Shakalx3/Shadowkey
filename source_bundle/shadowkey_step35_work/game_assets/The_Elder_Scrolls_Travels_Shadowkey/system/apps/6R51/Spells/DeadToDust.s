{
	Init[ (s)
	{
		SetUseText(2424);
		SetName(1531);
		SetShortName(2425);
		SetRating(9);
		SetItemDescription(2426);
		RestrictUse(2,7);
		SetIcon( 209 );
		SetCost(1100);
		SetMarketValue(385);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2424);
		}
		else
		{
			SetUseText(2427);
		}
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target, 5);
	} ]
}