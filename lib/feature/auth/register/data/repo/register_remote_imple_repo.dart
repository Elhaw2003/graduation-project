import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_guide/core/errors/exceptions.dart';
import 'package:smart_guide/core/errors/failures.dart';
import 'package:smart_guide/core/network/connectivity_guard.dart';
import 'package:smart_guide/core/network/api_constants.dart';
import 'package:smart_guide/core/network/api_consumer.dart';
import 'package:smart_guide/feature/auth/register/data/model/register_request_model.dart';
import 'package:smart_guide/feature/auth/register/data/model/register_response_model.dart';
import 'package:smart_guide/feature/auth/register/data/repo/register_repo.dart';
import 'package:smart_guide/generated/locale_keys.g.dart';

class RegisterRemoteImpleRepo implements RegisterRepo {
  final ApiConsumer apiConsumer;

  RegisterRemoteImpleRepo({required this.apiConsumer});

  @override
  Future<Either<Failure, RegisterResponseModel>> register({
    required RegisterRequestModel registerRequestModel,
  }) async {
    try {
      if (!await ConnectivityGuard.hasInternet()) {
        return Left(NetworkFailure(LocaleKeys.noInternetConnection.tr()));
      }
      Map<String, dynamic> data = {
        "FirstName": registerRequestModel.firstName,
        "LastName": registerRequestModel.lastName,
        "UserName": registerRequestModel.userName,
        "Country": registerRequestModel.country,
        "Email": registerRequestModel.email,
        "WhatsAppNumber": registerRequestModel.whatsAppNumber,
        "Password": registerRequestModel.password,
        "ConfirmPassword": registerRequestModel.confirmPassword,
        "Role": registerRequestModel.role,
      };

      // 2. إنشاء الـ FormData لتحويل الطلب لـ Multipart
      FormData formData = FormData.fromMap(data);

      // 3. إضافة الصور (إرسال الملفات الفعلية وليس مجرد المسار String)
      if (registerRequestModel.profileImage != null) {
        formData.files.add(
          MapEntry(
            "ProfileImage",
            await MultipartFile.fromFile(registerRequestModel.profileImage!),
          ),
        );
      }

      // إذا كان المستخدم مرشد، نبعت صور التراخيص والبطاقة
      if (registerRequestModel.role == "TourGuide") {
        if (registerRequestModel.guideLicenseImage != null &&
            registerRequestModel.guideLicenseImage!.isNotEmpty) {
          formData.files.add(
            MapEntry(
              "GuideLicenseImage",
              await MultipartFile.fromFile(
                registerRequestModel.guideLicenseImage!,
                // إضافة اسم الملف بيساعد السيرفر يتعرف على النوع
                filename: registerRequestModel.guideLicenseImage!
                    .split('/')
                    .last,
              ),
            ),
          );
        }

        if (registerRequestModel.nationalIdImage != null &&
            registerRequestModel.nationalIdImage!.isNotEmpty) {
          formData.files.add(
            MapEntry(
              "NationalIdImage",
              await MultipartFile.fromFile(
                registerRequestModel.nationalIdImage!,
                filename: registerRequestModel.nationalIdImage!.split('/').last,
              ),
            ),
          );
        }
      }
      final response = await apiConsumer.post(
        EndPoint.register,
        data: formData,
        isFromData: true,
      );

      final registerRespone = RegisterResponseModel.fromJson(response);
      return Right(registerRespone);
    } on ServerException catch (e) {
      print(
        "Server Exception :::::::::::::::::::::::::::::::::::::::::::${e.toString()}",
      );
      return Left(ServerFailure(e.errModel.errorMessage));
    } catch (e) {
      print("catch :::::::::::::::::::::::::::::::::::${e.toString()}");
      return Left(ServerFailure(LocaleKeys.error.tr()));
    }
  }
}
