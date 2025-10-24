abstract class ShareState {
  const ShareState();
}

class ShareInitial extends ShareState {}

class ShareGenerating extends ShareState {}

class ShareGenerated extends ShareState {
  final String deepLink;
  const ShareGenerated({required this.deepLink});
}

class ShareSharing extends ShareState {}

class ShareSuccess extends ShareState {
  final String message;
  const ShareSuccess({this.message = 'Chia sẻ thành công'});
}

class ShareCancelled extends ShareState {}

class ShareError extends ShareState {
  final String message;
  const ShareError({required this.message});
}