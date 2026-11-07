{
	Init[ (s)
	{
		SetUseText(2432);
		SetName(2432);
		SetRating(5);
		SetItemDescription(2433);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetCost(1500);
		SetMarketValue(250);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2434);
		}
		else
		{
			SetUseText(2435);
		}
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target);
	} ]
}