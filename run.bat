@echo off

SET BASEPATH=%~dp0

CALL "%JULIA_184%" --color=yes --project=%BASEPATH% %BASEPATH%\main.jl %*