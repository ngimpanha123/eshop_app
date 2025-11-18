# 📐 Reports Module - Architecture & Flow Diagram

## 🏗️ Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                         REPORTS MODULE                           │
└─────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │   ReportsBinding       │
                    │  (Dependency Inject)   │
                    └────────────────────────┘
                                 │
                                 ▼
                    ┌────────────────────────┐
                    │  ReportsController     │
                    │  - Role Detection      │
                    │  - Date Management     │
                    │  - API Calls           │
                    └────────────────────────┘
                                 │
                ┌────────────────┴────────────────┐
                ▼                                  ▼
    ┌─────────────────────┐          ┌─────────────────────┐
    │   ReportsView       │          │   ReportsView       │
    │   (Role Router)     │◄────────►│   (Role Router)     │
    └─────────────────────┘          └─────────────────────┘
                │                                  │
        ┌───────┴───────┐                  ┌──────┴──────┐
        ▼               ▼                  ▼              ▼
┌──────────────┐  ┌──────────────┐  ┌──────────┐  ┌──────────┐
│ Admin View   │  │ Cashier View │  │ Loading  │  │  Error   │
│ (Full Access)│  │ (Limited)    │  │  State   │  │  State   │
└──────────────┘  └──────────────┘  └──────────┘  └──────────┘
        │                  │
        └──────────┬───────┘
                   ▼
         ┌─────────────────┐
         │ Shared Widgets  │
         │ (Components)    │
         └─────────────────┘
                   │
    ┌──────────────┼──────────────┐
    ▼              ▼               ▼
┌────────┐  ┌──────────┐  ┌────────────┐
│ Report │  │   Date   │  │   Preset   │
│  Type  │  │  Range   │  │   Ranges   │
│Selector│  │ Selector │  │            │
└────────┘  └──────────┘  └────────────┘
    ▼              ▼               ▼
┌────────┐  ┌──────────┐
│Generate│  │   PDF    │
│ Button │  │  Dialog  │
└────────┘  └──────────┘
```

---

## 🔄 User Flow Diagram

### Admin User Flow:
```
┌─────────────┐
│   User      │
│  (Admin)    │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│ Click Reports   │
└──────┬──────────┘
       │
       ▼
┌─────────────────────────┐
│ ReportsController       │
│ - Detect Role           │
│ - isAdmin = true ✅     │
└──────┬──────────────────┘
       │
       ▼
┌─────────────────────────┐
│ Show AdminReportsView   │
│ - 3 Report Types        │
│ - Full Features         │
└──────┬──────────────────┘
       │
       ├─────► Select Report Type
       │       (Sale/Cashier/Product)
       │
       ├─────► Select Date Range
       │       (Start & End)
       │
       ├─────► Optional: Quick Preset
       │       (Today/Week/Month)
       │
       ▼
┌─────────────────────────┐
│ Click Generate Report   │
└──────┬──────────────────┘
       │
       ▼
┌─────────────────────────┐
│ API Call                │
│ - generateSaleReport()  │
│ - OR generateCashier()  │
│ - OR generateProduct()  │
└──────┬──────────────────┘
       │
       ├─────► Success ✅
       │       │
       │       ▼
       │   ┌────────────────┐
       │   │ Show PDF Dialog│
       │   │ - Share        │
       │   │ - Download     │
       │   └────────────────┘
       │
       └─────► Error ❌
               │
               ▼
           ┌────────────────┐
           │ Show Error Msg │
           └────────────────┘
```

### Cashier User Flow:
```
┌─────────────┐
│   User      │
│  (Cashier)  │
└──────┬──────┘
       │
       ▼
┌─────────────────┐
│ Click Reports   │
└──────┬──────────┘
       │
       ▼
┌─────────────────────────┐
│ ReportsController       │
│ - Detect Role           │
│ - isAdmin = false ✅    │
└──────┬──────────────────┘
       │
       ▼
┌─────────────────────────┐
│ Show CashierReportsView │
│ - Sale Report Only 🔒   │
│ - Limited Features      │
└──────┬──────────────────┘
       │
       ├─────► Fixed: Sale Report
       │       (Cannot change ❌)
       │
       ├─────► Select Date Range
       │       (Start & End)
       │
       ├─────► Optional: Quick Preset
       │       (Today/Week/Month)
       │
       ▼
┌─────────────────────────┐
│ Click Generate Report   │
└──────┬──────────────────┘
       │
       ▼
┌─────────────────────────┐
│ API Call                │
│ - generateSaleReport()  │
│   (Only this one)       │
└──────┬──────────────────┘
       │
       ├─────► Success ✅
       │       │
       │       ▼
       │   ┌────────────────┐
       │   │ Show PDF Dialog│
       │   │ - Share        │
       │   │ - Download     │
       │   └────────────────┘
       │
       └─────► Error ❌
               │
               ▼
           ┌────────────────┐
           │ Show Error Msg │
           └────────────────┘
