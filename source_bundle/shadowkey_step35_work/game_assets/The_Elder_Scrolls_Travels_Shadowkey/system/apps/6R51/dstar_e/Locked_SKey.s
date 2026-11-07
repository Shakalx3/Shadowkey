{
	saved_Open [0]

	Init[ (s)
	{
		SetUseText(3403);		
	} ]

	OnUse[ (s)
	{
		if( saved_Open = 0 )
		{

			if(GetPlayer().FindInventory( "skey6" ) != null)
			{

				Door = Level.GetEntity("sdwdoor");
				Door.DestroyObjectMirror(Door);
				Level.saved_OpenSwdoor=1;
				return;
			}
			else
			{
				OpenMenu("dstar_e\\\\ShadowDoorLcked");
			}
		}
	}]
}