#!/bin/bash

# Run this script to create a DMG containing the Matlab installer files

# Enter a volume name
VOLNAME="Matlab-R2016a-installer-files"

# Filenames you want to pack
INSTALLER="R2016a_maci64.iso"
LICENSE_FILE="network.lic"
INSTALLER_FILE="installer_input.txt"
BUGFIX="1374124.zip"

# STOP EDITING
	
output_Name="${VOLNAME}.dmg"

mkdir tmp
ls ${INSTALLER} ${LICENSE_FILE} ${INSTALLER_FILE} ${BUGFIX}| while read script
do
	echo "MATLAB DMG maker."
	mv $script tmp/
done
hdiutil create \
	-volname "${VOLNAME}" \
	-srcfolder ./tmp \
	-ov \
	$output_Name
mv tmp/* .
rm -rf tmp
exit 0
