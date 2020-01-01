# CBDirectory
CBDirectory

Build State:
[![Build Status](https://app.bitrise.io/app/78ba60ad3662f53d/status.svg?token=ub_XfGcSzjV83X_V50OB6g&branch=master)](https://app.bitrise.io/app/78ba60ad3662f53d)


Progress; https://trello.com/b/QzyQA4ym/cbdirectory

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

