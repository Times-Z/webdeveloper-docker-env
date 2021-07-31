:: Get path of current dir (work in admin mode)
SET path=%~dp0

:: Echo alias for docker up in westart.cmd (alias is westart)
(
@echo docker-compose -f %path%docker-compose.yml up -d
) > %windir%\westart.cmd

:: Echo alias for docker dow in westop.cmd (alias is westop)
(
@echo docker-compose -f %path%docker-compose.yml down
) > %windir%\westop.cmd
