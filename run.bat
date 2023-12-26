@echo off

SET BASEPATH=%~dp0

CALL "%JULIA_185%" --color=yes --project=%BASEPATH% %BASEPATH%\main.jl %*