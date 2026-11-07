{
	Init[ (s)
	{
		SetUseText(747);
		SetUsable(true);
	} ]

	OnUse[ (s)
	{
		if( GetPlayer().HasItem("cellkey") )
		{
			DestroyObjectMirror( self );
		}
	} ]
}