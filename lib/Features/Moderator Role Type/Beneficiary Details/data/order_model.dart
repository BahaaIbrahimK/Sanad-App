class OrderModelData {
  String _housingCondition;
  String _monthlyIncome;
  String _name;
  int _numberOfMembers;
  String _states;
  String _userId;

  OrderModelData({
    required String housingCondition,
    required String monthlyIncome,
    required String name,
    required int numberOfMembers,
    required String states,
    required String userId,
  })  : _housingCondition = housingCondition,
        _monthlyIncome = monthlyIncome,
        _name = name,
        _numberOfMembers = numberOfMembers,
        _states = states,
        _userId = userId;

  // Getters
  String get housingCondition => _housingCondition;
  String get monthlyIncome => _monthlyIncome;
  String get name => _name;
  int get numberOfMembers => _numberOfMembers;
  String get states => _states;
  String get userId => _userId;

  // Setters
  set housingCondition(String value) => _housingCondition = value;
  set monthlyIncome(String value) => _monthlyIncome = value;
  set name(String value) => _name = value;
  set numberOfMembers(int value) => _numberOfMembers = value;
  set states(String value) => _states = value;
  set userId(String value) => _userId = value;

  factory OrderModelData.fromJson(Map<String, dynamic> json) {
    return OrderModelData(
      housingCondition: json['housing_condition'] as String,
      monthlyIncome: json['monthly_income'] as String,
      name: json['name'] as String,
      numberOfMembers: int.parse(json['numberOfMembers'].toString()),
      states: json['states'] as String,
      userId: json['userId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'housing_condition': _housingCondition,
      'monthly_income': _monthlyIncome,
      'name': _name,
      'numberOfMembers': _numberOfMembers.toString(),
      'states': _states,
      'userId': _userId,
    };
  }
}