### PreRequisites

- Install Node and NPM

### Setup

    git clone https://github.com/ng-learn-org/workshop.git
    cd workshop
    npm install
    npm install -g bower
    bower install


### Step 0 - Setup the AngularJs App

    git checkout -f step-0

- Add AngularJs library to our index.html

    ``` html
      <div>Welcome to the AngularJS World</div>
      
      <script src="bower_components/angular/angular.js"></script>
    
    </body>
    ```

- Bootstrap the AngularJS app using the automatic method

    ``` html
    <body ng-app>
    ```

- Lets update our welcome message

    ``` html
    <div>Welcome to the AngularJS World, {{userName}}</div>
    ```

- Start the app

    ``` coffeescript
    grunt server
    ```

  **Notes:** The application should say "Welcome to the AngularJS World," but the "{{userName}}" portion should not be visible. Angular has kicked in and it does not display it because that variable is not binded to anything, yet!

### Step 1 - Defining our first module

    git checkout -f step-1

- Lets name our application

    ``` html
    <body ng-app="myStoreApp">
    ```

- Create app.coffee inside app folder and define our application in app.coffee

    ``` coffeescript
    angular.module("myStoreApp", [])
    ```

  **Notes:** Here we define a module named 'myStoreApp'. The second parameter it is an array of dependencies required for this module.

- Add app.js to our index.html so the browser will load it

    ``` html
      <div>Welcome to the AngularJS World</div>
   
      <script src="bower_components/angular/angular.js"></script>
   
      <!-- build:js({.tmp,app}) scripts/scripts.js -->
      <script src="scripts/app.js"></script>
      <!-- endbuild -->
    </body>
    ```

  **Notes:** we add our js file wrapped in a 'build comment' so our toolchain converts it from coffee script to javascript.

- To prove our point, we will add a Run block to our module. Run blocks are the closest thing in Angular to the main method in Java.
  It will be executed after all the dependencies have been injected. Open app.coffee and make the following modification

    ``` coffeescript
    angular.module("myStoreApp", []).
      run ->
        console.log 'Its alive!'
    ```

  Lets run 'grunt server' in the terminal. This will open a browser with out application. Lets open the developer tools and on the console you should find "Its alive!".
  Congratulations. You've created your first Angular module.

### Step 2 - Defining our first controller

    git checkout -f step-2

