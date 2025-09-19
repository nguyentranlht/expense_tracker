import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final int? id;
  final String name;
  final String? icon;
  final String? color;
  final DateTime createdAt;

  const Category({
    this.id,
    required this.name,
    this.icon,
    this.color,
    required this.createdAt,
  });

  Category copyWith({
    int? id,
    String? name,
    String? icon,
    String? color,
    DateTime? createdAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    icon,
    color,
    createdAt,
  ];
}