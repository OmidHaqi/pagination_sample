import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import '../view_models/items_view_model.dart';
import '../view_models/ui_settings_view_model.dart';
import '../widgets/item_card.dart';
import '../widgets/pagination_controls.dart';
import '../widgets/creative_loading_indicator.dart';
import '../widgets/animated_grid_item.dart';
import '../widgets/shimmer_loading_effect.dart';
import 'settings_screen.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Initialize view model
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ItemsViewModel>().init();
      _animationController.forward();
    });
    
    // Setup scroll listener for infinite scrolling
    _scrollController.addListener(_scrollListener);
  }
  
  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      context.read<ItemsViewModel>().loadNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Get the number of columns based on screen width and user preference
  int _getColumnCount(double screenWidth, UISettingsViewModel uiSettings) {
    // Use user's preferred setting if in grid mode
    if (uiSettings.viewType == ViewType.grid) {
      return uiSettings.gridColumns;
    }
    
    // Otherwise calculate based on screen width
    if (screenWidth < 600) {
      return 2; // Phone
    } else if (screenWidth < 900) {
      return 3; // Small tablet
    } else if (screenWidth < 1200) {
      return 4; // Large tablet
    } else {
      return 5; // Desktop
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final uiSettings = Provider.of<UISettingsViewModel>(context);
    final columnCount = _getColumnCount(screenWidth, uiSettings);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: FadeTransition(
          opacity: _animationController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.5),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _animationController,
              curve: Curves.easeOut,
            )),
            child: Text(
              'Creative Gallery',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
                fontSize: 24,
              ),
            ),
          ),
        ),
        actions: [
          // Toggle view button
          IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            onPressed: () => context.read<UISettingsViewModel>().toggleViewType(),
            tooltip: 'Change View',
          ),
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ItemsViewModel>().refreshItems(),
            tooltip: 'Refresh Items',
          ),
          // Settings button with hero animation
          Hero(
            tag: 'settings-icon',
            child: Material(
              color: Colors.transparent,
              child: IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                },
                tooltip: 'Settings',
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.05),
              theme.colorScheme.surface,
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: Consumer2<ItemsViewModel, UISettingsViewModel>(
          builder: (context, viewModel, uiSettings, child) {
            if (viewModel.loadingState == LoadingState.initial) {
              return const Center(child: CreativeLoadingIndicator());
            }
            
            if (viewModel.loadingState == LoadingState.error && viewModel.items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_off,
                      size: 64,
                      color: theme.colorScheme.error.withValues(alpha: 0.8),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      viewModel.errorMessage,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: viewModel.refreshItems,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            return SafeArea(
              child: Column(
                children: [
                  // Stats bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Page ${viewModel.currentPage} of ${viewModel.totalPages}',
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${viewModel.items.length} items loaded',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // List of items using StaggeredGridView
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: viewModel.refreshItems,
                      backgroundColor: theme.colorScheme.primary,
                      color: theme.colorScheme.onPrimary,
                      child: uiSettings.viewType == ViewType.grid
                          ? _buildStaggeredGridView(viewModel, uiSettings, columnCount)
                          : _buildListView(viewModel, uiSettings),
                    ),
                  ),
                  
                  // Pagination controls
                  PaginationControls(
                    currentPage: viewModel.currentPage,
                    totalPages: viewModel.totalPages,
                    onPageChanged: viewModel.goToPage,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStaggeredGridView(
    ItemsViewModel viewModel, 
    UISettingsViewModel uiSettings,
    int columnCount,
  ) {
    // Calculate proper spacing for grid items
    final double spacing = uiSettings.compactView ? 8 : 16;
    
    return MasonryGridView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: uiSettings.compactView ? 8 : 16, 
        vertical: uiSettings.compactView ? 4 : 8
      ),
      itemCount: viewModel.items.length + (viewModel.hasMoreItems ? columnCount : 0),
      gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: uiSettings.gridColumns,
      ),
      mainAxisSpacing: spacing,
      crossAxisSpacing: spacing,
      itemBuilder: (context, index) {
        // Show loading indicators at the end
        if (index >= viewModel.items.length) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              // Improved shimmer with proper sizing
              child: ShimmerLoadingEffect(
                height: 150,
                width: double.infinity,
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                constraints: const BoxConstraints(minHeight: 150),
              ),
            ),
          );
        }
        
        // Calculate varied heights for items based on their ID
        final item = viewModel.items[index];
        final aspectRatio = _calculateAspectRatio(item.id);
        
        // Add container with proper spacing to prevent overlap on hover
        return Container(
          margin: const EdgeInsets.all(1), // Small margin to prevent hover overlap
          child: AnimatedGridItem(
            index: index,
            playAnimation: uiSettings.areAnimationsEnabled,
            child: ItemCard(
              item: item,
              heightFactor: aspectRatio,
            ),
          ),
        );
      },
    );
  }
  
  // Update ListView implementation to ensure consistent spacing
  Widget _buildListView(ItemsViewModel viewModel, UISettingsViewModel uiSettings) {
    final double spacing = uiSettings.compactView ? 8 : 16;
    
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(
        horizontal: uiSettings.compactView ? 8 : 16, 
        vertical: uiSettings.compactView ? 4 : 8
      ),
      itemCount: viewModel.items.length + (viewModel.hasMoreItems ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= viewModel.items.length) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: spacing),
            child: const Center(
              child: ShimmerLoadingEffect(
                height: 80,
                width: double.infinity,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            ),
          );
        }
        
        return Padding(
          padding: EdgeInsets.only(bottom: spacing),
          // Add container to prevent hover overlap
          child: Container(
            decoration: const BoxDecoration(),
            margin: const EdgeInsets.symmetric(vertical: 2),
            child: AnimatedGridItem(
              index: index,
              playAnimation: uiSettings.areAnimationsEnabled,
              animationDuration: Duration(
                milliseconds: uiSettings.animationsScale == 1.0 ? 400 : 200
              ),
              child: ItemCard(
                item: viewModel.items[index],
                isListItem: true,
              ),
            ),
          ),
        );
      },
    );
  }
  
  // Generate varied aspect ratios for a more interesting staggered look
  double _calculateAspectRatio(int itemId) {
    // Use the item ID to deterministically generate a height factor
    // This creates a staggered effect but remains consistent between refreshes
    final baseValue = (itemId % 5) / 10; // 0.0, 0.1, 0.2, 0.3, 0.4
    return 1.0 + baseValue; // Results in values between 1.0 and 1.4
  }
}
