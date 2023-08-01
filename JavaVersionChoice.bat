:: 关闭命令回显 Turn off command display
@echo off
:: 获取管理员权限 Obtaining Administrator Privileges
Net session >nul 2>&1 || mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c %~s0","","runas",1)(window.close)&&exit
:: 防止乱码 Preventing Garbled Codes
chcp 936 >nul
:: 启用延迟变量 Enabling delayed variables
@setlocal EnableDelayedExpansion
:: 判断是否具有管理员权限 Determine if you have administrator privileges
fltmc>nul||(echo 请右键"以管理员身份运行/Run As Administrator"&echo.&pause)
:: 打印Java版本 Print Java version
:: 通过java原生命令判断是否具备完整环境变量 Determine if you have the full environment variables with java native commands
call:printJavaVersion
:: 判断是否出现错误信息 Determine if an error message appears
if %errorlevel% neq 0 (
	call:printTitle 当前未设置环境变量/NoEnvironmentVariablesAreCurrentlySet
	:: 初始化Path Initialize Path
	call:initPath
)else (
	:: 打印环境变量 Printing environment variables
	call:printEnv
)
:: 开始选择 Start selecting
call:choice
:: 窗口停驻 Window stationing
pause
exit
:: 初始化Path Initialize Path
:initPath
	@setx /M PATH "%PATH%;%%JAVA_HOME%%\bin"
	pas
goto :eof
:: 设置JAVA_HOME Setting JAVA_HOME
:setJavaHome
	set javaBelong=%%JAVA_BELONG%%
	set javaVersion=%%JAVA_VERSION%%
	set dir=%~dp0%
	set javaHome=%dir%%javaBelong%\%javaVersion%
	@setx /M JAVA_HOME %javaHome%>nul
	echo JAVA_HOME 已设置/Has been set: %javaHome%
goto:eof
:: 打印环境变量 Printing environment variables
:printEnv
	call:printTitle 当前环境变量/CurrentEnvironmentVariable
	echo JAVA_HOME : %JAVA_HOME%
	echo JAVA_BELONG : %JAVA_BELONG%
	echo JAVA_VERSION : %JAVA_VERSION%
goto:eof
:: 打印JDK版本 Print the JDK version
:printJavaVersion
	call:printTitle 当前JAVA版本/CurrentJAVAVersion
	java -version
goto:eof
:: 标题打印 Header Printing
:printTitle
	echo.
	echo ====================%~1====================
	echo.
goto:eof	
:: 选择厂商 Select Manufacturer
:choiceBelong
call:printTitle Java厂商切换/JavaVendorSwitching
:: 建立厂商索引 Create a vendor index
set num=0
:: 缓存所有厂商索引 Cache all vendor indexes
set numCache=
:: 展示所有Java厂商 Showcase all Java vendors
for /D %%i in (%~dp0/*) do (
	:: 厂商索引累加 Vendor Index Accumulation
	set /a num+=1
	:: 缓存厂商索引 Cache Vendor Index
	set numCache=!numCache!!num!
	:: 输出厂商索引：厂商 Output Vendor Index: Vendor
	echo !num!:%%~ni
)
echo.
:: 选择Java厂商 Select Java Vendor
set /p choise=--------------------请选择Java厂商/Please Select Java Vendor...
:: 判断厂商索引是否包含输入内容 Determine if the vendor index contains the input
echo !numCache!|findstr %choise% >nul && (
	echo.
	:: 建立厂商索引 Create a vendor index
	set num=0
	:: 匹配索引 Match Index
	for /D %%i in (%~dp0/*) do (
		set /a num+=1
		:: 判断所选Java厂商 Determine the selected Java vendor
		if !num! == %choise% (
			:: 切入厂商目录 Cut to Manufacturer Catalog
			cd %%i
			:: 选择版本 Select Version
			call:choiceVersion %%i %%~ni
		)
	)
) || (
	echo 请输入正确的厂商索引 Please enter the correct vendor index
	:: 重新选择厂商 Re-selection of vendors
	goto choiceBelong
)
goto:eof
:: 选择版本 Select Version
:choiceVersion
	call:printTitle Java版本切换/JavaVersionSwitching
	:: 建立版本索引 Creating a version index
	set version=0
	:: 缓存所有版本索引 Cache all version indexes
	set versionCache=
	echo !version!:上一步/previous step
	:: 展示所有Java版本 Show all Java versions
	for /D %%j in (%~1/*) do (
		:: 版本索引累加 Version Index Accumulation
		set /a version+=1
		:: 缓存版本索引 Cached version index
		set versionCache=!versionCache!!version!
		:: 输出版本索引：版本 Output version index: version
		echo !version!:%%~nj
	)
	echo.
	:: 选择版本 Select Version
	set /p choiseversion=--------------------请选择Java版本/Please Select Java Version...
	:: 判断版本索引是否包含输入内容 Determine if the version index contains the input
	echo !versionCache!|findstr %choiseversion% >nul && (
		echo.
		:: 建立版本索引 Creating a version index
		set version=0
		:: 匹配索引 Match Index
		for /D %%j in (%~1/*) do (
			set /a version+=1
			:: 判断所选Java版本 Determine the selected Java version
			if !version! == !choiseversion! (
				@setx /M JAVA_BELONG %~2 >nul
				echo Java厂商已切换/Vendor has switched: %~2
				@setx /M JAVA_VERSION %%~nj >nul
				echo Java版本已切换/Version has switched: %%~nj
				call:setJavaHome
				echo.
			)
		)
	) || (
		echo "0"|findstr %choiseversion% >nul && (
			goto choiceBelong
		) || (
			echo 请输入正确的版本索引/Please enter the correct version index
			goto choiceVersion
		)
	)
goto:eof
:: 切换开始 Toggle Start
:choice
call:choiceBelong
goto:eof