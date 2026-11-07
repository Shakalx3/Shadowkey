{
	Init[ (s)
	{
		SetUseText(3560);
		SetName(3560);
		SetItemDescription(3561);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetRating(28);
		SetCost(5000);
		SetMarketValue(1977);
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
}