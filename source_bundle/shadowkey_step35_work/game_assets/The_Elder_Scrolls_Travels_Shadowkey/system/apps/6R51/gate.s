{
	saved_Open [0]

	Init[ (s)
	{
		SetUseText(1427);
	} ]

	RaiseDoor[ (s)
	{
		if( saved_Open = 0 )
		{
			// the door is closed.  open it!
			GetPlayer().PlaySound( 63 );
			x=GetPositionX();
			y=GetPositionY();
			z=GetPositionZ() + 1200;
			SetPosition(x,y,z);
			saved_Open = 1;
			DoorOpened(self,1,0); //replicate door open  1 for open, 0 for normal door
			return;
		}
		if( saved_Open = 1 )
		{
			// the door is open, close it!
			GetPlayer().PlaySound( 62 );
			x=GetPositionX();
			y=GetPositionY();
			z=GetPositionZ() - 1200;
			SetPosition(x,y,z);
			saved_Open = 0;
			DoorOpened(self,0,0); //replicate door open  0 for closed, 0 for normal door
			return;
		}
	} ]
}