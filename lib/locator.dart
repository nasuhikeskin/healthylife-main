import 'package:diyetin_app/repository/user_repository.dart';
import 'package:diyetin_app/services/bildirim_gonderme_servisi.dart';
import 'package:diyetin_app/services/firebase_auth_service.dart';
import 'package:diyetin_app/services/firebase_db_service.dart';
import 'package:diyetin_app/services/firebase_storage_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt(); // GetIt.I -  GetIt.instance - nin kisaltmasidir

void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirestoreDBService());
  locator.registerLazySingleton(() => FirebaseStorageService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => BildirimGondermeServis());
}
