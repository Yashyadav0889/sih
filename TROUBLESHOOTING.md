# 🔧 Troubleshooting Guide - "Failed to Fetch Data" Error

## 🚨 **Quick Fix Steps**

### **Step 1: Set Up Supabase (Most Common Issue)**

The "failed to fetch data" error usually means your Supabase database isn't configured properly.

1. **Create Supabase Project:**
   - Go to [supabase.com](https://supabase.com)
   - Sign up/Sign in
   - Click "New Project"
   - Choose organization and enter project details
   - Wait for project to be created (2-3 minutes)

2. **Get Your Credentials:**
   - Go to **Settings** → **API**
   - Copy your **Project URL** (looks like: `https://abcdefgh.supabase.co`)
   - Copy your **anon public key** (long string starting with `eyJ...`)

3. **Update .env File:**
   ```bash
   # Replace the placeholder values in .env with your actual credentials
   VITE_SUPABASE_URL=https://your-actual-project-id.supabase.co
   VITE_SUPABASE_ANON_KEY=your-actual-anon-key-here
   VITE_GEMINI_API_KEY=your-gemini-api-key-here
   ```

### **Step 2: Set Up Database Tables**

1. **Go to Supabase SQL Editor:**
   - In your Supabase dashboard, click **SQL Editor**
   - Click **New Query**

2. **Run Database Setup:**
   - Copy the entire content from `quick-database-setup.sql`
   - Paste it into the SQL editor
   - Click **Run** (or press Ctrl+Enter)
   - You should see "Database setup completed successfully!" message

### **Step 3: Test Your Connection**

1. **Open the test file:**
   - Open `test-database-connection.html` in your browser
   - Enter your Supabase URL and anon key
   - Click "Test Connection"
   - If successful, you'll see green success messages

2. **Restart Development Server:**
   ```bash
   # Stop the current server (Ctrl+C)
   # Then restart:
   npm run dev
   ```

## 🔍 **Common Error Messages & Solutions**

### **Error: "Failed to fetch"**
**Cause:** Invalid Supabase credentials or network issues
**Solution:** 
- Check your `.env` file has correct Supabase URL and key
- Ensure no extra spaces or quotes around the values
- Restart your dev server after changing `.env`

### **Error: "relation 'hospitals' does not exist"**
**Cause:** Database tables haven't been created
**Solution:** 
- Run the SQL script from `quick-database-setup.sql` in Supabase SQL Editor
- Make sure all tables are created successfully

### **Error: "Invalid API key"**
**Cause:** Wrong anon key or expired key
**Solution:** 
- Go to Supabase Settings → API
- Copy the **anon public key** (not the service role key)
- Update your `.env` file

### **Error: "Network request failed"**
**Cause:** CORS issues or network connectivity
**Solution:** 
- Check your internet connection
- Ensure Supabase project is active (not paused)
- Try refreshing the page

## 🧪 **Testing Each Component**

### **Test 1: Environment Variables**
```bash
# Check if your .env file is loaded correctly
echo $VITE_SUPABASE_URL
echo $VITE_SUPABASE_ANON_KEY
```

### **Test 2: Database Connection**
Use the `test-database-connection.html` file to verify:
- ✅ Connection to Supabase
- ✅ Database tables exist
- ✅ Sample data is loaded

### **Test 3: Application Login**
Try logging in with predefined accounts:
- Doctor: `WHNYJ64469870` / `Yash+-07@`
- Admin: `ADMIN64469870` / `Yash+-07@`

## 📋 **Complete Setup Checklist**

### **Supabase Setup:**
- [ ] Created Supabase project
- [ ] Copied project URL and anon key
- [ ] Updated `.env` file with real credentials
- [ ] Ran `quick-database-setup.sql` in SQL Editor
- [ ] Verified tables exist in Table Editor

### **User Accounts Setup:**
- [ ] Created predefined users in Authentication → Users
- [ ] Added user metadata (name, role) for each user
- [ ] Tested login with at least one account

### **Application Setup:**
- [ ] Installed dependencies (`npm install`)
- [ ] Environment variables loaded correctly
- [ ] Development server restarted
- [ ] No console errors in browser

## 🔧 **Advanced Troubleshooting**

### **Check Browser Console:**
1. Open browser Developer Tools (F12)
2. Go to Console tab
3. Look for error messages
4. Common errors and solutions:

```javascript
// Error: "Failed to fetch"
// Solution: Check network tab for failed requests

// Error: "Invalid JWT"
// Solution: Check if user is properly authenticated

// Error: "Permission denied"
// Solution: Check RLS policies in Supabase
```

### **Check Network Tab:**
1. Open Developer Tools → Network tab
2. Try to reproduce the error
3. Look for failed requests (red entries)
4. Check the response for error details

### **Supabase Dashboard Checks:**
1. **Authentication → Users:** Should show created users
2. **Table Editor:** Should show tables with data
3. **API Logs:** Check for recent requests and errors
4. **Settings → API:** Verify URL and keys are correct

## 🆘 **Still Having Issues?**

### **Quick Diagnostic Commands:**
```bash
# Check if environment variables are loaded
npm run dev
# Then in browser console:
console.log(import.meta.env.VITE_SUPABASE_URL)
console.log(import.meta.env.VITE_SUPABASE_ANON_KEY)
```

### **Reset Everything:**
If nothing works, try a complete reset:

1. **Delete .env file**
2. **Copy .env.example to .env**
3. **Add your real Supabase credentials**
4. **Delete node_modules and package-lock.json**
5. **Run `npm install` again**
6. **Run `npm run dev`**

### **Create Minimal Test:**
Create a simple test file to isolate the issue:

```html
<!-- test-minimal.html -->
<!DOCTYPE html>
<html>
<head>
    <title>Minimal Supabase Test</title>
</head>
<body>
    <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
    <script>
        const supabase = window.supabase.createClient(
            'YOUR_SUPABASE_URL',
            'YOUR_SUPABASE_ANON_KEY'
        );
        
        supabase.from('hospitals').select('*').limit(1)
            .then(result => {
                console.log('Success:', result);
                document.body.innerHTML = '<h1>✅ Connection Works!</h1>';
            })
            .catch(error => {
                console.error('Error:', error);
                document.body.innerHTML = '<h1>❌ Connection Failed</h1><p>' + error.message + '</p>';
            });
    </script>
</body>
</html>
```

## 📞 **Getting Help**

If you're still stuck:
1. Use the `test-database-connection.html` file to identify the exact issue
2. Check the browser console for specific error messages
3. Verify your Supabase project is active and not paused
4. Make sure you're using the correct credentials (anon key, not service role key)

The most common cause is missing or incorrect Supabase credentials in the `.env` file!
