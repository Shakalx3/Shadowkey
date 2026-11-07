{

	Init[ (s)
	{
		SetUseText(2456);
		SetName(2456);
		SetRating(16);
		SetItemDescription(2457);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetCost(2340);
		SetMarketValue(819);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2458);
		}
		else
		{
			SetUseText(2459);
		}
	}]
}