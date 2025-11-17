import 'package:equatable/equatable.dart';

class AffiliateStats extends Equatable {
  final String userId;
  final String referralCode;
  final int totalReferrals;
  final int activeReferrals;
  final double totalEarnings;
  final double pendingEarnings;
  final double withdrawableEarnings;
  final double totalWithdrawn;
  final int clickCount;
  final double conversionRate;

  const AffiliateStats({
    required this.userId,
    required this.referralCode,
    required this.totalReferrals,
    required this.activeReferrals,
    required this.totalEarnings,
    required this.pendingEarnings,
    required this.withdrawableEarnings,
    required this.totalWithdrawn,
    required this.clickCount,
    required this.conversionRate,
  });

  @override
  List<Object?> get props => [
        userId,
        referralCode,
        totalReferrals,
        activeReferrals,
        totalEarnings,
        pendingEarnings,
        withdrawableEarnings,
        totalWithdrawn,
        clickCount,
        conversionRate,
      ];
}
