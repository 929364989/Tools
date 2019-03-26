@echo off
set code=%1
set version=%2

echo code: %code%
echo version: %version%

ruby units_md5.rb %code% %version%
ruby history.rb %code%
ruby manifest.rb %code% %version%
ruby update.rb %code% %version%
