#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <colors>

new Time[33];

public Plugin:myinfo = 
{
	name = "Suicide&AFK&Heal",
	author = "Coralare",
	description = "",
	version = "1.2.0",
	url = "https://github.com/AsamiCoZ/Suicide-AFK-Heal"
}

public OnPluginStart()
{	
	RegConsoleCmd("sm_away", AFKTurnClientToSpectate);
	RegConsoleCmd("sm_afk", AFKTurnClientToSpectate);
	RegConsoleCmd("sm_idle", AFKTurnClientToSpectate);
	RegConsoleCmd("sm_jg", AFKTurnClientToSurvivors);
	RegConsoleCmd("sm_join", AFKTurnClientToSurvivors);
	RegConsoleCmd("sm_zs", Kill_Me);
	RegConsoleCmd("sm_kill", Kill_Me);
	RegAdminCmd("sm_hp",GiveallHealth, ADMFLAG_KICK, "Allow admin to healing all" );
}

public Action:AFKTurnClientToSpectate(client, args)
{
	if(!Time[client])
	{
		ChangeClientTeam(client, 1);
		Time[client] = 30;
		CreateTimer(1.0, Count, client, TIMER_REPEAT);
		/*CreateTimer(GetRandomFloat(0.1, 0.5), CheckClients, client, TIMER_REPEAT);*/
		CreateTimer(GetRandomFloat(0.001, 0.002), Check, client, TIMER_REPEAT);
	}
	return Plugin_Handled;
}

public Action:Count(Handle:t, client)
{
	Time[client]--;
	if(!Time[client]) return Plugin_Stop;
	return Plugin_Continue;
}

public Action:AFKTurnClientToSurvivors(client, args)
{ 
	if(!Time[client])
	{
		ClientCommand(client, "jointeam 2");
		return Plugin_Handled;
	}
	else
	{
		PrintToChat(client, "\x04You should wait %iseconds are able to join survivor~", Time[client]);
		return Plugin_Handled;
	}
}

public Action:Check(Handle:timer, client)
{
	if(!Time[client]) return Plugin_Stop;
	if(GetClientTeam(client) == 2 && Time[client] != 0)
	{
		ChangeClientTeam(client, 1);
		PrintToChat(client, "\x04You should wait %iseconds are able to join survivor~", Time[client]);
	}
	return Plugin_Continue;
}

public Action:Kill_Me(client, args)
{
	if(IsClientInGame(client) && GetClientTeam(client) == 2 && IsPlayerAlive(client))
	{
		ForcePlayerSuicide(client);
		CPrintToChatAll("{default}(*ﾟДﾟ)σーーーーーーー→ Stupid player {blue}%N {default}suicided.",client);
	}
	return Plugin_Handled;
}

public Action:GiveallHealth(client, args)
{
	for (new i = 1; i <= MaxClients; i++)
	{
        if (IsClientInGame(i) && GetClientTeam(i) == 2)
		{
			new userflags = GetUserFlagBits(i);
			SetUserFlagBits(i, ADMFLAG_ROOT);
			new iflags=GetCommandFlags("give");
			SetCommandFlags("give", iflags & ~FCVAR_CHEAT);
			FakeClientCommand(i,"give health");
			SetCommandFlags("give", iflags);
			SetUserFlagBits(i, userflags);
        }
    }
}
