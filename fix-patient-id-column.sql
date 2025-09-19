-- Fix Missing patient_id Column
-- Run this in your Supabase SQL Editor to add the missing patient_id column

-- Check if the column already exists
DO $$ 
BEGIN
    -- Add patient_id column if it doesn't exist
    IF NOT EXISTS (
        SELECT 1 
        FROM information_schema.columns 
        WHERE table_name = 'patients' 
        AND column_name = 'patient_id'
    ) THEN
        ALTER TABLE patients ADD COLUMN patient_id VARCHAR(50) UNIQUE;
        
        -- Add comment
        COMMENT ON COLUMN patients.patient_id IS 'Unique patient identifier in format KL{timestamp}{random}';
        
        -- Create index for better performance
        CREATE INDEX IF NOT EXISTS idx_patients_patient_id ON patients(patient_id);
        
        RAISE NOTICE 'Added patient_id column to patients table';
    ELSE
        RAISE NOTICE 'patient_id column already exists';
    END IF;
END $$;

-- Verify the column was added
SELECT 
    column_name, 
    data_type, 
    is_nullable, 
    column_default
FROM information_schema.columns 
WHERE table_name = 'patients' 
AND column_name = 'patient_id';

-- Show the updated table structure
SELECT 
    column_name, 
    data_type, 
    is_nullable
FROM information_schema.columns 
WHERE table_name = 'patients' 
ORDER BY ordinal_position;

-- Success message
SELECT 'patient_id column fix completed successfully!' as message;
