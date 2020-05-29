#include includes\InjectDll.ahk
#SingleInstance force
#NoTrayIcon
IfNotExist, C:\AYE
{
	FileCreateDir, C:\AYE
}
IfNotExist, C:\AYE\config.ini
{
	IniWrite, true, C:\AYE\config.ini, settings, autoupdate
	IniWrite, false, C:\AYE\config.ini, settings, custominject
}
IniRead, autoupdate, C:\AYE\config.ini, settings, autoupdate
IniRead, custominject, C:\AYE\config.ini, settings, custominject
StringLower, autoupdate, autoupdate
StringLower, custominject, custominject
if (autoupdate = "true")
{
	FileDelete, C:\AYE\*.dll ; бюджетный автоапдейт
}
Menu, ConfigMenu, Add, &Config, ConfigOpen
Gui, Menu, ConfigMenu
Gui, Font, s9
Gui, Show, w315 h165, AYE Loader v1.2.2
Gui, Add, Text, x112 y9 w100 h20 +Center, AYE Loader
Gui, Add, Progress, x22 y39 w270 h20 -smooth +Center vPbar
if (custominject = "true")
{
	Gui, Add, DropDownList, x112 y79 w100 vcheat, OTC|OTC+Addon|FTC 27.04|Fake skeet|Load DLL
} else {
	Gui, Add, DropDownList, x112 y79 w100 vcheat, OTC|OTC+Addon|FTC 27.04|Fake skeet
}
Gui, Add, Button, x112 y129 w100 h20 +Center gLoad, Load

ConfigOpen()
{
	run, notepad.exe "C:\AYE\config.ini"
}

GuiControl,, Pbar, 0
return
GuiClose:
ExitApp
Load:
Gui, Submit, NoHide
if (cheat != "Load DLL")
{
	IfNotExist, C:\AYE\otc.dll
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/otc.dll, C:\AYE\otc.dll
		GuiControl,, Pbar, 25
	}
	IfNotExist, C:\AYE\ftc.dll
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/ftc.dll, C:\AYE\ftc.dll
		GuiControl,, Pbar, 50
	}
	IfNotExist, C:\AYE\addon.dll
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/addon.dll, C:\AYE\addon.dll
		GuiControl,, Pbar, 75
	}
	IfNotExist, C:\AYE\skeet.dll
	{
		UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/skeet.dll, C:\AYE\skeet.dll
		GuiControl,, Pbar, 100
	}
}
Process, Wait, csgo.exe, 1
PID = %ErrorLevel%
if (PID == 0)
{
	MsgBox, 4, AYE Loader, Процесс csgo.exe не найден. Запустить?
	IfMsgBox, Yes
		try {
			Run, steam://run/730
		} catch e {
			MsgBox, 0, AYE Loader, Стим установи ебать
			return
		}
	IfMsgBox, No
		Return
}
if (PID > 0)
{
	Switch cheat
	{
		Case "OTC+Addon":
			TO_LOAD = C:\AYE\otc.dll
			ADDON = C:\AYE\addon.dll
			GuiControl,, Pbar, 0
			INJECT := Inject_Dll(PID,ADDON)
			if (!INJECT)
				Return
			GuiControl,, Pbar, 50
			Sleep 1250
			Inject_Dll(PID,TO_LOAD)
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			ExitApp
		Case "FTC 27.04":
			TO_LOAD = C:\AYE\ftc.dll
			GuiControl,, Pbar, 0
			INJECT := Inject_Dll(PID,TO_LOAD)
			if (!INJECT)
				Return
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			ExitApp
		Case "OTC":
			TO_LOAD = C:\AYE\otc.dll
			GuiControl,, Pbar, 0
			INJECT := Inject_Dll(PID,TO_LOAD)
			if (!INJECT)
				Return
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			ExitApp
		Case "Fake skeet":
			TO_LOAD = C:\AYE\skeet.dll
			GuiControl,, Pbar, 0
			INJECT := Inject_Dll(PID,TO_LOAD)
			if (!INJECT)
				Return
			GuiControl,, Pbar, 100
			MsgBox, Successful injection!
			ExitApp
		Case "Load DLL":
			MsgBox, 4, AYE Loader, Мы не будем тебе помогать если у тебя нахуй система полетит винда нахуй слетит это не наша вина.`nПонял?
			IfMsgBox, Yes
			{
				FileSelectFile, DLL, 3, , AYE Loader | Select DLL, DLL (*.dll)
				if (DLL = "")
					MsgBox, 0, AYE Loader, Ты не выбрал DLL.
				else {
					GuiControl,, Pbar, 0
					INJECT := Inject_Dll(PID,DLL)
					if (!INJECT)
						Return
					GuiControl,, Pbar, 100
					MsgBox, Successful injection!
					ExitApp
				}
			}
			IfMsgBox, No
				Return
		Default:
			MsgBox, 0, AYE Loader, А че грузить то?
	}
} else
{
	MsgBox, 0, AYE Loader, Ору нищ не пук
}
