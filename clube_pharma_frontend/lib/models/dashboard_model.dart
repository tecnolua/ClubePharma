/// Overview Stats Model
///
/// Represents overview statistics for the dashboard.
class OverviewStatsModel {
  final int totalUsers;
  final int totalOrders;
  final int totalAppointments;
  final double totalRevenue;

  OverviewStatsModel({
    required this.totalUsers,
    required this.totalOrders,
    required this.totalAppointments,
    required this.totalRevenue,
  });

  /// Create OverviewStatsModel from JSON
  factory OverviewStatsModel.fromJson(Map<String, dynamic> json) {
    return OverviewStatsModel(
      totalUsers: json['totalUsers'] as int? ?? 0,
      totalOrders: json['totalOrders'] as int? ?? 0,
      totalAppointments: json['totalAppointments'] as int? ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0,
    );
  }

  /// Convert OverviewStatsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'totalOrders': totalOrders,
      'totalAppointments': totalAppointments,
      'totalRevenue': totalRevenue,
    };
  }
}

/// Sales Stats Model
///
/// Represents sales statistics.
class SalesStatsModel {
  final double totalSales;
  final int totalOrders;
  final double averageOrderValue;
  final List<MonthlySales> monthlySales;

  SalesStatsModel({
    required this.totalSales,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.monthlySales,
  });

  /// Create SalesStatsModel from JSON
  factory SalesStatsModel.fromJson(Map<String, dynamic> json) {
    return SalesStatsModel(
      totalSales: (json['totalSales'] as num?)?.toDouble() ?? 0,
      totalOrders: json['totalOrders'] as int? ?? 0,
      averageOrderValue: (json['averageOrderValue'] as num?)?.toDouble() ?? 0,
      monthlySales: (json['monthlySales'] as List?)?.map((e) => MonthlySales.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    );
  }

  /// Convert SalesStatsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalSales': totalSales,
      'totalOrders': totalOrders,
      'averageOrderValue': averageOrderValue,
      'monthlySales': monthlySales.map((e) => e.toJson()).toList(),
    };
  }
}

/// Monthly Sales
///
/// Represents sales data for a specific month.
class MonthlySales {
  final String month;
  final double total;
  final int orders;

  MonthlySales({
    required this.month,
    required this.total,
    required this.orders,
  });

  factory MonthlySales.fromJson(Map<String, dynamic> json) {
    return MonthlySales(
      month: json['month'] as String,
      total: (json['total'] as num).toDouble(),
      orders: json['orders'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'total': total,
      'orders': orders,
    };
  }
}

/// User Stats Model
///
/// Represents user statistics.
class UserStatsModel {
  final int totalUsers;
  final int activeUsers;
  final int newUsersThisMonth;
  final Map<String, int> usersByPlanType;

  UserStatsModel({
    required this.totalUsers,
    required this.activeUsers,
    required this.newUsersThisMonth,
    required this.usersByPlanType,
  });

  /// Create UserStatsModel from JSON
  factory UserStatsModel.fromJson(Map<String, dynamic> json) {
    return UserStatsModel(
      totalUsers: json['totalUsers'] as int? ?? 0,
      activeUsers: json['activeUsers'] as int? ?? 0,
      newUsersThisMonth: json['newUsersThisMonth'] as int? ?? 0,
      usersByPlanType: Map<String, int>.from(json['usersByPlanType'] as Map? ?? {}),
    );
  }

  /// Convert UserStatsModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalUsers': totalUsers,
      'activeUsers': activeUsers,
      'newUsersThisMonth': newUsersThisMonth,
      'usersByPlanType': usersByPlanType,
    };
  }
}
