import 'dart:convert';

import 'package:get/get.dart';
import 'package:getx_pattern/app/controller/auth/auth.dart';
import 'package:getx_pattern/app/data/model/http_exception.dart';
import 'package:http/http.dart' as http;

import '../../ui/android/products_overview/widgets/product.dart';
import '../../data/model/http_exception.dart';

class Products extends GetxController {
  List<Product> _items = [];
  final String token = Get.find<Auth>().token;
  final String userId = Get.find<Auth>().userId;
  Products();

  @override
  onInit() {
    _items = [
      // Product(
      //   id: 'p1',
      //   title: 'Red Shirt',
      //   description: 'A red shirt - it is pretty red!',
      //   price: 29.99,
      //   imageUrl:
      //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      // ),
      // Product(
      //   id: 'p2',
      //   title: 'Trousers',
      //   description: 'A nice pair of trousers.',
      //   price: 59.99,
      //   imageUrl:
      //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
      // ),
      // Product(
      //   id: 'p3',
      //   title: 'Yellow Scarf',
      //   description: 'Warm and cozy - exactly what you need for the winter.',
      //   price: 19.99,
      //   imageUrl:
      //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      // ),
      // Product(
      //   id: 'p4',
      //   title: 'A Pan',
      //   description: 'Prepare any meal you want.',
      //   price: 49.99,
      //   imageUrl:
      //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      // ),
    ];

    // List<Product> favoriteItems = [];

    update();
    super.onInit();
  }

  List get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> toggleFavoriteStatus(String id) async {
    final oldStatus = _items.firstWhere((prod) => prod.id == id).isFavorite;
    _items.firstWhere((prod) => prod.id == id).isFavorite =
        !_items.firstWhere((prod) => prod.id == id).isFavorite;
    update(/*[id]*/);
    final url =
        'https://firedata-95380.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(url,
          body: json.encode(
            _items.firstWhere((prod) => prod.id == id).isFavorite,
          ));
      if (response.statusCode >= 400) {
        _items.firstWhere((prod) => prod.id == id).isFavorite = oldStatus;
        update();
      }
    } catch (error) {
      _items.firstWhere((prod) => prod.id == id).isFavorite = oldStatus;
      update();
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://firedata-95380.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        }),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      // _items.insert(0, newProduct);
      update();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://firedata-95380.firebaseio.com/products/$id.json?auth=$token';
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
          }));
      _items[prodIndex] = newProduct;
    } else {
      print('...');
    }
    update();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://firedata-95380.firebaseio.com/products/$id.json?auth=$token';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    update();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      update();
      throw HttpException(message: 'Could not delete product.');
    }
    existingProduct = null;
    update();
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderB"creatorId"&equalTo="$userId"' : '';
    var url =
        'https://firedata-95380.firebaseio.com/products.json?auth=$token&$filterString';
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      if (responseBody == null) return;
      url =
          'https://firedata-95380.firebaseio.com/userFavorites/$userId.json?auth=$token';
      final favoriteResponse = await http.get(url);
      final favoriteData = jsonDecode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      responseBody.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite:
              favoriteData == null ? false : favoriteData[prodId] ?? false,
        ));
      });
      _items = loadedProducts;
      update();
    } catch (error) {
      throw error;
    }
  }

  final _showOnlyFavorites = false.obs;
  bool get showOnlyFavorites => _showOnlyFavorites.value;
  fav() => _showOnlyFavorites.value = true;
  all() => _showOnlyFavorites.value = false;

  final _isDeleting = false.obs;
  bool get isDeleting => _isDeleting.value;
  deletingFalse() => _isDeleting.value = false;
  deletingTrue() => _isDeleting.value = true;
}
