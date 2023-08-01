:: �ر�������� Turn off command display
@echo off
:: ��ȡ����ԱȨ�� Obtaining Administrator Privileges
Net session >nul 2>&1 || mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0","","runas",1)(window.close)&&exit
:: ��ֹ���� Preventing Garbled Codes
chcp 936 >nul
:: �����ӳٱ��� Enabling delayed variables
@setlocal EnableDelayedExpansion
:: �ж��Ƿ���й���ԱȨ�� Determine if you have administrator privileges
fltmc>nul||(echo ���Ҽ�"�Թ���Ա�������/Run As Administrator"&echo.&pause)
:: ��ӡJava�汾 Print Java version
:: ͨ��javaԭ�������ж��Ƿ�߱������������� Determine if you have the full environment variables with java native commands
call:printJavaVersion
:: �ж��Ƿ���ִ�����Ϣ Determine if an error message appears
if %errorlevel% neq 0 (
	call:printTitle ��ǰδ���û�������/NoEnvironmentVariablesAreCurrentlySet
	:: ��ʼ��Path Initialize Path
	call:initPath
)else (
	:: ��ӡ�������� Printing environment variables
	call:printEnv
)
:: ��ʼѡ�� Start selecting
call:choice
:: ����ͣפ Window stationing
pause
exit
:: ��ʼ��Path Initialize Path
:initPath
	@setx /M PATH "%PATH%;%%JAVA_HOME%%\bin"
	pas
goto :eof
:: ����JAVA_HOME Setting JAVA_HOME
:setJavaHome
	set javaBelong=%%JAVA_BELONG%%
	set javaVersion=%%JAVA_VERSION%%
	set dir=%~dp0%
	set javaHome=%dir%%javaBelong%\%javaVersion%
	@setx /M JAVA_HOME %javaHome%>nul
	echo JAVA_HOME ������/Has been set: %javaHome%
goto:eof
:: ��ӡ�������� Printing environment variables
:printEnv
	call:printTitle ��ǰ��������/CurrentEnvironmentVariable
	echo JAVA_HOME : %JAVA_HOME%
	echo JAVA_BELONG : %JAVA_BELONG%
	echo JAVA_VERSION : %JAVA_VERSION%
goto:eof
:: ��ӡJDK�汾 Print the JDK version
:printJavaVersion
	call:printTitle ��ǰJAVA�汾/CurrentJAVAVersion
	java -version
goto:eof
:: �����ӡ Header Printing
:printTitle
	echo.
	echo ====================%~1====================
	echo.
goto:eof	
:: ѡ���� Select Manufacturer
:choiceBelong
call:printTitle Java�����л�/JavaVendorSwitching
:: ������������ Create a vendor index
set num=0
:: �������г������� Cache all vendor indexes
set numCache=
:: չʾ����Java���� Showcase all Java vendors
for /D %%i in (%~dp0/*) do (
	:: ���������ۼ� Vendor Index Accumulation
	set /a num+=1
	:: ���泧������ Cache Vendor Index
	set numCache=!numCache!!num!
	:: ����������������� Output Vendor Index: Vendor
	echo !num!:%%~ni
)
echo.
:: ѡ��Java���� Select Java Vendor
set /p choise=--------------------��ѡ��Java����/Please Select Java Vendor...
:: �жϳ��������Ƿ������������ Determine if the vendor index contains the input
echo !numCache!|findstr %choise% >nul && (
	echo.
	:: ������������ Create a vendor index
	set num=0
	:: ƥ������ Match Index
	for /D %%i in (%~dp0/*) do (
		set /a num+=1
		:: �ж���ѡJava���� Determine the selected Java vendor
		if !num! == %choise% (
			:: ���볧��Ŀ¼ Cut to Manufacturer Catalog
			cd %%i
			:: ѡ��汾 Select Version
			call:choiceVersion %%i %%~ni
		)
	)
) || (
	echo ��������ȷ�ĳ������� Please enter the correct vendor index
	:: ����ѡ���� Re-selection of vendors
	goto choiceBelong
)
goto:eof
:: ѡ��汾 Select Version
:choiceVersion
	call:printTitle Java�汾�л�/JavaVersionSwitching
	:: �����汾���� Creating a version index
	set version=0
	:: �������а汾���� Cache all version indexes
	set versionCache=
	echo !version!:��һ��/previous step
	:: չʾ����Java�汾 Show all Java versions
	for /D %%j in (%~1/*) do (
		:: �汾�����ۼ� Version Index Accumulation
		set /a version+=1
		:: ����汾���� Cached version index
		set versionCache=!versionCache!!version!
		:: ����汾�������汾 Output version index: version
		echo !version!:%%~nj
	)
	echo.
	:: ѡ��汾 Select Version
	set /p choiseversion=--------------------��ѡ��Java�汾/Please Select Java Version...
	:: �жϰ汾�����Ƿ������������ Determine if the version index contains the input
	echo !versionCache!|findstr %choiseversion% >nul && (
		echo.
		:: �����汾���� Creating a version index
		set version=0
		:: ƥ������ Match Index
		for /D %%j in (%~1/*) do (
			set /a version+=1
			:: �ж���ѡJava�汾 Determine the selected Java version
			if !version! == !choiseversion! (
				@setx /M JAVA_BELONG %~2 >nul
				echo Java�������л�/Vendor has switched: %~2
				@setx /M JAVA_VERSION %%~nj >nul
				echo Java�汾���л�/Version has switched: %%~nj
				call:setJavaHome
				echo.
			)
		)
	) || (
		echo "0"|findstr %choiseversion% >nul && (
			goto choiceBelong
		) || (
			echo ��������ȷ�İ汾����/Please enter the correct version index
			goto choiceVersion
		)
	)
goto:eof
:: �л���ʼ Toggle Start
:choice
call:choiceBelong
goto:eof