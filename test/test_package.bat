@echo off

SET BASEPATH=%~dp0

julia --project=%BASEPATH%\.. -e "import Pkg; Pkg.test()"