-- Quick Database Setup for Digital Health Plus
-- Copy and paste this into your Supabase SQL Editor

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Create patients table
CREATE TABLE IF NOT EXISTS patients (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    name VARCHAR(255) NOT NULL,
    age INTEGER NOT NULL,
    date_of_birth DATE NOT NULL,
    blood_group VARCHAR(10) NOT NULL,
    height INTEGER NOT NULL,
    weight INTEGER NOT NULL,
    mobile VARCHAR(15) NOT NULL,
    email VARCHAR(255),
    from_state VARCHAR(100) NOT NULL,
    year_moved_to_kerala INTEGER NOT NULL,
    recent_illness VARCHAR(10) NOT NULL,
    disease_details JSONB,
    chronic_diseases VARCHAR(10) NOT NULL,
    chronic_disease_details JSONB,
    covid_vaccination VARCHAR(20) NOT NULL,
    vaccination_certificate TEXT,
    user_id UUID REFERENCES auth.users(id),
    patient_id VARCHAR(50) UNIQUE -- Added missing patient_id column
);

-- Create doctors table
CREATE TABLE IF NOT EXISTS doctors (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    name VARCHAR(255) NOT NULL,
    specialization VARCHAR(255) NOT NULL,
    license_number VARCHAR(100) NOT NULL UNIQUE,
    hospital_affiliation VARCHAR(255) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    available_online BOOLEAN DEFAULT false,
    user_id UUID REFERENCES auth.users(id)
);

-- Create hospitals table
CREATE TABLE IF NOT EXISTS hospitals (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(255),
    type VARCHAR(50) NOT NULL DEFAULT 'government',
    specialties JSONB,
    emergency_services BOOLEAN DEFAULT true
);

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    patient_id UUID REFERENCES patients(id),
    doctor_id UUID REFERENCES doctors(id),
    hospital_id UUID REFERENCES hospitals(id),
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    type VARCHAR(20) NOT NULL, -- 'online' or 'in-person'
    status VARCHAR(20) DEFAULT 'scheduled', -- 'scheduled', 'completed', 'cancelled'
    notes TEXT
);

-- Enable Row Level Security
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE hospitals ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for patients
CREATE POLICY "Users can view own patient data" ON patients
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own patient data" ON patients
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own patient data" ON patients
    FOR UPDATE USING (auth.uid() = user_id);

-- Create RLS policies for doctors
CREATE POLICY "Doctors can view own data" ON doctors
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Doctors can insert own data" ON doctors
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Doctors can update own data" ON doctors
    FOR UPDATE USING (auth.uid() = user_id);

-- Create RLS policies for hospitals (public read)
CREATE POLICY "Anyone can view hospitals" ON hospitals
    FOR SELECT USING (true);

-- Create RLS policies for appointments
CREATE POLICY "Users can view own appointments" ON appointments
    FOR SELECT USING (
        auth.uid() IN (
            SELECT user_id FROM patients WHERE id = patient_id
            UNION
            SELECT user_id FROM doctors WHERE id = doctor_id
        )
    );

-- Insert sample hospitals data
INSERT INTO hospitals (name, address, city, phone, email, specialties) VALUES
('Government Medical College Hospital', 'Thiruvananthapuram Medical College Campus', 'Thiruvananthapuram', '+91-471-2528300', 'gmc.tvm@kerala.gov.in', '["General Medicine", "Surgery", "Cardiology", "Neurology"]'),
('Ernakulam General Hospital', 'Ernakulam District, Kochi', 'Kochi', '+91-484-2371056', 'egh.kochi@kerala.gov.in', '["General Medicine", "Pediatrics", "Orthopedics", "Gynecology"]'),
('Kozhikode Medical College Hospital', 'Kozhikode Medical College Campus', 'Kozhikode', '+91-495-2359126', 'kmch.calicut@kerala.gov.in', '["General Medicine", "Surgery", "Cardiology", "Oncology"]'),
('Thrissur District Hospital', 'Thrissur District Headquarters', 'Thrissur', '+91-487-2320812', 'tdh.thrissur@kerala.gov.in', '["General Medicine", "Emergency Care", "Maternity", "Pediatrics"]'),
('Kollam District Hospital', 'Kollam District Headquarters', 'Kollam', '+91-474-2794300', 'kdh.kollam@kerala.gov.in', '["General Medicine", "Surgery", "Emergency Care", "Orthopedics"]');

-- Insert sample doctors data
INSERT INTO doctors (name, specialization, license_number, hospital_affiliation, phone, email, city, available_online) VALUES
('Dr. Rajesh Kumar', 'General Medicine', 'KMC001234', 'Government Medical College Hospital', '+91-9876543210', 'dr.rajesh@healthplus.kerala.gov.in', 'Thiruvananthapuram', true),
('Dr. Priya Nair', 'Cardiology', 'KMC001235', 'Ernakulam General Hospital', '+91-9876543211', 'dr.priya@healthplus.kerala.gov.in', 'Kochi', true),
('Dr. Suresh Menon', 'Pediatrics', 'KMC001236', 'Kozhikode Medical College Hospital', '+91-9876543212', 'dr.suresh@healthplus.kerala.gov.in', 'Kozhikode', false),
('Dr. Lakshmi Pillai', 'Gynecology', 'KMC001237', 'Thrissur District Hospital', '+91-9876543213', 'dr.lakshmi@healthplus.kerala.gov.in', 'Thrissur', true),
('Dr. Arun Das', 'Orthopedics', 'KMC001238', 'Kollam District Hospital', '+91-9876543214', 'dr.arun@healthplus.kerala.gov.in', 'Kollam', false);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_patients_user_id ON patients(user_id);
CREATE INDEX IF NOT EXISTS idx_doctors_user_id ON doctors(user_id);
CREATE INDEX IF NOT EXISTS idx_hospitals_city ON hospitals(city);
CREATE INDEX IF NOT EXISTS idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor_id ON appointments(doctor_id);

-- Success message
SELECT 'Database setup completed successfully! You can now use the Digital Health Plus application.' as message;
