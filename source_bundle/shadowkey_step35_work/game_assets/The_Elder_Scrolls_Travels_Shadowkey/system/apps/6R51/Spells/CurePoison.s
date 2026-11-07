{
	Init[ (s)
	{
		SetUseText(2416);
		SetName(2417);
		SetRating(7);
		SetItemDescription(2418);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetCost(1460);
		SetMarketValue(511);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2416);
		}
		else
		{
			SetUseText(2419);
		}
	} ]
}