# Quick Start Guide - Dashboard Integration

## 🚀 Quick Setup (5 minutes)

### Step 1: Add Dashboard to Home Navigation

Update your `lib/app/modules/home/controllers/home_controller.dart`:

```dart
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../app_settings/views/app_settings_view.dart';
import '../../cart/views/cart_view.dart';
import '../../product/views/product_view.dart';
import '../../search_product/views/search_product_view.dart';
import '../../dashboard/views/dashboard_view.dart'; // ADD THIS

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  var lstRoutesName = [
    Routes.DASHBOARD,      // ADD THIS as first item
    Routes.PRODUCT,
    Routes.SEARCH_PRODUCT,
    Routes.CART,
    Routes.APP_SETTINGS,
  ];
  
  void onPageChange(int index){
    selectedIndex.value = index;
    Get.offAllNamed(lstRoutesName[index], id: 1);
  }
  
  Route? onGenerateRoute(RouteSettings settings) {
    // ADD THIS
    if(settings.name == Routes.DASHBOARD) {
      return GetPageRoute(
        settings: settings,
        page: () => const DashboardView(),
      );
    }
    
    if(settings.name == Routes.PRODUCT) {
      return GetPageRoute(
        settings: settings,
        page: () => const ProductView(),
      );
    }

    if(settings.name == Routes.SEARCH_PRODUCT) {
      return GetPageRoute(
        settings: settings,
        page: () => const SearchProductView(),
      );
    }

    if(settings.name == Routes.CART){
      return GetPageRoute(
        settings: settings,
        page: () => const CartView(),
      );
    }

    if(settings.name == Routes.APP_SETTINGS) {
      return GetPageRoute(
        settings: settings,
        page: () => const AppSettingsView(),
      );
    }

    return null;
  }
}
```

### Step 2: Update Home View Bottom Navigation

Update your `lib/app/modules/home/views/home_view.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        key: Get.nestedKey(1),
        initialRoute: Routes.DASHBOARD, // CHANGE THIS from Routes.PRODUCT
        onGenerateRoute: controller.onGenerateRoute,
      ),
      bottomNavigationBar: Obx(
        () {
          return BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.onPageChange,
            type: BottomNavigationBarType.fixed,
            items: const [ // UPDATE ITEMS
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'ទំព័រដើម', // Dashboard
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'ផលិតផល', // Products
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'ស្វែងរក', // Search
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'កន្រ្តក', // Cart
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'ការកំណត់', // Settings
              ),
            ],
          );
        }
      ),
    );
  }
}
```

### Step 3: Initialize Dashboard Service

Update your `lib/app/dependency_injection.dart`:

```dart
import 'package:get/get.dart';
// ... your other imports

import 'services/dashboard_service.dart'; // ADD THIS

class DependencyInjection {
  static void init() {
    // ADD THIS
    Get.put<DashboardService>(DashboardService(), permanent: true);
    
    // ... your other dependencies
  }
}
```

### Step 4: Update API Base URL

Edit `lib/app/services/dashboard_service.dart` and change the baseUrl:

```dart
final Dio _dio = Dio(BaseOptions(
  baseUrl: 'http://localhost:9055/api/admin', // Update to your API URL
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
));
```

### Step 5: Run the App

```bash
flutter pub get
flutter run
```

---

## 🎯 Direct Access (Without Bottom Navigation)

If you want to navigate directly to the dashboard from anywhere:

```dart
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

// From a button or any widget
ElevatedButton(
  onPressed: () {
    Get.toNamed(Routes.DASHBOARD);
  },
  child: const Text('Open Dashboard'),
)
```

---

## 🔧 Quick Customization

### Change Dashboard Initial Date
```dart
// In lib/app/modules/dashboard/controllers/dashboard_controller.dart
var selectedDate = DateTime.now().obs; // or any date
```

### Change Color Scheme
```dart
// In each widget file, update the color constants:
// statistic_card.dart
iconColor: const Color(0xFF5C6BC0), // Change to your primary color

// sales_bar_chart.dart
color: const Color(0xFF5C6BC0), // Bar color
```

### Add Loading Indicator Style
```dart
// In dashboard_view.dart, update the loading indicator
if (controller.isLoading.value) {
  return Center(
    child: CircularProgressIndicator(
      color: Colors.blue, // Your brand color
    ),
  );
}
```

---

## ✅ Verification Checklist

After integration, verify:

1. **Navigation Works**
   - [ ] Dashboard shows in bottom navigation
   - [ ] Tapping dashboard icon loads the view
   - [ ] Navigation between tabs works smoothly

2. **API Connection**
   - [ ] Open browser DevTools (F12)
   - [ ] Check Network tab for API calls
   - [ ] Verify 200 OK responses

3. **Data Display**
   - [ ] Statistics cards show numbers
   - [ ] Charts render correctly
   - [ ] Cashier list displays
   - [ ] No console errors

4. **Responsive Design**
   - [ ] Test on mobile size (< 768px)
   - [ ] Test on tablet/desktop (>= 768px)
   - [ ] Pull-to-refresh works on mobile

---

## 🐛 Common Issues & Solutions

### Issue: "DashboardService not found"
**Solution**: Make sure to initialize in `dependency_injection.dart`:
```dart
Get.put<DashboardService>(DashboardService(), permanent: true);
```

### Issue: "API 404 Error"
**Solution**: Check the base URL in `dashboard_service.dart` matches your server.

### Issue: Charts not displaying
**Solution**: 
1. Check console for errors
2. Verify API returns data in correct format
3. Ensure `fl_chart` package is installed: `flutter pub get`

### Issue: Khmer text shows as boxes
**Solution**: Add Khmer font to pubspec.yaml or use system fonts that support Khmer.

### Issue: "Bottom navigation not updating"
**Solution**: Make sure the index matches the order in `lstRoutesName` array.

---

## 📱 Test Data

If your API is not ready, you can test with mock data:

```dart
// In dashboard_controller.dart, modify fetchDashboardData():
Future<void> fetchDashboardData() async {
  isLoading.value = true;
  
  // MOCK DATA FOR TESTING
  statistic.value = Statistic(
    totalProduct: 18,
    totalProductType: 3,
    totalUser: 3,
    totalOrder: 101,
    total: 16000,
    totalPercentageIncrease: -99.73,
    saleIncreasePreviousDay: '-12037500',
  );
  
  salesData.value = SalesData(
    labels: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'],
    data: [0, 12053500, 16000, 0, 0, 0, 0],
  );
  
  productTypeData.value = ProductTypeData(
    labels: ['Food-Meat', 'Alcohol', 'Beverage'],
    data: [1, 5, 12],
  );
  
  cashierList.value = [
    CashierInfo(
      id: 1,
      name: 'ចាន់ សុវ៉ាន់ណេត',
      avatar: 'static/pos/user/avatar.png',
      totalAmount: 16000,
      percentageChange: '-99.62',
      role: [],
    ),
  ];
  
  isLoading.value = false;
}
```

---

## 🎉 You're Done!

Your dashboard should now be fully integrated and working. The dashboard will:
- ✅ Show real-time statistics
- ✅ Display beautiful charts
- ✅ Update on pull-to-refresh
- ✅ Adapt to different screen sizes
- ✅ Support Khmer language

For more details, see:
- `DASHBOARD_README.md` - Complete documentation
- `USAGE_EXAMPLE.dart` - Code examples
- `DASHBOARD_IMPLEMENTATION_SUMMARY.md` - Technical details
