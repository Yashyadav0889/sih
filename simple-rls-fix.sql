-- Simple RLS Fix for Patient Registration
-- This focuses only on allowing patient registration to work
-- Run this in your Supabase SQL Editor

-- Step 1: Drop all existing policies to start fresh
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

-- Step 2: Create simple policies that work

-- Policy 1: Allow authenticated users to insert patient records
-- This is the key policy needed for registration
CREATE POLICY "allow_patient_registration" ON patients
    FOR INSERT 
    TO authenticated
    WITH CHECK (true);  -- Allow any authenticated user to insert

-- Policy 2: Allow users to view their own patient records
CREATE POLICY "users_view_own_records" ON patients
    FOR SELECT 
    TO authenticated
    USING (auth.uid() = user_id);

-- Policy 3: Allow users to update their own patient records
CREATE POLICY "users_update_own_records" ON patients
    FOR UPDATE 
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Step 3: Ensure RLS is enabled
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

-- Step 4: Grant necessary permissions
GRANT SELECT, INSERT, UPDATE ON patients TO authenticated;

-- Step 5: Verify the setup
SELECT 
    'Simple RLS policies created!' as message,
    COUNT(*) as policy_count
FROM pg_policies 
WHERE tablename = 'patients';

-- Show the policies
SELECT 
    policyname,
    cmd,
    permissive
FROM pg_policies 
WHERE tablename = 'patients'
ORDER BY policyname;

-- Success message
SELECT 'Patient registration should now work!' as final_message;
