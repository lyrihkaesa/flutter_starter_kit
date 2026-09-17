class Response<T> {
  final String? message;
  final T? data;
  final Meta? meta;

  Response({this.message, this.data, this.meta});

  /// Menandakan apakah response memiliki metadata pagination
  bool get isPaginated => meta != null;
}

class Meta {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<MetaLink>? links;
  final String? path;
  final int? perPage;
  final int? to;
  final int? total;
  final String? message;

  Meta({
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

  /// Menandakan apakah masih ada halaman selanjutnya
  bool get hasNextPage =>
      currentPage != null && lastPage != null && currentPage! < lastPage!;

  /// Menandakan apakah masih ada halaman sebelumnya
  bool get hasPreviousPage => currentPage != null && currentPage! > 1;
}

class MetaLink {
  final String? url;
  final String? label;
  final bool? active;

  MetaLink({this.url, this.label, this.active});
}
