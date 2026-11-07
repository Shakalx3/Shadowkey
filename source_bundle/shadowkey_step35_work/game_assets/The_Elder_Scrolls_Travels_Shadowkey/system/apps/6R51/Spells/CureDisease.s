{
	Init[ (s)
	{
		SetUseText(2412);
		SetName(2413);
		SetRating(6);
		SetItemDescription(2414);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetCost(800);
		SetMarketValue(280);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2412);
		}
		else
		{
			SetUseText(2415);
		}
	} ]
}