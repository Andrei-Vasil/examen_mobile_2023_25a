import 'package:floor/floor.dart';
import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@entity
@JsonSerializable()
class Item {
  @primaryKey
  @JsonKey(name: 'id')
  int? id;
  String? name;
  String? description;
  String? image;
  String? category;
  int? units;
  double? price;

  Item({
    this.id,
    this.name,
    this.description,
    this.image,
    this.category,
    this.units,
    this.price,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
