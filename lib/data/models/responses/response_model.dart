import '../../../domain/entities/responses/response.dart';

class ResponseModel<T> {
  final String? message;
  final T? data;
  final MetaModel? meta;
  final Map<String, List<String>>? errors; // misal: validation error
  final String? error; // misal: "invalid_token"
  final String? errorDescription; // misal: "Token expired"

  ResponseModel({
    this.message,
    this.data,
    this.meta,
    this.errors,
    this.error,
    this.errorDescription,
  });

  /// Menandakan apakah response memiliki metadata pagination
  bool get isPaginated => meta != null;

  /// Mengonversi ke Entity domain [Response<R>].
  ///
  /// Jika tipe entity berbeda dari tipe model (misalnya [UserModel] ke [User]),
  /// berikan fungsi [dataMapper] untuk mentransformasikan data.
  Response<R> toEntity<R>([R Function(T data)? dataMapper]) {
    final R? mappedData = data != null
        ? (dataMapper != null ? dataMapper(data as T) : data as R?)
        : null;

    return Response<R>(
      message: message,
      data: mappedData,
      meta: meta?.toEntity(),
    );
  }

  factory ResponseModel.fromEntity(
    Response<T> response, [
    T Function(T entity)? entityMapper,
  ]) {
    return ResponseModel<T>(
      message: response.message,
      data: response.data != null && entityMapper != null
          ? entityMapper(response.data as T)
          : response.data,
      meta: response.meta != null ? MetaModel.fromEntity(response.meta!) : null,
    );
  }

  factory ResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return ResponseModel<T>(
      message: json['message'] as String?,
      data: json.containsKey('data') && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      meta: json['meta'] != null ? MetaModel.fromJson(json['meta']) : null,
      errors: json['errors'] != null
          ? (json['errors'] as Map<String, dynamic>).map(
              (key, value) => MapEntry(
                key,
                (value as List<dynamic>).map((e) => e.toString()).toList(),
              ),
            )
          : null,
      error: json['error'] as String?,
      errorDescription: json['error_description'] as String?,
    );
  }
}

class MetaModel {
  // Pagination Laravel
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<MetaLinkModel>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;
  final String? message;

  MetaModel({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
    this.message,
  });

  Meta toEntity() {
    return Meta(
      currentPage: currentPage,
      from: from,
      lastPage: lastPage,
      links: links?.map((link) => link.toEntity()).toList(),
      path: path,
      perPage: perPage,
      to: to,
      total: total,
      message: message,
    );
  }

  factory MetaModel.fromEntity(Meta meta) {
    return MetaModel(
      currentPage: meta.currentPage,
      from: meta.from,
      lastPage: meta.lastPage,
      links: meta.links?.map((link) => MetaLinkModel.fromEntity(link)).toList(),
      path: meta.path,
      perPage: meta.perPage,
      to: meta.to,
      total: meta.total,
      message: meta.message,
    );
  }

  factory MetaModel.fromJson(Map<String, dynamic> json) {
    return MetaModel(
      currentPage: json['current_page'] as int?,
      from: json['from'] as int?,
      lastPage: json['last_page'] as int?,
      links: (json['links'] as List<dynamic>?)
          ?.map((link) => MetaLinkModel.fromJson(link as Map<String, dynamic>))
          .toList(),
      path: json['path'] as String?,
      perPage: json['per_page'] as int?,
      to: json['to'] as int?,
      total: json['total'] as int?,
      message: json['message'] as String?,
    );
  }
}

class MetaLinkModel {
  final String? url;
  final String? label;
  final bool? active;

  MetaLinkModel({this.url, this.label, this.active});

  MetaLink toEntity() {
    return MetaLink(url: url, label: label, active: active);
  }

  factory MetaLinkModel.fromEntity(MetaLink link) {
    return MetaLinkModel(url: link.url, label: link.label, active: link.active);
  }

  factory MetaLinkModel.fromJson(Map<String, dynamic> json) {
    return MetaLinkModel(
      url: json['url'] as String?,
      label: json['label'] as String?,
      active: json['active'] as bool?,
    );
  }
}
