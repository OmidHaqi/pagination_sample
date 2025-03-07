import 'package:flutter/material.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) return const SizedBox.shrink();
    
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Pill indicator
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Page controls - Wrapped in SingleChildScrollView for horizontal scrolling
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // First page button
                _buildIconButton(
                  icon: Icons.first_page,
                  enabled: currentPage > 1,
                  onPressed: () => onPageChanged(1),
                  tooltip: 'First Page',
                  theme: theme,
                  isSmallScreen: isSmallScreen,
                ),
                
                // Previous page button
                _buildNavButton(
                  icon: Icons.chevron_left,
                  enabled: currentPage > 1,
                  onPressed: () => onPageChanged(currentPage - 1),
                  tooltip: 'Previous Page',
                  theme: theme,
                  isSmallScreen: isSmallScreen,
                ),
                
                SizedBox(width: isSmallScreen ? 4 : 8),
                
                // Page numbers
                ...buildPageNumbers(context, isSmallScreen),
                
                SizedBox(width: isSmallScreen ? 4 : 8),
                
                // Next page button
                _buildNavButton(
                  icon: Icons.chevron_right,
                  enabled: currentPage < totalPages,
                  onPressed: () => onPageChanged(currentPage + 1),
                  tooltip: 'Next Page',
                  theme: theme,
                  isSmallScreen: isSmallScreen,
                ),
                
                // Last page button
                _buildIconButton(
                  icon: Icons.last_page,
                  enabled: currentPage < totalPages,
                  onPressed: () => onPageChanged(totalPages),
                  tooltip: 'Last Page',
                  theme: theme,
                  isSmallScreen: isSmallScreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build navigation buttons with container background
  Widget _buildNavButton({
    required IconData icon,
    required bool enabled,
    required Function() onPressed,
    required String tooltip,
    required ThemeData theme,
    required bool isSmallScreen,
  }) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 200),
      child: Container(
        height: isSmallScreen ? 32 : 36,
        width: isSmallScreen ? 32 : 36,
        decoration: BoxDecoration(
          color: enabled
            ? theme.colorScheme.primary.withValues(alpha: 0.1)
            : theme.colorScheme.onSurface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: isSmallScreen ? 18 : 22,
          icon: Icon(
            icon,
            color: enabled
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          onPressed: enabled ? onPressed : null,
          tooltip: tooltip,
        ),
      ),
    );
  }

  // Helper method to build simple icon buttons
  Widget _buildIconButton({
    required IconData icon,
    required bool enabled,
    required Function() onPressed,
    required String tooltip,
    required ThemeData theme,
    required bool isSmallScreen,
  }) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        height: isSmallScreen ? 32 : 36,
        width: isSmallScreen ? 32 : 36,
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: isSmallScreen ? 18 : 22,
          icon: Icon(icon),
          onPressed: enabled ? onPressed : null,
          tooltip: tooltip,
        ),
      ),
    );
  }

  List<Widget> buildPageNumbers(BuildContext context, bool isSmallScreen) {
    final theme = Theme.of(context);
    List<Widget> pageNumbers = [];
    
    // For very small screens, show fewer page numbers
    final maxPagesToShow = isSmallScreen ? 3 : 5;
    
    if (totalPages <= maxPagesToShow) {
      // If there are few pages, show all of them
      for (int i = 1; i <= totalPages; i++) {
        pageNumbers.add(buildPageButton(context, i, isSmallScreen));
      }
    } else {
      // Always show first page
      pageNumbers.add(buildPageButton(context, 1, isSmallScreen));
      
      // Show ellipsis if current page is far from start
      if (currentPage > 2) {
        pageNumbers.add(buildEllipsis(theme, isSmallScreen));
      }
      
      // Show current page (and maybe adjacent pages if space allows)
      if (currentPage != 1 && currentPage != totalPages) {
        // On small screens, just show the current page
        if (isSmallScreen) {
          pageNumbers.add(buildPageButton(context, currentPage, isSmallScreen));
        } else {
          // On larger screens, we can show adjacent pages too
          if (currentPage > 2) {
            pageNumbers.add(buildPageButton(context, currentPage - 1, isSmallScreen));
          }
          pageNumbers.add(buildPageButton(context, currentPage, isSmallScreen));
          if (currentPage < totalPages - 1) {
            pageNumbers.add(buildPageButton(context, currentPage + 1, isSmallScreen));
          }
        }
      }
      
      // Show ellipsis if current page is far from end
      if (currentPage < totalPages - 1) {
        pageNumbers.add(buildEllipsis(theme, isSmallScreen));
      }
      
      // Always show last page
      pageNumbers.add(buildPageButton(context, totalPages, isSmallScreen));
    }
    
    return pageNumbers;
  }
  
  Widget buildEllipsis(ThemeData theme, bool isSmallScreen) {
    final size = isSmallScreen ? 28.0 : 32.0;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: isSmallScreen ? 2 : 4),
      child: Text(
        '...',
        style: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          fontWeight: FontWeight.bold,
          fontSize: isSmallScreen ? 12 : 14,
        ),
      ),
    );
  }
  
  Widget buildPageButton(BuildContext context, int pageNumber, bool isSmallScreen) {
    final theme = Theme.of(context);
    final isSelected = pageNumber == currentPage;
    final size = isSmallScreen ? 28.0 : 36.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        onTap: isSelected ? null : () => onPageChanged(pageNumber),
        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected 
              ? theme.colorScheme.primary 
              : theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 12),
            boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
          ),
          child: Text(
            '$pageNumber',
            style: TextStyle(
              color: isSelected 
                ? theme.colorScheme.onPrimary 
                : theme.colorScheme.primary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
        ),
      ),
    );
  }
  
  int max(int a, int b) => a > b ? a : b;
  int min(int a, int b) => a < b ? a : b;
}
