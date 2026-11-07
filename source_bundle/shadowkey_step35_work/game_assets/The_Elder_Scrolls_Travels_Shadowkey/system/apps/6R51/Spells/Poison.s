{

	Init[ (s)
	{
		SetUseText(2473);
		SetName(2473);
		SetRating(8);
		SetItemDescription(2474);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );

		SetCost(40);
		SetMarketValue(0);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2475);
		}
		else
		{
			SetUseText(2476);
		}
	}]

	HitTarget[ (target)
	{
		DoAttackRoll(target);
	} ]
}