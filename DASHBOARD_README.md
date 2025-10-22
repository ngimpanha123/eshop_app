# Dashboard Module

This dashboard provides a comprehensive view of your POS system statistics, sales data, cashier performance, and product type distribution.

## Features

### 📊 Statistics Overview
- Total Products
- Total Product Types
- Total Users
- Total Orders

### 💰 Sales Revenue Card
- Current day's total sales
- Percentage change compared to previous day
- Previous day's sale amount

### 👥 Cashier Performance
- Semi-circular gauge chart showing cashier contributions
- Individual cashier performance with percentage changes
- Total sales amount per cashier

### 📦 Product Type Distribution
- Donut chart showing product type breakdown
- Total count per product type
- Visual representation with color-coded categories

### 📈 Sales Data Chart
- Bar chart showing sales for each day of the week
- Khmer day labels
- Interactive tooltips with exact values

## Navigation

To navigate to the dashboard from any screen:

```dart
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';

// Navigate to dashboard
Get.toNamed(Routes.DASHBOARD);
```

## API Endpoints Used

The dashboard consumes the following API endpoints:

1. **Main Dashboard Data**
   - Endpoint: `GET /api/admin/dashboard?today=YYYY-MM-DD`
   - Returns: Statistics, sales data, product types, and cashier data

2. **Cashier Data**
   - Endpoint: `GET /api/admin/dashboard/cashier?today=YYYY-MM-DD`
   - Returns: List of cashiers with performance metrics

3. **Product Type Data**
   - Endpoint: `GET /api/admin/dashboard/product-type?thisMonth=YYYY-MM-DD`
   - Returns: Product type labels and counts

4. **Sales Data**
   - Endpoint: `GET /api/admin/dashboard/data-sale`
   - Returns: Weekly sales data with day labels

## Configuration

### Base URL
Update the base URL in `lib/app/services/dashboard_service.dart`:

```dart
final Dio _dio = Dio(BaseOptions(
  baseUrl: 'http://your-api-url.com/api/admin', // Change this
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
));
```

### Date Format
The dashboard uses the current date by default. To change the date:

```dart
// In the dashboard controller
controller.changeDate(DateTime(2024, 10, 26));
```

## Responsive Design

The dashboard automatically adapts to different screen sizes:
- **Mobile (< 768px)**: Single column layout with stacked cards
- **Desktop (>= 768px)**: Two-column grid layout with side-by-side charts

## Usage Example

### Adding Dashboard to Bottom Navigation

```dart
// In your home controller
void navigateToDashboard() {
  Get.toNamed(Routes.DASHBOARD);
}
```

### Refreshing Dashboard Data

The dashboard supports pull-to-refresh on mobile:

```dart
// The controller's fetchDashboardData method is called
// Users can pull down on mobile to refresh the data
```

### Manual Refresh

```dart
final controller = Get.find<DashboardController>();
controller.fetchDashboardData();
```

## Customization

### Colors
Modify colors in the widget files:
- Statistics cards: `lib/app/modules/dashboard/views/widgets/statistic_card.dart`
- Charts: Update the `_getColor()` methods in respective chart widgets

### Chart Types
The dashboard uses `fl_chart` package. You can customize:
- Pie/Donut charts for product types and cashier performance
- Bar charts for sales data

### Khmer Language
All labels are in Khmer. To change to another language, update the text strings in:
- Dashboard view
- Widget files
- Sales bar chart day labels

## Dependencies

```yaml
dependencies:
  fl_chart: ^0.69.0  # For charts
  intl: ^0.19.0      # For number formatting
  dio: ^5.7.0        # For API calls
  get: ^4.7.2        # For state management
```

## Screenshots Reference

The dashboard follows the design patterns from:
- Mobile view: Clean card-based layout with statistics at top
- Desktop view: Two-column layout with header and user info

## Troubleshooting

### API Connection Issues
- Verify the base URL is correct
- Check network connectivity
- Ensure API endpoints are accessible
- Review CORS settings if accessing from web

### Data Not Showing
- Check API response format matches the models
- Verify date parameters are in correct format (YYYY-MM-DD)
- Check console logs for any errors

### Chart Display Issues
- Ensure data is not null
- Verify data arrays have matching lengths (labels and values)
- Check if chart constraints have proper sizing
