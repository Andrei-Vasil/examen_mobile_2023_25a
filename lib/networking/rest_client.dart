import 'package:my_albums_flutter/models/entity.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' show Dio, Options, RequestOptions, ResponseType;

part 'rest_client.g.dart';

@RestApi(baseUrl: "http://192.168.1.4:2325")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  @GET("/items")
  Future<List<Item>> getItems();

  @GET("/categories")
  Future<List<String>> getCategories();

  @GET("/discounted")
  Future<Item> getDiscounted();

  @POST("/item")
  Future<Item> postEntity(@Body() Item item);

  @PUT("/price/{id}")
  Future<Item> putEntity(@Path() int id);

  @DELETE("/item/{id}")
  Future<Item> deleteEntity(@Path() int id);
}
