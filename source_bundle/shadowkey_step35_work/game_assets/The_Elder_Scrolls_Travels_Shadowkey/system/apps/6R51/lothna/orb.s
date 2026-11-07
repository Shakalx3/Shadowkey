{	
	saved_GaveGift[0]
	
	Init[ (s)
	{
		SetUseText(1928);
		SetName(1928);	
		SetUsable( true );	
	} ]

	OnUse[ (s)
	{		
		if (saved_GaveGift = 0)
		{
			OpenMenu("lothna\\\\treasure_menu");		
			saved_GaveGift=1;
		}
	} ]
}