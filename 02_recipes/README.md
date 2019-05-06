# Recipes Lab Exercise
## Chef Fundamentals

This lab focuses on exploring recipe files, and executing them with the chef-client. These exercises should be completed within the provided Windows 2016 training environment.

## What's in a recipe?

_Recipe files are the foundational Chef "script", meaning they are what is executed by the chef-client. Recipes contain Chef resources, and will later be stored within a cookbook._

1. Explore the about page on recipe files [About Recipes](https://docs.chef.io/recipes.html)
   * The first thing mentioned is that a recipe A recipe "is the most fundamental configuration element within the organization." Why would it be considered foundational?
   * This page has a lot of great info on it, but contains many concepts we have yet to cover. After reading over the summary of bullet points, move on to the next step.

2. Navigate to the docs page titled [About the Recipe DSL](https://docs.chef.io/dsl_recipe.html)
   * A Domain-Specific Language, or DSL, is key to many of the configuration files you will write with Chef. This is simply a language that can be used within particular files, and in the case of recipes will be an abstaction of the Ruby programming language.
   * Recipe files are Ruby files (.rb) that will be executed by the chef-client. They may contain any Ruby expressions or statements you like, but is NOT pure Ruby code, as they contain Chef resource. A resource is not pure Ruby, it's Chef code.
   * The docs page states that the recipe DSL is primarily used to declare Chef resources, and when executed by the chef-client ensures safe interaction with a node's underlying OS. It stresses that anything you can do with Ruby, you can do within a recipe, such as using a `case` statement or a conditional like `if`.
   * If this is your first time using Ruby, you may find the [Ruby Style Guide](https://docs.chef.io/ruby.html) to be a valuable resource. If you come across any code that doesn't make sense, this is a great cheat-sheet to have handy.

3. The recipe DSL allows for a number of helper methods only used within these files.
   * The most common method you might see is the `include_recipe` method, which allows you to call recipes from within a cookbook's recipes/ directory. More on cookbooks later.
   * There are lots of other useful methods. We won't take the time to explore them all now, but notice these:
     * attribute?
     * cookbook_name
     * find_resource
     * platform?
     * platform_family?
     * search
     * shell_out
     * registry_key_exists?
   * These methods imply that Chef has a way to detect system properties, and query for those properties as it executes recipe code. We'll discuss this tool, called Ohai, later on.

## Recipes contain resources

4. The execution order of resources within recipes is very straightforward.
   * Resources are compiled from top-to-bottom in the order they appear. They are executed synchronously, meaning one after another. This prevents resources that depend on prior events from attempting to execute if a pre-condition has failed.
     * Does this make sense?
     * The chef-client will fail its run if a resource cannot be executed. For example, a service that has not been installed cannot be configured. Guards (not_if and only_if conditions) can be used to provide custom checks for resources.

5. Ruby code is compiled before Chef resources. This can be very important when you find values driven by Ruby code are not being parsed correctly by a resource.

   * Although not a problem for most beginners, it should be noted that resources are executed _after_ pure Ruby code is compiled. This includes operations like:
     * variable declarations
     * `case` statements
     * conditionals like `if`
     * hash and array declarations
     * class definitions
   * This does _not_ apply to values that are passed within a resource definition itself, such as template variables. This applies to Ruby code outside of resource definitions.
   * When this presents a challenge it can be worked around using a `lazy` block definition or by chaining the `.run_action` method onto the end of a resource definition. See
     * [Lazy Evalutation](https://docs.chef.io/resource_reference.html#lazy-evaluation)
     * [Run in Compile Phase](https://docs.chef.io/resource_reference.html#run-in-compile-phase)

## Introducing the chef-client

6. Recipes are executed by the `chef-client`. We'll examine the chef-client in more detail later on, but for now here's the general definition:
   * The `chef-client` is "an agent that runs locally on every node that is under management by Chef. When a chef-client is run, it will perform all of the steps that are required to bring the node into the expected state"
   * Whether the Chef code is stored on a Chef server or written directly on a node (a machine to be configured by Chef), the chef-client always executed recipes locally on that machine.
   * When a chef-client "run" is performed, each Chef resource whose state can be checked goes through the "test-and-repair" procedure. If a resource is already in the desired state as defined by a recipe, no action is taken.

7. How should the chef-client be called? Again taking the package resource as an example:
   ```
    package 'nginx' do
      version '1.15.12'
      action :install
    end
   ```
   * This resource might be written to a recipe file, such as install_server.rb . Again, recipe files are just Ruby files that contain resources.
   * When the chef-client is executed locally, it is given a recipe to compile and run:
     * `chef-client install_server.rb`
     * generally, the chef-client must be executed with admin or root privileges to make system-level changes.
   * Typically several recipes might be executed in order, and may need supporting files to perform tasks, such as templates or config files to be copied to disk. Because of this we will later store recipes within a file structure called a "cookbook" that contains everything a recipe needs to do its work.
   * These cookbooks are usually stored on a Chef Server, which provides a version control mechanism and indexing of your fleet's details. If your recipes are stored locally instead, the chef-client is run in "local-mode", and handed a recipe or cookbook. 

8. So, to successfully execute our recipe above on a *nix system, you would run:
    * `sudo chef-client --local-mode install_server.rb`
    * Note that this example assumes we're running the command in the same directory where the recipe is stored.
    * The chef-client would then compile the recipe, turning the resources found into pure Ruby code that can be used to make system-level changes.
    * The chef-client is lazy. If the package at the requested version is already installed, then no action is taken. If a lower version is installed, the newer version is installed on top of the older one. In this situation it may be more preferable to use the :upgrade action instead of :install if a newer version is available.
    * Bonus:
      * What package manager would be used on Ubuntu? On Centos? Would this work on Windows?

## Your first recipe

9. Let's get cooking! 
   * In your home directory, create a new file called hello.rb . You can do this from powershell or within your text editor.
   * Open the [Resources Reference](https://docs.chef.io/resource_reference.html) page, or use search to locate the docs for the following resources:
     * file
     * windows_package
     * service
   * Using the `file` resource:
     * create a file at 'c:\users\administrator\hello.txt' with the content "hello, world!"
   * Using `windows_package`:
     * install the "firefox" package from the source
     
       http://archive.mozilla.org/pub/firefox/releases/66.0.3/win64/en-US/Firefox%20Setup%2066.0.3.msi
     * install the "7zip" package locally from the source 

       c:\users\administrator\7zip\7z938-x64.msi
       * note that you should use single-quotes around this path when providing it to the windows_package resource. That has to do with string-interpolation within Ruby, discussed later on.
   * Managing services:
     * Using the `windows_service` resource, stop the Windows Update service (wuauserv) and set its startup_type to manual
     * Using the `service` resource, start and enable the "w32time" service

10. Execute the chef-client
    * Chef the options on the chef-client command's help menu.
    * Remember that the chef-client command must be run in local-mode. What is the short option for this?
    * Execute the hello.rb recipe. Remember we are using windows, and logged-in as the Administrative user.

11. Discussion
    * Once others around you are nearing completion of the lab, discuss:
    * How can you verify your results?
    * What happens when the chef-client is executed again?
    * Why is there both a "service" and "windows_service" resource?
    * Is it a good idea to store all these resources in the same recipe file? What might be a better way to organize them?
    * Bonus: If you haven't seen the chef-client fail yet, try to force a failure. Try to start at the bottom of the output and read your way upwards. 
      * Can you see where the failure occurred? 
      * Are the error messages useful? 
      * By default the chef-client prints to stdout. How might your store this output in a logfile?