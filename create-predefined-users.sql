-- Create Predefined Users for Digital Health Plus
-- Run this in your Supabase SQL Editor AFTER setting up the database tables

-- Note: This creates users directly in the auth.users table
-- You may need to use the Supabase dashboard Authentication > Users instead
-- This is provided as a reference for the user structure

-- Insert predefined users into auth.users table
-- WARNING: This approach may not work due to Supabase security restrictions
-- Use the Supabase Dashboard Authentication > Users interface instead

-- The users should be created with these details:

/*
DOCTOR ACCOUNT:
Email: doctor@healthplus.kerala.gov.in
Password: Yash+-07@
User Metadata: {"name": "Dr. Rajesh Kumar", "role": "doctor"}

ADMINISTRATOR ACCOUNT:
Email: admin@healthplus.kerala.gov.in
Password: Yash+-07@
User Metadata: {"name": "System Administrator", "role": "admin"}

GOVERNMENT OFFICIAL ACCOUNT:
Email: official@healthplus.kerala.gov.in
Password: Yash+-07@
User Metadata: {"name": "Government Official", "role": "government"}

COMPANY ACCOUNT:
Email: company@healthplus.kerala.gov.in
Password: Yash+-07@
User Metadata: {"name": "Company Representative", "role": "company"}
*/

-- Instead, use the Supabase Dashboard:
-- 1. Go to Authentication > Users
-- 2. Click "Add User" for each account
-- 3. Fill in the email and password
-- 4. Check "Email Confirm"
-- 5. Add the user metadata JSON for each user

-- After creating the users, you can verify they exist:
SELECT 
    id,
    email,
    user_metadata->>'name' as name,
    user_metadata->>'role' as role,
    created_at,
    email_confirmed_at
FROM auth.users 
WHERE email IN (
    'doctor@healthplus.kerala.gov.in',
    'admin@healthplus.kerala.gov.in',
    'official@healthplus.kerala.gov.in',
    'company@healthplus.kerala.gov.in'
);

-- This query should return 4 rows if all users are created successfully
