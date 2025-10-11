import 'package:flutter_test/flutter_test.dart';
import 'package:tracking_app/feature/home/api/models/update_state_request_model.dart';
import 'package:tracking_app/feature/home/domain/entity/start_order_request_entity.dart';

void main() {
  test('entityToModel should convert entity to model correctly when not null', () {

    const entity = StrartOrderRequestEntity("pending");

 
    final model = UpdateStateRequestModel.entityToModel(entity);

  
    expect(model.state, entity.orderState);
  });
}
