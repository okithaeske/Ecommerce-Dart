import 'package:ecommerce/providers/auth_provider.dart';
import 'package:ecommerce/providers/cart_provider.dart';
import 'package:ecommerce/services/checkout_api.dart';
import 'package:ecommerce/services/sync_queue_service.dart';
import 'package:ecommerce/utils/api_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _shippingNameController = TextEditingController();
  final _shippingEmailController = TextEditingController();
  final _shippingPhoneController = TextEditingController();
  final _shippingAddressController = TextEditingController();
  final _shippingCityController = TextEditingController();
  final _shippingCountryController = TextEditingController();
  final _shippingPostalCodeController = TextEditingController();
  final _notesController = TextEditingController();

  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardExpMonthController = TextEditingController();
  final _cardExpYearController = TextEditingController();
  final _cardCvcController = TextEditingController();

  String _paymentMethod = 'card';
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    final name = (user?['name'] ?? '').toString();
    final email = (user?['email'] ?? '').toString();
    if (name.isNotEmpty) {
      _shippingNameController.text = name;
      _cardNameController.text = name;
    }
    if (email.isNotEmpty) {
      _shippingEmailController.text = email;
    }
  }

  @override
  void dispose() {
    _shippingNameController.dispose();
    _shippingEmailController.dispose();
    _shippingPhoneController.dispose();
    _shippingAddressController.dispose();
    _shippingCityController.dispose();
    _shippingCountryController.dispose();
    _shippingPostalCodeController.dispose();
    _notesController.dispose();
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _cardExpMonthController.dispose();
    _cardExpYearController.dispose();
    _cardCvcController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final cart = context.read<CartProvider>();
    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Your cart is empty.')));
      return;
    }
    if (!SyncQueueService.instance.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You appear to be offline.')),
      );
      return;
    }
    if (_isSubmitting) return;
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    FocusScope.of(context).unfocus();
    final auth = context.read<AuthProvider>();
    final token = auth.token;
    final tokenType = auth.tokenType;
    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to place the order.')),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    final api = CheckoutApi(baseUrl: ApiConfig.baseUrl);
    final payload = _buildPayload(cart);
    try {
      final response = await api.submitOrder(
        token: token,
        tokenType: tokenType,
        payload: payload,
      );
      cart.clear();
      if (!mounted) return;
      Navigator.of(context).pop(response);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  Map<String, dynamic> _buildPayload(CartProvider cart) {
    final items =
        cart.items.values.map((item) {
          final parsedId = int.tryParse(item.id);
          return {'product_id': parsedId ?? item.id, 'quantity': item.quantity};
        }).toList();

    final payload = <String, dynamic>{
      'items': items,
      'shipping_name': _shippingNameController.text.trim(),
      'shipping_email': _shippingEmailController.text.trim(),
      'shipping_phone': _shippingPhoneController.text.trim(),
      'shipping_address': _shippingAddressController.text.trim(),
      'shipping_city': _shippingCityController.text.trim(),
      'shipping_country': _shippingCountryController.text.trim(),
      'shipping_postal_code': _shippingPostalCodeController.text.trim(),
      'payment_method': _paymentMethod,
    };

    final notes = _notesController.text.trim();
    if (notes.isNotEmpty) {
      payload['notes'] = notes;
    }

    if (_paymentMethod == 'card') {
      final expMonth = int.parse(_cardExpMonthController.text.trim());
      final expYear = int.parse(_cardExpYearController.text.trim());
      payload.addAll({
        'card_name': _cardNameController.text.trim(),
        'card_number': _cardNumberController.text.replaceAll(
          RegExp('\\s+'),
          '',
        ),
        'card_exp_month': expMonth,
        'card_exp_year': expYear,
        'card_cvc': _cardCvcController.text.trim(),
      });
    }

    return payload;
  }

  String? _requiredValidator(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final canSubmit = items.isNotEmpty && !_isSubmitting;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle(context, 'Shipping Details'),
                TextFormField(
                  controller: _shippingNameController,
                  decoration: const InputDecoration(labelText: 'Full name'),
                  textInputAction: TextInputAction.next,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _shippingEmailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final base = _requiredValidator(
                      value,
                      message: 'Email is required',
                    );
                    if (base != null) return base;
                    final email = value!.trim();
                    if (!email.contains('@')) {
                      return 'Enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _shippingPhoneController,
                  decoration: const InputDecoration(labelText: 'Phone number'),
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _shippingAddressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  textInputAction: TextInputAction.next,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _shippingCityController,
                  decoration: const InputDecoration(labelText: 'City'),
                  textInputAction: TextInputAction.next,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _shippingCountryController,
                  decoration: const InputDecoration(labelText: 'Country'),
                  textInputAction: TextInputAction.next,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _shippingPostalCodeController,
                  decoration: const InputDecoration(labelText: 'Postal code'),
                  textInputAction: TextInputAction.next,
                  validator: _requiredValidator,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                  ),
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
                const SizedBox(height: 24),
                _sectionTitle(context, 'Payment'),
                DropdownButtonFormField<String>(
                  value: _paymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'Payment method',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'card', child: Text('Card')),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => _paymentMethod = value);
                  },
                ),
                const SizedBox(height: 12),
                if (_paymentMethod == 'card') ...[
                  TextFormField(
                    controller: _cardNameController,
                    decoration: const InputDecoration(
                      labelText: 'Name on card',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: _requiredValidator,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cardNumberController,
                    decoration: const InputDecoration(labelText: 'Card number'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      final base = _requiredValidator(
                        value,
                        message: 'Card number is required',
                      );
                      if (base != null) return base;
                      final digits = value!.replaceAll(RegExp('\\s+'), '');
                      if (digits.length < 12 || digits.length > 19) {
                        return 'Enter a valid card number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _cardExpMonthController,
                          decoration: const InputDecoration(
                            labelText: 'Exp. month',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            final base = _requiredValidator(
                              value,
                              message: 'Month required',
                            );
                            if (base != null) return base;
                            final month = int.tryParse(value!.trim());
                            if (month == null || month < 1 || month > 12) {
                              return '1 - 12';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _cardExpYearController,
                          decoration: const InputDecoration(
                            labelText: 'Exp. year',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            final base = _requiredValidator(
                              value,
                              message: 'Year required',
                            );
                            if (base != null) return base;
                            final year = int.tryParse(value!.trim());
                            final currentYear = DateTime.now().year;
                            if (year == null || year < currentYear) {
                              return 'Year must be $currentYear or later';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cardCvcController,
                    decoration: const InputDecoration(labelText: 'CVC'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      final base = _requiredValidator(
                        value,
                        message: 'CVC required',
                      );
                      if (base != null) return base;
                      final digits = value!.trim();
                      if (digits.length < 3 || digits.length > 4) {
                        return '3 or 4 digits';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                const SizedBox(height: 24),
                _sectionTitle(context, 'Order Summary'),
                if (items.isEmpty)
                  Text(
                    'Your cart is empty.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final item in items) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.name} x ${item.quantity}',
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            Text(
                              '\$${item.totalPrice.toStringAsFixed(2)}',
                              style: textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                      ],
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${cart.totalAmount.toStringAsFixed(2)}',
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canSubmit ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.black,
                    ),
                    child:
                        _isSubmitting
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                            : const Text('Place Order'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: theme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
