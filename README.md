# debian-setup-script
## What it will do
This is a very simple Setup-script that will:  
    * Install the Packages in the packages.list file  
    * Install KVM/QEMU  
    * Install Docker  
    * Install X11Docker  
    * Install Flatpak  
    * Install Nix Package Manager  
    * Install Github-Cli  
    * Use my dotfiles to configure:  
        * Wayfire  
        * Bash  
        * Neovim  
        * XFCE4  
        * Firefox  
## How to use it
First you need to have sudo privilages regular Debian will not give the Users sudo privilages so you have to give it to the User yourself.  

To do so First switch to the Root user with   

```
su
```

then enter  

```
sudo visudo
``` 

and add your user to the sudoers file with adding  

```
'username' ALL=(ALL:ALL) ALL
``` 

to the sudoers file obviously replacing username with your username.  

Then just become the regular User with  

```
exit
```  

Then you need to download the script with:  

```
git clone https://github.com/JustusFriehl/debian-setup-script
```

Then you run:  

```
./setup.sh
```  

And it will be Done after just a few seconds.  
