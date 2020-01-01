# CBDirectory
CBDirectory

Build State:
[![Build Status](https://app.bitrise.io/app/78ba60ad3662f53d/status.svg?token=ub_XfGcSzjV83X_V50OB6g&branch=master)](https://app.bitrise.io/app/78ba60ad3662f53d)

Trello: https://trello.com/b/QzyQA4ym/cbdirectory

Testing on iPhone X and iPad Simulators.

The general structure is an MVVM Approach. The view models uses the didset funtionality of structs to update views via an update closure. This makes the code easy to pick up for developers that are not familiar with framworks that a bit more of a learning curve such as RXSwift for example. 

The view models call into a basic service layer to retreive data items. The code is written in a modular fashion, but it not split into modules. If I had more time I could have done this by using cocoa pods to build seperate frameworks for each feature. This could also do with some refactoring to allow the viewmodels to share a bit more code.

The trello board includes other features and improvements that were not implemented.

From a usuability standpoint I chose to implment the following features:
-Contacts are ordered by last name to make it easier to scan through. I had planned to implement a search feature which would match search terms against first/last name and also job title.
-Rooms are  orderered by availability (if I had more time I might have implemented an option to order by the room name, almost certainly added search)
-I made sure phone numbers and telephone numbers could be tapped on to contact people
-I build the detail page using a UITableView as it was requested this be easily extendable. The PersonDetailsPageController basicaly renders using an array of Key value pairs which means it is easy to add new entries. This also could be easily modified to support groups of  data etc.

The code could also be improved using some other design patterns and third party frameworks, in particular I had in mind using an iOC container for better dependancy management and injection, simple autolayout helpers, and a more robust network layer. A more complete list is available on the trelloboard: https://trello.com/b/QzyQA4ym/cbdirectory

Accessibility:
-Supports dynamic type
-Supports Voice over (could be improved)


Built using Xcode 11.2.1 on and a macbook pro on macOS catalina. The deployment target is iOS 13.0. This was mainly so I could make use of assets from the new SFSymbols and use the SwiftUI Canvas to preview my UIkitCode. If you remote the SF Symbols and preview code it would build on 

The app also compiles on bitrise CI System: xcode 11.2.x on macOS 10.14.6 (though the actual ipa artifact form this build has not been tested).


# Clydesdale Developer Challenge - iOS
Clydesdale would like a directory app to allow staff to:
 - See all of their colleagues contact details
 - See which rooms in the office are currently occupied.

Your task is to create this app in Xcode using Swift 5.0. It should contain list/detail pages for the people and a list page for the rooms. It should include features that you deem important to delivering the desired experience to the user.

The actual design doesn't matter, however the consistency in which you implement your chosen design style does.

This task is designed to test your ability to functionally design an app that meets real-world use goals. This skill is very important to us as Clydesdale.

Additionally, we are interested in the way your app is structured (how the UI interacts with the data, how your file structure is set out) so keep this in mind.

The code should be structured in such a way that the app is easily **testable**. 

# 🔌 Data Source

The API that provides the necessary data is located at https://5cc736f4ae1431001472e333.mockapi.io/api/v1 and is RESTful with 2 resources:

- people 
- rooms

Both support `GET` requests to list the data and also to directly access individual records (the API is read only).

# 📖 Development Story

The following story around how the app will be used should inform how you approach development/code structure:

Clydesdale aim to use their branding in all of their internal services. They currently use a main brand color 
`#C40202` however they are in the early stages of a rebrand that may lead this to change in the near future.

All employees will have access to the app and will expect the ability to quickly pull up and use the contact details of any of their colleagues. Employees use iOS devices across the full range, so your design must work across iPhones and iPads. Several of our employees use the accessibility features of iOS, so your app **should** be accessibile. 

If the trial of the Directory app proves successful with the staff, Clydesdale may look to expand the app so that it will also allow users to access and administer more data, so ensure that the app can be easily expanded both in terms of codebase and UX.  The code from this app could be used in other applications so modularity is **important**. If the app expands in scope, it will be more rigorously tested by our QA resource and will therefore **need** to support a test environment as well as a live environment. 

Clydesdale cannot guarantee that the same developer(s) will always be working on this app throughout it's lifecycle, so it is important that other developers will be able to onboard themselves onto the codebase with ease.

# 🏁 Finished! Now what?

Store your code on a public repo, either Github or Bitbucket, and email the link.
Zip up your code and return it via email.

