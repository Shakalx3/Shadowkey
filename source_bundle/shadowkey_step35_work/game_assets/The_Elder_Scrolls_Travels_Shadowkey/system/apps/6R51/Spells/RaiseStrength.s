{
	Init[ (s)
	{
		SetUseText(2477);
		SetName(2477);
		SetRating(21);
		SetItemDescription(2478);
		RestrictUse(2, 4, 7, 6);
		SetIcon( 209 );
		SetCost(1100);
		SetMarketValue(385);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2479);
		}
		else
		{
			SetUseText(2480);
		}
	} ]
}