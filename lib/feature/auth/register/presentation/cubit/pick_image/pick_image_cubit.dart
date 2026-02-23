import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_states.dart';

class PickImageCubit extends Cubit<PickImageStates> {
  PickImageCubit() : super(PickImageInitialStates());

  ImagePicker picker = ImagePicker();

  XFile? image;
  // String?base64Image;
  Future<void> pickImage(ImageSource imageSource, context) async {
    // emit(PickImageLoadingStates());
    image = await picker.pickImage(source: imageSource);
    if (image != null) {
      // File imageFile =  File(image!.path);
      // List<int> imageBytes = imageFile.readAsBytesSync();
      //  base64Image = base64Encode(imageBytes);
      // Close the bottom sheet
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      emit(PickImageSuccessStates());
    }
  }
}
