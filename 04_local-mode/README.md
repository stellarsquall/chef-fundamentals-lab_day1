# chef-client Lab Exercise
## Chef Fundamentals

This lab focuses on the execution of the chef-client in local-mode, and applying recipes stored within cookbooks. These exercises should be completed within the provided Windows 2016 training environment.

## The chef-client

_Cookbooks are the packaging mechanism for Chef, meaning they're how we distribute recipes, supporting files and their documentation to a node to be applied by the chef-client. These recipes are always applied one-after-another, in the order they are given to the client. This order is called the run-list._

1. First, briefly review the docs page [Chef-Client Overview](https://docs.chef.io/chef_client_overview.html)
   * This page summarizes the phases of the chef-client process. The process includes several components that we haven't reviewed yet, including concepts like the Chef Server and the Node Object. Patience :D
   * For now, the major steps to highlight include:
     * Get Config Data
     * Expand the run-list
     * Compile the resource collection
     * Converge the node

2. Navigate to the docs page [chef-client Executable](https://docs.chef.io/ctl_chef_client.html)
   * This docs page contains a summary of the chef-client executable that is much more useful for now. It states that the chef-client "is an agent that runs locally on every node that is under management by Chef. When a chef-client is run, it will perform all of the steps that are required to bring the node into the expected state".
   * These steps include:
     * Registering and authenticating the node with the Chef server
     * Building the node object
     * Synchronizing cookbooks
     * Compiling the resource collection by loading each of the required cookbooks, including recipes, attributes, and all other dependencies
     * Taking the appropriate and required actions to configure the node
     * Looking for exceptions and notifications, handling each as required

## Running without a Chef Server

_Since we don't yet have a Chef Server, we're executing cookbooks written directly on the node. This is a perfectly valid way to use Chef! Cookbooks are always executed locally, but there are benefits to using a Chef Server we'll discuss later on._

3. This lab is concerned with understanding how to run the chef-client in local-mode.
   * You've already experimented with this syntax in executing a single recipe file, whether it's stored in a cookbook or not. However we'll soon find that recipes can call on supporting files from within a cookbook, and the chef-client will need to understand where those files are kept. This is one of the primary reasons to use cookbooks!
   * Checking the help options for the chef-client, you'll find two important flags we'll need to use to execute a recipe in the context of a cookbook.
     * `--local-mode` points the chef-client at a local repository. We'll need this until a Chef Server is integrated into our workflow. This flag can be abbreviated to `-z`.
     * `--runlist` or `-r` supplies an ordered list of recipes to be applied during that run. If a recipe appears more than once it will not be run twice. See [About Run-lists](https://docs.chef.io/run_lists.html) to learn more.
   
4. The format used with the `--runlist` option must include the cookbook that contains a recipe to be executed, or a "role" that encapsulates a runlist into a file for easy reference.
   * These formats looks like this:
     * `'recipe[COOKBOOK_NAME::RECIPE_NAME]'` or
     * `COOKBOOK_NAME::RECIPE_NAME`
   * To execute multiple recipes in order, separate them by commas, without a space:
     * `'recipe[COOKBOOK1::RECIPE1],'recipe[COOKBOOK1::RECIPE2],recipe[COOKBOOK2::RECIPE3]...`
   * The above will execute recipe1 from cookbook1, followed by recipe2 from cookbook1, then recipe3 from cookbook2, and so on. You can run as many recipes as you would like, but remember that the order is important.

5. Try it out!
   * These are all valid ways to execute the myiis::server recipe:
     * `chef-client --local-mode --runlist 'recipe[myiis::server]'` or
     * `chef-client -z -r 'recipe[myiis::server]'` or
     * `chef-client -zr 'myiis::server'`
   * The order of the -z and -r options is important - local-mode must be specified before the runlist.

## Including recipes

6. Having to supply a long runlist to the chef-client on each run is inconvenient, and doesn't make for an automated workflow.
   * Cookbooks should be structured in a way that encapsulates related functionality. The myiis cookbook should only contain recipes and files that support installing and configuring the myiis windows-feature.
   * Similarly, recipes should only contain instructions for performing specific tasks. Instead of setting up a single "server" recipe, later on it would make more sense to have an installation recipe, a setup recipe, and a service recipe to keep these operations logically isolated.
   * This can be automated into a workflow, because recipes can call other recipes!

7. The `include_recipe` method is used to call a recipe from within a cookbook, or from another cookbook when dependencies are properly configured.
   * You can find check the include_recipe docs [here](https://docs.chef.io/dsl_recipe.html#include-recipes)
   * When a recipe is included, the resources found in that recipe will be inserted in the same exact order at the point where the include_recipe keyword is located.
   * The format for the command is the same COOKBOOK::RECIPE used when supplying a runlist:
     * `include_recipe 'COOKBOOK::RECIPE'`
   * Each include_recipe statement should appear on a new line, and included recipes and the recipes they contain will be called in the order they appear.

8. Let's try this out. Notice the default.rb file in the recipes directory. The default recipe came from the `chef generate cookbook` command, and it used to set up a workflow for the cookbook.
   * Open the default recipe. 
   * Use the include_recipe method to call the server recipe by default:
   * `include_recipe 'myiis::server'`

9. Execute the default recipe with the chef-client.
   * `chef-client -z -r 'recipe[myiis::default]'`
     * Verify that the server recipe is called. If not, make sure you've saved the changes to the default recipe.
   * This command can be shortened further to
   * `chef-client -zr 'recipe[myiis]'` or
   * `chef-client -zr 'myiis'`
   * If a recipe isn't specified, the default will be called.