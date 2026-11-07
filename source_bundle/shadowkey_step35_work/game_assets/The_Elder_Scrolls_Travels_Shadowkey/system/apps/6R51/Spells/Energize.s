{
	Init[ (s)
	{
		SetUseText(2444);
		SetName(2444);
		SetRating(13);
		SetItemDescription(2445);
		RestrictUse(2, 6);
		SetIcon( 209 );
		SetCost(250);
		SetMarketValue(88);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2446);
		}
		else
		{
			SetUseText(2447);
		}
	} ]

	OnUse[ (s)
	{
		GetPlayer().EquipItem( 0, self );
	} ]

}