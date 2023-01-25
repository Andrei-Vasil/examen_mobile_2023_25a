import 'package:my_albums_flutter/models/entity.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' show Dio, Options, RequestOptions, ResponseType;

part 'rest_client.g.dart';

@RestApi(baseUrl: "http://192.168.43.164:2325")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @GET("/items/{category}")
  Future<List<Item>> getItemsForCategory(@Path() String category);

  @GET("/categories")
  Future<List<String>> getCategories();

  @GET("/discounted")
  Future<List<Item>> getDiscounted();

  @POST("/item")
  Future<Item> postItem(@Body() Item item);

  @POST("/price")
  Future<Item> updatePrice(@Body() Map<String, dynamic> entity);

  @DELETE("/item/{id}")
  Future<Item> deleteItem(@Path() int id);
}
