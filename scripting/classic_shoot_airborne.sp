#include <sourcescramble>

#pragma newdecls required
#pragma semicolon 1

MemoryPatch g_Patch;

ConVar sm_classic_shoot_airborne;

public Plugin myinfo =
{
	name = "[TF2] Classic Shoot Airborne",
	author = "kingo",
	description = "Allows to shoot the classic while airboirne",
	version = "0.0.1",
	url = "https://github.com/kingofings/classic_shoot_airborne"
};


public void OnPluginStart()
{
	GameData gameConf = new GameData("tf2.classic_shoot_airborne");
	if (!gameConf)SetFailState("Failed to parse tf2.classic_shoot_airborne.txt gamedata!");

	g_Patch = MemoryPatch.CreateFromConf(gameConf, "CTFSniperRifleClassic::ItemPostFrame::AllowClassicAirborneShot");
	if (!g_Patch)SetFailState("Failed to create static patch CTFSniperRifleClassic::ItemPostFrame::AllowClassicAirborneShot!");
	if (!g_Patch.Validate())SetFailState("Failed to validate static patch CTFSniperRifleClassic::ItemPostFrame::AllowClassicAirborneShot!");

	delete gameConf;

	sm_classic_shoot_airborne = CreateConVar("sm_classic_shoot_airborne", "1", "Is the classic allowed to fire while airborne?", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	sm_classic_shoot_airborne.AddChangeHook(OnConVarChange);
	OnConVarChange(sm_classic_shoot_airborne, "", "");
}

void OnConVarChange(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (convar.BoolValue)
	{
		if (g_Patch.Enable())
		{
			LogMessage("Enabled static patch CTFSniperRifleClassic::ItemPostFrame::AllowClassicAirborneShot");
			return;
		}
		
		ThrowError("Failed to enable static patch CTFSniperRifleClassic::ItemPostFrame::AllowClassicAirborneShot");
		return;
	}

	g_Patch.Disable();
	LogMessage("Disabled static patch CTFSniperRifleClassic::ItemPostFrame::AllowClassicAirborneShot");
}