import '../../../../../Beneficiaries Role Type/Profile/data/userprofile_model.dart';
import '../../../data/order_model.dart';
import '../../../data/user_model.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}

class BeneficiariesLoading extends OrderState {}

class BeneficiariesLoaded extends OrderState {
  final List<UserProfile> beneficiaries;

  BeneficiariesLoaded(this.beneficiaries);
}

class BeneficiariesError extends OrderState {
  final String message;

  BeneficiariesError(this.message);
}

class BeneficiaryLoading extends OrderState {}

class OrderDetailsLoading extends OrderState {}

class OrderDetailsLoaded extends OrderState {
  final UserProfile order;
  OrderDetailsLoaded(this.order);
}
class OrderDetailsError extends OrderState {
  final String message;
  OrderDetailsError(this.message);
}

class OrderDetailsNotificationSent extends OrderState {}

class OrderDetailsNotificationLoading extends OrderState {}

class OrderDetailsNotificationError extends OrderState {
  final String message;
  OrderDetailsNotificationError(this.message);
}

class BeneficiaryLoaded extends OrderState {}

class BeneficiaryError extends OrderState {
  final String message;
  BeneficiaryError(this.message);
}

class OrderEmpty extends OrderState {}

class OrderCreated extends OrderState {}

class OrderUpdated extends OrderState {}

class OrderDeleted extends OrderState {}

class OrderError extends OrderState {
  final String message;

  OrderError(this.message);
}
