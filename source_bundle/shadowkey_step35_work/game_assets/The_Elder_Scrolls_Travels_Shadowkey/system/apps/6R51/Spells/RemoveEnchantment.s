{
	Init[ (s)
	{
		SetUseText(2481);
		SetName(2481);
		SetRating(22);
		SetItemDescription(2482);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetCost(1600);
		SetMarketValue(560);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2483);
		}
		else
		{
			SetUseText(2484);
		}
	} ]
}