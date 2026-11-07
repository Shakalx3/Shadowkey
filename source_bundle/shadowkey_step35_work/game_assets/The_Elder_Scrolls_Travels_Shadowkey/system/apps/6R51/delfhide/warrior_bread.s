{
	Init[ (s)
	{
		SetName(933);
		SetShortName(1776);
		SetUsable( true );
		SetUseText(935);
		SetCost( 25 );
		SetMarketValue( 9 );
		SetItemDescription(1777);
		SetIcon(212);
	} ]

	OnUse[ (s)
	{
		curFatigue = GetOwner().GetFatigue();
		GetOwner().SetFatigue( curFatigue + 40 );
		curHealth = GetOwner().GetHealth();
		GetOwner().SetHealth( curHealth + 10 );
		GetOwner().PlaySound(87);
		DestroyObject(self);
	} ]
}