@echo off

SET BASEPATH=%~dp0

%JULIA_167% --project=%BASEPATH% --color=yes %BASEPATH%\compile.jl