```

---

## 🎯 Component Interaction Flow

```
┌────────────────────────────────────────────────┐
│           AdminReportsView / CashierReportsView│
└────────────┬───────────────────────────────────┘
             │
   ┌─────────┼─────────┬──────────┬──────────┐
   │         │         │          │          │
   ▼         ▼         ▼          ▼          ▼
┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐
│Report│ │ Date │ │Preset│ │Button│ │Dialog│
│ Type │ │Range │ │Range │ │      │ │      │
└───┬──┘ └───┬──┘ └───┬──┘ └───┬──┘ └───┬──┘
    │        │        │        │        │
    │        │        │        │        │
    └────────┴────────┴────────┴────────┘
                     │
                     ▼
            ┌────────────────┐
            │ ReportsController│
            │  - State Mgmt  │
            │  - API Calls   │
            └────────┬───────┘
                     │
                     ▼
            ┌────────────────┐
            │  API Provider  │
            │  - HTTP Calls  │
            └────────┬───────┘
                     │
                     ▼
            ┌────────────────┐
            │   Backend API  │
            │  - Generate PDF│
            └────────────────┘
```

---

## 📦 Data Flow

### 1. Role Detection Flow:
```
User Opens Reports
        ↓
ReportsController.onInit()
        ↓
_detectUserRole()
        ↓
┌─────────────────────┐
│ Check User Profile  │
│ (Future API Call)   │
└──────────┬──────────┘
           │
    ┌──────┴──────┐
    ▼             ▼
[Admin]      [Cashier]
    │             │
    └──────┬──────┘
           ▼
   isAdmin.value set
           ↓
   Route to View
```

### 2. Report Generation Flow:
```
User Clicks "Generate Report"
        ↓
Validate Dates
        ↓
┌─────────────────┐
│ Show Loading    │
│ isLoading=true  │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│ API Call                │
│ - generateSaleReport()  │
│ - OR Other Reports      │
└────────┬────────────────┘
         │
    ┌────┴────┐
    ▼         ▼
[Success]  [Error]
    │         │
    │         └──► Show Error Message
    │               isLoading=false
    │
    ▼
┌─────────────────┐
│ Receive PDF     │
│ (Base64 String) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Show PDF Dialog │
│ - Display Info  │
│ - Share/Download│
└─────────────────┘
         ↓
   isLoading=false
```

### 3. Date Selection Flow:
```
User Taps Date Field
        ↓
┌─────────────────┐
│ Show DatePicker │
│ (Material UI)   │
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
[Cancel]   [Select]
    │         │
    │         ▼
    │   ┌──────────────┐
    │   │ Update State │
    │   │ dateRx.value │
    │   └──────┬───────┘
    │          │
    └──────────┤
               ▼
        Validate Range
               ↓
        Update UI
```

---

## 🔧 State Management

### Controller State:
```dart
ReportsController {
  // Role Management
  isLoadingRole: RxBool        // Loading role detection
  isAdmin: RxBool              // User is admin?
  
  // Report Generation
  isLoading: RxBool            // Generating report?
  hasError: RxBool             // Has error?
  errorMessage: RxString       // Error details
  
  // Date Selection
  selectedStartDate: Rx<DateTime?>
  selectedEndDate: Rx<DateTime?>
  
  // Report Type
  selectedReportType: RxString // 'sale'|'cashier'|'product'
}
```

### State Transitions:
```
Initial State:
  isLoadingRole: true
  isLoading: false
  hasError: false
           ↓
Role Detected:
  isLoadingRole: false
  isAdmin: true/false
           ↓
Generating Report:
  isLoading: true
  hasError: false
           ↓
Report Success:
  isLoading: false
  hasError: false
  [Show PDF Dialog]
           OR
Report Error:
  isLoading: false
  hasError: true
  errorMessage: "..."
