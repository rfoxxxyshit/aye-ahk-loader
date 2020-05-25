#include includes\InjectDll.ahk
#SingleInstance force
FileDelete, C:\OTC\*.dll
Gui, Font, s9
Gui, Show, w300 h130, OTC Loader
Gui, Add, Text, x90 y10 w130 h20 +Center, OTC Loader by m4x3r1337
Gui, Add, Progress, x30 y30 w240 h20 -smooth +Center vPbar
Gui, Add, Checkbox, x110 y57 vInj_Addon, Inject addon
Gui, Add, Button, x95 y80 w110 h30 +Center gLoad, Inject!
GuiControl,, Pbar, 0
return
GuiClose:
ExitApp
Load:
Gui, Submit, NoHide
IfNotExist, C:\OTC
{
	FileCreateDir, C:\OTC
}
IfNotExist, C:\OTC\cheat.dll
{
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/cheat.dll, C:\OTC\cheat.dll
	GuiControl,, Pbar, 50
}
IfNotExist, C:\OTC\addon.dll
{
	UrlDownloadToFile, https://github.com/m4x3r1337/otc-direct-link/raw/master/addon.dll, C:\OTC\addon.dll
	GuiControl,, Pbar, 100
}
Process, Wait, csgo.exe, 1
PID = %ErrorLevel%
if (PID == 0)
{
	MsgBox, 4, OTC Loader, Процесс csgo.exe не найден. Запустить?
	IfMsgBox, Yes
		Run, steam://run/730
	IfMsgBox, No
		Return
}
if (PID > 0) and (Inj_Addon == 1)
{
	GuiControl,, Pbar, 0
	addon = C:\OTC\addon.dll
	Inject_Dll(PID,addon)
	GuiControl,, Pbar, 50
	Sleep 1250
	cheat = C:\OTC\cheat.dll
	Inject_Dll(PID,cheat)
	GuiControl,, Pbar, 100
	MsgBox, Successful injection!
	ExitApp
}
else (PID > 0) and (Inj_Addon == 0)
{
	GuiControl,, Pbar, 0
	cheat = C:\OTC\cheat.dll
	Inject_Dll(PID,cheat)
	GuiControl,, Pbar, 100
	MsgBox, Successful injection!
	ExitApp
}