- Now we are going to create a controller and provide our application some behaviour. Open index.html and lets add ng-controller to our div.

 ``` html
 <div ng-controller="welcomeController">Welcome to the AngularJS World, {{userName}}</div>
 ```

 **Notes:** When you do this, Angular will look for a controller - inside of our myStoreApp module - called welcomeController. This controller will only have power over whats happening inside our 'div'. We will refer to this domain as scope.

 Lets run the app and see what happens. The application will run without obvious problems. Now if we open the developer tools and take a look at the console we are going to see an error. This error is telling us the controller we are trying to use, it is not yet defined.

 - Lets define our controller. Open app.coffee and make the following modifications.

 ``` coffeescript
 angular.module("myStoreApp").controller "welcomeController", ["$scope", ($scope) ->
     $scope.userName = "Santiago Esteva"
 ]
 ```

 **Notes:** A few things have happened.
    - We just created a new controller inside our module. We named it "welcomeController".
    - When we use a module we do not declare its dependencies. We declare dependencies only the first time we defined the module.
    - After naming our controller, we pass its dependencies **' ["$scope", '** and then we defined the name these dependencies will have locally **' ($scope) -> '**. This means that we could have renamed them to whatever we wanted. **Example:  angular.module("myStoreApp").controller "welcomeController", ["$scope", (localScope) -> .**
As a best practice we keep the same names, specially when we deal with Angular objects.

 Let's open the application and see what we have. The application should not have any error and now you should see "Welcome to the AngularJS World, Santiago"


- Finally, lets make a few more changes on our index.html.

 ``` html
 <div ng-controller="welcomeController">
     Welcome to the AngularJS World, {{userName}}
     <hr>
     <p>Inside the controller: <input name="userName" ng-model="userName"/></p>
 </div>
 <hr>
 <div>
     <p>Outside the controller: <input name="userName" ng-model="userName"/></p>
 </div>
 ```

 Now, lets play with the inputs and lets see what happens. As you can see the first input generates the Bidirectional binding between the input and the welcome phrase.
 This is Angular magic. the userName variable exists under an specific scope, the controller's scope. This is why the input that exists outside our controller does not change and when we enter text it does not change the welcome phrase.

### Step 3 - Our first Requirement

    git checkout -f step-3
If you get "Karma is not a task" or "Karma is not found". Please execute

    npm install grunt-karma --save-dev
    npm install karma-ng-scenario --save-dev


 **AC:** As a User, when I open myStore home page, then I should see the phrase "Welcome to the AngularJS World, {{fullName}}".

 **Assumptions:** The application already has an object called profile that contains firstName and lastName.

 - **Development Flow - Unit Test:** Now that we know our AC, we need to write our first unit test. Under test lets create a folder spec and a subfolder called controllers. And inside lets create a file called welcomeControllerSpec.coffee

  ``` coffeescript
  describe "Controller: WelcomeController", ->

    # load the controller's module
    beforeEach module("myStoreApp")

    welcomeController = scope = undefined

    # Initialize the controller and a mock scope
    beforeEach inject(($controller, $rootScope) ->

      $rootScope.profile =
        firstName: "First"
        lastName: "Last"

      scope = $rootScope.$new()

      welcomeController = $controller("welcomeController",
        $scope: scope
      )
    )

    it "should compose the fullName based on firstName and lastName attributes from prexisting profile object", ->
      expect(scope.fullName).toBe "First Last"
  ```

  Lets run the tests, go to the console and execute 'grunt test'. You will see "Expected undefined to be 'Santiago Esteva'." and "PhantomJS 1.9.2 (Linux): Executed 1 of 1 (1 FAILED) ERROR (0.183 secs / 0.009 secs)"
  That's actually great. This is the expected output. Now we have a failing unit test that we can code against. Kudos!

 - **Development Flow - Coding:** Now we will write the minimum amount of code to make the unit test pass. In our app.coffee we will create the function to compose the fullName

  ``` coffeescript
  angular.module("myStoreApp").controller "welcomeController", ["$scope", ($scope)->
      $scope.fullName = $scope.profile.firstName + " " +  $scope.profile.lastName
  ]
  ```

  The business logic is covered. Lets make the changes on the UI. Go to index.html and update the welcome phrase div.

  ``` html
  Welcome to the AngularJS World, {{fullName}}
  ```

  Lets run the app with 'grunt server'.
  How come we still see {{fullName}}? That's because we don't have a preexisting profile object. Lets cover this with some stubbed data. Open app.coffee and update the run block.

  ``` coffeescript
    angular.module("myStoreApp", []).
      run ($rootScope) ->
        console.log 'Its alive!'

        # Prexisting profile object
        $rootScope.profile =
          firstName: "Santiago"
          lastName: "Esteva"
  ```

  Lets refresh the app. You should now see "Welcome to the AngularJS World, Santiago Esteva".

  **Notes:** This actually brings up an interesting subject. When we created the myStoreApp, Angular created a $rootScope. This is parent of all scopes. At the run block, we instructed Angular to inject an object Profile with certain attributes.
  Our welcome phrase lives inside the welcomeController's scope. All scopes inherit from its parent and ultimately from $rootScope. This is why we can refer to $scope.profile.firstName in our controller.

### Step 4 - Our second Requirement

    git checkout -f step-4

**AC:**
  1. As a User, when I open myStore home page, then I should see the login form requesting username and password.
  2. As a User, when I fill in the login form, then I should be redirected to my welcome page.
  3. As a User, when I get to my welcome page, then I should see the phrase "Welcome to the AngularJS World, {{fullName}}".

**Assumptions:**
  1. All login attempts are successful.
  2. When the user fills the form, our application needs to pass the username and password to our Profile Service. Our Profile Service returns a Profile containing user's Full Name.

### AC 1
AC 1 seems to require a change on the flow. We need to add another test to our test nest. For this change, a unit test will not do. Instead, we will do an E2E test. E2E should be considered the Angular keyword to describe Component or UI testing.

 - **Development Flow - E2E Test:** In this case, we can create an E2E test to validate the first page we hit is the login page. Create a new folder under test. Lets call it e2e. Then create a new file called "loginScenario.coffee".

 ``` coffeescript
 describe "Login Flow", ->

   beforeEach ->
     browser().navigateTo "/"

   it "should be the first page", ->
     expect(element("h1").text()).toBe "Login"
 ```

 If we run 'grunt test' then all unit and e2e test will be executed. We now have a failing test.

 - **Development Flow - Coding:**  Adding an H1 tag in our index.html would be enough to make this test go green. Since we are alraedy there, lets add a small form requesting a username and password.

 ``` html
 <div>
     <h1>Login</h1>
     <form>
         <label>username</label><input name="username">
         <label>password</label><input name="password">
         <button>Login</button>
     </form>
 </div>

 <div ng-controller="welcomeController">
     Welcome to the AngularJS World, {{fullName}}
 </div>
 ```

 Lets run the app and see what we got. As you can see we now have the Login section and the welcome phrase all together on the same page. This is not the flow requested. Lets fix that. We are going to create two different views: one for the login page and one for the welcome page.

 - Create a new file under app/views and call it 'login.html' and cut/paste the div containing the Login H1 and form.
 - Create a new file under app/views and call it 'welcome.html' and cut/paste the div containing the welcome phrase.

 If we run the app right now, nothing will be displayed since we have removed all the content from that index.html. Now we need to attach the views to our app flow. How do we do that?

 - Step 1: In our index.html we will add a container for our views.

 ``` html
  <div ng-view></div>
 ```
 **Notes:** The ng-view directive is the one Angular will find and insert/remove/swap the views.

 - Step 2: Now we need to tell Angular what view to include based on the url we are at. so if we are in '/' we want to display the login page. if we are at '/welcome' we want to display the welcome page. In order to that we will Routes to our main module 'myStoreApp'. Lets go to app.coffee and make the following modifications:

 ``` coffeescript
 # Define main module and its dependencies
 angular.module('myStoreApp', [])

 # Add configuration to the module; such as routes
 angular.module("myStoreApp").config ($routeProvider) ->

     # When the url matches / then we inject the login html
     $routeProvider.when("/",
       templateUrl: "views/login.html"
     )

 # Add a run block. This is executed only once when the app is bootstrapped.
 angular.module("myStoreApp").run ($rootScope) ->
     console.log 'Its alive!'

     # Prexisting profile object
     $rootScope.profile =
       firstName: "Santiago"
       lastName: "Esteva"

 # Add a controller to our main module/
 angular.module("myStoreApp").controller "welcomeController", ["$scope", ($scope)->

     $scope.fullName = $scope.profile.firstName + " " +  $scope.profile.lastName

 ]
 ```

 Now lets add a route for our welcome page.

 ``` coffeescript
 # When the url matches / then we inject the login html
 $routeProvider.when("/",
     templateUrl: "views/login.html"
 ).when("/welcome",
     templateUrl: "views/welcome.html"
 )
 ```

 Lets run our app. 'grunt server' and we should find the login form being displayed. The url is 'http://localhost:9000/#/' The portion we should be paying attention to is '#/'. If we change the url manually to 'http://localhost:9000/#/welcome' the application will change the view and it will now display the welcome phrase only.
 AC 1 seems to be covered. We are in a good state to commit our code. We have added value and left everything in a good position so somebody else could pick this up tomorrow.


### AC 2

    git checkout -f step-4b

 "As a User, when I fill in the login form, then I should be redirected to my welcome page."

 It seems that once again, we could start with a flow interaction test. When I click on Login button, the application should redirect to the welcome page. We have two options to test this.
 We could extend our E2E test simulating the user has filled the form, click Login and expect the welcome view has been attached and the welcome phrase is now displayed.
 We can also write a unit test taking advantage we have access to the $location service, who is responsible for making that url change which ultimately produces the view change.
 Which one to choose? 600 unit tests will run in 2 secs. 20 E2E test will execute in 1-2 mins. Taking into account the validation is covered by both test, the economic option seems to be the best fit in this case.

 - **Development Flow - Unit Test:** Lets create a new test inside our spec/controllers folder. Lets call it "loginController.coffee"

    ``` coffeescript
    describe "Login Controller", ->

      # load the controller's module
      beforeEach module("myStoreApp")

      loginController = scope = undefined

      # Initialize the controller
      beforeEach inject ($controller, $rootScope) ->
        scope = $rootScope.$new()

        loginController = $controller "loginController",
          $scope: scope

      describe "When clicking the submit button", ->

        it "should go to the welcome page", ->
    ```


   If we run grunt test, we will get a message saying "Error: Argument 'loginController' is not a function, got undefined" Lets switch and code the minimum code to make this test green.

 - **Development Flow - Coding:** Lets create a new controller inside our app. In our app.coffee lets add the new controller.

    ``` coffeescript
    angular.module("myStoreApp").controller "loginController", ["$scope", ($scope)->

    ]
    ```

   Run the tests again. Success!

 - **Development Flow - Unit Test:** Lets add a new expectation in our test, so when we click the submit button the app is redirected to the welcome page.

    ``` coffeescript
    describe "Login Controller", ->

      # load the controller's module
      beforeEach module("myStoreApp")

      loginController = scope = location = undefined

      # Initialize the controller
      beforeEach inject ($controller, $rootScope, $location) ->
        location = $location
        scope = $rootScope.$new()

        loginController = $controller "loginController",
          $scope: scope

      describe "When clicking the submit button", ->

        it "should go to the welcome page", ->
          scope.submit()
          expect(location.path()).toBe("/welcome")
    ```

   Run grunt test and you will see a new error: TypeError: 'undefined' is not a function (evaluating 'scope.submit()'). Switch!

 - **Development Flow - Coding:** We will add a new function to our scope and use the location service to change the path.

    ``` coffeescript
    angular.module("myStoreApp").controller "loginController", ["$scope","$location", ($scope, $location)->

      $scope.submit = ()->
        $location.path "/welcome"

    ]
    ```

   Lets run the tests again...success!
   Are we missing something? Lets attach this new behaviour to our View.
   In our login.html we will give the control to our loginController and attach our submit function to out Login button.

    ``` html
    <div ng-controller="loginController">
        <h1>Login</h1>
        <form>
            <label>username</label><input name="username">
            <label>password</label><input name="password">
            <button ng-click="submit()">Login</button>
        </form>
    </div>
    ```
   Lets run the app with 'grunt server' and hit the Login button. AC 2 seems to be covered. Lets move to AC 3.

### AC 3

    git checkout -f step-4c

 "As a User, when I get to my welcome page, then I should see the phrase "Welcome to the AngularJS World, {{fullName}}"."

 **Assumptions:**
   1. All login attempts are successful.
   2. When the user fills the form, our application needs to pass the username and password to our Profile Service. Our Profile Service returns a Profile containing user's Full Name.

 - **Development Flow - Unit Test:** We will start by creating a unit test for our ProfileService. We will create the file profileServiceSpec.coffee inside a new folder called services inside Spec.

   ``` coffeescript
   describe "Profile Service", ->

     # load the controller's module
     beforeEach module("myStoreApp")

     profileService = undefined

     # create an instance of the ProfileService and assign it to my local variable
     beforeEach inject ($injector) ->
       profileService = $injector.get 'profileService'

     it "login user with username and password", ->
       profileService.login("myUser", "myPassword")
   ```

   Now if we run 'grunt test' we should get an error saying **"Error: Unknown provider: ProfileServiceProvider <- ProfileService"** since our ProfileService does not actually exist yet. Lets fix that.

 - **Development Flow - Coding:** Since our application is still small, we will keep working on our app.coffee. Only fix the problem you have in front of you. Lets add a new service.

   ``` coffeescript
   angular.module("myStoreApp").service "profileService", [ ->

       login: ()->

   ]
   ```

   We created a service and gave it a public method called 'login. 'Run 'grunt test' again and our tests are back to green.

 - **Development Flow - Unit Test:** Lets add another failing test.

   ``` coffeescript
   it "should login user with username and password", ->
       profile = profileService.login("myUser", "myPassword")
       expect(profile.fullName).toBe("Santiago Esteva")
   ```

 - **Development Flow - Coding:** We will provide an implementation to our login method. Pay special attention to our public vs private functions.

   ``` coffeescript
   angular.module("myStoreApp").service "profileService", [ ->

       # private functions
       retrieveProfile = (user, password)->
         profile =
           fullName: "Santiago Esteva"

       # public functions
       login: retrieveProfile

   ]
   ```

   Lets run 'grunt test' again. All tests should be green now. Lets pause for a second. What if we want to see the JS generated for our service? Go to .tmp/scripts and open app.js and lets take a look at the profileService.

 - **Development Flow - Unit Test:** Lets add another failing test.

   ``` coffeescript
   it "should login user with username and password", ->
       profile = profileService.login("myUser", "myPassword")
       expect(profile.fullName).toBe("Santiago Esteva")

   it "should login any user with username and password and return the fullName", ->
       profile = profileService.login("anotherUser", "hisPassword")
       expect(profile.fullName).toBe("John Doe")
   ```

   When running the tests you will see **"Expected 'Santiago Esteva' to be 'John Doe'."**

 - **Development Flow - Coding:** We will need to make a few changes to fix this one. Lets start...

   Im going to start providing a fake persistance layer, somewhere where we can retrieve the profile based on user/pass. We are going to use the object of type Constant. In our app.coffee...

   ``` coffeescript
   angular.module("myStoreApp").constant "myFakeDb",

     profiles: [
       user: "myUser"
       password: "myPassword"
       fullName: "Santiago Esteva"
     ,
       user: "anotherUser"
       password: "hisPassword"
       fullName: "John Doe"
     ]
   ```

   In our profileService we want to include the constants as our fake DB and query it looking for that profile that matches our user/pass.

   ``` coffeescript
   retrieveProfile = (user, password)->
       matchedProfile = undefined

       angular.forEach myFakeDb.profiles, (profile, key)->
           if profile.user is user then matchedProfile = profile

       return matchedProfile
   ```

 - **Development Flow - Unit Test:** Next move is to provide the logic in our controller so it queries the ProfileService with the user/pass provided by the user. Lets open our loginControllerSpec.coffee. We need to make sure that after the form was submitted, the profile service was queried and then the location was changed to the welcome page.

   We add a local instance of the profile service in our test

   ``` coffeescript
   loginController = scope = location = profileService = undefined
   ```

   We add _profileService_ to our inject statement. Angular removed the underscores and injects a version of our ProfileService. Then assign the service to our local instance.
   Then we create a spy on the service's function called login. A spy is an object that will intercept that call and it will provide control to us to verify it was called, inject a canned response and other convenient methods.

   ``` coffeescript
   # Initialize the controller
   beforeEach inject ($controller, $rootScope, $location, _profileService_) ->
       location = $location
       scope = $rootScope.$new()

       # The injector unwraps the underscores (_) from around the parameter names when matching
       profileService = _profileService_

       loginController = $controller "loginController",
           $scope: scope

   describe "When clicking the submit button", ->

       it "should go to the welcome page", ->

           # Create spy on our service. Intercept the call to our login method. We do not care about its internal implementation or response
           profileSpyOn = spyOn(profileService, "login")

           scope.submit()

           expect(profileSpyOn).toHaveBeenCalled()
           expect(location.path()).toBe("/welcome")

   ```

   Since we are not really interested in the ProfileService, instead of injecting the ProfileService we could have created a small fake profileService that has a function called login.
   If you do this, you should also tell the controller you want to inject the fake Service on the place of the real service. In the previous scenario, Angular was taking care of that for us.
   The last change is to spy on the fakeService instead. The changes would look like this.

   ``` coffeescript
   loginController = scope = location = fakeProfileService = undefined

   # Initialize the controller
   beforeEach inject ($controller, $rootScope, $location) ->
       location = $location
       scope = $rootScope.$new()

       # We create a fake profile Service that fulfills the login function
       fakeProfileService =
           login: ()->
             return null

       # We create the controller passing the profile service implementation to be injected.
       loginController = $controller "loginController",
           $scope: scope
           profileService: fakeProfileService

     describe "When clicking the submit button", ->

       it "should go to the welcome page", ->

           # Create spy on our service. Intercept the call to our login method. We do not care about its internal implementation or response
           profileSpyOn = spyOn(fakeProfileService, "login")

           scope.submit()

           expect(profileSpyOn).toHaveBeenCalled()
           expect(location.path()).toBe("/welcome")
   ```

   Both options are correct and you may find opting for the later one since allows you more control.
   On the other hand, if the object you are testing has a lot of dependencies there may be an overhead creating all those fake implementations.
   In that case you may choose to inject the real implementation but then use spyOn so you intercept those calls.
   we are going to stick with this last implementation.

   If we run 'grunt test' now, it will show the following error "Expected spy login to have been called." since our controller does not have any call to our profileService. We shall change that..

 - **Development Flow - Coding:** Lets open our app.coffee and go into our loginController.

   ``` coffeescript
   angular.module("myStoreApp").controller "loginController", ["$scope","$location","profileService", ($scope, $location, Profile)->

       $scope.submit = ()->
         Profile.login("user", "password")
         $location.path "/welcome"

   ]
   ```

   Run the tests and we should be green again.

 - **Development Flow - Unit Test:** Now lets make sure the controller is passing the values the user entered.

   ``` coffeescript
   describe "When clicking the submit button", ->

       it "should go to the welcome page", ->

           # Create spy on our service. Intercept the call to our login method. We do not care about its internal implementation or response
           profileSpyOn = spyOn(fakeProfileService, "login")

           # Faking user input
           scope.ui.login.user = "labrador"
           scope.ui.login.pass = "trinity1"

           scope.submit()

           expect(profileSpyOn).toHaveBeenCalledWith('labrador', 'trinity1')
           expect(location.path()).toBe("/welcome")
   ```

   Lets run the tests. Failed as expected.

 - **Development Flow - Coding:** Lets implement the code to make that test pass.

   ``` coffeescript
   angular.module("myStoreApp").controller "loginController", ["$scope","$location","profileService", ($scope, $location, Profile)->

       $scope.ui =
           login: {}

       $scope.submit = ()->
           Profile.login($scope.ui.login.user, $scope.ui.login.pass)
           $location.path "/welcome"

   ]
   ```

   We run the tests and green!  Lets run the app. 'grunt server'.

   ### Debugging

   Before completing our AC lets jump for a second into debugging. Leaving the application running go to our login.html and add a block for debugging purposes

   git checkout -f step-4c

   ``` html
   <div ng-controller="loginController">
       <h1>Login</h1>
       <form>
           <label>username</label><input name="username">
           <label>password</label><input name="password">
           <button ng-click="submit()">Login</button>
       </form>

       <!--Debugging purposes-->
       <pre>{{ui | json}}</pre>
       <!--Debugging purposes-->
   </div>
   ```

   Go back to your browser and you will able to observe a new block that illustrates and object that has an attribute called login.

   Lets add some angular magic to our form inputs so the user's input is binded to our scope.

   ``` html
   <label>username</label><input name="username" ng-model="ui.login.user">
   <label>password</label><input name="password" ng-model="ui.login.pass">
   ```

   Go back to the browser and start playing with the inputs. This is how two way binding works. And this is a useful way of debugging your model.

   Ctrl + Shift + J will open the developer tools in Chrome. Lets go to the sources tab, top left corner, click on that little box with a triangle pointing to the right and navigate the folder structure till you can double click on /scripts/app.js.

   Look for loginController and add a breakpoint to the line " Profile.login($scope.ui.login.user, $scope.ui.login.pass); ". Now fill the form and hit submit.

































































