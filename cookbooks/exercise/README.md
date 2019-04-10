# Cookbooks Lab Exercise
## Chef Fundamentals

This lab will guide you through the process of generating a cookbook and recipe, populating the recipe with resources, and executing the recipe to verify your results. This cookbook should be generated and executed within the provided Windows 2016 training environment.

## Generating a cookbook

* Login to the Windows machine using your RDP client.
  * Ask the instructor for connection details if needed.

1. Double-click the "ChefDK" icon on the desktop. This should open a customized powershell session with the Chef tooling available.
2. Ensure you are navigated into the home directory, C:\Users\Administrator
  * You can always get home by running `cd ~`
3. If it doesn't exist, create a new directory called "cookbooks"
  * Run `mkdir cookbooks`, or `mkdir c:\users\administrator\cookbooks`
  * Ensure the directory exists by running `dir` or `ls` in the home directory.
4. Execute `chef generate --help` and examine the output and options. Notice how to ask for help about any additional subcommands with --help
5. Generate a new cookbook called "myiis"
  * From the home directory, run `chef generate cookbook cookbooks\myiis`
6. Open the cookbooks directory within your text editor
  * Using any text editor you like, open the cookbooks directory.
  * This can be done from powershell by running `code cookbooks\`
  * Examine the contents of the empty cookbook. This is the standard scaffolding to be expected with the `chef generate cookbook` command. An empty copy of the "myiis" generated cookbook can be found in this directory for comparison.
7. Add a recipe to the cookbook called "server"
  * Using the help options for `chef generate`, can you figure out how to do this?
  * Run `chef generate recipe cookbooks\myiis server`. Notice that the .rb file extension is unnecessary. You can also simply add a new file called "server.rb" to the myiis\cookbooks directory, but there are benefits to using the generator.
8. Populate the recipe with the following resources:
  * powershell_script 'Install IIS'
    * Set the "code" property to 'add-windowsfeature Web-Server'
  * file 'c:\inetpub\wwwroot\Default.htm'
    * Set the "content" property to 'Hello, world!'
  * service 'w3svc'
    * Take the actions of "start" and "enable"
9. Use the docs, found at [docs.chef.io](https://docs.chef.io/) to find examples of the usage for any of these resources. Attempt to finish the recipe yourself before referring to the solution.
10. Lastly, save all modified files and execute your new recipe.
  * Examine the help options on the chef-client command
    * `chef-client --help`
    * locate the "local-mode" option, and understand we will be using this flag to run cookbooks that are available locally (and not hosted on a Chef Server)
    * execute the server recipe with `chef-client --local-mode 'recipe[myiis::server]'`

## Verify the results
* Outbound to AWS

### Stuff