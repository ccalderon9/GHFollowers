# GHFollowers

GitHub Followers app is designed to let a user browse the followers of a selected Github user.  After selecting a follower, they can add them to their list of Favorites, view their profile or also view their followers. This project showcases:

- CollectionViews with DiffableDataSource
- Search Function
- Parsing JSON with Codable protocol
- Pagination of Network calls
- Memory Management - Capture Lists [weak self]
- Image Caching
- MVC Architecture
- Persistence
- Proper Error Handling
- SafariViewController
- Date Formatters
- Reusable Components

## UX improvements

- Repositioned the Add to Favorites button to the UserInfo screen that way the user can make the choice to favorite after they've seen the GitHub user's info. 
- Add button is now a star SFSymbol that is "filled in" if the user is already in your favorites and otherwise "un-filled".
- Add button fulfills the double functions of adding/removing a user from your favorites based on their status.
