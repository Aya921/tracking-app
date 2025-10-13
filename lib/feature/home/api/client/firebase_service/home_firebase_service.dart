import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:tracking_app/core/constants/constants.dart';
import 'package:tracking_app/feature/home/api/models/remote_data_model.dart';
// import 'todo_model.dart';



@injectable
class HomeFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference<RemoteDataModel> _collectionReference;

  HomeFirebaseService() {
    _collectionReference = _firestore
        .collection(Constants.orderRef)
        .withConverter<RemoteDataModel>(
          fromFirestore: (snap, _) => RemoteDataModel.fromJson(snap.data()!),
          toFirestore: (remoteData, _) => remoteData.toJson(),
        );
  }

  Future<void> addOrders(RemoteDataModel model) async {
    await _collectionReference.doc(model.orderModel!.id).set(model);
  }

  Stream<RemoteDataModel> getDataFromRemote(String orderId) {
    return _collectionReference
        .doc(orderId)
        .snapshots()
        .map((snapshot) => snapshot.data()!);
  }

  Future<void> updateOrderState(String orderId, String newState) async {
    await _collectionReference.doc(orderId).update({
      'orderDeliveryStatus': newState,
    });
  }

}
