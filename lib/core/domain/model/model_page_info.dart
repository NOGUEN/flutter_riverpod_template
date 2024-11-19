
class ModelPageInfo {
  final num? page;
  final num? pageSize;
  final num? totalCount;
  final bool? first;
  final bool? last;

  ModelPageInfo({
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.first,
    required this.last,
  });

  factory ModelPageInfo.fromJson(Map<String, dynamic> json) {
    return ModelPageInfo(
      page: json['page'],
      pageSize: json['page_size'],
      totalCount: json['total_count'],
      first: json['first'],
      last: json['last'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'page_size': pageSize,
      'total_count': totalCount,
      'first': first,
      'last': last,
    };
  }

  // copywith
  ModelPageInfo copyWith({
    num? page,
    num? pageSize,
    num? totalCount,
    bool? first,
    bool? last,
  }) {
    return ModelPageInfo(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      first: first ?? this.first,
      last: last ?? this.last,
    );
  }
}
