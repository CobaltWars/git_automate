@echo off
color F1
setlocal enabledelayedexpansion
cls
mode con: cols=130 lines=50
title Git Automate 

::Variables
set "verif_txt_file=info_user.txt"
set email=
set name=
set mode_d_w=

set compteur=1

goto :title_1

:config_user
echo.
echo     ##############################
echo     Configuration de l'utilisateur
echo     ##############################
echo.
:q_mail
set /p email=Votre adresse e-mail git ?
:: Vérification de la forme de l'email
if "%email%"=="" goto erreur
for /f "delims=@ tokens=1,2" %%a in ("%email%") do (
    if "%%b"=="" goto erreur
    set localpart=%%a
    set domaine=%%b
)
:: Vérification de la partie locale (avant le @)
for /f "delims=. tokens=1" %%a in ("%localpart%") do (
    if "%%a"=="" goto erreur
)
:: Vérification de la partie domaine (après le @)
for /f "delims=. tokens=1,2" %%a in ("%domaine%") do (
    if "%%b"=="" goto erreur
)
goto :q_name
:erreur
echo L'adresse email est invalide ! Veuillez reessayer.
goto :q_mail
:q_name
set /p name=Votre nom d'utilisateur git ?
:q_mode
set /P mode_d_w=Mode dark, hacker ou rester en mode white  ? (DARK/WHITE/HACKER)



echo %email% > %verif_txt_file%
echo %name% >> %verif_txt_file%
echo %mode_d_w% >> %verif_txt_file%

git config --global user.email "%email%"
git config --global user.name "%name%"
if /i "%mode_d_w%"=="DARK" (
    color 0F
) else if /i "%mode_d_w%"=="WHITE" (
    color F1
) else if /i "%mode_d_w%"=="HACKER" (
    color 0A
) else (
    echo Choix invalide. Veuillez réessayer.
    goto :q_mode
)
cls
:menu
if /i "%mode_d_w%"=="DARK " (
    color 0F
) else if /i "%mode_d_w%"=="WHITE " (
    color F1
) else if /i "%mode_d_w%"=="HACKER " (
    color 0A
)
echo      %email% - %name% -- Connecte
echo.
echo      ##############################
echo                   Menu
echo      ##############################
echo.
echo  1. Creer un nouveau repository
echo  2. Push un repository existant
echo.
set /P choix= Votre choix ? 
if /i "%choix%"=="1" (
    goto :create
) else if /i "%choix%"=="2" (
    goto :push
) else (
    echo  Choix invalide. Veuillez réessayer.
    goto :menu
)

:create
echo.
echo      #############################
echo       Creer un nouveau repository
echo      #############################
echo.
set /p emplacement= Emplacement du projet sur votre ordinateur ? 
cd /d "%emplacement%"
git init
git lfs install
echo. > "%temp%\git-lfs-exclude.txt"
for /f "delims=" %%f in ('dir /b /a-d *.* ^| findstr /v /g:"%temp%\git-lfs-exclude.txt"') do (
    if %%~zf gtr 104857600 (
        git lfs track "%%f"
    )
)
git add .
git commit -m "Initial commit"

set /p geturl= Votre lien url de votre repository ? 
git remote add origin "%geturl%"
git branch -M main
git push -u origin main
echo.
echo      #############################
echo      Repository cree avec succès !
echo      #############################
pause
goto :eof

:push
echo.
echo      #############################
echo       Push un repository existant
echo      #############################
echo.
set /p emplacement= Emplacement du projet sur votre ordinateur ? 
cd /d "%emplacement%"
set /p geturl= Votre lien url de votre repository ? 
git remote add origin "%geturl%"
git lfs install
echo. > "%temp%\git-lfs-exclude.txt"
for /f "delims=" %%f in ('dir /b /a-d *.* ^| findstr /v /g:"%temp%\git-lfs-exclude.txt"') do (
    if %%~zf gtr 104857600 (
        git lfs track "%%f"
    )
)
git add .
git commit -m "Push du repository"
git push -u origin main
echo.
echo      #############################
echo      Repository push avec succes !
echo      #############################
pause
goto :eof

:title_1
::::  ________  ___  _________        ________  ___  ___  _________  ________  _____ ______   ________  _________   _______ 
:::: |\   ____\|\  \|\___   ___\     |\   __  \|\  \|\  \|\___   ___\\   __  \|\   _ \  _   \|\   __  \|\___   ___\|\  ___ \ 
:::: \ \  \___|\ \  \|___ \  \_|     \ \  \|\  \ \  \\\  \|___ \  \_\ \  \|\  \ \  \\\__\ \  \ \  \|\  \|___ \  \_|\ \   __/|
::::  \ \  \  __\ \  \   \ \  \       \ \   __  \ \  \\\  \   \ \  \ \ \  \\\  \ \  \\|__| \  \ \   __  \   \ \  \  \ \  \_|/_
::::   \ \  \|\  \ \  \   \ \  \       \ \  \ \  \ \  \\\  \   \ \  \ \ \  \\\  \ \  \    \ \  \ \  \ \  \   \ \  \  \ \  \_|\ \ 
::::    \ \_______\ \__\   \ \__\       \ \__\ \__\ \_______\   \ \__\ \ \_______\ \__\    \ \__\ \__\ \__\   \ \__\  \ \_______\
::::     \|_______|\|__|    \|__|        \|__|\|__|\|_______|    \|__|  \|_______|\|__|     \|__|\|__|\|__|    \|__|   \|_______| 
::::
::::      By CobaltWars

for /f "delims=: tokens=*" %%A in ('findstr /b :::: "%~f0"') do @echo(%%A

if exist "%verif_txt_file%" (
    for /f "tokens=*" %%l in (info_user.txt) do (
        if !compteur! == 1 set email=%%l
        if !compteur! == 2 set name=%%l
        if !compteur! == 3 set mode_d_w=%%l
        set /a compteur+=1
    )
    goto :title_1
) else (
    goto :config_user
)