#include includes\InjectDll.ahk
#SingleInstance force
#NoTrayIcon
FileDelete, C:\AYE\*.dll ; бюджетный автоапдейт
Gui, Font, s9
Gui, Show, w315 h165, AYE Loader
Gui, Add, Text, x112 y9 w100 h20 +Center, AYE Loader
Gui, Add, Progress, x22 y39 w270 h20 -smooth +Center vPbar
Gui, Add, DropDownList, x112 y79 w100 vcheat, OTC|OTC+Addon|FTC 27.04|
Gui, Add, Button, x112 y129 w100 h20 +Center gLoad, load



GuiControl,, Pbar, 0
return
GuiClose:
ExitApp
Load:
Gui, Submit, NoHide
IfNotExist, C:\AYE
{
	FileCreateDir, C:\AYE
}
IfNotExist, C:\AYE\otc.dll
{
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/otc.dll, C:\AYE\otc.dll
	GuiControl,, Pbar, 50
}
IfNotExist, C:\AYE\ftc.dll
{
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/ftc.dll, C:\AYE\ftc.dll
	GuiControl,, Pbar, 50
}
IfNotExist, C:\AYE\addon.dll
{
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/addon.dll, C:\AYE\addon.dll
	GuiControl,, Pbar, 100
}
Process, Wait, csgo.exe, 1
PID = %ErrorLevel%
if (PID == 0)
{
	MsgBox, 4, AYE Loader, Процесс csgo.exe не найден. Запустить?
	IfMsgBox, Yes
		Run, steam://run/730
	IfMsgBox, No
		Return
}
if (PID > 0) and (cheat = "OTC+Addon")
{
	OTC = C:\AYE\otc.dll
	ADDON = C:\AYE\addon.dll
	GuiControl,, Pbar, 0
	Inject_Dll(PID,ADDON)
	GuiControl,, Pbar, 50
	Sleep 1250
	Inject_Dll(PID,OTC)
	GuiControl,, Pbar, 100
	MsgBox, Successful injection!
	ExitApp
}
else if (PID > 0) and (cheat = "FTC 27.04")
{
	FTC = C:\AYE\ftc.dll
	GuiControl,, Pbar, 0
	Inject_Dll(PID,FTC)
	GuiControl,, Pbar, 100
	MsgBox, Successful injection!
	ExitApp
}
else if (PID > 0) and (cheat = "OTC")
{
	OTC = C:\AYE\otc.dll
	GuiControl,, Pbar, 0
	Inject_Dll(PID,OTC)
	GuiControl,, Pbar, 100
	MsgBox, Successful injection!
	ExitApp	
}