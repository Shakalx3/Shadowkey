{
	Init[ (s)
	{
		SetUseText(2485);
		SetName(2485);
		SetRating(23);
		SetItemDescription(2981);
		RestrictUse(2, 4, 6);
		SetIcon( 209 );
		SetCost(4200);
		SetMarketValue(1470);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2486);
		}
		else
		{
			SetUseText(2487);
		}
	} ]
}