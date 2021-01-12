part of 'bloc.dart';

class DynamicLinkState extends Equatable {
  const DynamicLinkState({
    this.status = DynamicLinkStatus.uninitialized,
    this.link,
    this.error,
  });

  final DynamicLinkStatus status;
  final Uri link;
  final String error;

  DynamicLinkState copyWith({
    DynamicLinkStatus status,
    Uri link,
    String error,
  }) {
    return DynamicLinkState(
      status: status ?? this.status,
      link: link ?? this.link,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, link, error];
}

enum DynamicLinkStatus { uninitialized, fetching, fetched }
