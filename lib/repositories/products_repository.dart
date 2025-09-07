import '../models/product.dart';
import '../services/products_api.dart';

class ProductsRepository {
  final ProductsApi api;
  const ProductsRepository(this.api);

  Future<List<Product>> getProducts({int page = 1, int limit = 20}) {
    return api.fetchProducts(page: page, limit: limit);
  }
}

