// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$GameFromJson(Map<String, dynamic> json) => Item(
      id: json['id'] as int?,
      name: json['name'] as String?,
      description: json['status'] as String?,
      units: json['size'] as int?,
      category: json['main'] as String?,
      price: json['popularityScore'] as int?,
    );

Map<String, dynamic> _$GameToJson(Item instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.description,
      'size': instance.units,
      'main': instance.category,
      'popularityScore': instance.price,
    };
