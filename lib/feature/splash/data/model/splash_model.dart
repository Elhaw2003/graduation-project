import 'package:equatable/equatable.dart';

class SplashModel extends Equatable{

  final String image;
  final String title;
  final String description;
  final String buttonText;

  const SplashModel({
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
  });
  
  @override
  List<Object?> get props => [image, title, description, buttonText];
}