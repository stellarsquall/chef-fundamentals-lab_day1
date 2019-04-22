# Cookbooks Lab Exercise
## Chef Fundamentals

This lab will guide you through the process of generating a cookbook and recipe, populating the recipe with resources, and executing the recipe to verify your results. This cookbook should be generated and executed within the provided Windows 2016 training environment.

## Generate a cookbook

_Here you will explore the process for generating cookbooks and accessing help menus._

* Log in to the Windows machine using your RDP client.
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
     * You may experience a git warning or error when running the command. Rest assured, your new cookbook should have been generated.
     * To suppress the warning you can set up your Git account if you would like using the `git config` command and entering in your Github/Gitlab credentials, or by supplying fake creds.
     * Git allows us to use version control within cookbooks. Each cookbook will be a separate repository, set up by the generate command. You can use any other source control method you would like with your cookbooks, but I recommend Git.

6. Open the cookbooks directory with your text editor
   * Using any text editor you like, open the cookbooks directory.
   * This can be done from powershell by running `code cookbooks\`
   * Examine the contents of the empty cookbook. This is the standard scaffolding to be expected with the `chef generate cookbook` command. An empty copy of the "myiis" generated cookbook can be found in this directory for comparison.
   * Discussion: What are the most essential components of a cookbook? Some of these files and folders will be unfamiliar until later modules, so for now don't worry about a complete understanding. Turn to a discussion partner/group and discuss the significance of the following:
     * README.md
     * metadata.rb
     * CHANGELOG.md
     * LICENSE
     * .gitignore
     * chefignore
     * recipes/
   * Feel free to discuss the following, but don't focus on these at the moment:
     * Berksfile    
     * .kitchen.yml
     * spec/
     * test/
     * .delivery/
     
## Generate a recipe

_Recipes are Ruby files (.rb) that are stored in a cookbook's recipes/ directory. When a cookbook is executed, a single recipe will be called by the chef-client. Later we will see that recipes can call other recipes, and the resources they contain._

7. Add a recipe to the cookbook called "server"
   * Using the help options for `chef generate`, can you figure out how to do this?
   * Run `chef generate recipe cookbooks\myiis server`. Notice that the .rb file extension is unnecessary. You can also simply add a new file called "server.rb" to the myiis\cookbooks directory, but there are benefits to using the generator.
   * Bonus: what other files did the recipe generator add to the cookbook?

## Populate chef resources
_Here you will use three Chef resources to set up a simple IIS webserver._

8. Populate the recipe with the following resources:
   * powershell_script 'Install IIS'
     * Set the "code" property to 'add-windowsfeature Web-Server'
   * file 'c:\inetpub\wwwroot\Default.htm'
     * Set the "content" property to 'Hello, world!'
   * service 'w3svc'
     * Take the actions of "start" and "enable"

9. Use the docs, found at [docs.chef.io](https://docs.chef.io/) to find examples of the usage for any of these resources. Attempt to finish the recipe yourself before referring to the solution.

## Execute the cookbook with chef-client

_Lastly, save all modified files and execute your new recipe. We will be using "local-mode" to run the recipe files stored on this machine. Later, we will store cookbooks on a Chef Server instead._

10. Examine the help options on the chef-client command
    * `chef-client --help`
    * locate the "local-mode" option, and understand we will be using this flag to run cookbooks that are available locally (and not hosted on a Chef Server)
    * execute the server recipe with `chef-client --local-mode 'recipe[myiis::server]'`

## Verify the results

_How can you check to see if the recipe executed successfully? You will always want to think of ways to check your code directly (ad-hoc), so that you can automate this testing process later on._

11. Use powershell to check your results
    * You can use the `Invoke-WebRequest` command to return what's being served on the localhost. This can be abbreviated to `iwr`:
      * `Invoke-WebRequest localhost` or
      * `iwr localhost`
    * How else can you check your work?
      * Port 80 access should be open to TCP traffic on your instance.

## An introduction to source control with Git
_Each generated cookbook will commit its contents to source control with Git. This can be replaced with any other SCM tool you would like, but in this class we'll use Git._

12. Tracking changes to your cookbooks 
    * Discussion: What's your level of experience with Git/Github?
      * Beginner
      * Novice
      * Advanced
    * We will be covering a beginner-level understanding of git principles in this class to enable everyone to track changes to their local cookbooks. In the future this practice will be essential to managing the cookbooks that are deployed to remotely managed nodes, whether using a Chef Server or not.

13. The most common commands for tracking changes to local git repositories include:
   ```
   git status
   git add
   git commit -m
   ```
   * Try it out:
     * To run a git command, you must be within the git repository, where the .git directory is located. If you should need to initialize an existing cookbook (or a git repo in general) you can use the `git init` command. Change into the myiis/ directory:
       * `cd ~\cookbooks\myiis`
     * Now, check the status of the cookbook:
       * `git status`
     * You should see that git notices that since the cookbook has been generated, a new recipe has been added (and files within spec/ and test/). These files have yet to be tracked with git, meaning we need to "add" these changes to source control with:
       * `git add .`
     * Files that have been added are placed in the "staging area" before changes will be hashed. This gives us an opportunity to decide what we want to track. Run `git status` again. You should see that all the new files have been "added" to git, meaning that changes to these files will be tracked. Before this occurs, we need to "commit" our changes, which hashes the content in our tracked files, creating an immutable record of the history and state of the myiis repository. Try this with:
       * `git commit -m 'added server recipe and resources'`
     * Congrats, you've made you're first commit!
     
14. Gitting Git    
     * The output of the `git commit`command should provide a summary of the hash id, and how many files have changed, including insertions and deletions. The `-m` option on the commit command allows us to add a message to the commit, which should describe what changes have been made, and why. Ideally this message will communicate to others who review and contribute to the cookbook why the change was made, so be precise and specific with your commit messages.
    * We can verify that our changes have been committed with `git status`, which should report "nothing to commit, working tree clean". This is the ideal state when you're tracking changes.
    * The smaller the commits, the better. Don't try to make large changes that are difficult to test. Instead, make small changes that are easy to document and describe. This will save you and anyone reviewing your code a lot of headaches going forward.
    * Other useful commands:
      * `git log`
        * produces 
      * `git diff`
        * Show changes between commits. Especially useful if your work was interrupted or if you made multiple changes to a file.
      * `git add /path/to/file`
        * Add a single file at a time to the staging area. If multiple changes have been made, this enables you to attach a commit message to those files alone.
      * `git rm`
        * This removes a file from the working tree and the git index. Use with care.
    * This course will not focus on managing upstream repositories with tools like Github or Gitlab, which are separate from the Git tooling itself. The above tutorial will suffice for tracking changes for this course, however you should become familiar with the following commands to enable you to work with collaborators later on:
      * `git clone`
        * Copies a repository from an external location to the local disk. This will include the entire git history.
      * `git pull`
        * Pull new changes from an upstream repository into the local copy. Be aware that this may overwrite local changes you've made, or produce a merge conflict if you've committed changes locally without pushing to the upstream branch.
      * `git push`
        * Push changes (commits) to an upstream repository. May require a pull request depending on your contribution rights for the repo.
      * `git branch`
        * Create a "branch" of the repo, where you can experiment with new changes and features without mutating the "master" branch codebase. After you're happy with your changes, they must be "merged" back into the master branch. Many times this must be approved with a pull request.
      * `git merge`
        * Merge two branches of a repo together, most often into the master branch. This is a bit of an art, and should be practiced so that changes aren't lost and branches don't become too difficult for maintainers to merge. The owner of a repo may reject a pull request if the history is too difficult to merge or not well documented.
    * For more on git, check out some of the great tutorials over at:
      * [Git-SCM](https://git-scm.com/book/en/v1/Getting-Started-Git-Basics)
      * [Try Github](http://try.github.io)
      * [Learn Git Branching](https://learngitbranching.js.org)