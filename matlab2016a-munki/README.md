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

###[Pre-requisites](id:prereqs)

* MATLAB_R2016.iso
* [[Bugfix 1374214](http://www.mathworks.com/support/bugreports/1374124) from Mathworks](id:anchor1). This requires a [Mathworks](http://www.mathworks.com) account.

###[Process](id:process)

* Clone this repo:  
```$ git clone https://github.com/andrewvalentine/osx-scripts.git```
* You should have downloaded the bugfix .zip as per the [Pre-requisites](#anchor1). Move this to the cloned directory, changing the name to something more logical:  
```$ mv /path/to/downloaded/bugfix.zip /path/to/osx-scripts/matlab2016a-munki/1374214.zip``` 
* Copy your latest MATLAB installer ISO into this directory. In this case it is `R2016a_maci64.iso`
* Modify `installer_input.txt` to suit your environment. As a minimum you will need to enter your File Installation Key (FIK).
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
```$ cp MATLAB-R2016a-9.0.0.plist /path/to/munki_repo/pkgsinfo/apps/matlab/```
* Set appropriate permissions:  
```$ chmod 644 /path/to/munki_repo/pkgsinfo/apps/matlab/MATLAB-R2016a-9.0.0.plist```
* Run makecatalogs:  
```$ makecatalogs```  

###[Notes on the pkginfo](id:pkginfo)  

* If needed, the `CFBundleVersion` can be determined via `makepkginfo` on an installed copy of Matlab.
* In my organization, making multiple versions of MATLAB available is essential. Different research groups often require specific versions of the application, so we need to ensure that Munki knows how to present different versions of MATLAB via Managed Software Center.
* To do this, we need to modify the ```installs``` array to determine installation status via the ```path``` and ```file``` parameters.
* You can use any path within the MATLAB_R2016a.app bundle, In this example, I use ```/Applications/MATLAB_R2016a.app/appdata/version.xml```.

###[Further info](id:furtherinfo)

Mathworks' support page on silent installation can be found here:  
  
[Install Noninteractively (Silent Installation)](http://uk.mathworks.com/help/install/ug/install-noninteractively-silent-installation.html)
