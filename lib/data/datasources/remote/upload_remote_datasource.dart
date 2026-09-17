import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../models/responses/upload_model.dart';

abstract class UploadRemoteDataSource {
  Future<UploadModel> prepareUpload({
    required String purpose,
    required String fileName,
    required String contentType,
    required int fileSize,
    String? requestedVisibility,
  });

  Future<void> uploadFileToSignedUrl({
    required String uploadUrl,
    required List<int> bytes,
    required String contentType,
  });

  Future<UploadModel> markUploaded(String uploadId);

  Future<UploadModel> getUpload(String uploadId);
}

@LazySingleton(as: UploadRemoteDataSource)
class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  final Dio _dio;

  UploadRemoteDataSourceImpl(this._dio);

  @override
  Future<UploadModel> prepareUpload({
    required String purpose,
    required String fileName,
    required String contentType,
    required int fileSize,
    String? requestedVisibility,
  }) async {
    final response = await _dio.post(
      '/v1/uploads/prepare',
      data: {
        'purpose': purpose,
        'file_name': fileName,
        'content_type': contentType,
        'file_size': fileSize,
        'requested_visibility': ?requestedVisibility,
      },
    );

    final dataMap = response.data['data'] as Map<String, dynamic>;
    return UploadModel.fromJson(dataMap);
  }

  @override
  Future<void> uploadFileToSignedUrl({
    required String uploadUrl,
    required List<int> bytes,
    required String contentType,
  }) async {
    await _dio.put(
      uploadUrl,
      data: Stream.fromIterable([bytes]),
      options: Options(
        headers: {
          'Content-Type': contentType,
          'Content-Length': bytes.length,
        },
      ),
    );
  }

  @override
  Future<UploadModel> markUploaded(String uploadId) async {
    final response = await _dio.post('/v1/uploads/$uploadId/mark-uploaded');
    final dataMap = response.data['data'] as Map<String, dynamic>;
    return UploadModel.fromJson(dataMap);
  }

  @override
  Future<UploadModel> getUpload(String uploadId) async {
    final response = await _dio.get('/v1/uploads/$uploadId');
    final dataMap = response.data['data'] as Map<String, dynamic>;
    return UploadModel.fromJson(dataMap);
  }
}
