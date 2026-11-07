{
	saved_Already[0]
	saved_WendekTalked[0]
	saved_Loopie [0]
	saved_SetZone[0]
	Init[ (s)
	{
		Level.PlayAmbient(73,100);

		if(saved_SetZone = 0)
		{
			SetZone(6, 7000);
			saved_SetZone = 1;
		}

		if(GetPlayer().QuestCompleted(19)=true)
		{
			Goblin1 = GetEntity("goblin1");
			if( isObject( Goblin1 ) )
			{
				Goblin1.DestroyObjectMirror(Goblin1);
			}

			Goblin2 = GetEntity("goblin2");
			if( isObject( Goblin2 ) )
			{
				Goblin2.DestroyObjectMirror(Goblin2);
			}

			Goblin3 = GetEntity("goblin3");
			if( isObject( Goblin3 ) )
			{
				Goblin3.DestroyObjectMirror(Goblin3);
			}

			Goblin4 = GetEntity("goblin4");
			if( isObject( Goblin4 ) )
			{
				Goblin4.DestroyObjectMirror(Goblin4);
			}

			Goblin5 = GetEntity("goblin5");
			if( isObject( Goblin5 ) )
			{
				Goblin5.DestroyObjectMirror(Goblin5);
			}
		}
	} ]
	EnterZone[ (s)
	{
		if( s = "FearFrost" )
		{
			Level.LoadLevel("fearfrst");
			GetPlayer().SetCameraStart( 15975, 1094, 0, 0, 174, 0 );
		}
		if( s = "Lakvan" )
		{
			Level.LoadLevel("lakvan");
			GetPlayer().SetCameraStart( 16507, 1406, 0, 0, -221, 0 );
		}
		if( s = "Ghasts" )
		{
			Level.LoadLevel("ghstpass");
			GetPlayer().SetCameraStart( 27802, 4793, -2680, 0, -16150, 0 );
		}
		if( s = "Dragonfields" )
		{
			Level.LoadLevel("drgnfld");
			GetPlayer().SetCameraStart( 16512, 31104, -2792, 0, -32256, 0 );
		}
		if( s = "Tubes" )
		{
			GetPlayer().SetPosition( 20665, 2528, -2887 );
			GetPlayer().OpenMenu("snowline\\\\Tubes");
		}
	} ]
}