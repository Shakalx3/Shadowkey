{
	Init[ (s)
	{
		SetUseText(2488);
		SetName(2488);
		SetRating(24);
		SetItemDescription(2489);
		RestrictUse(4, 6, 7);
		SetIcon( 209 );
		SetCost(710);
		SetMarketValue(249);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2490);
		}
		else
		{
			SetUseText(2491);
		}
		SetRefireRate(768); //3 secs
	} ]
}