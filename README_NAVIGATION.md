# 🎯 POS App - Quick Navigation Guide

## 🚀 Quick Start

### Run the App
```bash
flutter run
```

### Login Credentials
- **Phone:** `0963919745`
- **Password:** `123456`

---

## 📱 Bottom Navigation (5 Main Tabs)

After login, you'll see 5 tabs at the bottom of the screen:

### 1. 📊 Dashboard
- View sales statistics
- See revenue charts
- Monitor cashier performance
- Track product analytics

### 2. 🛒 New Order
- Browse products by category
- Add items to cart with quantity
- View cart total in real-time
- Place orders with confirmation

### 3. 📝 My Sales
- View your personal sales history
- See sale details with products
- Print/download invoices
- Delete sales (if permitted)
- Pagination support

### 4. 📈 Reports
- Generate PDF reports:
  - **Sale Report** - Sales summary
  - **Cashier Report** - Performance report
  - **Product Report** - Product analytics
- Select date ranges
- Use quick presets (Today, This Week, This Month, etc.)
- Download/share reports

### 5. 👤 Profile
- View profile information
- Edit profile (name, phone, email)
- Change password
- View activity logs
- Switch roles
- Logout

---

## ☰ Navigation Drawer (Additional Features)

**Access:** Tap the hamburger icon (☰) on the Dashboard

### Main Section
- Dashboard
- New Order
- My Sales

### Admin Section
- **All Sales** - View and manage all sales across all cashiers
- **Products** - Browse all products
- **Manage Products** - Add, edit, delete products
- **Users** - Manage user accounts

### Tools Section
- Reports
- Search Products
- Settings

---

## 🎨 UI Features

### Modern Design
- ✅ Clean light blue login screen with decorative circles
- ✅ Dark theme for main app (easy on eyes)
- ✅ Gradient buttons with shadows
- ✅ Smooth animations
- ✅ Card-based layouts
- ✅ Modern icons and badges

### User Experience
- ✅ Pull-to-refresh on lists
- ✅ Loading indicators
- ✅ Empty state messages
- ✅ Error handling with retry
- ✅ Confirmation dialogs
- ✅ Toast notifications
- ✅ Platform badges (Web/Mobile)

---

## 📂 Folder Structure (Clean & Organized)

```
lib/app/modules/
├── home/              # Main container with bottom navigation
│   └── widgets/
│       └── app_drawer.dart    # Navigation drawer
│
├── login/             # Authentication
├── dashboard/         # Tab 1 - Analytics
├── cashier_order/     # Tab 2 - Create orders
├── cashier_sales/     # Tab 3 - Personal sales
├── reports/           # Tab 4 - Generate reports
├── profile/           # Tab 5 - User profile
│
├── admin_sales/       # Admin: All sales
├── admin_product/     # Admin: Manage products
├── admin_user/        # Admin: Manage users
├── product/           # Browse products
├── search_product/    # Search functionality
└── app_settings/      # App settings
```

---

## 🔄 Navigation Flow

### Bottom Navigation
Tap any of the 5 icons at the bottom to switch between main features:
```
Dashboard → New Order → My Sales → Reports → Profile
```

### Drawer Menu
1. Tap the ☰ icon (top-left of Dashboard)
2. Select any menu item
3. Screen will navigate to that feature

### Back Navigation
- **Android:** Use back button
- **iOS:** Swipe from left edge
- **Both:** Use back arrow in AppBar

---

## 🎯 Common Tasks

### Place an Order
1. Tap **New Order** (bottom tab)
2. Select product category (tabs at top)
3. Tap products to add to cart
4. Use +/- to adjust quantities
5. Tap **Place Order** button
6. Confirm and submit

### View Sales
1. Tap **My Sales** (bottom tab)
2. See all your sales in list
3. Tap any sale to see details
4. Use Print button for invoice

### Generate Report
1. Tap **Reports** (bottom tab)
2. Select report type (Sale/Cashier/Product)
3. Choose date range
4. Tap **Generate Report**
5. Download or share PDF

### Update Profile
1. Tap **Profile** (bottom tab)
2. Tap **Edit Profile**
3. Update information
4. Tap **Save**

### Change Password
1. Tap **Profile** (bottom tab)
2. Tap **Change Password**
3. Enter new password
4. Tap **Update**

---

## 🔐 Security

### Token Storage
- Secure token storage using FlutterSecureStorage
- Auto-logout on token expiration
- Protected API endpoints

### Logout
1. Tap **Profile** tab
2. Tap **Logout** icon (top-right)
3. Or use drawer menu → **Logout**
4. Confirm logout

---

## 🛠️ Technical Details

### State Management
- **GetX** for reactive state management
- All controllers pre-initialized
- Persistent state across tab switches

### API Integration
- Centralized API provider
- Automatic token injection
- Error handling and retry logic

### Theme
- **Dark Mode** by default
- Consistent design system
- Modern Material 3 components

---

## 📞 Support

### Issues?
1. Check API base URL in `app_config.dart`
2. Verify login credentials
3. Check network connection
4. Review error messages

### Need Help?
- See `PROJECT_STRUCTURE.md` for detailed structure
- See `API_IMPLEMENTATION_SUMMARY.md` for API details
- Check console logs for errors

---

## ✅ Quick Checklist

- [ ] Login successful
- [ ] Can see dashboard
- [ ] Bottom navigation works (5 tabs)
- [ ] Drawer menu opens
- [ ] Can place an order
- [ ] Can view sales
- [ ] Can generate reports
- [ ] Profile loads correctly
- [ ] Logout works

---

**Enjoy your modern POS system! 🎉**
