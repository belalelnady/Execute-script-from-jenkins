# Execute a script from github with Jenkins
This is a simple example for executing a script from github using jenkins freestyle build

## 1. Create a freestyle
1. From jenkins dashboard open New item
2. Select freestyle project and give it a name without any spaces
3. In the configuration page of the freestyle 
4. Add a Description if you want
5. Select **Git** from **Source Code Management**
6. Add the public repository link in the Repository URL input field
7. Branches to build input choose the branch `*/main` 
	- Make sure that the main branch in your public repository is named `master` if you want to keep it `*/master`
	- You can keep it blank for 'any'
8. Select **Execute shell** from **Build Steps** and write the execution of  the script file 
```bash
/bin/bash hello.sh
```
9. Select Build Now
