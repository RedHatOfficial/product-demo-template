#!/bin/bash

#########################################
##                                     ##
## Creates Demo Project Automagically! ##
##                                     ##
#########################################
clear

# no args need to show help.
if [ $# -ne 1 ]
then
	echo Usage: 
	echo
	echo "     `basename $0` projectname"
	echo
	exit 
fi

echo
echo
echo "#######################################################################################"
echo "##                                                                                   ##"   
echo "##  Setting up your project.                                                         ##"
echo "##                                                                                   ##"   
echo "##                                                                                   ##"   
echo "##  ####  #####  #   #   ####    ##### #####  #   #  ####  #      ###  #####  #####  ##"
echo "##  #   # #     # # # # #    #     #   #     # # # # #   # #     #   #   #    #      ##"
echo "##  #   # ###   #  #  # #    #     #   ###   #  #  # ####  #     #####   #    ###    ##"
echo "##  #   # #     #     # #    #     #   #     #     # #     #     #   #   #    #      ##"
echo "##  ####  ##### #     #  ####      #   ##### #     # #     ##### #   #   #    #####  ##"
echo "##                                                                                   ##"   
echo "##                                                                                   ##"   
echo "##  brought to you by,                                                               ##"   
echo "##                     Eric D. Schabell (@ericschabell)                              ##"
echo "##                                                                                   ##"   
echo "#######################################################################################"
echo
echo

# check if dir for project exists.
if [ -d $1 ]
then
	echo "Directory already exists for $1, please try again..."
  echo
  exit
fi

echo "  Setting up project $1:"
echo
# create project directory.
echo
echo "   Created project directory."
echo
mkdir $1
cd $1

echo 
echo "   Adding main readme file."
echo

echo "Generic $1 Quickstart Guide
============================================================
Demo based on Red Hat [product-name] products.

Setup and Configuration
-----------------------
See docs directory for details on this project.

For those that can't wait, see README in 'installs' directory, add products, 
run 'init.sh' and follow the instructions given.

[insert-quickstart-steps]


Supporting articles
-------------------
None yet...


Released versions
-----------------
See the tagged releases for the following versions of the product:
" > README.md

# create dirs.
echo
echo "   Creating installs directory and readme."
echo
mkdir installs 
echo 'In this directory you fill in this readme file to point the user
to any software needed to run your demo. See below for example of 
what you will find for our current product demos.

The init scripts that install your project will be looking in this
directory for software that might be needed to install for your project
to run on.

=======================================================
Download the following from the Red Hat Customer Portal

* [insert-product] ([insert-product-file].zip)

and copy to this directory for the init.sh script to work.

Ensure that this file is executable by running:

chmod +x <path-to-project>/installs/[insert-product-file].zip
=======================================================
' > installs/README

echo
echo "   Creating projects directory and readme."
echo
mkdir projects
echo 'This directory is for putting your projects source code into. The install script 
will then be pointed here to do any builds, copy of built source binaries to an 
installed product server, etc.
' > projects/README

echo
echo "   Creating support files directory and readme."
echo
mkdir support
echo 'Everything not held in the projects, installs, docs or root of your project 
goes in here... everything means everything... even if it is needed at some point 
to run from the root level of your project, have the init.sh automate it.

Very important to keep the root of the template clean and consistent.
' > support/README

echo
echo "   Creating documentation files directory and readme."
echo
mkdir -p docs/demo-images
echo 'This directory contains any project documentation and you can place images
of screenshots into the demo-images directory. We often link the images into our
root level Readme.md for nice visual displays on github.com.
' > docs/README

echo 
echo "   Creating various .gitignores."
echo
echo 'target/
.DS_Store
' > .gitignore
echo '*.zip' > installs/.gitignore
echo '*.jar' > installs/.gitignore
echo '.metadata' > projects/.gitignore

echo 
echo "   Create example inital init.sh for installation of the project."
echo
echo '#!/bin/sh 
# This is a generated example init for your project, just adjust as needed
# for your needs. It is not a complete setup but parts that give you a few
# hints on how to install a product, build a project and install it on the
# application server (java project).
#
# This same principle can be applied to any language project, the point is
# to keep it simple and clean (KISS). 
#
# Note everything is installed into the target directory, so now that we
# have an easily repeatable installation of your project, you can throw away
# the target directory at any time and run your init.sh to start over!
#

DEMO="YOUR-PROJECT-NAME-HERE"
AUTHORS="YOUR-NAME-HERE"
PROJECT="YOUR-GIT-URL-HERE"
PRODUCT="YOUR-PRODUCT-HERE"
PRODUCT_HOME=./target/PRODUCT-HOME-HERE
SRC_DIR=./installs
SUPPORT_DIR=./support
PRJ_DIR=./projects
INSTALLER=PRODUCT-INSTALLER.jar
VERSION=YOUR-VERSION-HERE

# wipe screen.
clear 

echo
echo "##################################################################"
echo "##                                                              ##"   
echo "##  Setting up the ${DEMO}                           ##"
echo "##                                                              ##"   
echo "##                                                              ##"   
echo "##      ####  ##### #   #  ###                                  ##"
echo "##      #   # #     ## ## #   #                                 ##"
echo "##      #   # ###   # # # #   #                                 ##"
echo "##      #   # #     #   # #   #                                 ##"
echo "##      ####  ####  #   #  ###                                  ##"
echo "##                                                              ##"   
echo "##                                                              ##"   
echo "##  brought to you by,                                          ##"   
echo "##                     ${AUTHORS}          ##"
echo "##                                                              ##"   
echo "##  ${PROJECT} ##"
echo "##                                                              ##"   
echo "##################################################################"
echo

command -v mvn -q >/dev/null 2>&1 || { echo >&2 "Maven is required but not installed yet... aborting."; exit 1; }

# make some checks first before proceeding.	
if [ -r $SRC_DIR/$INSTALLER ] || [ -L $SRC_DIR/$INSTALLER ]; then
	echo Product sources are present...
	echo
else
	echo Need to download $PRODUCT package from the Customer Portal 
	echo and place it in the $SRC_DIR directory to proceed...
	echo
	exit
fi

# Remove old install if it exists.
if [ -x $PRODUCT_HOME ]; then
	echo "  - existing product install removed..."
	echo
	rm -rf target
fi

# Run installer.
echo Product installer running now...
echo
java -jar $SRC_DIR/$INSTALLER 

if [ $? -ne 0 ]; then
	echo Error occurred during $PRODUCT installation!
	exit
fi

echo "Example section: configure your installation here..."
echo

echo "Example section: build your project sources here..."
echo
mvn clean install -f $PRJ_DIR/pom.xml
cp -r $PRJ_DIR/example-project/target/example.war $SERVER_DIR

echo
echo "========================================================================"
echo "=                                                                      ="
echo "=  You can now start the $PRODUCT with:                         ="
echo "=                                                                      ="
echo "=   $SERVER_BIN/standalone.sh                           ="
echo "=                                                                      ="
echo "=  See README.md for general details to run the various demo cases.    ="
echo "=                                                                      ="
echo "=  $PRODUCT $VERSION $DEMO Setup Complete.            ="
echo "=                                                                      ="
echo "========================================================================"

echo' > init.sh


echo 
echo "   Create example inital init.bat for windows installation of the project."
echo
echo '# This is a generated example window init bat file for your project, just adjust as needed
# for your needs. It is not a complete setup but parts that give you a few
# hints on how to install a product, build a project and install it on the
# application server (java project).
#
# This same principle can be applied to any language project, the point is
# to keep it simple and clean (KISS). 
#
# Note everything is installed into the target directory, so now that we
# have an easily repeatable installation of your project, you can throw away
# the target directory at any time and run your init.sh to start over!
#
@ECHO OFF
setlocal

set PROJECT_HOME=%~dp0
set DEMO=YOUR-PRJECT-DEMO
set AUTHORS=YOUR-NAME
set PROJECT=YOUR-GIT-REPO
set PRODUCT=PRODUCT-HERE
set PRODUCT_HOME=%PROJECT_HOME%target\PRODUCT-HERE
set SRC_DIR=%PROJECT_HOME%installs
set SUPPORT_DIR=%PROJECT_HOME%support
set PRJ_DIR=%PROJECT_HOME%projects
set INSTALLER=PRODUCT-INSTALLER.jar
set VERSION=YOUR-VERSION

REM wipe screen.
cls

echo.
echo #################################################################
echo ##                                                             ##   
echo ##  Setting up the %DEMO%                          ##
echo ##                                                             ##   
echo ##                                                             ##   
echo ##       ####  ##### #   #  ###                                ##
echo ##       #   # #     ## ## #   #                               ##
echo ##       #   # ###   # # # #   #                               ##
echo ##       #   # #     #   # #   #                               ##
echo ##       ####  ####  #   #  ###                                ##
echo ##                                                             ##   
echo ##  brought to you by,                                         ##   
echo ##                     %AUTHORS%           ##
echo ##                                                             ##   
echo ##  %PROJECT%##
echo ##                                                             ##   
echo #################################################################
echo.

REM make some checks first before proceeding.	
if exist %SRC_DIR%\%INSTALLER% (
	echo Product sources are present...
	echo.
) else (
	echo Need to download %INSTALLER% package from the Customer Support Portal
	echo and place it in the %SRC_DIR% directory to proceed...
	echo.
	GOTO :EOF
)

REM Remove existing installation if found.
if exist %PRODUCT_HOME% (
	echo - existing product install removed...
	echo.
	rmdir /s /q target"
)

REM Run installer.
echo Product installer running now...
echo.
call java -jar %SRC_DIR%/%INSTALLER% 

if not "%ERRORLEVEL%" == "0" (
	echo Error Occurred During %PRODUCT% Installation!
	echo.
	GOTO :EOF
)

echo Example section: configure your installation here...
echo.

echo Example section: build your project sources here...
echo.
call mvn clean install -f %PRJ_DIR%/pom.xml
xcopy /Y /Q "%PRJ_DIR%\example-project\target\example.war" "%SERVER_DIR%"

echo.
echo ========================================================================
echo =                                                                      =
echo =  You can now start the %PRODUCT% with:                         =
echo =                                                                      =
echo =   %SERVER_BIN%\standalone.bat                           =
echo =                                                                      =
echo =  See README.md for general details to run the various demo cases.    =
echo =                                                                      =
echo =  %PRODUCT% %VERSION% %DEMO% Setup Complete.            =
echo =                                                                      =
echo ========================================================================
echo.

echo' > init.bat

echo
echo "You can new view project $1:"
echo "---------------"
echo $1 | ls -l
echo "---------------"
