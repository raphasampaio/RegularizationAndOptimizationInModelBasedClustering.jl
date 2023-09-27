@echo off

SET BASEPATH=%~dp0

CALL "%JULIA_184%" --project=%BASEPATH% --interactive --load=%BASEPATH%\revise.jl
