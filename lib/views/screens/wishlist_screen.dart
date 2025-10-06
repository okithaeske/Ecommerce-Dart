import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:ecommerce/models/wishlist_item.dart';
import 'package:ecommerce/providers/wishlist_provider.dart';
import 'package:ecommerce/views/screens/product_detail.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  void _shareItem(WishlistItem item) {
    final pricePart =
        item.priceLabel.isNotEmpty ? ' for ${item.priceLabel}' : '';
    final message =
        'Check out ${item.name}$pricePart. Found via Zentara wishlist.';
    SharePlus.instance.share(ShareParams(text: message.trim()));
  }

  @override
  Widget build(BuildContext context) {
    final wishlist = context.watch<WishlistProvider>();
    final items = wishlist.items;
    final isLoading = wishlist.isLoading;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: cs.surface,
      ),
      backgroundColor: cs.surface,
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (items.isEmpty) {
            return _EmptyState(colorScheme: cs);
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = items[index];
              return _WishlistTile(
                item: item,
                onRemove: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final wishlistProvider = context.read<WishlistProvider>();
                  await wishlistProvider.remove(item.productId);
                  messenger.hideCurrentSnackBar();
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Removed from wishlist')),
                  );
                },
                onShare: () => _shareItem(item),
                onOpen: () {
                  final product = item.toProduct();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (_) => ProductDetailScreen(
                            id: product.id,
                            name: product.name,
                            price: product.priceLabel,
                            imagePath: product.imageUrl,
                            description: product.description,
                          ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: items.length,
          );
        },
      ),
    );
  }
}

class _WishlistTile extends StatelessWidget {
  const _WishlistTile({
    required this.item,
    required this.onRemove,
    required this.onShare,
    required this.onOpen,
  });

  final WishlistItem item;
  final VoidCallback onRemove;
  final VoidCallback onShare;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Card(
      color: cs.surfaceContainerHighest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        onTap: onOpen,
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child:
              item.imageUrl.isNotEmpty
                  ? Image.network(
                    item.imageUrl,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholderIcon(cs),
                  )
                  : _placeholderIcon(cs),
        ),
        title: Text(
          item.name,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          item.priceLabel.isNotEmpty ? item.priceLabel : 'Price unavailable',
        ),
        trailing: Wrap(
          spacing: 4,
          children: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Share',
              onPressed: onShare,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Remove',
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholderIcon(ColorScheme cs) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.watch_outlined, color: cs.onSurfaceVariant),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.colorScheme});

  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 72, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'No favorites yet',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart icon on any product page to save it here for quick access and sharing.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
