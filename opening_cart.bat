@echo off
cd "C:\Users\fenan\lenguagens_de_programmation\tic-80"
:menu

echo --------------------------------------------------------
echo o que vc quer fazer?
echo     1 = rodar um arquivo
echo     2 = acao avancada
echo     3 = lista de comandos para usar na "acao avancada"
echo  -------------------------------------------------------

SET /P "menu=selecao: "

if %menu%==1 (
	cls
	goto run
)
if %menu%==2 (
	cls
	goto advanced_run
)
if %menu%==3 (
	goto list
)

:run
SET /P "cart=arguivo a ser rodado: "
tic80.exe %cart%
goto menu

:advanced_run
SET /P "cart=arguivo a ser rodado: "
SET /P "comandos=Comandos: "
tic80.exe %cart% %comandos%
goto menu

:list
tic80.exe -h --keepcmd
goto menu
