import 'dart:async';

class HasFavSongChanged {}

class Eventbus {
  static final Eventbus _instance = Eventbus._internal();
  factory Eventbus() => _instance;
  Eventbus._internal();

  final _favouritesChangedController =
      StreamController<HasFavSongChanged>.broadcast();
  Stream<HasFavSongChanged> get onFavoritesChanged =>
      _favouritesChangedController.stream;
  void notifyFavouritesChanged() {
    _favouritesChangedController.add(HasFavSongChanged());
  }

  void dispose() {
    _favouritesChangedController.close();
  }
}
