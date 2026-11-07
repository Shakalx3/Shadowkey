{
	saved_Charges[0]
	Init[ (s)
	{
		SetUseText(2985);
		SetName(2985);
		SetID("skelkey");
		SetIcon(218);
		SetItemDescription(3887);
		SetCost(2500);
		SetMarketValue( 500 );
	} ]

	UseCharge[ (s)
	{
		saved_Charges = saved_Charges + 1;
		if(saved_Charges = 5)
		{
			GetPlayer().RemoveItem(self);
			GetPlayer().OpenMenu("keybroken");
		}
	}]
}