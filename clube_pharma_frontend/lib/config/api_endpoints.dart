/// API Endpoints
///
/// Contains all 91 specific endpoints organized by 14 modules
class ApiEndpoints {
  // ========== AUTH ENDPOINTS (7) ==========
  static const String authLogin = '/auth/login';
  static const String authRegister = '/auth/register';
  static const String authLogout = '/auth/logout';
  static const String authMe = '/auth/me';
  static const String authRefreshToken = '/auth/refresh-token';
  static const String authForgotPassword = '/auth/forgot-password';
  static const String authResetPassword = '/auth/reset-password';

  // ========== USER ENDPOINTS (5) ==========
  static const String userProfile = '/users/profile';
  static const String userUpdateProfile = '/users/profile';
  static const String userUpdatePassword = '/users/password';
  static const String userUploadAvatar = '/users/avatar';
  static const String userDeleteAccount = '/users/account';

  // ========== FAMILY MEMBERS ENDPOINTS (5) ==========
  static const String familyMembersList = '/family-members';
  static const String familyMembersCreate = '/family-members';
  static String familyMembersGetById(String id) => '/family-members/$id';
  static String familyMembersUpdate(String id) => '/family-members/$id';
  static String familyMembersDelete(String id) => '/family-members/$id';

  // ========== TREATMENTS ENDPOINTS (7) ==========
  static const String treatmentsList = '/treatments';
  static const String treatmentsCreate = '/treatments';
  static const String treatmentsActive = '/treatments/active';
  static String treatmentsGetById(String id) => '/treatments/$id';
  static String treatmentsUpdate(String id) => '/treatments/$id';
  static String treatmentsDelete(String id) => '/treatments/$id';
  static String treatmentsSchedule(String id) => '/treatments/$id/schedule';

  // ========== PILL TAKES ENDPOINTS (8) ==========
  static const String pillTakesToday = '/pill-takes/today';
  static const String pillTakesUpcoming = '/pill-takes/upcoming';
  static const String pillTakesAdherence = '/pill-takes/adherence';
  static const String pillTakesCreate = '/pill-takes';
  static String pillTakesGetById(String id) => '/pill-takes/$id';
  static String pillTakesMarkTaken(String id) => '/pill-takes/$id/take';
  static String pillTakesMarkSkipped(String id) => '/pill-takes/$id/skip';
  static String pillTakesDelete(String id) => '/pill-takes/$id';

  // ========== PRESCRIPTIONS ENDPOINTS (6) ==========
  static const String prescriptionsList = '/prescriptions';
  static const String prescriptionsUpload = '/prescriptions'; // POST to /prescriptions
  static String prescriptionsGetById(String id) => '/prescriptions/$id';
  static String prescriptionsDownload(String id) => '/prescriptions/$id/download';
  static String prescriptionsUpdate(String id) => '/prescriptions/$id';
  static String prescriptionsDelete(String id) => '/prescriptions/$id';

  // ========== EXAMS ENDPOINTS (6) ==========
  static const String examsList = '/exams';
  static const String examsUpload = '/exams'; // POST to /exams
  static String examsGetById(String id) => '/exams/$id';
  static String examsDownload(String id) => '/exams/$id/download';
  static String examsUpdate(String id) => '/exams/$id';
  static String examsDelete(String id) => '/exams/$id';

  // ========== PRODUCTS ENDPOINTS (7) ==========
  static const String productsList = '/products';
  static const String productsCategories = '/products/categories';
  static const String productsSearch = '/products/search';
  static const String productsFeatured = '/products/featured';
  static const String productsByCategory = '/products/by-category';
  static String productsGetById(String id) => '/products/$id';
  static String productsReviews(String id) => '/products/$id/reviews';

  // ========== CART ENDPOINTS (6) ==========
  static const String cartGet = '/cart';
  static const String cartAdd = '/cart'; // POST to /cart
  static const String cartClear = '/cart'; // DELETE to /cart
  static String cartUpdateItem(String itemId) => '/cart/$itemId'; // PUT
  static String cartRemoveItem(String itemId) => '/cart/$itemId'; // DELETE
  static String cartUpdateQuantity(String itemId) => '/cart/$itemId/quantity';

  // ========== ORDERS ENDPOINTS (8) ==========
  static const String ordersList = '/orders';
  static const String ordersCreate = '/orders';
  static const String ordersStats = '/orders/stats';
  static String ordersGetById(String id) => '/orders/$id';
  static String ordersCancel(String id) => '/orders/$id/cancel';
  static String ordersTrack(String id) => '/orders/$id/track';
  static String ordersInvoice(String id) => '/orders/$id/invoice';
  static String ordersReorder(String id) => '/orders/$id/reorder';

  // ========== DOCTORS ENDPOINTS (6) ==========
  static const String doctorsList = '/doctors';
  static const String doctorsSpecialties = '/doctors/specialties';
  static const String doctorsSearch = '/doctors/search';
  static const String doctorsNearby = '/doctors/nearby';
  static String doctorsGetById(String id) => '/doctors/$id';
  static String doctorsReviews(String id) => '/doctors/$id/reviews';

  // ========== APPOINTMENTS ENDPOINTS (8) ==========
  static const String appointmentsList = '/appointments';
  static const String appointmentsCreate = '/appointments';
  static const String appointmentsUpcoming = '/appointments/upcoming';
  static String appointmentsGetById(String id) => '/appointments/$id';
  static String appointmentsAvailableSlots(String doctorId) =>
      '/appointments/available-slots/$doctorId';
  static String appointmentsConfirm(String id) => '/appointments/$id/confirm';
  static String appointmentsCancel(String id) => '/appointments/$id/cancel';
  static String appointmentsReschedule(String id) => '/appointments/$id/reschedule';

  // ========== PAYMENTS ENDPOINTS (6) ==========
  static const String paymentsList = '/payments';
  static const String paymentsCreatePreference = '/payments/create-preference';
  static const String paymentsHistory = '/payments/history';
  static String paymentsGetById(String id) => '/payments/$id';
  static String paymentsStatus(String id) => '/payments/$id/status';
  static String paymentsRefund(String id) => '/payments/$id/refund';

  // ========== COUPONS ENDPOINTS (5) ==========
  static const String couponsList = '/coupons';
  static const String couponsValidate = '/coupons/validate';
  static const String couponsApply = '/coupons/apply';
  static String couponsGetById(String id) => '/coupons/$id';
  static String couponsRemove(String code) => '/coupons/$code/remove';

  // ========== DASHBOARD ENDPOINTS (5) ==========
  static const String dashboardStats = '/dashboard/stats';
  static const String dashboardActivities = '/dashboard/activities';
  static const String dashboardUpcomingTasks = '/dashboard/upcoming-tasks';
  static const String dashboardHealthSummary = '/dashboard/health-summary';
  static const String dashboardNotifications = '/dashboard/notifications';

  // ========== ADDRESSES ENDPOINTS (6) ==========
  static const String addressesList = '/addresses';
  static const String addressesCreate = '/addresses';
  static const String addressesDefault = '/addresses/default';
  static String addressesGetById(String id) => '/addresses/$id';
  static String addressesUpdate(String id) => '/addresses/$id';
  static String addressesDelete(String id) => '/addresses/$id';
}
