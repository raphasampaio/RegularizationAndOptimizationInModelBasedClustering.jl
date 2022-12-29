Get-ChildItem -Filter "partes-upload" -Recurse -force | Remove-Item -Force -Recurse
Get-ChildItem -Filter "dsbcaseinfo.dat" -Recurse -force | Remove-Item -Force -Recurse
Get-ChildItem -Filter "upload_*" -Recurse -force | Remove-Item -Force -Recurse