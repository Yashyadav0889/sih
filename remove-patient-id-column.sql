-- Remove patient_id column since we're using user_id as the patient identifier
-- Run this in your Supabase SQL Editor

-- Check if the column exists and remove it
DO $$ 
BEGIN
    -- Remove patient_id column if it exists
    IF EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'patients' 
        AND column_name = 'patient_id'
    ) THEN
        -- Drop the unique constraint first if it exists
        IF EXISTS (
            SELECT 1 
            FROM information_schema.table_constraints 
            WHERE table_name = 'patients' 
            AND constraint_type = 'UNIQUE'
            AND constraint_name LIKE '%patient_id%'
        ) THEN
            ALTER TABLE patients DROP CONSTRAINT IF EXISTS patients_patient_id_key;
        END IF;
        
        -- Drop the index if it exists
        DROP INDEX IF EXISTS idx_patients_patient_id;
        
        -- Drop the column
        ALTER TABLE patients DROP COLUMN patient_id;
        
        RAISE NOTICE 'Removed patient_id column from patients table';
    ELSE
        RAISE NOTICE 'patient_id column does not exist';
    END IF;
END $$;

-- Verify the column was removed
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'patients' 
ORDER BY ordinal_position;

-- Show that user_id is now the primary patient identifier
SELECT 
    'user_id is now the patient identifier' as message,
    'Patients login with their UUID from Supabase Auth' as note;

-- Success message
SELECT 'patient_id column removal completed successfully!' as message;
