@echo off

SET FORMATTER_DIR=%~dp0

%JULIA_185% --project=%FORMATTER_DIR% %FORMATTER_DIR%\format.jl