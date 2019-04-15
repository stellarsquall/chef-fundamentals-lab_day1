# Resources Lab Exercise
## Chef Fundamentals

This lab is a self-guided exploration of some of the most common Chef resources. You will be exploring the docs to identify resource syntax and using common properties.

## Exploring the docs

_The documentation will be referenced often as you begin learning Chef. Don't focus on memorizing the exact usage for each resource, instead focus on the sytax and properties common to each resource, and how to quickly locate the information you need._

1. Navigate to the Chef docs using your browser at [docs.chef.io](https://docs.chef.io/)
   * The documentation is common to most of Chef Inc.'s open source tools and projects, including:
     * The chef-client 
     * InSpec
     * Habitat
     * Chef Automate 
   * This course focuses on "Chef", meaning the infrastructure automation tooling surrounding the chef-client. Other Chef Inc. automation tools are outside the scope of this course.
   * This information can be located on the left-half of the docs, under the "Chef" section.

2. Open the "Getting Started" and "Concepts" section dropdowns. It's worth exploring some of the docs pages here to get a sense of what common architecture looks like, and the "pull" model that's usually used.

## About resources

3. Locate the search bar in the upper-left corner of the site.
   * Most relevant information can be located easily using search. I recommend this anytime you're exploring a new concept or trying to locate something quickly.
   * Type "resources" into the search bar. Although autocomplete will list a number of suggestions, you can just hit enter and view the results page.

4. Select the option titled "About Resources". Most concepts explored in this class have an "about" page. You should locate this page when learning something new.

5. The first thing you will see on the About Resources page is a summary of what a resource is. Generically:

   * A resource is a statement of configuration policy that:
     * Describes the desired state for a configuration item
     * Declares the steps needed to bring that item to the desired state
     * Specifies a resource type—such as package, template, or service
     * Lists additional details (also known as resource properties), as necessary
     * Are grouped into recipes, which describe working configurations
   * Explore the docs further. What is the "policy" described above, and is implied by the "desired state" for a resource?

6. Next, examine the generic resource syntax. 
   * You will see this in the docs:
   ```
      type 'name' do
        attribute 'value'
        action :type_of_action
      end
    ```
   * So resources have a type, name, attributes (which we will call _properties_) and actions. Resources are written using a Ruby syntax, but don't worry if you're not familiar with Ruby. It's important to use a `do` block when defining resource properties, and each resource should be closed with an `end` statement.
   * The package resource is then given as an example:
   ```
      package 'tar' do
        version '1.16.1'
        action :install
      end
    ```
    * In this example, what is the resource's type, name, given properties, and action?
    * While common properties and default actions can often be excluded, a resource declaration will always have a type and name. 
    * Although not important at this point, you can also create your own Chef resources. The "custom resources" page is where to look for further information here. We will discuss custom resources (installed with community cookbooks) later in class.

## Examine the file, package, and service resources

7. Although the [Resources Reference](https://docs.chef.io/resource_reference.html) page contains a list of all the built-in Chef resources, it's usually more convenient to search for a resource's dedicated page when trying to locate its usage.
   * Review the docs pages for the following resources:
     * package
     * file
     * service
   * Turn to your neighbor or find a group of learners and discuss each of these resources in turn. What should be used when defining their name, properties, and actions? What is common to the resources, and what is different? 
   * When discussing the package resource, notice that it is a platform-independent resource, or generic resource, that references an OS's default package manager. How would you declare a specific package manager to use?
   * Pay special attention to the file resource. Notice the disclaimer that there are several types of file resources. What are they, and what is scenario is each used for?

## Common Functionality

8. Locate the [Common Functionality](https://docs.chef.io/resource_common.html) page.
   * If time permits, browse this page with your discussion partner or group and review these topics:
     * Actions
     * Properties
     * Guards
     * Notifications
   * A complete understanding isn't necessary at this point. Call your instructor over to go over topics that might be confusing.

## Lastly, if you have time...

9. Examine the docs page for the [script](https://docs.chef.io/resource_script.html) resource.
   * Now is a great time to consider why Chef exists. This resource allows Chef to execute any command with the default shell. If this exists, why use Chef resources instead of simply using the script resource for all desired configurations?
   * What benefits do Chef resources provide that the script resource cannot guarantee?
     * hint: if the chef-client is run periodically, what might happen?
     * followup: what is a guard? How might it be used with the script resource, or any other resource?