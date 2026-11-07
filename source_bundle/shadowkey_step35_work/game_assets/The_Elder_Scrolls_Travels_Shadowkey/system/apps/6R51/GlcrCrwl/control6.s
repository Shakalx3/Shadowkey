{
	saved_Control6[0]
	saved_Gate[0]
	Init[ (s)
	{
		SetName(1548);
		SetUsable( true );
		if(saved_Gate = 0)
		{
			SetUseText(1548);
		}
		else
		{
			SetUseText(3756);
		}


	} ]

	OnUse[ ()
	{
		GetPlayer().OpenMenu("GlcrCrwl\\\\Gate6");
	}]

	OnReallyUsed1[ (s)
	{
		Level.Log("pre-key");
		Key = GetPlayer().FindInventory("frozen_key");
		Level.Log("pre-if");
		if(saved_Control6 = 0)
		{
			Level.Log("if");
			if(Key != null)
			{
				Gate = Level.GetEntity("gate6");
				Gate.RaiseDoor();
				if (not IsMultiplayerClient())
				{
					GetPlayer().OpenMenu("GlcrCrwl\\\\OpenGate");
				}
				saved_Control6 = 1;
				GetPlayer().RemoveItem(Key, false);
				SetUseText(3756);
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
			saved_Control6 = 0;
			Item = Level.CreateEntity( 805 );
			GetPlayer().PickupItem( Item );
			Gate = Level.GetEntity("gate6");
			Gate.LowerDoor();
			if (not IsMultiplayerClient())
			{
			GetPlayer().OpenMenu("GlcrCrwl\\\\CloseGate");
			}
			SetUseText(1548);
			saved_Gate = 0;
		}
	} ]

	OnReallyUsed2[ (s)
	{
		Level.Log("pre-key");
		Key = GetPlayer().FindInventory("frozen_key");
		Level.Log("pre-if");
		if(saved_Control6 = 0)
		{
			Level.Log("if");
			if(Key != null)
			{
				Gate = Level.GetEntity("gate6");
				Gate.RaiseDoor();
				if (not IsMultiplayerClient())
				{
				GetPlayer().OpenMenu("GlcrCrwl\\\\OpenGate");
				}
				saved_Control6 = 1;
				GetPlayer().RemoveItem(Key, false);
				SetUseText(3756);
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
			saved_Control6 = 0;
			Item = Level.CreateEntity( 805 );
			GetPlayer().PickupItem( Item );
			Gate = Level.GetEntity("gate6");
			Gate.LowerDoor();
			if (not IsMultiplayerClient())
			{
				GetPlayer().OpenMenu("GlcrCrwl\\\\CloseGate");
			}
			SetUseText(1548);
			saved_Gate = 0;
		}
	} ]
}