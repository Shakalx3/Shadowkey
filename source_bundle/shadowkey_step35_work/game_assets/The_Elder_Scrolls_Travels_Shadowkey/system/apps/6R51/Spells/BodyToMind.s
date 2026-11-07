{
	Init[ (s)
	{
		SetUseText(2408);
		SetName(2408);
		SetRating(5);
		SetItemDescription(2409);
		RestrictUse(2, 6, 7);
		SetIcon( 209 );
		SetCost(800);
		SetMarketValue(280);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2410);
		}
		else
		{
			SetUseText(2411);
		}
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]
}