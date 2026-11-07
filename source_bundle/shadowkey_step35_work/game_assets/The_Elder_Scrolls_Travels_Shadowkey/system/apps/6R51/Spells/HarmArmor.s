{
	Init[ (s)
	{
		SetUseText(2460);
		SetName(2460);
		SetRating(17);
		SetItemDescription(2461);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetCost(1100);
		SetMarketValue(385);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2462);
		}
		else
		{
			SetUseText(2463);
		}
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target, 11);
	} ]
}