class BalancesModel {
  final double totalBalance;
  final double remainingBalance;
  final double paid;

  BalancesModel({
    required this.totalBalance,
    required this.remainingBalance,
    required this.paid,
  });

  // Create a BalancesModel from a JSON object
  factory BalancesModel.fromJson(Map<String, dynamic> json) {
    return BalancesModel(
      totalBalance: (json['totalBalance'] ?? 0.0).toDouble(),
      remainingBalance: (json['remainingBalance'] ?? 0.0).toDouble(),
      paid: (json['paid'] ?? 0.0).toDouble(),
    );
  }

  // Convert BalancesModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'totalBalance': totalBalance,
      'remainingBalance': remainingBalance,
      'paid': paid,
    };
  }
}