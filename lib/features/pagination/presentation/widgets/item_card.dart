import 'package:flutter/material.dart';
import '../../data/models/item_model.dart';
import 'shimmer_loading_effect.dart';

class ItemCard extends StatefulWidget {
  final ItemModel item;
  final double heightFactor;
  final bool isListItem;
  
  const ItemCard({
    super.key, 
    required this.item,
    this.heightFactor = 1.0,
    this.isListItem = false,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovering = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    // Reduce the scale factor to prevent excessive overlap
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    // Different layout for list items vs grid items
    if (widget.isListItem) {
      return _buildListItem(theme);
    }
    
    // Calculate the height based on the heightFactor (for staggered grid)
    final baseHeight = 220.0 * widget.heightFactor;
    
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
          _controller.forward();
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
          _controller.reverse();
        });
      },
      child: GestureDetector(
        onTap: () {
          // Show details or larger image
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Viewing ${widget.item.title}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: Hero(
            tag: 'item-${widget.item.id}',
            child: Container(
              height: baseHeight,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: _isHovering ? 0.1 : 0.05),
                    offset: const Offset(0, 4),
                    blurRadius: 12,
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  // Background image with shimmer loading effect
                  Positioned.fill(
                    child: Image.network(
                      widget.item.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        
                        // Shimmer effect while loading - specify dimensions
                        return ShimmerLoadingEffect(
                          width: double.infinity,
                          height: double.infinity,
                          borderRadius: BorderRadius.circular(20),
                          baseColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          highlightColor: theme.colorScheme.surfaceContainerHighest,
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: theme.colorScheme.errorContainer,
                          child: Center(
                            child: Icon(
                              Icons.broken_image_rounded, 
                              color: theme.colorScheme.onErrorContainer,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  // Gradient overlay for text readability
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Item ID badge
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#${widget.item.id}',
                        style: TextStyle(
                          color: theme.colorScheme.onSecondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  
                  // Title and description
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              shadows: [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.item.description,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                              shadows: const [
                                Shadow(
                                  color: Colors.black45,
                                  blurRadius: 2,
                                ),
                              ],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildListItem(ThemeData theme) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: _isHovering ? 4 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Viewing ${widget.item.title}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        onHover: (hovering) {
          setState(() {
            _isHovering = hovering;
            if (hovering) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          });
        },
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Image with shimmer effect
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Image.network(
                  widget.item.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return ShimmerLoadingEffect(
                      width: 120,
                      height: 120,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        bottomLeft: Radius.circular(16),
                      ),
                      constraints: const BoxConstraints.tightFor(width: 120, height: 120),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: theme.colorScheme.errorContainer,
                      child: Center(
                        child: Icon(
                          Icons.broken_image_rounded, 
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            
            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#${widget.item.id}',
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Title
                    Text(
                      widget.item.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    
                    // Description
                    Text(
                      widget.item.description,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
