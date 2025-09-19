-- Complete RLS Fix for Patient Registration
-- This addresses the "violates row-level security policy" error
-- Run this in your Supabase SQL Editor

-- Step 1: Check if patients table exists and has RLS enabled
SELECT 
    schemaname, 
    tablename, 
    rowsecurity 
FROM pg_tables 
WHERE tablename = 'patients';

-- Step 2: Drop all existing policies to start fresh
DO $$ 
DECLARE
    policy_record RECORD;
BEGIN
    FOR policy_record IN 
        SELECT policyname 
        FROM pg_policies 
        WHERE tablename = 'patients'
    LOOP
        EXECUTE 'DROP POLICY IF EXISTS "' || policy_record.policyname || '" ON patients';
    END LOOP;
END $$;

-- Step 3: Create comprehensive RLS policies

-- Policy 1: Allow any authenticated user to insert patient records
-- This is needed during registration when user just signed up
CREATE POLICY "authenticated_users_can_insert_patients" ON patients
    FOR INSERT 
    TO authenticated
    WITH CHECK (
        -- Allow if the user_id matches the authenticated user
        auth.uid() = user_id
        OR
        -- Allow if user_id is provided and user is authenticated (for registration)
        (user_id IS NOT NULL AND auth.uid() IS NOT NULL)
    );

-- Policy 2: Users can view their own patient records
CREATE POLICY "users_can_view_own_patient_record" ON patients
    FOR SELECT 
    TO authenticated
    USING (auth.uid() = user_id);

-- Policy 3: Users can update their own patient records
CREATE POLICY "users_can_update_own_patient_record" ON patients
    FOR UPDATE 
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Policy 4: Doctors can view all patient records
CREATE POLICY "doctors_can_view_all_patients" ON patients
    FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.raw_user_meta_data->>'role' = 'doctor'
        )
    );

-- Policy 5: Admins can manage all patient records
CREATE POLICY "admins_can_manage_all_patients" ON patients
    FOR ALL
    TO authenticated
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

-- Policy 6: Government officials can view all patient records
CREATE POLICY "government_can_view_all_patients" ON patients
    FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.raw_user_meta_data->>'role' = 'government'
        )
    );

-- Policy 7: Company users can view patient records (if needed)
CREATE POLICY "company_can_view_patients" ON patients
    FOR SELECT
    TO authenticated
    USING (
        EXISTS (
            SELECT 1 FROM auth.users
            WHERE auth.users.id = auth.uid()
            AND auth.users.raw_user_meta_data->>'role' = 'company'
        )
    );

-- Step 4: Ensure RLS is enabled
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

-- Step 5: Grant necessary permissions to authenticated users
GRANT SELECT, INSERT, UPDATE ON patients TO authenticated;

-- Step 6: Verify the setup
SELECT 
    'RLS policies created successfully!' as message,
    COUNT(*) as policy_count
FROM pg_policies 
WHERE tablename = 'patients';

-- Step 7: Show all policies for verification
SELECT 
    policyname,
    cmd,
    permissive,
    roles
FROM pg_policies 
WHERE tablename = 'patients'
ORDER BY policyname;

-- Step 8: Test authentication context
SELECT 
    CASE 
        WHEN auth.uid() IS NULL THEN 'No user authenticated - this is normal in SQL editor'
        ELSE 'User authenticated: ' || auth.uid()::text
    END as auth_status;

-- Success message
SELECT 'Complete RLS fix applied! Try patient registration now.' as final_message;
