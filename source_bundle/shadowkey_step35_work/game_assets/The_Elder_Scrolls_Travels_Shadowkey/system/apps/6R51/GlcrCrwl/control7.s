{
	saved_Control7[0]
	saved_Gate[0]
	Init[ (s)
	{
		SetName(1549);
		SetUsable( true );
		if(saved_Gate = 0)
		{
			SetUseText(1549);
		}
		else
		{
			SetUseText(3757);
		}


	} ]

	OnUse[ ()
	{
		GetPlayer().OpenMenu("GlcrCrwl\\\\Gate7");
	}]

	OnReallyUsed1[ (s)
	{
		Level.Log("pre-key");
		Key = GetPlayer().FindInventory("frozen_key");
		Level.Log("pre-if");
		if(saved_Control7 = 0)
		{
			Level.Log("if");
			if(Key != null)
			{
				Gate = Level.GetEntity("gate7");
				Gate.RaiseDoor();
				if (not IsMultiplayerClient())
				{
					GetPlayer().OpenMenu("GlcrCrwl\\\\OpenGate");
				}
				saved_Control7 = 1;
				GetPlayer().RemoveItem(Key, false);
				SetUseText(3757);
				saved_Gate = 1;
			}
			else
			{
				if (not IsMultiplayerClient())
				{
				GetPlayer().OpenMenu("GlcrCrwl\\\\NoKey");
				}
			}
		}
		else
		{
			Level.Log("else");
			saved_Control7 = 0;
			Item = Level.CreateEntity( 805 );
			GetPlayer().PickupItem( Item );
			Gate = Level.GetEntity("gate7");
			Gate.LowerDoor();
			if (not IsMultiplayerClient())
			{
				GetPlayer().OpenMenu("GlcrCrwl\\\\CloseGate");
			}
			SetUseText(1549);
			saved_Gate = 0;
		}
	} ]

	OnReallyUsed2[ (s)
	{
		Level.Log("pre-key");
		Key = GetPlayer().FindInventory("frozen_key");
		Level.Log("pre-if");
		if(saved_Control7 = 0)
		{
			Level.Log("if");
			if(Key != null)
			{
				Gate = Level.GetEntity("gate7");
				Gate.RaiseDoor();
				if (not IsMultiplayerClient())
				{
				GetPlayer().OpenMenu("GlcrCrwl\\\\OpenGate");
				}
				saved_Control7 = 1;
				GetPlayer().RemoveItem(Key, false);
				SetUseText(3757);
				saved_Gate = 1;
			}
			else
			{
				if (not IsMultiplayerClient())
				{
				GetPlayer().OpenMenu("GlcrCrwl\\\\NoKey");
				}
			}
		}
		else
		{
			Level.Log("else");
			saved_Control7 = 0;
			Item = Level.CreateEntity( 805 );
			GetPlayer().PickupItem( Item );
			Gate = Level.GetEntity("gate7");
			Gate.LowerDoor();
			if (not IsMultiplayerClient())
			{
			GetPlayer().OpenMenu("GlcrCrwl\\\\CloseGate");
			}
			SetUseText(1549);
			saved_Gate = 0;
		}
	} ]
}