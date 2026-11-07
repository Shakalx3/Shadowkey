{
	Init[ (s)
	{
		SetName(403);
		SetItemDescription(2979);
		SetRating(2);
		RestrictUse(2, 4, 6, 7);
		SetItemDescription(4002);
		SetIcon( 209 );
		SetMarketValue(112);
		if (GetPlayer().IsItemEnabledFor(self) = true)
		{
			SetUseText(404);
		}
		else
		{
			SetUseText(405);
		}
		SetMPUsable(true);
	} ]

	HitTarget[ (target)
	{
		DoAttackRoll(target, 1);
		//Level.CreateEffect( 12, 19, 1, target.GetPositionX(), target.GetPositionY(), target.GetPositionZ(), 128, 16, 128, 128 );
		//target.DoDamage( Random( 3, ( GetOwner().GetLevel() + 1 ) * 2 ) );
	} ]
}