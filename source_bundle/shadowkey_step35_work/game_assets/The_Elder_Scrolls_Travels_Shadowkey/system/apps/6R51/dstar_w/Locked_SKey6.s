{
	saved_Open [0]

	Init[ (s)
	{
		SetUseText(3403);
		if (saved_Open = 1)
		{
			UnlockZone("sdoor6");
		}
	}]

	OnUse[ (s)
	{
		if( saved_Open = 0 )
		{

			if(GetPlayer().FindInventory( "skey7" ) != null)
			{
				Door = Level.GetEntity("sdoor01");
				Door.DestroyObjectMirror(Door);
				Level.saved_doorA=1;
				return;
			}
			else
			{
				OpenMenu("dstar_w\\\\Skey6_convo");
			}
		}
	} ]

	MenuQuit[ (s)
	{
		Quit();
	}]
}