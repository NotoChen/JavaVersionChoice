:: �ر��������
@echo off
:: ��ȡ����ԱȨ��
Net session >nul 2>&1 || mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0","","runas",1)(window.close)&&exit
:: �����ӳٱ���
@setlocal EnableDelayedExpansion
:: �ж��Ƿ���й���ԱȨ��
fltmc>nul||(echo ���Ҽ�"�Թ���Ա�������"&echo.&pause)
:: ��ӡJava�汾
:: ͨ��javaԭ�������ж��Ƿ�߱�������������
call:printJavaVersion
:: �ж��Ƿ���ִ�����Ϣ
if %errorlevel% neq 0 (
	call:printTitle ��ǰδ���û�������
	:: ��ʼ��Path
	call:initPath
)else (
	:: ��ӡ��������
	call:printEnv
)
:: ��ʼѡ��
call:choice
:: ����ͣפ
pause
exit
:: ��ʼ��Path
:initPath
	@setx /M PATH "%PATH%;%%JAVA_HOME%%\bin"
	pas
goto :eof
:: ����JAVA_HOME
:setJavaHome
	set javaBelong=%%JAVA_BELONG%%
	set javaVersion=%%JAVA_VERSION%%
	set dir=%~dp0%
	set javaHome=%dir%%javaBelong%\%javaVersion%
	@setx /M JAVA_HOME %javaHome%>nul
	echo JAVA_HOME������: %javaHome%
goto:eof
:: ��ӡ��������
:printEnv
	call:printTitle ��ǰ��������
	echo JAVA_HOME : %JAVA_HOME%
	echo JAVA_BELONG : %JAVA_BELONG%
	echo JAVA_VERSION : %JAVA_VERSION%
goto:eof
:: ��ӡJDK�汾
:printJavaVersion
	call:printTitle ��ǰJAVA�汾
	java -version
goto:eof
:: �����ӡ
:printTitle
	echo.
	echo ====================%~1====================
	echo.
goto:eof	
:: ѡ����
:choiceBelong
call:printTitle Java�����л�
:: ������������
set num=0
:: �������г�������
set numCache=
:: չʾ����Java����
for /D %%i in (%~dp0/*) do (
	:: ���������ۼ�
	set /a num+=1
	:: ���泧������
	set numCache=!numCache!!num!
	:: �����������������
	echo !num!:%%~ni
)
echo.
:: ѡ��Java����
set /p choise=--------------------��ѡ��Java����...
:: �жϳ��������Ƿ������������
echo !numCache!|findstr %choise% >nul && (
	echo.
	:: ������������
	set num=0
	:: ƥ������
	for /D %%i in (%~dp0/*) do (
		set /a num+=1
		:: �ж���ѡJava����
		if !num! == %choise% (
			:: ���볧��Ŀ¼
			cd %%i
			:: ѡ��汾
			call:choiceVersion %%i %%~ni
		)
	)
) || (
	echo ��������ȷ�ĳ�������
	:: ����ѡ����
	goto choiceBelong
)
goto:eof
:: ѡ��汾
:choiceVersion
	call:printTitle Java�汾�л�
	:: �����汾����
	set version=0
	:: �������а汾����
	set versionCache=
	echo !version!:��һ��
	:: չʾ����Java�汾
	for /D %%j in (%~1/*) do (
		:: �汾�����ۼ�
		set /a version+=1
		:: ����汾����
		set versionCache=!versionCache!!version!
		:: ����汾�������汾
		echo !version!:%%~nj
	)
	echo.
	:: ѡ��汾
	set /p choiseversion=--------------------��ѡ��Java�汾...
	:: �жϰ汾�����Ƿ������������
	echo !versionCache!|findstr %choiseversion% >nul && (
		echo.
		:: �����汾����
		set version=0
		:: ƥ������
		for /D %%j in (%~1/*) do (
			set /a version+=1
			:: �ж���ѡJava�汾
			if !version! == !choiseversion! (
				@setx /M JAVA_BELONG %~2 >nul
				echo Java�������л�: %~2
				@setx /M JAVA_VERSION %%~nj >nul
				echo Java�汾���л�: %%~nj
				call:setJavaHome
				echo.
			)
		)
	) || (
		echo "0"|findstr %choiseversion% >nul && (
			goto choiceBelong
		) || (
			echo ��������ȷ�İ汾����
			goto choiceVersion
		)
	)
goto:eof
:: �л���ʼ
:choice
call:choiceBelong
goto:eof