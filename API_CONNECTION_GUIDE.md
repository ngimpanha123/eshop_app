# API Connection Guide

## ✅ Fixed Issues

The dashboard API connection has been configured for Android development.

## 📱 Connection Setup

### For Android Emulator
```dart
baseUrl: 'http://10.0.2.2:9055/api/admin'
```
✅ Already configured in `lib/app/services/dashboard_service.dart`

### For Physical Android Device
Update to your computer's IP address:
```dart
baseUrl: 'http://192.168.1.XXX:9055/api/admin'  // Replace XXX with your IP
```

### For iOS Simulator
Use localhost (already works):
```dart
baseUrl: 'http://localhost:9055/api/admin'
```

---

## 🔧 Quick Setup Steps

### 1. Start Your API Server
Make sure your backend server is running on port **9055**

```bash
# Check if server is running
curl http://localhost:9055/api/admin/dashboard?today=2024-10-26
```

### 2. Find Your Computer's IP (for physical devices)

**Windows:**
```cmd
ipconfig
# Look for "IPv4 Address" under your active network adapter
```

**macOS/Linux:**
```bash
ifconfig | grep "inet "
# or
ip addr show
```

### 3. Update API URL (if using physical device)

Edit `lib/app/services/dashboard_service.dart`:
```dart
final Dio _dio = Dio(BaseOptions(
  baseUrl: 'http://YOUR_IP:9055/api/admin',  // Change this
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
));
```

---

## 🐛 Troubleshooting

### Error: "Connection refused"

**Possible causes:**
1. ❌ Backend server not running
2. ❌ Wrong IP address or port
3. ❌ Firewall blocking the connection
4. ❌ Using `localhost` on Android device

**Solutions:**
1. ✅ Start your backend server: `npm start` or equivalent
2. ✅ Verify server is accessible: `curl http://localhost:9055/api/admin/dashboard`
3. ✅ Check firewall settings (allow port 9055)
4. ✅ Use `10.0.2.2` for emulator or actual IP for device

### Error: "Timeout"

**Solutions:**
- Increase timeout in `dashboard_service.dart`:
```dart
connectTimeout: const Duration(seconds: 30),
receiveTimeout: const Duration(seconds: 30),
```

### Testing Connection

**From Android Emulator:**
```bash
# Open terminal in Android Studio
adb shell
curl http://10.0.2.2:9055/api/admin/dashboard?today=2024-10-26
```

**From Physical Device:**
```bash
# Replace with your IP
curl http://192.168.1.XXX:9055/api/admin/dashboard?today=2024-10-26
```

---

## 📋 Network Reference

| Environment | Base URL | Notes |
|-------------|----------|-------|
| Android Emulator | `http://10.0.2.2:9055` | Maps to host's localhost |
| iOS Simulator | `http://localhost:9055` | Direct localhost access |
| Physical Device (WiFi) | `http://192.168.x.x:9055` | Use computer's LAN IP |
| Production | `https://api.yourdomain.com` | Your production server |

---

## 🔐 CORS Configuration

If using web platform, ensure your backend allows CORS:

**Node.js/Express example:**
```javascript
app.use(cors({
  origin: '*', // Or specific origins
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
}));
```

---

## 📝 Current Configuration

- ✅ Base URL: `http://10.0.2.2:9055/api/admin`
- ✅ Timeout: 10 seconds
- ✅ Error handling: Enabled with retry
- ✅ Logger: Enabled for debugging

---

## 🎯 Next Steps

1. **Start your backend server** on port 9055
2. **Run the Flutter app** on Android emulator
3. **Navigate to Dashboard** tab
4. If error appears, click **Retry** button

The app will show a helpful error message if the connection fails!
