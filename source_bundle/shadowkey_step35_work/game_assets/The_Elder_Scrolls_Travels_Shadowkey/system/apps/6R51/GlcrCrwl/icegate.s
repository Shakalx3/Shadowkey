{
	Init[ (s)
	{
		SetUseText(1555);
	} ]

	RaiseDoor[ (s)
	{
		SetPassable( true );
		GetPlayer().PlaySound( 63 );
		x=GetPositionX() - 128;
		y=GetPositionY() - 128;
		z=GetPositionZ() + 1000;
		SetPosition(x, y, z);
		SetPassable( true );
		//DoorOpened(self,1,1);
	} ]

	LowerDoor[ (s)
	{
		SetPassable(true);
		GetPlayer().PlaySound( 62 );
		x=GetPositionX() - 128;
		y=GetPositionY() - 128;
		z=GetPositionZ() - 1000;
		SetPosition(x + 0,y + 0,z);
		SetPassable(false);
		//DoorOpened(self,0,1);
	}]
}