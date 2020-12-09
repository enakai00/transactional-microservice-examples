import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../client/http_client.dart';
import '../entity/order.dart';

final orderRepository = Provider.autoDispose<OrderRepository>(
    (ref) => OrderRepositoryImpl(ref.read));

abstract class OrderRepository {
  Future<String> createOrder(bool isAsync, String token, OrderDto orderDto);
  Future<String> getOrder(bool isAsync, String token, OrderDto orderDto);
  Future<String> updateOrder(String token, OrderDto orderDto);
  Future<String> processOrder(String token, OrderDto orderDto);
}

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this.read);

  final Reader read;

  String _getPrefix(bool isAsync) {
    return isAsync ? '/order-service-async' : '/order-service-sync';
  }

  @override
  Future<String> createOrder(
      bool isAsync, String token, OrderDto orderDto) async {
    const _path = '/api/v1/order/create';
    return postData(_getPrefix(isAsync) + _path, token, orderDto.toJson());
  }

  @override
  Future<String> getOrder(bool isAsync, String token, OrderDto orderDto) async {
    const _path = '/api/v1/order/get';
    return postData(_getPrefix(isAsync) + _path, token, orderDto.toJson());
  }

  @override
  Future<String> updateOrder(String token, OrderDto orderDto) async {
    const _service = '/order-service-sync';
    const _path = '/api/v1/order/update';
    return postData(_service + _path, token, orderDto.toJson());
  }

  @override
  Future<String> processOrder(String token, OrderDto orderDto) async {
    const _service = '/order-processor-service';
    const _path = '/api/v1/order/process';
    return postData(_service + _path, token, orderDto.toJson());
  }
}
