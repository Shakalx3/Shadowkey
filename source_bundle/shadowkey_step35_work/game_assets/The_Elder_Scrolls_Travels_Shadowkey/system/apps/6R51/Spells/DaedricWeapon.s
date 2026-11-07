{
	Init[ (s)
	{
		SetUseText(2420);
		SetName(2421);
		SetRating(8);
		SetItemDescription(2422);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );

		SetCost(420);
		SetMarketValue(147);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2420);
		}
		else
		{
			SetUseText(2423);
		}
	} ]
}