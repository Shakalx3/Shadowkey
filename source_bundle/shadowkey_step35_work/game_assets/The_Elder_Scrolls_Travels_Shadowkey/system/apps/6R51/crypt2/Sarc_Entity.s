{
	A[0]
	C[0]
	D[0]
	F[0]
	G[0]
	H[0]
	I[0]
	K[0]
	L[0]
	M[0]
	N[0]
	O[0]

	Init[()
	{
		SetUsable(true);
		SetUseText(612);
	}]

	OnUse[(s)
	{
		who = GetID();
		if (who = "sarc_a")
		{
			if (A = 0)
			{
				Delay(1,2);
				A = 1;
			}
			else
			{
				OpenMenu("NoLoot");
			}
		}

		if (who = "sarc_c")
		{
			if (C = 0)
			{
				Delay(1,3);			
				C = 1;
			}
			else
			{
				OpenMenu("NoLoot");
			}
		}

		if (who = "sarc_d")
		{
			if (D = 0)
			{
				Delay(1,4);				
				D = 1;
			}
			else
			{
				OpenMenu("NoLoot");
			}
		}

		if (who = "sarc_f")
		{
			if (F = 0)
			{
				Delay(1,5);			
				F = 1;
			}
			else
			{
				OpenMenu("NoLoot");
			}
		}

		if (who = "sarc_g")
		{
			if (G = 0)
			{
				Delay(1,6);				
				G = 1;
			}
			else
			{
				OpenMenu("NoLoot");
			}
		}

		if (who = "sarc_h")
		{
			if (H = 0)
			{
				Delay(1,7);				
				H = 1;
			}
			else
			{
				OpenMenu("NoLoot");
			}
		}

		if (who = "sarc_k")
		{
			if (K = 0)
			{
				Delay(1,8);
				K = 1;
			}
			else
			{
				OpenMenu("NoLoot");
			}
		}

		if (who = "sarc_l")
		{
			if (L = 0)
			{			
				GetPlayer().OpenMenu("crypt2\\\\loot1");
				Delay(1,1);
				L = 1;
			}
			else
			{
				OpenMenu("NoLoot");
			}
		}

		if (who = "sarc_m")
		{
			if (M = 0)
			{
				Delay(1,9);				
				M = 1;
			}
			else
			{
				OpenMenu("NoLoot");
			}
		}

		if (who = "sarc_n")
		{
			if (N = 0)
			{
				Delay(1,10);				
				N = 1;
			}
			else
			{
				OpenMenu("NoLoot");
			}
		}

		if (who = "sarc_o")
		{
			if (O = 0)
			{
				Delay(1,11);				
				O = 1;
			}
			else
			{
				OpenMenu("NoLoot");
			}
		}
	}]
	
	DelayReached[ (id)
	{
		if (id = 1)
		{
			Level.CreateEntity(105, GetPositionX() + 250, GetPositionY() + 250, GetPositionZ());				
			Level.CreateEntity(105, GetPositionX() + 400, GetPositionY() + 400, GetPositionZ());		
		}
		if (id = 2)
		{
			Level.CreateEntity(272, GetPositionX() + 250, GetPositionY() + 250, GetPositionZ());
		}
		if (id = 3)
		{
			Level.CreateEntity(105, GetPositionX() + 250, GetPositionY() + 250, GetPositionZ());
		}
		if (id = 4)
		{
			Level.CreateEntity(105, GetPositionX() + 250, GetPositionY() + 250, GetPositionZ());
		}
		if (id = 5)
		{
			Level.CreateEntity(264, GetPositionX() + 250, GetPositionY() + 250, GetPositionZ());
		}
		if (id = 6)
		{
			Level.CreateEntity(258, GetPositionX() + 250, GetPositionY() + 250, GetPositionZ());
		}
		if (id = 7)
		{
			Level.CreateEntity(258, GetPositionX() + 250, GetPositionY() + 250, GetPositionZ());
		}
		if (id = 8)
		{
			Level.CreateEntity(105, GetPositionX() + 250, GetPositionY() + 250, GetPositionZ());
		}
		if (id = 9)
		{
			Level.CreateEntity(3201, GetPositionX() + 250, GetPositionY() + 250, GetPositionZ());
		}	
		if (id = 10)
		{
			Level.CreateEntity(272, GetPositionX() + 250, GetPositionY() + 250, GetPositionZ());
		}
		if (id = 11)
		{
			Level.CreateEntity(272, GetPositionX() + 250, GetPositionY() + 250, GetPositionZ());
		}						
	}]
}