@echo off

SET BASEPATH=%~dp0

CALL "%JULIA_185%" --project=%BASEPATH% --interactive --load=%BASEPATH%\revise.jl
