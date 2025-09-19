# Setup Predefined User Accounts

## Overview
This document provides instructions for setting up the predefined user accounts in your Supabase project.

## Predefined User Accounts

### 1. Doctor Account
- **User ID**: WHNYJ64469870
- **Email**: doctor@healthplus.kerala.gov.in
- **Password**: Yash+-07@
- **Role**: doctor
- **Name**: Dr. Rajesh Kumar

### 2. Administrator Account
- **User ID**: ADMIN64469870
- **Email**: admin@healthplus.kerala.gov.in
- **Password**: Yash+-07@
- **Role**: admin
- **Name**: System Administrator

### 3. Government Official Account
- **User ID**: GOVT64469870
- **Email**: official@healthplus.kerala.gov.in
- **Password**: Yash+-07@
- **Role**: government
- **Name**: Government Official

### 4. Company Account
- **User ID**: COMP64469870
- **Email**: company@healthplus.kerala.gov.in
- **Password**: Yash+-07@
- **Role**: company
- **Name**: Company Representative

## Setup Instructions

### Method 1: Using Supabase Dashboard (Recommended)

1. **Go to your Supabase project dashboard**
2. **Navigate to Authentication > Users**
3. **Click "Add User" for each account**
4. **Fill in the details:**
   - Email: (use the email from above)
   - Password: Yash+-07@
   - Email Confirm: Yes (check the box)
   - User Metadata: Add the following JSON:
   ```json
   {
     "name": "Dr. Rajesh Kumar",
     "role": "doctor"
   }
   ```

### Method 2: Using Supabase API (Advanced)

You can also create these users programmatically using the Supabase Admin API:

```javascript
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'YOUR_SUPABASE_URL'
const supabaseServiceKey = 'YOUR_SERVICE_ROLE_KEY' // Use service role key, not anon key

const supabase = createClient(supabaseUrl, supabaseServiceKey, {
  auth: {
    autoRefreshToken: false,
    persistSession: false
  }
})

const predefinedUsers = [
  {
    email: 'doctor@healthplus.kerala.gov.in',
    password: 'Yash+-07@',
    user_metadata: {
      name: 'Dr. Rajesh Kumar',
      role: 'doctor'
    }
  },
  {
    email: 'admin@healthplus.kerala.gov.in',
    password: 'Yash+-07@',
    user_metadata: {
      name: 'System Administrator',
      role: 'admin'
    }
  },
  {
    email: 'official@healthplus.kerala.gov.in',
    password: 'Yash+-07@',
    user_metadata: {
      name: 'Government Official',
      role: 'government'
    }
  },
  {
    email: 'company@healthplus.kerala.gov.in',
    password: 'Yash+-07@',
    user_metadata: {
      name: 'Company Representative',
      role: 'company'
    }
  }
]

async function createPredefinedUsers() {
  for (const userData of predefinedUsers) {
    const { data, error } = await supabase.auth.admin.createUser({
      email: userData.email,
      password: userData.password,
      user_metadata: userData.user_metadata,
      email_confirm: true
    })
    
    if (error) {
      console.error(`Error creating user ${userData.email}:`, error)
    } else {
      console.log(`Successfully created user ${userData.email}`)
    }
  }
}

createPredefinedUsers()
```

### Method 3: Manual SQL Insert (Not Recommended)

If you need to insert users directly into the database (not recommended for production):

```sql
-- Note: This is for reference only. Use Supabase Auth methods instead.
-- These users should be created through Supabase Auth to ensure proper security.
```

## Verification

After creating the users, verify they work by:

1. **Testing Login**: Try logging in with each User ID and password
2. **Check User Metadata**: Ensure the role and name are correctly set
3. **Test Role-Based Access**: Verify each user can access their appropriate dashboard

## Security Notes

1. **Change Default Passwords**: In production, change these default passwords
2. **Use Strong Passwords**: The provided password meets complexity requirements
3. **Enable MFA**: Consider enabling multi-factor authentication for admin accounts
4. **Regular Audits**: Regularly audit user access and permissions

## Troubleshooting

### Common Issues:

1. **Email Already Exists**: If you get this error, the user might already exist
2. **Password Too Weak**: Ensure the password meets your security requirements
3. **Invalid Email**: Make sure the email format is correct
4. **Role Not Set**: Verify the user_metadata contains the correct role

### Solutions:

1. **Check Existing Users**: Look in Authentication > Users to see if the user already exists
2. **Update User Metadata**: You can edit existing users to add the correct metadata
3. **Reset Password**: Use the "Reset Password" function if needed

## Testing the Accounts

Once created, test each account:

1. **Go to the login page**
2. **Select the appropriate user type**
3. **Enter the User ID and password**
4. **Verify successful login and correct dashboard access**

Example test:
- User Type: Doctor
- User ID: WHNYJ64469870
- Password: Yash+-07@
- Expected Result: Login successful, redirect to doctor dashboard

## Next Steps

After setting up the predefined users:

1. **Update Documentation**: Document any changes to credentials
2. **Set Up Role-Based Permissions**: Ensure each role has appropriate database permissions
3. **Configure Dashboards**: Make sure each user type has access to their respective features
4. **Test All Functionality**: Verify all features work correctly for each user type

The predefined user accounts are now ready for use in your Digital Health Plus application!