```

---

## 🎨 UI Component Hierarchy

```
ReportsView (Router)
│
├── AdminReportsView
│   ├── AppBar
│   │   ├── Title: "Admin Reports"
│   │   └── Info Button
│   │
│   ├── RefreshIndicator
│   │   └── SingleChildScrollView
│   │       ├── HeaderCard
│   │       │   ├── Admin Icon
│   │       │   ├── Title & Subtitle
│   │       │   └── Permission Badge
│   │       │
│   │       ├── ReportTypeSelector
│   │       │   └── 3 Choice Chips
│   │       │       ├── Sale Report ✅
│   │       │       ├── Cashier Report ✅
│   │       │       └── Product Report ✅
│   │       │
│   │       ├── DateRangeSelector
│   │       │   ├── Start Date Field
│   │       │   └── End Date Field
│   │       │
│   │       ├── PresetRanges
│   │       │   └── Quick Select Buttons
│   │       │       ├── Today
│   │       │       ├── Yesterday
│   │       │       ├── This Week
│   │       │       ├── Last Week
│   │       │       ├── This Month
│   │       │       └── Last Month
│   │       │
│   │       └── GenerateReportButton
│   │
│   └── Info Dialog (on demand)
│
└── CashierReportsView
    ├── AppBar
    │   └── Title: "My Sales Reports"
    │
    ├── RefreshIndicator
    │   └── SingleChildScrollView
    │       ├── HeaderCard
    │       │   ├── Receipt Icon
    │       │   └── Title & Subtitle
    │       │
    │       ├── ReportTypeInfo
    │       │   └── Fixed: Sale Report 🔒
    │       │
    │       ├── DateRangeSelector
    │       │   ├── Start Date Field
    │       │   └── End Date Field
    │       │
    │       ├── PresetRanges
    │       │   └── Quick Select Buttons
    │       │
    │       ├── GenerateReportButton
    │       │
    │       └── InfoCard
    │           └── Cashier Access Message
    │
    └── (No Info Dialog - fixed report type)
```

---

## 🔐 Security Architecture

```
┌─────────────────────────────────────────┐
│          Security Layers                 │
└─────────────────────────────────────────┘

Layer 1: UI-Level Access Control
├── ReportsView (Role Router)
│   ├── Admin → AdminReportsView ✅
│   └── Cashier → CashierReportsView ✅
│
Layer 2: Controller-Level Validation
├── Role Detection (Backend)
├── Safe Defaults (Cashier on error)
└── API Token Authentication
│
Layer 3: API-Level Authorization
├── Backend validates user role
├── Token-based authentication
└── Endpoint-specific permissions
│
Layer 4: Data Protection
├── No sensitive data in UI state
├── PDF data handled securely
└── Proper error messages (no stack traces)
```

---

## 📊 Performance Optimization

### 1. Lazy Loading:
```
ReportsView (33 lines) → Lightweight Router
        ↓
[Role Detected]
        ↓
Load appropriate view (Admin OR Cashier)
        ↓
Components loaded on demand
```

### 2. Widget Reusability:
```
Shared Components:
├── DateRangeSelector (used by both views)
├── PresetRanges (used by both views)
├── GenerateReportButton (used by both views)
└── ReportPdfDialog (used by both views)

Benefits:
✅ Reduced build time
✅ Smaller widget tree
✅ Memory efficient
```

### 3. State Management:
```
Obx (Reactive Widgets):
├── Only rebuild when state changes
├── Minimal widget rebuilds
└── Efficient reactivity

Local Variables:
├── Store computed values
├── Prevent excessive getter calls
└── Avoid GetX warnings
```

---

## 🧪 Testing Strategy

### Unit Tests:
```
ReportsController Tests:
├── Role detection logic
├── Date validation
├── Report generation
├── Error handling
└── State transitions
```

### Widget Tests:
```
Component Tests:
├── ReportTypeSelector
├── DateRangeSelector
├── PresetRanges
├── GenerateReportButton
└── ReportPdfDialog
```

### Integration Tests:
```
Flow Tests:
├── Admin report generation
├── Cashier report generation
├── Role-based routing
└── Error scenarios
```

---

## 📱 Responsive Design

```
Mobile (< 600dp):
├── Single column layout
├── Full-width components
└── Touch-optimized controls

Tablet (600-840dp):
├── Optimized spacing
├── Larger touch targets
└── Better use of space

Desktop (> 840dp):
├── Max-width containers
├── Multi-column layouts
└── Enhanced interactions
```

---

## 🔄 Data Sync Flow

```
┌─────────────────────┐
│   User Action       │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Controller        │
│   (State Update)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   API Provider      │
│   (HTTP Request)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Backend API       │
│   (Process Request) │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Response          │
│   (JSON/PDF Data)   │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   Controller        │
│   (Update State)    │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│   UI Update         │
│   (Obx Rebuild)     │
└─────────────────────┘
```

---

## 🎯 Summary

### Architecture Highlights:
✅ **Role-Based Routing**: Automatic view selection
✅ **Component Reusability**: 5 shared widgets
✅ **Clean Separation**: Controllers, Views, Components
✅ **Security Layers**: Multi-level access control
✅ **Performance**: Optimized for mobile
✅ **Maintainability**: Well-organized codebase
✅ **Scalability**: Easy to add new features

### Key Design Patterns:
- **Router Pattern**: ReportsView as entry point
- **Component Pattern**: Reusable UI widgets
- **Observer Pattern**: GetX reactive state
- **Factory Pattern**: Component creation
- **Strategy Pattern**: Different report generators

---

**Version**: 2.0.0  
**Architecture**: Clean & Modular  
**Status**: ✅ Production Ready
