class TouristSessionState {
  const TouristSessionState({
    required this.userName,
    required this.profilePic,
    required this.userId,
  });

  final String userName;
  final String? profilePic;
  final String userId;
}

class TouristSessionInitial extends TouristSessionState {
  const TouristSessionInitial()
      : super(userName: '', profilePic: null, userId: '');
}

class TouristSessionLoaded extends TouristSessionState {
  const TouristSessionLoaded({
    required super.userName,
    required super.profilePic,
    required super.userId,
  });
}
