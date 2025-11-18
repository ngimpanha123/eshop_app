# POS System - Project Structure & Navigation

## 📁 Folder Structure

```
lib/
├── app/
│   ├── config/
│   │   ├── app_config.dart              # API URLs and configuration
│   │   └── theme_config.dart            # Dark theme configuration
│   │
│   ├── constants/
│   │   └── color_constan.dart           # Color constants
│   │
│   ├── data/
│   │   ├── models/                      # Data Models
│   │   │   ├── sale_model.dart          # Sales & transactions
│   │   │   ├── order_model.dart         # Orders & cart
│   │   │   ├── profile_model.dart       # User profile & logs
│   │   │   └── sales_setup_model.dart   # Setup configurations
│   │   │
│   │   └── providers/
│   │       └── api_provider.dart        # All API endpoints
│   │
│   ├── modules/
│   │   ├── home/                        # 🏠 Main Container
│   │   │   ├── bindings/
│   │   │   │   └── home_binding.dart    # Initialize all controllers
│   │   │   ├── controllers/
│   │   │   │   └── home_controller.dart # Bottom navigation logic
│   │   │   ├── views/
│   │   │   │   └── home_view.dart       # Bottom navigation UI
│   │   │   └── widgets/
│   │   │       └── app_drawer.dart      # Navigation drawer
│   │   │
│   │   ├── login/                       # 🔐 Authentication
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   │       └── login_view.dart      # Modern login UI
│   │   │
│   │   ├── dashboard/                   # 📊 Dashboard (Tab 1)
│   │   │   ├── controllers/
│   │   │   ├── views/
│   │   │   └── widgets/
│   │   │
│   │   ├── cashier_order/               # 🛒 New Order (Tab 2)
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   │   └── cashier_order_controller.dart
│   │   │   └── views/
│   │   │       └── cashier_order_view.dart
│   │   │
│   │   ├── cashier_sales/               # 📝 My Sales (Tab 3)
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   │   └── cashier_sales_controller.dart
│   │   │   └── views/
│   │   │       └── cashier_sales_view.dart
│   │   │
│   │   ├── reports/                     # 📈 Reports (Tab 4)
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   │   └── reports_controller.dart
│   │   │   └── views/
│   │   │       └── reports_view.dart
│   │   │
│   │   ├── profile/                     # 👤 Profile (Tab 5)
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   │   └── profile_controller.dart
│   │   │   └── views/
│   │   │       └── profile_view.dart
│   │   │
│   │   ├── admin_sales/                 # 💼 Admin Sales (Drawer)
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   │   └── admin_sales_controller.dart
│   │   │   └── views/
│   │   │       └── admin_sales_view.dart
│   │   │
│   │   ├── product/                     # 📦 Products (Drawer)
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   │
│   │   ├── admin_product/               # ⚙️ Manage Products (Drawer)
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   │
│   │   ├── admin_user/                  # 👥 Users (Drawer)
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   │
│   │   ├── search_product/              # 🔍 Search (Drawer)
│   │   │   ├── bindings/
│   │   │   ├── controllers/
│   │   │   └── views/
│   │   │
│   │   └── app_settings/                # ⚙️ Settings (Drawer)
│   │       ├── bindings/
│   │       ├── controllers/
│   │       └── views/
│   │
│   ├── routes/
│   │   ├── app_pages.dart               # Route definitions
│   │   └── app_routes.dart              # Route names & paths
│   │
│   ├── services/
│   │   └── storage_service.dart         # Token storage
│   │
│   └── dependency_injection.dart        # Initialize dependencies
│
└── main.dart                            # App entry point
```

## 🗺️ Navigation Structure

### Bottom Navigation (Main Tabs)
The app has 5 main tabs accessible from the bottom navigation bar:

1. **Dashboard** (`/dashboard`)
   - Sales statistics
   - Revenue charts
   - Cashier performance
   - Product analytics

2. **New Order** (`/cashier-order`)
   - Browse products by category
   - Add items to cart
   - Place orders
   - Cart management

3. **My Sales** (`/cashier-sales`)
   - View personal sales
   - Sale details
   - Print invoices
   - Sales history

4. **Reports** (`/reports`)
   - Generate sale reports
   - Cashier reports
   - Product reports
   - Date range selection

5. **Profile** (`/profile`)
   - View profile
   - Edit profile
   - Change password
   - Activity logs
   - Logout

### Navigation Drawer (Additional Menus)
Accessible from the hamburger menu on the dashboard:

**Main Section:**
- Dashboard
- New Order
- My Sales

**Admin Section:**
- All Sales (`/admin-sales`) - View all sales with filters
- Products (`/product`) - Browse products
- Manage Products (`/admin-product`) - CRUD operations
- Users (`/admin-user`) - User management

**Tools Section:**
- Reports
- Search Products (`/search-product`)
- Settings (`/app-settings`)

## 🔄 Route Flow

### 1. App Startup
```
main.dart
  → DependencyInjection.init()
  → InitialRoute: /login
```

