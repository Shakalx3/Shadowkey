{
	Init[ (s)
	{
		SetUseText(2464);
		SetName(2464);
		SetShortName(2465);
		SetRating(19);
		SetItemDescription(2466);
		RestrictUse(2,7, 6, 4);
		SetIcon( 209 );
		SetCost(4200);
		SetMarketValue(1470);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2467);
		}
		else
		{
			SetUseText(2468);
		}

		SetCost(5253);
		SetMarketValue(1839);
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]


	HitTarget[ (target)
	{
		DoAttackRoll(target,6);
	} ]
}