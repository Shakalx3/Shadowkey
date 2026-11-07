{
	saved_Active[1]
	
	Init[()
	{
		if (saved_Active = 1)
		{
			SetUseText(666);
			SetUsable(true);
		}
	}]

	OnUse[(who)
	{
		who = GetID();
		STooth = GetPlayer().FindInventory("stooth");
		if(GetPlayer().QuestSolved(240) = false)
		{
			GetPlayer().OpenMenu("crypt2\\\\FindUmbra");
		}
		else
		{
			if (STooth != null)
			{
				if(who = "ped1")
				{
					Level.GetEntity("crys1").ShowEntity(true);
					MirrorMethod("ClientShowCrystal1");
					GetPlayer().OpenMenu("crypt2\\\\Startooth");
					GetPlayer().RemoveItem(STooth);
					SetUsable(false);
					Level.saved_Crys1 = 1;
					Level.AddCrystal();
					saved_Active=0;
				}
				else
				{
					if(who = "ped2")
					{
						Level.GetEntity("crys2").ShowEntity(true);
						MirrorMethod("ClientShowCrystal2");
						GetPlayer().OpenMenu("crypt2\\\\Startooth");
						GetPlayer().RemoveItem(STooth);
						SetUsable(false);
						Level.saved_Crys2 = 1;
						Level.AddCrystal();
						saved_Active=0;
					}
					else
					{
						if(who = "ped3")
						{
							Level.GetEntity("crys3").ShowEntity(true);
							MirrorMethod("ClientShowCrystal3");
							GetPlayer().OpenMenu("crypt2\\\\Startooth");
							GetPlayer().RemoveItem(STooth);
							SetUsable(false);
							Level.saved_Crys3 = 1;
							Level.AddCrystal();
							saved_Active=0;
						}
						else
						{
							if(who = "ped4")
							{
								Level.GetEntity("crys4").ShowEntity(true);
								MirrorMethod("ClientShowCrystal4");
								GetPlayer().OpenMenu("crypt2\\\\Startooth");
								GetPlayer().RemoveItem(STooth);
								SetUsable(false);
								Level.saved_Crys4 = 1;
								Level.AddCrystal();
								saved_Active=0;
							}
							else
							{
								if(who = "ped5")
								{
									Level.GetEntity("crys5").ShowEntity(true);
									MirrorMethod("ClientShowCrystal5");
									GetPlayer().OpenMenu("crypt2\\\\Startooth");
									GetPlayer().RemoveItem(STooth);
									SetUsable(false);
									Level.saved_Crys5 = 1;
									Level.AddCrystal();
									saved_Active=0;
								}
								else
								{
									if(who = "ped6")
									{
										Level.GetEntity("crys6").ShowEntity(true);
										MirrorMethod("ClientShowCrystal6");
										GetPlayer().OpenMenu("crypt2\\\\Startooth");
										GetPlayer().RemoveItem(STooth);
										SetUsable(false);
										Level.saved_Crys6 = 1;
										Level.AddCrystal();
										saved_Active=0;
									}
									else
									{
										if(who = "ped7")
										{
											Level.GetEntity("crys7").ShowEntity(true);
											MirrorMethod("ClientShowCrystal7");
											GetPlayer().OpenMenu("crypt2\\\\Startooth");
											GetPlayer().RemoveItem(STooth);
											SetUsable(false);
											Level.saved_Crys7 = 1;
											Level.AddCrystal();
											saved_Active=0;
										}
									}
								}
							}
						}
					}
				}
			}
			else
			{
				GetPlayer().OpenMenu("crypt2\\\\NoStartooth");
			}
		//}
	}]
	
	ClientShowCrystal1[ ()
	{
		cry = Level.GetEntity("crys1")
		if (cry != null)
		{
			cry.ShowEntity(true);
		}
	}]
	ClientShowCrystal2[ ()
	{
		cry = Level.GetEntity("crys2")
		if (cry != null)
		{
			cry.ShowEntity(true);
		}
	}]
	ClientShowCrystal3[ ()
	{
		cry = Level.GetEntity("crys3")
		if (cry != null)
		{
			cry.ShowEntity(true);
		}
	}]
	ClientShowCrystal4[ ()
	{
		cry = Level.GetEntity("crys4")
		if (cry != null)
		{
			cry.ShowEntity(true);
		}
	}]
	ClientShowCrystal5[ ()
	{
		cry = Level.GetEntity("crys5")
		if (cry != null)
		{
			cry.ShowEntity(true);
		}
	}]
	ClientShowCrystal6[ ()
	{
		cry = Level.GetEntity("crys6")
		if (cry != null)
		{
			cry.ShowEntity(true);
		}
	}]
	ClientShowCrystal7[ ()
	{
		cry = Level.GetEntity("crys7")
		if (cry != null)
		{
			cry.ShowEntity(true);
		}
	}]		
}