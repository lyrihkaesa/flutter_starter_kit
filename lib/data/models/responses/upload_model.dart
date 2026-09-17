import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/entities/responses/upload.dart';

part 'upload_model.freezed.dart';
part 'upload_model.g.dart';

@freezed
abstract class UploadModel with _$UploadModel {
  const UploadModel._();

  const factory UploadModel({
    required String id,
    @JsonKey(name: 'upload_id') String? uploadId,
    @JsonKey(name: 'upload_url') String? uploadUrl,
    String? status,
    String? purpose,
    @JsonKey(name: 'file_name') String? fileName,
    @JsonKey(name: 'content_type') String? contentType,
    @JsonKey(name: 'file_size') int? fileSize,
    String? key,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _UploadModel;

  factory UploadModel.fromJson(Map<String, dynamic> json) => _$UploadModelFromJson(json);

  Upload toEntity() {
    return Upload(
      id: id,
      uploadId: uploadId,
      uploadUrl: uploadUrl,
      status: status,
      purpose: purpose,
      fileName: fileName,
      contentType: contentType,
      fileSize: fileSize,
      key: key,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory UploadModel.fromEntity(Upload entity) {
    return UploadModel(
      id: entity.id,
      uploadId: entity.uploadId,
      uploadUrl: entity.uploadUrl,
      status: entity.status,
      purpose: entity.purpose,
      fileName: entity.fileName,
      contentType: entity.contentType,
      fileSize: entity.fileSize,
      key: entity.key,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
