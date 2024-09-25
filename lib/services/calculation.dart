import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_mortgage_calc/models/mortgage_input.dart';
import 'package:logger/logger.dart';

class CalculationService extends ChangeNotifier {
  bool _isResults = false;
  String _formattedMonthlyRepayment = '';
  String _formattedTotalRepayment = '';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger logger = Logger();

  bool get isResults => _isResults;
  String get formattedMonthlyRepayment => _formattedMonthlyRepayment;
  String get formattedTotalRepayment => _formattedTotalRepayment;

  Future<void> saveUserInput(MortgageInput input) async {
    try {
      await _firestore
          .collection('users')
          .doc(input.userID)
          .collection('inputs')
          .add(input.toFirestore());
    } catch (e) {
      logger.e('Failed to save input: $e');
    }
  }

  Future<void> calculateRepayments(
    double amount,
    int years,
    double interest,
    String mortgageType,
  ) async {
    double monthlyRate = interest / 100 / 12;
    double numberOfPayments = years * 12;
    double monthlyRepayment;

    if (mortgageType == 'repayment') {
      double dividend = monthlyRate * pow(1 + monthlyRate, numberOfPayments);
      double divisor = pow(1 + monthlyRate, numberOfPayments) - 1;
      monthlyRepayment = amount * (dividend / divisor);
    } else {
      monthlyRepayment = amount * monthlyRate;
    }

    double totalRepayment = monthlyRepayment * numberOfPayments;

    final NumberFormat numberFormat = NumberFormat('#,##0.00');
    _formattedMonthlyRepayment = numberFormat.format(monthlyRepayment);
    _formattedTotalRepayment = numberFormat.format(totalRepayment);

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      MortgageInput input = MortgageInput(
        amount: amount,
        years: years,
        interestRate: interest,
        mortgageType: mortgageType,
        userID: user.uid,
        timestamp: DateTime.now(),
      );
      // await saveUserInput(input);
    }

    _isResults = true;
    notifyListeners();
  }

  Future<void> hideResults() async {
    _isResults = false;
    notifyListeners();
  }
}
