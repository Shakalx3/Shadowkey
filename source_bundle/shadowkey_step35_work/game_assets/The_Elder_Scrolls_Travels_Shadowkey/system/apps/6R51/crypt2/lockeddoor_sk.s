{
	saved_Open [0]

	Init[ (s)
	{
		SetUseText(3403);
	} ]

	OnUse[ (s)
	{
		if (saved_Open = 0)
		{
			GetPlayer().OpenMenu("crypt2\\\\skdoor");

			skey1 = GetPlayer().FindInventory("skey1");
			skey2 = GetPlayer().FindInventory("skey2");
			skey3 = GetPlayer().FindInventory("skey3");
			skey4 = GetPlayer().FindInventory("skey4");
			skey5 = GetPlayer().FindInventory("skey5");
			skey6 = GetPlayer().FindInventory("skey6");
			skey7 = GetPlayer().FindInventory("skey7");
			skey8 = GetPlayer().FindInventory("skey8");
			skey9 = GetPlayer().FindInventory("skey9");
			skey10 = GetPlayer().FindInventory("skey10");
			skey11 = GetPlayer().FindInventory("skey11");
			if( skey1 != null or skey2 != null or skey3 != null or skey4 != null or skey5 != null or skey6 != null or skey7 != null or skey8 != null or skey9 != null or skey10 != null or skey11 != null )
			{
				OpenDoor();
			}
			else
			{
				GetPlayer().OpenMenu("crypt2\\\\NeedSKMore");
			}
		}
	}]

	OpenDoor[ ()
	{
		SkDoor = Level.GetEntity("skdoor");
		SkDoor = DestroyObjectMirror(SkDoor);
		Level.saved_Swdoor=1;
		//saved_bCanOpen=true;
                //
		//if( saved_Open = 0 )
		//{
		//	if (saved_bCanOpen = true)
		//	{
		//		// the door is closed.  open it!
		//		GetPlayer().PlaySound( 63 );
		//		SetPassable( true );
		//		AddRotationTurn( -64*256 );
		//		SetPassable( true );
		//		saved_Open = 1;
		//		DoorOpened(self,1,0); //replicate door open  1 for open, 0 for normal door
		//		SetUsable(false);
		//		SetUseText(714);
		//		return;
		//	}
		//}
	} ]
}