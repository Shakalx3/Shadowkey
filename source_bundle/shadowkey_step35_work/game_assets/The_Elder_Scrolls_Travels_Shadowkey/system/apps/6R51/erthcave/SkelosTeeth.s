{
	Init[()
	{
		tooth = GetPlayer().FindInventory("stooth");
		if(tooth = null)
		{
			if(GetPlayer().saved_StarTooth = 5)
			{
				AddStaticItem(3861);
				AddStaticItem(179, false);
				AddMenuItem(386, "Quit");
			}
			else
			{
				AddStaticItem(3849);
				AddStaticItem(179, false);
				AddMenuItem(386, "Quit");
			}
		}
		else
		{
			if(GetPlayer().saved_StarTooth = 0)
			{
				if(Level.saved_WeTalked1 = 0)
				{
					if(tooth != null)
					{
						AddStaticItem(3850);
						AddStaticItem(179, false);
						AddMenuItem(3851, "More1");
					}
					else
					{
						AddStaticItem(3852);
						AddStaticItem(179, false);
						AddMenuItem(386, "Quit");
					}
				}
				else
				{
					AddStaticItem(3852);
					AddStaticItem(179, false);
					AddMenuItem(386, "Quit");
				}
			}
			else
			{
				if(Level.saved_OptionGiven = 0)
				{
					if(GetPlayer().QuestCompleted(24) = true)
					{
						AddStaticItem(3853);
						AddStaticItem(179, false);
						AddMenuItem(3854, "DontDie");
						Level.saved_OptionGiven = 1;
					}
					else
					{
						if(GetPlayer().saved_StarTooth = 1)
						{
							if(Level.saved_WeTalked2 = 0)
							{
								if(tooth != null)
								{
									AddStaticItem(3855);
									AddStaticItem(179, false);
									AddMenuItem(3856, "Another1");
								}
								else
								{
									AddStaticItem(3852);
									AddStaticItem(179, false);
									AddMenuItem(386, "Quit");
								}
							}
							else
							{
								AddStaticItem(3852);
								AddStaticItem(179, false);
								AddMenuItem(386, "Quit");
							}
						}
						else
						{
							if(GetPlayer().saved_StarTooth = 2)
							{
								if(Level.saved_WeTalked3 = 0)
								{
									if(tooth != null)
									{
										AddStaticItem(3857);
										AddStaticItem(179, false);
										AddMenuItem(434, "YetAnother1");
									}
									else
									{
										AddStaticItem(3852);
										AddStaticItem(179, false);
										AddMenuItem(386, "Quit");
									}
								}
								else
								{
									AddStaticItem(3852);
									AddStaticItem(179, false);
									AddMenuItem(386, "Quit");
								}
							}
							else
							{
								if(GetPlayer().saved_StarTooth = 3)
								{
									if(Level.saved_WeTalked4 = 0)
									{
										if(tooth != null)
										{
											AddStaticItem(3858);
											AddStaticItem(179, false);
											AddMenuItem(3859, "OneMoreTime1");
										}
										else
										{
											AddStaticItem(3852);
											AddStaticItem(179, false);
											AddMenuItem(386, "Quit");
										}
									}
									else
									{
										AddStaticItem(3852);
										AddStaticItem(179, false);
										AddMenuItem(386, "Quit");
									}
								}
								else
								{
									if(GetPlayer().saved_StarTooth = 4)
									{
										if(Level.saved_WeTalked5 = 0)
										{
											if(tooth != null)
											{
												AddStaticItem(3860);
												AddStaticItem(179, false);
												AddMenuItem(3851, "LastOne1");
											}
											else
											{
												AddStaticItem(3861);
												AddStaticItem(179, false);
												AddMenuItem(386, "Quit");
											}
										}
										else
										{
											AddStaticItem(3861);
											AddStaticItem(179, false);
											AddMenuItem(386, "Quit");
										}
									}
									else
									{
										AddStaticItem(3861);
										AddStaticItem(179, false);
										AddMenuItem(386, "Quit");
									}
								}
							}
						}
					}
				}
				else
				{
					if(GetPlayer().saved_StarTooth = 1)
					{
						if(Level.saved_WeTalked2 = 0)
						{
							if(tooth != null)
							{
								AddStaticItem(3855);
								AddStaticItem(179, false);
								AddMenuItem(3856, "Another1");
							}
							else
							{
								AddStaticItem(3852);
								AddStaticItem(179, false);
								AddMenuItem(386, "Quit");
							}
						}
						else
						{
							AddStaticItem(3852);
							AddStaticItem(179, false);
							AddMenuItem(386, "Quit");
						}
					}
					else
					{
						if(GetPlayer().saved_StarTooth = 2)
						{
							if(Level.saved_WeTalked3 = 0)
							{
								if(tooth != null)
								{
									AddStaticItem(3857);
									AddStaticItem(179, false);
									AddMenuItem(434, "YetAnother1");
								}
								else
								{
									AddStaticItem(3852);
									AddStaticItem(179, false);
									AddMenuItem(386, "Quit");
								}
							}
							else
							{
								AddStaticItem(3852);
								AddStaticItem(179, false);
								AddMenuItem(386, "Quit");
							}
						}
						else
						{
							if(GetPlayer().saved_StarTooth = 3)
							{
								if(Level.saved_WeTalked4 = 0)
								{
									if(tooth != null)
									{
										AddStaticItem(3858);
										AddStaticItem(179, false);
										AddMenuItem(3859, "OneMoreTime1");
									}
									else
									{
										AddStaticItem(3852);
										AddStaticItem(179, false);
										AddMenuItem(386, "Quit");
									}
								}
								else
								{
									AddStaticItem(3852);
									AddStaticItem(179, false);
									AddMenuItem(386, "Quit");
								}
							}
							else
							{
								if(GetPlayer().saved_StarTooth = 4)
								{
									if(Level.saved_WeTalked5 = 0)
									{
										if(tooth != null)
										{
											AddStaticItem(3860);
											AddStaticItem(179, false);
											AddMenuItem(3851, "LastOne1");
										}
										else
										{
											AddStaticItem(3861);
											AddStaticItem(179, false);
											AddMenuItem(386, "Quit");
										}
									}
									else
									{
										AddStaticItem(3861);
										AddStaticItem(179, false);
										AddMenuItem(386, "Quit");
									}
								}
								else
								{
									AddStaticItem(3861);
									AddStaticItem(179, false);
									AddMenuItem(386, "Quit");
								}
							}
						}
					}
				}
			}
		}
	}]

	LastOne1[()
	{
		ClearMenu();
		AddStaticItem(3862);
		AddStaticItem(179, false);
		AddMenuItem(182, "LastOne2");
	}]

	LastOne2[()
	{
		ClearMenu();
		AddStaticItem(3863);
		AddStaticItem(179, false);
		AddMenuItem(3864, "Quit");
		GetPlayer().AddExperience(3000);
		GetPlayer().SetQuestSolved(10);
		GetPlayer().SetQuestCompleted(10);
		GetPlayer().saved_StarTooth = 5;
		Level.saved_WeTalked5 = 1;
		tooth = GetPlayer().FindInventory("stooth");
		GetPlayer().RemoveItem(tooth);
	}]

	OneMoreTime1[()
	{
		ClearMenu();
		AddStaticItem(3865);
		AddStaticItem(179, false);
		AddMenuItem(182, "OneMoreTime2");
	}]

	OneMoreTime2[()
	{
		ClearMenu();
		AddStaticItem(3866);
		AddStaticItem(179, false);
		AddMenuItem(3870, "Quit");
		GetPlayer().AddExperience(2500);
		GetPlayer().saved_StarTooth = 4;
		Level.saved_WeTalked4 = 1;
		tooth = GetPlayer().FindInventory("stooth");
		GetPlayer().RemoveItem(tooth);
	}]

	YetAnother1[()
	{
		ClearMenu();
		AddStaticItem(3868);
		AddStaticItem(179, false);
		AddMenuItem(182, "YetAnother2");
	}]

	YetAnother2[()
	{
		ClearMenu();
		AddStaticItem(3869);
		AddStaticItem(179, false);
		AddMenuItem(3870, "Quit");
		GetPlayer().AddExperience(2000);
		GetPlayer().saved_StarTooth = 3;
		Level.saved_WeTalked3 = 1;
		tooth = GetPlayer().FindInventory("stooth");
		GetPlayer().RemoveItem(tooth);
	}]

	More1[()
	{
		ClearMenu();
		AddStaticItem(3871);
		AddStaticItem(179, false);
		AddMenuItem(182, "More2");
	}]

	More2[()
	{
		ClearMenu();
		AddStaticItem(3872);
		AddStaticItem(179, false);
		AddMenuItem(3870, "Quit");
		GetPlayer().AddExperience(1000);
		GetPlayer().saved_StarTooth = 1;
		Level.saved_WeTalked1 = 1;
		tooth = GetPlayer().FindInventory("stooth");
		GetPlayer().RemoveItem(tooth);
	}]

	Another1[()
	{
		ClearMenu();
		AddStaticItem(3867);
		AddStaticItem(179, false);
		AddMenuItem(182, "Another2");
	}]

	Another2[()
	{
		ClearMenu();
		AddStaticItem(3873);
		AddStaticItem(179, false);
		AddMenuItem(3870, "Quit");
		GetPlayer().AddExperience(1500);
		GetPlayer().saved_StarTooth = 2;
		Level.saved_WeTalked2 = 1;
		tooth = GetPlayer().FindInventory("stooth");
		GetPlayer().RemoveItem(tooth);
	}]

	DontDie[()
	{
		ClearMenu();
		AddStaticItem(3874);
		AddStaticItem(179, false);
		AddMenuItem(3875, "Consider1");
		AddMenuItem(3876, "Quit");
	}]

	Consider1[()
	{
		ClearMenu();
		AddStaticItem(3877);
		AddStaticItem(179, false);
		AddMenuItem(182, "Consider2");
	}]

	Consider2[()
	{
		ClearMenu();
		AddStaticItem(3878);
		AddStaticItem(179, false);
		AddMenuItem(3879, "Farewell");
	}]

	Farewell[()
	{
		ClearMenu();
		AddStaticItem(3880);
		AddStaticItem(179, false);
		AddMenuItem(3881, "Quit");

		Skelos = Level.GetEntity("skelos");
		Skelos.DestroyObjectMirror(Skelos);

		GetPlayer().AddExperience(2000);

		GetPlayer().SetQuestAssigned(10, false);

		if(GetPlayer().saved_StarTooth = 1)
		{
			Item = Level.CreateEntity( 714 );
			GetPlayer().PickupItem( Item );
		}
		else
		{
			if(GetPlayer().saved_StarTooth = 2)
			{
				Item = Level.CreateEntity( 714 );
				GetPlayer().PickupItem( Item );

				Item = Level.CreateEntity( 714 );
				GetPlayer().PickupItem( Item );
			}
			else
			{
				if(GetPlayer().saved_StarTooth = 3)
				{
					Item = Level.CreateEntity( 714 );
					GetPlayer().PickupItem( Item );

					Item = Level.CreateEntity( 714 );
					GetPlayer().PickupItem( Item );

					Item = Level.CreateEntity( 714 );
					GetPlayer().PickupItem( Item );
				}
				else
				{
					if(GetPlayer().saved_StarTooth = 4)
					{
						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );
					}
					else
					{
						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );

						Item = Level.CreateEntity( 714 );
						GetPlayer().PickupItem( Item );
					}
				}
			}
		}
	}]
}