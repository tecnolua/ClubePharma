import prisma from '../config/database.js';

/**
 * Dashboard Controller
 *
 * Provides analytics and statistics for admin dashboard.
 * Includes overview stats, sales data, and user metrics.
 */

/**
 * Get Overview Statistics (Admin only)
 * GET /api/dashboard/overview
 *
 * Returns general statistics about the platform.
 */
export const getOverviewStats = async (req, res) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    // Get all stats in parallel
    const [
      totalUsers,
      totalOrders,
      totalRevenue,
      ordersToday,
      newUsersToday,
      scheduledAppointments
    ] = await Promise.all([
      // Total users
      prisma.user.count(),

      // Total orders
      prisma.order.count(),

      // Total revenue (excluding cancelled orders)
      prisma.order.aggregate({
        where: {
          status: {
            notIn: ['CANCELLED']
          }
        },
        _sum: {
          total: true
        }
      }),

      // Orders today
      prisma.order.count({
        where: {
          createdAt: {
            gte: today
          }
        }
      }),

      // New users today
      prisma.user.count({
        where: {
          createdAt: {
            gte: today
          }
        }
      }),

      // Scheduled appointments (upcoming only)
      prisma.appointment.count({
        where: {
          status: 'SCHEDULED',
          scheduledFor: {
            gte: new Date()
          }
        }
      })
    ]);

    res.status(200).json({
      success: true,
      data: {
        totalUsers,
        totalOrders,
        totalRevenue: totalRevenue._sum.total || 0,
        ordersToday,
        newUsersToday,
        scheduledAppointments
      }
    });
  } catch (error) {
    console.error('Get overview stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

/**
 * Get Sales Statistics (Admin only)
 * GET /api/dashboard/sales
 *
 * Returns sales data including trends and top products.
 */
export const getSalesStats = async (req, res) => {
  try {
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    // Sales by day for last 30 days
    const salesByDay = await prisma.order.groupBy({
      by: ['createdAt'],
      where: {
        createdAt: {
          gte: thirtyDaysAgo
        },
        status: {
          notIn: ['CANCELLED']
        }
      },
      _sum: {
        total: true
      },
      _count: {
        id: true
      }
    });

    // Format sales by day
    const formattedSalesByDay = salesByDay.reduce((acc, sale) => {
      const date = new Date(sale.createdAt).toISOString().split('T')[0];
      if (!acc[date]) {
        acc[date] = {
          date,
          revenue: 0,
          orders: 0
        };
      }
      acc[date].revenue += parseFloat(sale._sum.total || 0);
      acc[date].orders += sale._count.id;
      return acc;
    }, {});

    // Most sold products (by quantity)
    const topProductsByQuantity = await prisma.orderItem.groupBy({
      by: ['productId'],
      _sum: {
        quantity: true
      },
      _count: {
        id: true
      },
      orderBy: {
        _sum: {
          quantity: 'desc'
        }
      },
      take: 10
    });

    // Get product details for top products
    const productIds = topProductsByQuantity.map(item => item.productId);
    const products = await prisma.product.findMany({
      where: {
        id: {
          in: productIds
        }
      },
      select: {
        id: true,
        name: true,
        category: true,
        price: true
      }
    });

    const topProducts = topProductsByQuantity.map(item => {
      const product = products.find(p => p.id === item.productId);
      return {
        productId: item.productId,
        productName: product?.name || 'Unknown',
        category: product?.category || 'Unknown',
        quantitySold: item._sum.quantity || 0,
        orderCount: item._count.id
      };
    });

    // Sales by category
    const salesByCategory = await prisma.orderItem.groupBy({
      by: ['productId'],
      _sum: {
        quantity: true
      }
    });

    // Get products with categories
    const allProducts = await prisma.product.findMany({
      select: {
        id: true,
        category: true
      }
    });

    const categoryStats = salesByCategory.reduce((acc, item) => {
      const product = allProducts.find(p => p.id === item.productId);
      if (product && product.category) {
        if (!acc[product.category]) {
          acc[product.category] = {
            category: product.category,
            quantitySold: 0
          };
        }
        acc[product.category].quantitySold += item._sum.quantity || 0;
      }
      return acc;
    }, {});

    // Calculate average ticket
    const orderStats = await prisma.order.aggregate({
      where: {
        status: {
          notIn: ['CANCELLED']
        }
      },
      _avg: {
        total: true
      },
      _count: {
        id: true
      }
    });

    res.status(200).json({
      success: true,
      data: {
        salesByDay: Object.values(formattedSalesByDay).sort((a, b) =>
          new Date(a.date) - new Date(b.date)
        ),
        topProducts,
        salesByCategory: Object.values(categoryStats).sort((a, b) =>
          b.quantitySold - a.quantitySold
        ),
        averageTicket: orderStats._avg.total || 0,
        totalOrders: orderStats._count.id
      }
    });
  } catch (error) {
    console.error('Get sales stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};

/**
 * Get User Statistics (Admin only)
 * GET /api/dashboard/users
 *
 * Returns user-related statistics and growth metrics.
 */
export const getUserStats = async (req, res) => {
  try {
    // Users by plan type
    const usersByPlan = await prisma.user.groupBy({
      by: ['planType'],
      _count: {
        id: true
      }
    });

    const planStats = usersByPlan.map(plan => ({
      planType: plan.planType,
      count: plan._count.id
    }));

    // Active vs inactive users (based on recent activity)
    const thirtyDaysAgo = new Date();
    thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

    const [activeUsers, totalUsers] = await Promise.all([
      prisma.user.count({
        where: {
          OR: [
            {
              orders: {
                some: {
                  createdAt: {
                    gte: thirtyDaysAgo
                  }
                }
              }
            },
            {
              appointments: {
                some: {
                  createdAt: {
                    gte: thirtyDaysAgo
                  }
                }
              }
            }
          ]
        }
      }),
      prisma.user.count()
    ]);

    const inactiveUsers = totalUsers - activeUsers;

    // New users per day (last 7 days)
    const sevenDaysAgo = new Date();
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7);

    const newUsersByDay = await prisma.user.groupBy({
      by: ['createdAt'],
      where: {
        createdAt: {
          gte: sevenDaysAgo
        }
      },
      _count: {
        id: true
      }
    });

    // Format new users by day
    const formattedNewUsers = newUsersByDay.reduce((acc, user) => {
      const date = new Date(user.createdAt).toISOString().split('T')[0];
      if (!acc[date]) {
        acc[date] = {
          date,
          count: 0
        };
      }
      acc[date].count += user._count.id;
      return acc;
    }, {});

    // Users by role
    const usersByRole = await prisma.user.groupBy({
      by: ['role'],
      _count: {
        id: true
      }
    });

    const roleStats = usersByRole.map(role => ({
      role: role.role,
      count: role._count.id
    }));

    res.status(200).json({
      success: true,
      data: {
        usersByPlan: planStats,
        activityStats: {
          activeUsers,
          inactiveUsers,
          totalUsers
        },
        newUsersByDay: Object.values(formattedNewUsers).sort((a, b) =>
          new Date(a.date) - new Date(b.date)
        ),
        usersByRole: roleStats
      }
    });
  } catch (error) {
    console.error('Get user stats error:', error);
    res.status(500).json({
      success: false,
      message: 'Internal server error'
    });
  }
};
