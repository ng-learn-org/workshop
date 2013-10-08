# PreRequisites

- Install NPM

# Checkout

    git clone https://github.com/ng-learn-org/workshop.git

# Setup

    cd workshop
    npm install

# Step 1 - Setup the AngularJs App

    git checkout -f step-0

- Add AngularJs library to our index.html

    {% raw %}
    ``` html
      <div>Welcome to the AngularJS World</div>
      <script src="bower_components/angular/angular.js"></script>
    </body>
    ```
    {% endraw %}

- Bootstrap the AngularJS app using the automatic method

    {% raw %}
    ``` html
    <body ng-app>
    ```
    {% endraw %}

- Lets update our welcome message

    {% raw %}
    ``` html
    <div>Welcome to the AngularJS World, {{userName}}</div>
    ```
    {% endraw %}

- Start the app

    grunt server

The application should say "Welcome to the AngularJS World," but the "{{userName}}" portion should not be visible. Angular has kicked in and it does not display it because that variable is not binded to anything, yet!

# Step 2 - Defining our first module

- Lets name our application

    {% raw %}
    ``` html
    <body ng-app="myStoreApp">
    ```
    {% endraw %}

- Create app.js inside app folder and define our application in app.coffee

    angular.module "myStoreApp", []

- Add app.js to our index.html so the browser will load it
    {% raw %}
    ``` html
      <div>Welcome to the AngularJS World</div>
   
      <script src="bower_components/angular/angular.js"></script>
   
      <!-- build:js({.tmp,app}) scripts/scripts.js -->
      <script src="scripts/app.js"></script>
   
      <!-- endbuild -->
    </body>
    ```
    {% endraw %}

 note: we add our js file wrapped in a 'build comment' so our toolchain converts it from coffee script to javascript.






