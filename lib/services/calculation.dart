import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalculationService extends ChangeNotifier {
  bool _isResults = false;
  String _formattedMonthlyRepayment = '';
  String _formattedTotalRepayment = '';

  bool get isResults => _isResults;
  String get formattedMonthlyRepayment => _formattedMonthlyRepayment;
  String get formattedTotalRepayment => _formattedTotalRepayment;

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

    _isResults = true;
    notifyListeners();
  }

  Future<void> hideResults() async {
    _isResults = false;
    notifyListeners();
  }
}
