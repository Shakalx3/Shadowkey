{
	Init[ (s)
	{
		SetUseText(2496);
		SetName(2496);
		SetRating(26);
		SetItemDescription(2497);
		RestrictUse(2, 4, 6, 7);
		SetIcon( 209 );
		SetCost(1340);
		SetMarketValue(469);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(2498);
		}
		else
		{
			SetUseText(2499);
		}
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target,14);
			//seconds = GetOwner().GetLevel() + 8;
			//target.AddEffect(Timed, Attack, Increment, -10, seconds);
	} ]
}