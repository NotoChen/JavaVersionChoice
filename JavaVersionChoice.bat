:: 关闭命令回显
@echo off
:: 获取管理员权限
Net session >nul 2>&1 || mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0","","runas",1)(window.close)&&exit
:: 启用延迟变量
@setlocal EnableDelayedExpansion
:: 判断是否具有管理员权限
fltmc>nul||(echo 请右键"以管理员身份运行"&echo.&pause)
:: 打印Java版本
:: 通过java原生命令判断是否具备完整环境变量
call:printJavaVersion
:: 判断是否出现错误信息
if %errorlevel% neq 0 (
	call:printTitle 当前未设置环境变量
	:: 初始化Path
	call:initPath
)else (
	:: 打印环境变量
	call:printEnv
)
:: 开始选择
call:choice
:: 窗口停驻
pause
exit
:: 初始化Path
:initPath
	@setx /M PATH "%PATH%;%%JAVA_HOME%%\bin"
	pas
goto :eof
:: 设置JAVA_HOME
:setJavaHome
	set javaBelong=%%JAVA_BELONG%%
	set javaVersion=%%JAVA_VERSION%%
	set dir=%~dp0%
	set javaHome=%dir%%javaBelong%\%javaVersion%
	@setx /M JAVA_HOME %javaHome%>nul
	echo JAVA_HOME已设置: %javaHome%
goto:eof
:: 打印环境变量
:printEnv
	call:printTitle 当前环境变量
	echo JAVA_HOME : %JAVA_HOME%
	echo JAVA_BELONG : %JAVA_BELONG%
	echo JAVA_VERSION : %JAVA_VERSION%
goto:eof
:: 打印JDK版本
:printJavaVersion
	call:printTitle 当前JAVA版本
	java -version
goto:eof
:: 标题打印
:printTitle
	echo.
	echo ====================%~1====================
	echo.
goto:eof	
:: 选择厂商
:choiceBelong
call:printTitle Java厂商切换
:: 建立厂商索引
set num=0
:: 缓存所有厂商索引
set numCache=
:: 展示所有Java厂商
for /D %%i in (%~dp0/*) do (
	:: 厂商索引累加
	set /a num+=1
	:: 缓存厂商索引
	set numCache=!numCache!!num!
	:: 输出厂商索引：厂商
	echo !num!:%%~ni
)
echo.
:: 选择Java厂商
set /p choise=--------------------请选择Java厂商...
:: 判断厂商索引是否包含输入内容
echo !numCache!|findstr %choise% >nul && (
	echo.
	:: 建立厂商索引
	set num=0
	:: 匹配索引
	for /D %%i in (%~dp0/*) do (
		set /a num+=1
		:: 判断所选Java厂商
		if !num! == %choise% (
			:: 切入厂商目录
			cd %%i
			:: 选择版本
			call:choiceVersion %%i %%~ni
		)
	)
) || (
	echo 请输入正确的厂商索引
	:: 重新选择厂商
	goto choiceBelong
)
goto:eof
:: 选择版本
:choiceVersion
	call:printTitle Java版本切换
	:: 建立版本索引
	set version=0
	:: 缓存所有版本索引
	set versionCache=
	echo !version!:上一步
	:: 展示所有Java版本
	for /D %%j in (%~1/*) do (
		:: 版本索引累加
		set /a version+=1
		:: 缓存版本索引
		set versionCache=!versionCache!!version!
		:: 输出版本索引：版本
		echo !version!:%%~nj
	)
	echo.
	:: 选择版本
	set /p choiseversion=--------------------请选择Java版本...
	:: 判断版本索引是否包含输入内容
	echo !versionCache!|findstr %choiseversion% >nul && (
		echo.
		:: 建立版本索引
		set version=0
		:: 匹配索引
		for /D %%j in (%~1/*) do (
			set /a version+=1
			:: 判断所选Java版本
			if !version! == !choiseversion! (
				@setx /M JAVA_BELONG %~2 >nul
				echo Java厂商已切换: %~2
				@setx /M JAVA_VERSION %%~nj >nul
				echo Java版本已切换: %%~nj
				call:setJavaHome
				echo.
			)
		)
	) || (
		echo "0"|findstr %choiseversion% >nul && (
			goto choiceBelong
		) || (
			echo 请输入正确的版本索引
			goto choiceVersion
		)
	)
goto:eof
:: 切换开始
:choice
call:choiceBelong
goto:eof