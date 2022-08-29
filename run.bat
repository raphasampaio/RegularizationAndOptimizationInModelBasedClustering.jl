@echo off

SET BASEPATH=%~dp0

%JULIA_167% --color=yes --project=%BASEPATH% %BASEPATH%\main.jl %*