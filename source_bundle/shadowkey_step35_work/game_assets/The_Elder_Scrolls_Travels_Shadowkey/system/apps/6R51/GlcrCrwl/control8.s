{
	saved_Control8[0]
	saved_Gate[0]
	Init[ (s)
	{
		SetName(1550);
		SetUsable( true );
		if(saved_Gate = 0)
		{
			SetUseText(1550);
		}
		else
		{
			SetUseText(3758);
		}


	} ]

	OnUse[ ()
	{
		GetPlayer().OpenMenu("GlcrCrwl\\\\Gate8");
	}]

	OnReallyUsed1[ (s)
	{
		Level.Log("pre-key");
		Key = GetPlayer().FindInventory("frozen_key");
		Level.Log("pre-if");
		if(saved_Control8 = 0)
		{
			Level.Log("if");
			if(Key != null)
			{
				Gate = Level.GetEntity("gate8");
				Gate.RaiseDoor();
				if (not IsMultiplayerClient())
				{
				GetPlayer().OpenMenu("GlcrCrwl\\\\OpenGate");
				}
				saved_Control8 = 1;
				//Key.DestroyObject(Key);
				GetPlayer().RemoveItem(Key, false);
				SetUseText(3758);
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
			saved_Control8 = 0;
			Item = Level.CreateEntity( 805 );
			GetPlayer().PickupItem( Item );
			Gate = Level.GetEntity("gate8");
			Gate.LowerDoor();
			if (not IsMultiplayerClient())
			{
			GetPlayer().OpenMenu("GlcrCrwl\\\\CloseGate");
			}
			SetUseText(1550);
			saved_Gate = 0;
		}
	} ]

	OnReallyUsed2[ (s)
	{
		Level.Log("pre-key");
		Key = GetPlayer().FindInventory("frozen_key");
		Level.Log("pre-if");
		if(saved_Control8 = 0)
		{
			Level.Log("if");
			if(Key != null)
			{
				Gate = Level.GetEntity("gate8");
				Gate.RaiseDoor();
				if (not IsMultiplayerClient()) 
				{
				GetPlayer().OpenMenu("GlcrCrwl\\\\OpenGate");
				}
				saved_Control8 = 1;
				//Key.DestroyObject(Key);
				GetPlayer().RemoveItem(Key, false);
				SetUseText(3758);
				saved_Gate = 1;
			}
			else
			{
				GetPlayer().OpenMenu("GlcrCrwl\\\\NoKey");
			}
		}
		else
		{
			Level.Log("else");
			saved_Control8 = 0;
			Item = Level.CreateEntity( 805 );
			GetPlayer().PickupItem( Item );
			Gate = Level.GetEntity("gate8");
			Gate.LowerDoor();
			if (not IsMultiplayerClient())
			{
			GetPlayer().OpenMenu("GlcrCrwl\\\\CloseGate");
			}
			SetUseText(1550);
			saved_Gate = 0;
		}
	} ]
}