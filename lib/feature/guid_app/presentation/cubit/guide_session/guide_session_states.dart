class GuideSessionState {
  const GuideSessionState({
    required this.userName,
    required this.profilePic,
    required this.userId,
  });

  final String userName;
  final String? profilePic;
  final String userId;
}

class GuideSessionInitial extends GuideSessionState {
  const GuideSessionInitial()
      : super(userName: '', profilePic: null, userId: '');
}

class GuideSessionLoaded extends GuideSessionState {
  const GuideSessionLoaded({
    required super.userName,
    required super.profilePic,
    required super.userId,
  });
}
