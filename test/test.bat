@echo off

SET BASEPATH=%~dp0

%JULIA_184% --color=yes --project=%BASEPATH%\.. -e "import Pkg; Pkg.test()"