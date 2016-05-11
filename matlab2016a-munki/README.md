Deploying MATLAB_R2016a with Munki
=====================

* [Info](#info)  
* [Pre-requisites](#prereqs)  
* [Process](#process)  
* [Further info](#furtherinfo)

###[Info](id:info)

These instuctions cover how to deploy a network licensed instance of MATLAB_R2016a via Munki.

Once complete, you will have a package that deploys via Munki as follows:  

* Copies `Matlab-R2016a-installer-files.dmg` to the local client.  
* Unpacks the required files to /tmp.  
* Uses the postinstall script to execute a silent install.
* Uses the postinstall script to apply bugfix 1374214.
* Uses the postinstall script to modify the CFBundleIdentifier in $MATLAB.app/Contents/Info.plist. This avoids pkg receipt conflicts, and therefore allows multiple version of Matlab to be installed on a given client.

###[Pre-requisites](id:prereqs)

* MATLAB_R2016.iso
* [[Bugfix 1374214](http://www.mathworks.com/support/bugreports/1374124) from Mathworks](id:anchor1). This requires a [Mathworks](http://www.mathworks.com) account.

###[Process](id:process)

* Clone this repo:  
```$ git clone https://github.com/andrewvalentine/osx-scripts.git```
* You should have downloaded the bugfix .zip as per the [Pre-requisites](#anchor1). Move this to the cloned directory, changing the name to something more logical:  
```$ mv /path/to/downloaded/bugfix.zip /path/to/osx-scripts/matlab2016a-munki/1374214.zip``` 
* Copy your latest MATLAB installer ISO into this directory. In this case it is `R2016a_maci64.iso`
* Modify `installer_input.txt` to suit your environment. As a minimum you will need to enter your File Installation Key
* Modify `network.lic` to suit your environment.
* Make `make-matlab-dmg.sh` executable:  
```$ chmod +x make-matlab-dmg.sh```
* Edit `make-matlab-dmg.sh`. You will need to the edit the `$INSTALLER` and `$BUGFIX` variables.
* Make the .dmg:  
```$ ./make-matlab-dmg.sh```
* Copy the resulting .dmg to your munki_repo:  
```$ cp Matlab-R2015a-installer-files.dmg /path/to/munki_repo/pkgs/apps/matlab/```
* Set appropriate permissions:  
```$ chmod 744 /path/to/munki_repo/pkgs/apps/matlab/Matlab-R2016a-installer-files.dmg```  
* Copy the pkginfo to your munki_repo:  
```$ cp MATLAB-R2016a-8.5.0.plist /path/to/munki_repo/pkgsinfo/apps/matlab/```
* Set appropriate permissions:  
```$ chmod 644 /path/to/munki_repo/pkgsinfo/apps/matlab/MATLAB-R2016a-8.5.0.plist```
* Run makecatalogs:  
```$ makecatalogs```  

###[Notes on the pkginfo](id:pkginfo)  

* The `CFBundleVersion` can be determined via `makepkginfo` on an installed copy of Matlab.
* By default, Mathworks' `CFBundleIdentifier` in any given version of Matlab is `com.mathworks.matlab`. This causes conflicts when deploying multiple versions of Matlab. For example, let's say you have MATLAB_R2013a and MATLAB_R2014a available via Managed Software Center. If a user installs MATLAB_R2014a, the app will install with the identifier `com.mathworks.matlab`. Managed Software Center will then report that both 2013 and 2014 are installed, and the user will not be able to install MATLAB_R2013a.
* You must therefore configure your install package to modify the `CFBundleIdentifier`. This will enable your clients to differentiate between the versions you have made available. You should do this in the following 2 ways:
* This identifier should be set in the `installs` array.
* The client side identifer should also be modified using `plutil` in the `postinstall` script.

###[Further info](id:furtherinfo)

Mathworks' support page on silent installation can be found here:  
  
[Install Noninteractively (Silent Installation)](http://uk.mathworks.com/help/install/ug/install-noninteractively-silent-installation.html)
