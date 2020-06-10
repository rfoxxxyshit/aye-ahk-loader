Logging(status,text)
{
	if (status = 1)
	{
		FileAppend, [LOG]%A_Hour%:%A_Min%:%A_Sec% - %text%`n, C:\AYE\logs.txt
	}
	if (status = 2)
	{
		FileAppend, [ERR]%A_Hour%:%A_Min%:%A_Sec% - %text%`n, C:\AYE\logs.txt
	}
}