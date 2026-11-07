{
	saved_Control1[0]
	saved_Gate[0]
	Init[ (s)
	{
		Level.Log("Control1 init");
		SetName(1543);
		SetUsable( true );
		if(saved_Gate = 0)
		{
			SetUseText(1543);
		}
		else
		{
			SetUseText(3751);
		}
	} ]

	OnUse[ ()
	{
		Level.Log("Player is interacting with control panel");
		GetPlayer().OpenMenu("GlcrCrwl\\\\Gate1");
	}]

	OnReallyUsed1[ (s)
	{		
		Level.Log("pre-key");
		Key = GetPlayer().FindInventory("frozen_key");
		Level.Log("pre-if");
		if(saved_Control1 = 0)
		{
			Level.Log("if");
			if(Key != null)
			{
				Gate = Level.GetEntity("gate1");
				Gate.RaiseDoor();
				
				if (not IsMultiplayerClient())
				{
					GetPlayer().OpenMenu("GlcrCrwl\\\\OpenGate");
				}
				
				saved_Control1 = 1;
				GetPlayer().RemoveItem(Key, false);
				SetUseText(3751);
				saved_Gate = 1;
				Level.Log("Player has opened gate");
			}
			else
			{
				if (not IsMultiplayerClient())
				{
					GetPlayer().OpenMenu("GlcrCrwl\\\\NoKey");
				}
				Level.Log("Player does not have a key");
			}
		}
		else
		{
			Level.Log("else");
			saved_Control1 = 0;
			Item = Level.CreateEntity( 805 );
			GetPlayer().PickupItem( Item );
			Gate = Level.GetEntity("gate1");
			Gate.LowerDoor();
			if (not IsMultiplayerClient())
			{
			GetPlayer().OpenMenu("GlcrCrwl\\\\CloseGate");
			}
			SetUseText(1543);
			saved_Gate = 0;
			Level.Log("Player has retrieved key, gate closing");
		}
	} ]

	OnReallyUsed2[ (s)
	{
		Level.Log("pre-key");
		Key = GetPlayer().FindInventory("frozen_key");
		Level.Log("pre-if");
		if(saved_Control1 = 0)
		{
			Level.Log("if");
			if(Key != null)
			{
				Gate = Level.GetEntity("gate1");
				Gate.RaiseDoor();
				if (not IsMultiplayerClient())
				{
				GetPlayer().OpenMenu("GlcrCrwl\\\\OpenGate");
				}
				saved_Control1 = 1;
				GetPlayer().RemoveItem(Key, false);
				SetUseText(3751);
				saved_Gate = 1;
				Level.Log("Player has opened gate");

			}
			else
			{
				if (not IsMultiplayerClient())
				{
				GetPlayer().OpenMenu("GlcrCrwl\\\\NoKey");
				}
				Level.Log("Player does not have a key");
			}
		}
		else
		{
			Level.Log("else");
			saved_Control1 = 0;
			Item = Level.CreateEntity( 805 );
			GetPlayer().PickupItem( Item );
			Gate = Level.GetEntity("gate1");
			Gate.LowerDoor();
			if (not IsMultiplayerClient())
			{
			GetPlayer().OpenMenu("GlcrCrwl\\\\CloseGate");
			}
			SetUseText(1543);
			saved_Gate = 0;
			Level.Log("Player has retrieved key, gate closing");
		}
	} ]
}