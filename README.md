# GHFollowers

This project is based on Sean Allen's iOS Dev Job Interview Practice course. While most of the project is Sean's design I made a few changes in order to enhance the user's experience. 

This project showccases:

• 100% ProgrammaticUI
• CollectionViews with the new DiffableDataSource
• Search Controllers
• Network Calls
• Parsing JSON with Codable
• Pagination of Network calls
• Memory Management - Capture Lists [weak self]
• Image Caching
• No 3rd party libraries
• Dark Mode
• Custom Alerts
• Project organization
• Composition - Longest VC is 200 lines of code
• Child View Controllers
• UITableView
• Delegation
• Persistence
• Proper Error Handling
• Empty States
• SafariViewController
• SFSymbols
• Dynamic Type
• StackViews
• Date Formatters
• Activity Indicators
• Reusable Components
• SceneDelegate
• Poor Network Testing
• Passing Data between views

## My improvements

- Repositioned the Add to Favorites button to the UserInfo screen that way the user can make the choice to favorite after they've seen the GitHub user's info. 
- Add button is now a star SFSymbol that is filled in if the user is already in your favorites and otherwise un-filled.
- Add button fulfills the double functions of adding/removing a user from your favorites based on their status.
