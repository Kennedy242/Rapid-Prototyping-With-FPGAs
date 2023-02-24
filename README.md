# Rapid-Prototyping-With-FPGAs

This repo will store the projects created for the course ECE-5211 Rapid Prototyping with FPGAs.

###### Homework 3 - wash_machine_controller
* Design and simulate controller for wash machine
###### Homework 4 - spi_master
* Design, simulate and synthesize a serial peripheral interface (SPI) to support an RDID instruction
###### Homework 5 - rdid_instruction
* < description >
    
 <br>

 #### Reports
Project reports will be written in LaTex and stored in reports/\<corresponding project name>. The reports are written using [Overleaf](https://www.overleaf.com) and each report is a submodule to this repo.<br>
##### Instructions to add a new report as a submodule to the project:
Note for first time use: Go to Account -> Account Settings then click link with GitHub sync to connect to your github account. 
* Create and open the report in overleaf
* Click menu in the top left corner
* From the Sync section, click Git
* A link will be provided to clone the report repo. Copy this link
* From this FPGA repo in the report directory run the following command:
Note: Omit "git clone" from the copied link
```
git submodule add <link copied from overleaf> <name of report>
Example: git submodule add https://git.overleaf.com/63f110afe74b04a2b05acda4 template/
``` 
* In this FPGA repo, running `git status` should show that two files were changed. ./gitmodules and <name of report>/
* Commit these two files
```
Example:
 git add .
 git commit -m "add <name of report> as a submodule
```
 Every time an edit is made to the report in overleaf, this repo will contain the changes. 
 * To update the report in this FPGA repo, navigate to <name of report> directory and run the following commands: 
 ```
git fetch 
git status // This should show master has changed and suggest "git pull"
git pull // as long as the previous command includes "fast-forward"
cd ..
git status // should show <name of report> has new commits
git add .
git commit -m "update hash"
 ``` 

##### Steps to finalize project once it is complete
* Make sure all source code is pushed to git
* In Overleaf, refresh source code files and then recompile document
* Make sure the hash is updated to master in the corresponding report for the submodule

