@echo off

SET BASEPATH=%~dp0

CALL "%JULIA_194%" --color=yes --project=%BASEPATH% %BASEPATH%\main.jl %*