class BeneficiaryModel {
  final double monthlyIncome;
  final String beneficiaryStatus;
  final String approvalStatus;

  BeneficiaryModel({
    required this.monthlyIncome,
    required this.beneficiaryStatus,
    required this.approvalStatus,
  });

  // Factory method to create a BeneficiaryModel
  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) {
    return BeneficiaryModel(
      monthlyIncome: (json['monthlyIncome'] ?? 0.0).toDouble(),
      beneficiaryStatus: json['beneficiaryStatus'] ?? '',
      approvalStatus: json['approvalStatus'] ?? '',
    );
  }

  // Convert BeneficiaryModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'monthlyIncome': monthlyIncome,
      'beneficiaryStatus': beneficiaryStatus,
      'approvalStatus': approvalStatus,
    };
  }
}