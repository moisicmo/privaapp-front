part of 'location_bloc.dart';

class LocationState extends Equatable {
  final bool followingUser;
  final double? latitude;
  final double? longitude;

  const LocationState({
    this.followingUser = false,
    this.latitude,
    this.longitude,
  });

  LocationState copyWith({
    bool? followingUser,
    double? latitude,
    double? longitude,
  }) =>
      LocationState(
        followingUser: followingUser ?? this.followingUser,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
      );

  @override
  List<Object?> get props => [followingUser, latitude, longitude];
}
