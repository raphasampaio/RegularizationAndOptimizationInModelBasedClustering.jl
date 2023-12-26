@echo off

SET BASEPATH=%~dp0

%JULIA_185% --color=yes --project=%BASEPATH%\.. -e "import Pkg; Pkg.test()"