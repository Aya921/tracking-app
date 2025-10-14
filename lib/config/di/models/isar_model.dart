/*import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tracking_app/feature/home/local/models/order_local_model.dart';


@module
abstract class IsarModel {
  @preResolve
  Future<Isar> provideIsar() async {
    final dir = await getApplicationDocumentsDirectory();
    final isar = Isar.open(
      schemas: [OrderLocalModelSchema],
      directory: dir.path,
      engine: IsarEngine.sqlite,
    );
    return isar;
  }
}*/
