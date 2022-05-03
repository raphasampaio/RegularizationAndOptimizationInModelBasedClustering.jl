@echo off

SET BASEPATH=%~dp0

@REM Colocar variaveis de ambiente se necessário
SET XPRESS_JL_NO_DEPS_ERROR=1
SET XPRESS_JL_NO_AUTO_INIT=1
SET XPRESS_JL_SKIP_LIB_CHECK=1
SET XPRESS_JL_NO_INFO=1

SET XPRESSDIR=
SET XPAUTH_PATH=

julia --project=%BASEPATH%\.. -e "import Pkg; Pkg.test()"