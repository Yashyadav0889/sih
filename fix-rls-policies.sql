-- Fix Row Level Security Policies for Patients Table
-- Run this in your Supabase SQL Editor

-- First, let's check current policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd, qual 
FROM pg_policies 
WHERE tablename = 'patients';

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Users can insert their own patient record" ON patients;
DROP POLICY IF EXISTS "Users can view their own patient record" ON patients;
DROP POLICY IF EXISTS "Users can update their own patient record" ON patients;
DROP POLICY IF EXISTS "Doctors can view all patient records" ON patients;
DROP POLICY IF EXISTS "Admins can manage all patient records" ON patients;

-- Create new RLS policies for patients table

-- 1. Allow users to insert their own patient record
CREATE POLICY "Users can insert their own patient record" ON patients
    FOR INSERT 
    WITH CHECK (auth.uid() = user_id);

-- 2. Allow users to view their own patient record
CREATE POLICY "Users can view their own patient record" ON patients
    FOR SELECT 
    USING (auth.uid() = user_id);

-- 3. Allow users to update their own patient record
CREATE POLICY "Users can update their own patient record" ON patients
    FOR UPDATE 
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- 4. Allow doctors to view all patient records
CREATE POLICY "Doctors can view all patient records" ON patients
    FOR SELECT 
    USING (
        EXISTS (
            SELECT 1 FROM auth.users 
            WHERE auth.users.id = auth.uid() 
            AND auth.users.raw_user_meta_data->>'role' = 'doctor'
        )
    );

-- 5. Allow admins to manage all patient records
CREATE POLICY "Admins can manage all patient records" ON patients
    FOR ALL 
    USING (
        EXISTS (
            SELECT 1 FROM auth.users 
            WHERE auth.users.id = auth.uid() 
            AND auth.users.raw_user_meta_data->>'role' = 'admin'
        )
    )
    WITH CHECK (
        EXISTS (
            SELECT 1 FROM auth.users 
            WHERE auth.users.id = auth.uid() 
            AND auth.users.raw_user_meta_data->>'role' = 'admin'
        )
    );

-- 6. Allow government officials to view all patient records
CREATE POLICY "Government can view all patient records" ON patients
    FOR SELECT 
    USING (
        EXISTS (
            SELECT 1 FROM auth.users 
            WHERE auth.users.id = auth.uid() 
            AND auth.users.raw_user_meta_data->>'role' = 'government'
        )
    );

-- Ensure RLS is enabled on the patients table
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

-- Verify the policies were created
SELECT schemaname, tablename, policyname, permissive, roles, cmd 
FROM pg_policies 
WHERE tablename = 'patients'
ORDER BY policyname;

-- Test policy by checking if current user can access
SELECT 
    'RLS policies updated successfully!' as message,
    'Users can now insert their own patient records' as note;

-- Show the auth.uid() function for debugging
SELECT 
    auth.uid() as current_user_id,
    CASE 
        WHEN auth.uid() IS NULL THEN 'No authenticated user'
        ELSE 'User is authenticated'
    END as auth_status;
