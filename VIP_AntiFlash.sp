#pragma semicolon 1

#include <sourcemod>
#include <blindhook>
#include <vip_core>

public Plugin:myinfo =
{
	name = "[VIP] AntiFlash (CS:GO)",
	author = "R1KO",
	version = "2.1"
};

#define	AF_FLAG_TEAM	(1<<0)	// 1
#define	AF_FLAG_SELF	(1<<1)	// 2
#define	AF_FLAG_FULL	(1<<2)	// 4

static const char g_sFeature[] = "AntiFlash";

public void OnPluginStart()
{
	if(VIP_IsVIPLoaded())
	{
		VIP_OnVIPLoaded();
	}
}

public void VIP_OnVIPLoaded()
{
	VIP_RegisterFeature(g_sFeature, INT);
}

public void OnPluginEnd()
{
	if(CanTestFeatures() && GetFeatureStatus(FeatureType_Native, "VIP_UnregisterFeature") == FeatureStatus_Available)
	{
		VIP_UnregisterFeature(g_sFeature);
	}
}

public Action CS_OnBlindPlayer(int iClient, int iAttacker, int iInflictor)
{
	if (VIP_IsClientFeatureUse(iClient, g_sFeature))
	{
		int iFlags = VIP_GetClientFeatureInt(iClient, g_sFeature);
		bool bSelf = iClient == iAttacker;
		if (iFlags & AF_FLAG_FULL)
		{
			return Plugin_Stop;
		}
		if (iFlags & AF_FLAG_SELF && bSelf)
		{
			return Plugin_Stop;
		}
		if (iFlags & AF_FLAG_TEAM && !bSelf && GetClientTeam(iClient) == GetEntProp(iInflictor, Prop_Data, "m_iTeamNum"))
		{
			return Plugin_Stop;
		}
	}

	return Plugin_Continue;
}
