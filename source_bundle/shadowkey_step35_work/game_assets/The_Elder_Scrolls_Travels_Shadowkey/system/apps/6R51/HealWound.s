{
	Init[ (s)
	{
		SetUseText(1582);
		SetUsable(true);
		SetName(1582);
		SetRating(18);
		SetItemDescription(2980);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(1581);
		}
		else
		{
			SetUseText(1581);
		}
	} ]

}