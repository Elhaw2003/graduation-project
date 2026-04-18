import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_guide/feature/auth/register/presentation/cubit/pick_image/pick_image_states.dart';

// تعريف Enum عشان الكود يكون منظم وأقل عرضة للأخطاء
enum ImageType { profile, nationalId, license }

class PickImageCubit extends Cubit<PickImageStates> {
  PickImageCubit() : super(PickImageInitialStates());

  final ImagePicker picker = ImagePicker();

  XFile? profileImage;
  XFile? nationalIdImage;
  XFile? licenseImage;

  // File imageFile =  File(image!.path);
  // List<int> imageBytes = imageFile.readAsBytesSync();
  //  base64Image = base64Encode(imageBytes);
  // Close the bottom sheet

  Future<void> pickImage(
    ImageSource imageSource,
    BuildContext context,
    ImageType type,
  ) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);

    if (pickedFile != null) {
      // تحديث المتغير المطلوب بناءً على النوع
      switch (type) {
        case ImageType.profile:
          profileImage = pickedFile;
          break;
        case ImageType.nationalId:
          nationalIdImage = pickedFile;
          break;
        case ImageType.license:
          licenseImage = pickedFile;
          break;
      }

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // بنبعت الحالة دي عشان الـ BlocBuilder يحس بالتغيير ويعيد الرسم
      emit(PickImageSuccessStates());
    }
  }
}
