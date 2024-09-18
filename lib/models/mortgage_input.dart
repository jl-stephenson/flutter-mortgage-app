import 'package:cloud_firestore/cloud_firestore.dart';

class MortgageInput {
  final double amount;
  final int years;
  final double interestRate;
  final String mortgageType;
  final String userID;
  final DateTime timestamp;

  MortgageInput({
    required this.amount,
    required this.years,
    required this.interestRate,
    required this.mortgageType,
    required this.userID,
    required this.timestamp,
  });

  Map<String, dynamic> toFirestore() {
    return {
      "amount": amount,
      "years": years,
      "interestRate": interestRate,
      "mortgageType": mortgageType,
      "userID": userID,
      "timestamp": timestamp,
    };
  }

  factory MortgageInput.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return MortgageInput(
      amount: data?['amount'],
      years: data?['years'],
      interestRate: data?['interestRate'],
      mortgageType: data?['mortgageType'],
      userID: data?['userID'],
      timestamp: data?['timestamp'],
    );
  }
}
