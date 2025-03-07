# Flutter Pagination Sample

![Flutter](https://img.shields.io/badge/Flutter-3.29-blue.svg)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue.svg)
![Provider](https://img.shields.io/badge/Provider-6.1.2-green.svg)
![Material3](https://img.shields.io/badge/Material3-Yes-purple.svg)

A beautiful Flutter application demonstrating pagination techniques in a clean, maintainable architecture. This project showcases both infinite scrolling and traditional pagination controls with a modern Material 3 design.

## 📱 Features

- **Multiple Pagination Types**
  - Infinite scrolling with automatic loading of more items
  - Traditional numbered pagination with page controls
  - Pull-to-refresh to reload data
  
- **Dynamic UI Options**
  - Switch between grid and list views
  - Customize grid columns (1-4)
  - Toggle compact mode for denser layouts
  
- **Theming & Customization**
  - Light, dark, and system theme options
  - Material 3 design language implementation
  - Beautiful color scheme and typography
  
- **Polished Animations**
  - Staggered item loading animations
  - Shimmer loading effects
  - Custom loading indicators
  - Animation preferences (full, reduced, disabled)
  
- **MVVM Architecture**
  - Clean separation of UI and business logic
  - Feature-based code organization
  - Provider pattern for state management

## 🏗️ Architecture

This project follows the **MVVM (Model-View-ViewModel)** architecture in a **feature-based** structure:

```
lib/
├── core/                     # Core components
│   ├── utils/                # Utility classes and functions
│   └── widgets/              # Shared widgets
├── features/
│   └── pagination/
│       ├── data/             # Data layer
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/           # Domain layer
│       │   └── repositories/
│       └── presentation/     # Presentation layer
│           ├── screens/
│           ├── view_models/
│           └── widgets/
└── main.dart                 # App entry point
```

## 📚 Understanding Pagination

### What is Pagination?

Pagination is a technique used to divide a large dataset into smaller, more manageable chunks (or "pages"). Instead of loading hundreds or thousands of items at once, we fetch and display them in batches.

This project implements two common pagination approaches:

1. **Infinite Scrolling** - Loading more content automatically as the user scrolls down
2. **Page-based Navigation** - Displaying page numbers that users can click to navigate

## 💡 How It Works

### Data Flow

```
User Action → ViewModel → Repository → (Mock/API) Data → ViewModel → UI Update
```

1. User performs an action (scrolling, clicking a page number, etc.)
2. ViewModel handles the business logic (managing page numbers, loading states)
3. Repository fetches the data from a source (mock data or real API)
4. ViewModel processes the response and updates its state
5. UI reacts to state changes and displays the updated content

## 📖 Code Examples

### 1. Implementing Infinite Scrolling

To implement infinite scrolling, we use a `ScrollController` to detect when the user is near the bottom of the list:

```dart
// Add a ScrollController and set up a listener
final ScrollController _scrollController = ScrollController();

@override
void initState() {
  super.initState();
  _scrollController.addListener(_scrollListener);
}

void _scrollListener() {
  // Load more items when user is near the bottom of the list
  if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
    context.read<ItemsViewModel>().loadNextPage();
  }
}

// Don't forget to dispose the controller
@override
void dispose() {
  _scrollController.dispose();
  super.dispose();
}
```

### 2. Managing Pagination State in ViewModel

The ViewModel maintains pagination state and provides methods for loading data:

```dart
class ItemsViewModel extends ChangeNotifier {
  // Pagination state
  List<ItemModel> _items = [];
  int _currentPage = 1;
  int _totalItems = 0;
  final int _itemsPerPage = 10;
  bool _hasMoreItems = true;
  
  // Load the next page
  Future<void> loadNextPage() async {
    if (!_hasMoreItems || _loadingState == LoadingState.loading) return;
    
    _currentPage++;
    await loadItems();
  }
  
  // Jump to a specific page
  Future<void> goToPage(int page) async {
    if (page < 1 || page > totalPages || page == _currentPage) return;
    
    _currentPage = page;
    _items = [];
    _hasMoreItems = true;
    await loadItems();
  }
}
```

### 3. Creating a Repository for Data Fetching

The repository pattern separates data access from business logic:

```dart
class ItemRepositoryImpl implements ItemRepository {
  @override
  Future<List<ItemModel>> getItems({required int page, required int limit}) async {
    // In a real app, this would be an API call
    await Future.delayed(const Duration(milliseconds: 800)); // Simulating network delay
    
    final startIndex = (page - 1) * limit;
    final endIndex = min(startIndex + limit, _mockDatabase.length);
    
    if (startIndex >= _mockDatabase.length) {
      return [];
    }
    
    return _mockDatabase.sublist(startIndex, endIndex);
  }
}
```

### 4. Building Pagination Controls

For traditional page-based navigation:

```dart
class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  // Build page number indicators
  List<Widget> buildPageNumbers(BuildContext context) {
    List<Widget> pageNumbers = [];
    
    // Always show first page
    pageNumbers.add(buildPageButton(context, 1));
    
    // Show ellipsis if needed
    if (currentPage > 3) {
      pageNumbers.add(const Text('...'));
    }
    
    // Show current page and adjacent pages
    for (int i = currentPage - 1; i <= currentPage + 1; i++) {
      if (i > 1 && i < totalPages) {
        pageNumbers.add(buildPageButton(context, i));
      }
    }
    
    // Show ellipsis and last page if needed
    if (currentPage < totalPages - 2) {
      pageNumbers.add(const Text('...'));
    }
    if (totalPages > 1) {
      pageNumbers.add(buildPageButton(context, totalPages));
    }
    
    return pageNumbers;
  }
}
```

### 5. Error Handling

Proper error handling ensures a good user experience even when things go wrong:

```dart
if (viewModel.loadingState == LoadingState.error && viewModel.items.isEmpty) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(viewModel.errorMessage),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: viewModel.refreshItems,
          child: const Text('Retry'),
        ),
      ],
    ),
  );
}
```

## 🚀 Getting Started

1. Ensure you have Flutter installed ([Flutter Installation Guide](https://docs.flutter.dev/get-started/install))
2. Clone this repository
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`

## 🔍 How to Use This Example for Learning

1. **Step 1**: Understand the project structure and architecture
   - Look at the feature-based organization
   - Review the MVVM separation of concerns

2. **Step 2**: Study the pagination implementation
   - Check `ItemsViewModel` to see how page state is managed
   - See how the Repository pattern abstracts data access

3. **Step 3**: Implement UI components
   - Examine how `ListView.builder` efficiently renders long lists
   - Review how pagination controls are rendered

4. **Step 4**: Experiment by modifying the code
   - Try changing page sizes
   - Add animations between page transitions
   - Implement sorting or filtering capabilities

## 📝 Pagination Best Practices

1. **Always show loading indicators** to inform users that content is being loaded
2. **Keep page sizes reasonable** (10-20 items is a good default)
3. **Cache loaded data** when possible to reduce unnecessary network calls
4. **Handle errors gracefully** with proper feedback and retry options
5. **Disable pagination controls** when they're not applicable (e.g., disabling "next" on last page)

## 📄 License

This project is licensed under the Apache License. For more information, see the [LICENSE](./LICENSE) file.

<div align="center">

Developed with  ☕ by [Umut](https://github.com/omidhaqi/)

</div>
