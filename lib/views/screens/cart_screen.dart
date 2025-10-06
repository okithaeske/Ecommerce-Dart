import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/providers/auth_provider.dart';
import 'package:ecommerce/views/screens/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Cart (${cart.totalCount})',
          style: TextStyle(color: colorScheme.onSurface),
        ),
        backgroundColor: colorScheme.surface,
        iconTheme: IconThemeData(color: colorScheme.primary),
        actions: [
          if (cart.items.isNotEmpty)
            TextButton(
              onPressed: cart.clear,
              child: Text(
                'Clear',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
        ],
      ),
      body:
          cart.items.isEmpty
              ? Center(
                child: Text(
                  'Your cart is empty',
                  style: textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              )
              : SafeArea(
                top: false,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount: cart.items.length,
                        separatorBuilder:
                            (_, __) => Divider(
                              height: 1,
                              color: colorScheme.outlineVariant,
                            ),
                        itemBuilder: (context, index) {
                          final item = cart.items.values.elementAt(index);
                          final width = MediaQuery.of(context).size.width;
                          final isCompact = width < 380;

                          Widget image = ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child:
                                item.imageUrl.startsWith('http')
                                    ? Image.network(
                                      item.imageUrl,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (c, e, s) =>
                                              SizedBox(width: 56, height: 56),
                                    )
                                    : Image.asset(
                                      item.imageUrl,
                                      width: 56,
                                      height: 56,
                                      fit: BoxFit.cover,
                                    ),
                          );

                          final title = Text(
                            item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleSmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          );
                          final sub = Text(
                            '${item.priceLabel} x ${item.quantity}',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          );
                          final totalText = Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          );

                          final qtyControls = Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed:
                                    () => context
                                        .read<CartProvider>()
                                        .decrement(item.id),
                                icon: const Icon(
                                  Icons.remove_circle_outline,
                                  size: 20,
                                ),
                                tooltip: 'Decrease',
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                ),
                                child: Text(
                                  '${item.quantity}',
                                  style: textTheme.bodyMedium,
                                ),
                              ),
                              IconButton(
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed:
                                    () => context
                                        .read<CartProvider>()
                                        .addByFields(
                                          id: item.id,
                                          name: item.name,
                                          imageUrl: item.imageUrl,
                                          priceLabel: item.priceLabel,
                                          quantity: 1,
                                        ),
                                icon: const Icon(
                                  Icons.add_circle_outline,
                                  size: 20,
                                ),
                                tooltip: 'Increase',
                              ),
                              IconButton(
                                constraints: const BoxConstraints(
                                  minWidth: 36,
                                  minHeight: 36,
                                ),
                                padding: EdgeInsets.zero,
                                onPressed:
                                    () => context.read<CartProvider>().remove(
                                      item.id,
                                    ),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 20,
                                ),
                                tooltip: 'Remove',
                              ),
                            ],
                          );

                          if (isCompact) {
                            // Stack controls below on compact screens
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  image,
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(child: title),
                                            const SizedBox(width: 8),
                                            totalText,
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        sub,
                                        const SizedBox(height: 6),
                                        qtyControls,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Regular/wide layout: trailing column fits nicely
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                image,
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      title,
                                      const SizedBox(height: 2),
                                      sub,
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    totalText,
                                    const SizedBox(height: 6),
                                    qtyControls,
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        border: Border(
                          top: BorderSide(color: colorScheme.outlineVariant),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Total',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: textTheme.titleLarge?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed:
                                cart.items.isEmpty
                                    ? null
                                    : () async {
                                      final auth = context.read<AuthProvider>();
                                      if (!auth.isAuthenticated) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Please sign in to checkout.',
                                            ),
                                          ),
                                        );
                                        return;
                                      }
                                      final result = await Navigator.of(
                                        context,
                                      ).push(
                                        MaterialPageRoute(
                                          builder:
                                              (_) => const CheckoutScreen(),
                                        ),
                                      );
                                      if (!context.mounted) return;
                                      if (result is Map<String, dynamic>) {
                                        final message =
                                            (result['message'] as String?) ??
                                            'Order placed successfully.';
                                        final data = result['data'];
                                        final orderId =
                                            (data is Map && data['id'] != null)
                                                ? data['id'].toString()
                                                : null;
                                        final status =
                                            (data is Map &&
                                                    data['status'] != null)
                                                ? data['status'].toString()
                                                : null;
                                        final details = [
                                          message,
                                          if (orderId != null)
                                            'Order ID: $orderId',
                                          if (status != null) 'Status: $status',
                                        ].join('\n');
                                        await showDialog<void>(
                                          context: context,
                                          builder:
                                              (dialogContext) => AlertDialog(
                                                title: const Text(
                                                  'Checkout Complete',
                                                ),
                                                content: Text(details),
                                                actions: [
                                                  TextButton(
                                                    onPressed:
                                                        () =>
                                                            Navigator.of(
                                                              dialogContext,
                                                            ).pop(),
                                                    child: const Text('Close'),
                                                  ),
                                                ],
                                              ),
                                        );
                                      }
                                    },
                            icon: const Icon(Icons.lock_outline),
                            label: const Text('Proceed to Checkout'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
