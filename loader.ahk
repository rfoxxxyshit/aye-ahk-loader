#SingleInstance, force
#NoTrayIcon
#include Lib\functions.ahk
#include Lib\strings.ahk

global script = "AYE Loader"
<<<<<<< Updated upstream
global version = "1.3"

=======
global version = "v1.3.2-beta"
>>>>>>> Stashed changes

FileDelete, %A_TEMP%\cheats.ini
FileDelete, C:\AYE\*.dll

<<<<<<< Updated upstream

Logging(1,"Starting "script " v" version "...")
=======
Logging(1,"Starting " script " " version "...")
>>>>>>> Stashed changes

RunAsAdmin()
Logging(1, "Creating folders and downloading files...")
IfNotExist, C:\AYE
{	
	Logging(1, "Creating folder...")
	FileCreateDir, C:\AYE
	Logging(1, "done.")
}
IfNotExist, C:\AYE\config.ini
{	
	Logging(1, "Creating config file...")
	IniWrite, false, C:\AYE\config.ini, settings, custominject
	Logging(1, "done.")
}
IfNotExist, %A_TEMP%\cheats.ini
{	
	Logging(1, "Getting cheat list...")
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/cheats.ini, %A_TEMP%\cheats.ini
	GuiControl,, Pbar, 100
	Logging(1, "done.")
}
IfNotExist, C:\AYE\vac-bypass.exe
{
	Logging(1,"Downloading vac-bypass.exe...")
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/vac-bypass.exe, C:\AYE\vac-bypass.exe
	Logging(1, "done.")
}

Logging(1,"Getting vars...")
IniRead, cheatlist, %A_TEMP%\cheats.ini, cheatlist, cheatlist
IniRead, custominject, C:\AYE\config.ini, settings, custominject
StringLower, custominject, custominject
<<<<<<< Updated upstream
=======
Logging(1, "done.")


Logging(1,"Checking updates...")
CheckUpdates()

>>>>>>> Stashed changes
Logging(1,"Building GUI...")

Gui, Font, s9
Gui, Show, w315 h195, %script% v%version%
Gui, Add, Text, x112 y9 w100 h20 +Center, %script%
Gui, Add, Progress, x22 y39 w270 h20 -smooth +Center vPbar

if (custominject = "true")
{
	Logging(1,"Custom injection was enabled!")
	Gui, Add, DropDownList, x112 y79 w100 vCheat Choose1, %cheatlist%|Load DLL
} else {
	Gui, Add, DropDownList, x112 y79 w100 vCheat Choose1, %cheatlist%
}
Gui, Add, Button, x15 y129 w100 h30 +Center gLoad, %string_load%
Gui, Add, Button, x200 y129 w100 h30 +Center gBypass, %string_bypass%
Menu, AppMenu, Add, &%string_config%, ConfigOpen
Menu, AppMenu, Add, &%string_about%, ShowAbout
Gui, Menu, AppMenu
GuiControl,, Pbar, 0
Logging(1,"done.")
return
GuiClose:
ExitApp
Load:
Gui, Submit, NoHide

Process, Wait, csgo.exe, 1
PID = %ErrorLevel%
if (PID == 0)
{
	Logging(2,"csgo process not found. promting to start.")
	MsgBox, 4, %script%, %string_pid0%
	IfMsgBox, Yes
		try {
			Logging(1,"Starting csgo...")
			Run, steam://run/730
			Return
		} catch e {
			MsgBox, 0, %script%, %string_nosteam%
			Logging(2,"steam not found")
			return
		}
	IfMsgBox, No
		Return
}

if (Cheat != "Load DLL") and (PID > 0)
{
	Logging(1,"Initialized dll injection")
	IniRead, dll, %A_TEMP%\cheats.ini, cheats, %Cheat%
	FileDelete, C:\AYE\%dll%
	Sleep 1500
	IfNotExist, C:\AYE\%dll%
	{
		Logging(1,"Downloading " DLL "...")
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/%dll%, C:\AYE\%dll%
		Sleep 2500
		GuiControl,, Pbar, 50
		Logging(1, "done.")
	}
	IfNotExist, C:\AYE\emb.exe
	{
		Logging(1,"Downloading emb.exe...")
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/emb.exe, C:\AYE\emb.exe
		Logging(1, "done.")
	}
	GuiControl,, Pbar, 100
	Logging(1,"Running emb...")
	Run, C:\AYE\emb.exe
	Logging(1, "done.")
	Sleep, 1500
	TO_LOAD = C:\AYE\%dll%
	Logging(1,"Injecting " DLL "...")
	GuiControl,, Pbar, 0
	Inject_Dll(PID,TO_LOAD)
	GuiControl,, Pbar, 100
	MsgBox, %string_success%
	Logging(1,"Injected " DLL)
	GuiControl,, Pbar, 0
	Return
}


if (PID > 0) and (Cheat = "Load DLL")
{	
	MsgBox, 4, %script%, %string_warning_custom_dll%
	IfMsgBox, Yes
	{
		Logging(1,"Initialized custom injection")
		FileSelectFile, DLL, 3, , %script% | Select DLL, DLL (*.dll)
		if (DLL = "")
		{
			Logging(1,"DLL not selected")
			MsgBox, 0, %script%, %string_no_dll%
		}
		else {
			Logging(1,"Injecting custom dll...")
			GuiControl,, Pbar, 0
			INJECT := Inject_Dll(PID,DLL)
			if (!INJECT)
			{
				Logging(2,"Injection failed. DLL: " DLL)
				Return
			}
			GuiControl,, Pbar, 100
			MsgBox, %string_success%
			Logging(1,"Injected custom dll")
			ExitApp
		}
	}
	IfMsgBox, No
		Return
	Return
}
Bypass:
{
	Run, C:\AYE\vac-bypass.exe
	return
}
