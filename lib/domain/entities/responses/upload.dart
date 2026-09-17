import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload.freezed.dart';

@freezed
abstract class Upload with _$Upload {
  const factory Upload({
    required String id,
    String? uploadId,
    String? uploadUrl,
    String? status,
    String? purpose,
    String? fileName,
    String? contentType,
    int? fileSize,
    String? key,
    String? createdAt,
    String? updatedAt,
  }) = _Upload;
}