### 2. After Login
```
LoginView
  → Login successful
  → Navigate to /home
  → HomeView loads with nested Navigator
  → Initial route: /dashboard
```

### 3. Bottom Navigation
```dart
// HomeController
var lstRoutesName = [
  Routes.DASHBOARD,        // Index 0
  Routes.CASHIER_ORDER,    // Index 1
  Routes.CASHIER_SALES,    // Index 2
  Routes.REPORTS,          // Index 3
  Routes.PROFILE,          // Index 4
];

void onPageChange(int index) {
  selectedIndex.value = index;
  Get.offAllNamed(lstRoutesName[index], id: 1);
}
```

### 4. Nested Navigation
All bottom tab routes use nested navigation (id: 1):
```dart
Navigator(
  key: Get.nestedKey(1),
  initialRoute: Routes.DASHBOARD,
  onGenerateRoute: controller.onGenerateRoute,
)
```

## 🎯 Controller Initialization

All controllers are pre-initialized in `HomeBinding` to prevent them from being disposed when switching tabs:

```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Main bottom navigation controllers
    Get.put(DashboardController(), permanent: true);
    Get.put(CashierOrderController(), permanent: true);
    Get.put(CashierSalesController(), permanent: true);
    Get.put(ReportsController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
    
    // Additional controllers
    Get.put(AdminSalesController(), permanent: true);
    Get.put(ProductController(), permanent: true);
    Get.put(AdminProductController(), permanent: true);
    // ... more controllers
  }
}
```

## 📋 API Integration

### API Provider
All API endpoints are centralized in `api_provider.dart`:

**Account Module:**
- `login()` - User authentication
- `switchRole()` - Switch user role
- `getProfileLogs()` - Activity logs
- `updateProfile()` - Update profile
- `updatePassword()` - Change password

**Admin Sales Module:**
- `getSalesSetup()` - Setup data
- `getSales()` - Sales list with filters
- `deleteSale()` - Delete sale

**Reports Module:**
- `generateSaleReport()` - PDF report
- `generateCashierReport()` - PDF report
- `generateProductReport()` - PDF report
- `getOrderInvoice()` - Invoice PDF

**Cashier Order Module:**
- `getOrderingProducts()` - Products for ordering
- `placeOrder()` - Create new order

**Cashier Sales Module:**
- `getCashierSales()` - Personal sales
- `viewSale()` - Sale details
- `deleteSale()` - Delete sale

## 🎨 Theme Configuration

### Dark Theme
All screens use the dark theme defined in `theme_config.dart`:

**Colors:**
- Background: `#0F0F0F`
- Surface: `#1A1A1A`
- Card: `#242424`
- Primary: `#6366F1` (Indigo)
- Accent: `#10B981` (Green)

**Components:**
- Cards with rounded corners
- Gradient buttons
- Soft shadows
- Proper text hierarchy

## 🚀 How to Run

### 1. Install Dependencies
```bash
flutter pub get
```

### 2. Run the App
```bash
flutter run
```

### 3. Login
Use the default credentials:
- Phone: `0963919745`
- Password: `123456`

### 4. Navigate
- Use **bottom navigation** for main features
- Use **drawer menu** (☰) for admin features
- Tap any menu item to navigate

## 📱 Features by Role

### Cashier Role
**Bottom Navigation:**
- ✅ Dashboard (read-only)
- ✅ New Order (create orders)
- ✅ My Sales (personal sales)
- ✅ Reports (personal reports)
- ✅ Profile (manage account)

**Drawer:**
- ✅ Products (browse)
- ✅ Search Products

### Admin Role
**Bottom Navigation:**
- ✅ Dashboard (full analytics)
- ✅ New Order (create orders)
- ✅ My Sales (personal sales)
- ✅ Reports (all reports)
- ✅ Profile (manage account)

**Drawer:**
- ✅ All Sales (view & manage all sales)
- ✅ Products (browse all)
- ✅ Manage Products (CRUD)
- ✅ Users (manage users)
- ✅ Search Products
- ✅ Settings

## 🔐 Authentication Flow

```
1. User opens app
   ↓
2. LoginView shown
   ↓
3. User enters credentials
   ↓
4. API call to /account/auth/login
   ↓
5. Token saved to storage
   ↓
6. Navigate to HomeView
   ↓
7. Load Dashboard (initial route)
   ↓
8. User can navigate using:
   - Bottom navigation (5 tabs)
   - Drawer menu (additional features)
```

## 📝 Notes

1. **State Management:** GetX (Reactive)
2. **HTTP Client:** Dio
3. **Storage:** GetStorage + FlutterSecureStorage
4. **Navigation:** GetX Navigation (Nested)
5. **Theme:** Material 3 Dark Theme

## 🎯 Next Steps

- [ ] Implement role-based menu visibility
- [ ] Add permission checks
- [ ] Implement real-time notifications
- [ ] Add offline mode
- [ ] Implement data caching
- [ ] Add biometric authentication
- [ ] Implement receipt printing
- [ ] Add barcode scanner

---

**Version:** 1.0.0  
**Last Updated:** 2024  
**Status:** ✅ Production Ready
