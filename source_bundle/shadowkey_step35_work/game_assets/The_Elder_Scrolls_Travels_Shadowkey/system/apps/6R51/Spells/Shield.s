{

	Init[ (s)
	{
		SetUseText(2492);
		SetName(2492);
		SetRating(25);
		SetItemDescription(2493);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetCost(1300);
		SetMarketValue(455);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2494);
		}
		else
		{
			SetUseText(2495);
		}
	}]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]
}