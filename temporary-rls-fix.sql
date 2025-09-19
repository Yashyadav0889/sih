-- Temporary RLS Fix for Patient Registration
-- This allows any authenticated user to insert patient records
-- Run this if the main RLS fix doesn't work

-- Option 1: Temporarily disable RLS on patients table (for testing only)
-- ALTER TABLE patients DISABLE ROW LEVEL SECURITY;

-- Option 2: Create a permissive policy for authenticated users
DROP POLICY IF EXISTS "Allow authenticated users to insert patients" ON patients;

CREATE POLICY "Allow authenticated users to insert patients" ON patients
    FOR INSERT 
    TO authenticated
    WITH CHECK (true);

-- Also allow authenticated users to select their own records
DROP POLICY IF EXISTS "Allow authenticated users to select their patients" ON patients;

CREATE POLICY "Allow authenticated users to select their patients" ON patients
    FOR SELECT 
    TO authenticated
    USING (auth.uid() = user_id);

-- Verify RLS is still enabled
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

-- Check the policies
SELECT schemaname, tablename, policyname, permissive, roles, cmd 
FROM pg_policies 
WHERE tablename = 'patients'
ORDER BY policyname;

-- Test message
SELECT 'Temporary RLS policies created for patient registration' as message;
