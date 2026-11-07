{
	DoneBefore [0]

	Init[ (s)
	{
		SetName(1263);
		SetUseText(1264);
		SetUsable(true);
	} ]

	OnUse[ (s)
	{
		if( DoneBefore = 0 )
		{
			GetPlayer().OpenMenu("erthcave\\\\EC_Menu8");
			DoneBefore = 1;
		}
	} ]
}