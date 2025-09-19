-- Digital Health Plus Database Schema
-- Run this in your Supabase SQL editor to set up the database

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
    height INTEGER NOT NULL, -- in cm
    weight INTEGER NOT NULL, -- in kg
    mobile VARCHAR(15) NOT NULL,
    email VARCHAR(255),
    from_state VARCHAR(100) NOT NULL,
    year_moved_to_kerala INTEGER NOT NULL,
    recent_illness VARCHAR(10) NOT NULL, -- 'yes' or 'no'
    disease_details JSONB,
    chronic_diseases VARCHAR(10) NOT NULL, -- 'yes' or 'no'
    chronic_disease_details JSONB,
    covid_vaccination VARCHAR(20) NOT NULL,
    vaccination_certificate TEXT,
    user_id UUID REFERENCES auth.users(id)
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
    city VARCHAR(100) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    address TEXT NOT NULL,
    specialties TEXT[] NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('government', 'private')),
    rating DECIMAL(2,1),
    reviews_count INTEGER DEFAULT 0
);

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    doctor_id UUID NOT NULL REFERENCES doctors(id) ON DELETE CASCADE,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('online', 'in-person')),
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'completed', 'cancelled')),
    notes TEXT
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_patients_user_id ON patients(user_id);
CREATE INDEX IF NOT EXISTS idx_patients_mobile ON patients(mobile);
CREATE INDEX IF NOT EXISTS idx_doctors_user_id ON doctors(user_id);
CREATE INDEX IF NOT EXISTS idx_doctors_city ON doctors(city);
CREATE INDEX IF NOT EXISTS idx_doctors_specialization ON doctors(specialization);
CREATE INDEX IF NOT EXISTS idx_hospitals_city ON hospitals(city);
CREATE INDEX IF NOT EXISTS idx_hospitals_type ON hospitals(type);
CREATE INDEX IF NOT EXISTS idx_appointments_patient_id ON appointments(patient_id);
CREATE INDEX IF NOT EXISTS idx_appointments_doctor_id ON appointments(doctor_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(appointment_date);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_patients_updated_at BEFORE UPDATE ON patients FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_doctors_updated_at BEFORE UPDATE ON doctors FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_hospitals_updated_at BEFORE UPDATE ON hospitals FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_appointments_updated_at BEFORE UPDATE ON appointments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert sample hospitals data
INSERT INTO hospitals (name, city, phone, address, specialties, type, rating, reviews_count) VALUES
('Government Medical College Hospital', 'Thiruvananthapuram', '+91-471-2528073', 'Medical College P.O, Thiruvananthapuram, Kerala 695011', ARRAY['Cardiology', 'Neurology', 'Orthopedics', 'General Medicine'], 'government', 4.2, 1245),
('Ernakulam General Hospital', 'Kochi', '+91-484-2376101', 'Ernakulam, Kochi, Kerala 682018', ARRAY['Pediatrics', 'Gynecology', 'Emergency Medicine', 'Surgery'], 'government', 4.0, 987),
('Kozhikode Medical College Hospital', 'Kozhikode', '+91-495-2359126', 'Kozhikode Medical College, Kerala 673008', ARRAY['Cardiology', 'Neurology', 'Pediatrics', 'General Medicine'], 'government', 4.1, 756),
('Kottayam Medical College Hospital', 'Kottayam', '+91-481-2597234', 'Kottayam Medical College, Kerala 686008', ARRAY['Orthopedics', 'General Medicine', 'Surgery', 'Gynecology'], 'government', 3.9, 543),
('Kollam District Hospital', 'Kollam', '+91-474-2794242', 'Kollam District Hospital, Kerala 691013', ARRAY['Emergency Medicine', 'General Medicine', 'Pediatrics'], 'government', 3.8, 432)
ON CONFLICT DO NOTHING;

-- Insert sample doctors data
INSERT INTO doctors (name, specialization, license_number, hospital_affiliation, phone, email, city, available_online) VALUES
('Dr. Rajesh Kumar', 'General Medicine', 'KL-GM-2020-001', 'Government Medical College Hospital', '+91-9876543210', 'rajesh.kumar@gmail.com', 'Thiruvananthapuram', true),
('Dr. Priya Nair', 'Pediatrics', 'KL-PD-2019-045', 'Ernakulam General Hospital', '+91-9876543211', 'priya.nair@gmail.com', 'Kochi', false),
('Dr. Kumar Menon', 'Cardiology', 'KL-CD-2021-023', 'Kozhikode Medical College Hospital', '+91-9876543212', 'kumar.menon@gmail.com', 'Kozhikode', true),
('Dr. Sita Devi', 'Gynecology', 'KL-GY-2020-067', 'Kottayam Medical College Hospital', '+91-9876543213', 'sita.devi@gmail.com', 'Kottayam', false),
('Dr. Arun Pillai', 'Orthopedics', 'KL-OR-2018-089', 'Kollam District Hospital', '+91-9876543214', 'arun.pillai@gmail.com', 'Kollam', true)
ON CONFLICT DO NOTHING;

-- Predefined User Accounts Information
-- These accounts should be created manually in Supabase Auth dashboard:
--
-- Doctor Account:
--   User ID: WHNYJ64469870
--   Email: doctor@healthplus.kerala.gov.in
--   Password: Yash+-07@
--   Role: doctor
--   Name: Dr. Rajesh Kumar
--
-- Administrator Account:
--   User ID: ADMIN64469870
--   Email: admin@healthplus.kerala.gov.in
--   Password: Yash+-07@
--   Role: admin
--   Name: System Administrator
--
-- Government Official Account:
--   User ID: GOVT64469870
--   Email: official@healthplus.kerala.gov.in
--   Password: Yash+-07@
--   Role: government
--   Name: Government Official
--
-- Company Account:
--   User ID: COMP64469870
--   Email: company@healthplus.kerala.gov.in
--   Password: Yash+-07@
--   Role: company
--   Name: Company Representative

-- Enable Row Level Security (RLS)
ALTER TABLE patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE hospitals ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- Create RLS policies
-- Patients can only see their own data
CREATE POLICY "Users can view own patient data" ON patients FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own patient data" ON patients FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own patient data" ON patients FOR UPDATE USING (auth.uid() = user_id);

-- Doctors can see their own data and patient data for appointments
CREATE POLICY "Doctors can view own data" ON doctors FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Doctors can insert own data" ON doctors FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Doctors can update own data" ON doctors FOR UPDATE USING (auth.uid() = user_id);

-- Hospitals are publicly readable
CREATE POLICY "Hospitals are publicly readable" ON hospitals FOR SELECT USING (true);

-- Appointments policies
CREATE POLICY "Users can view own appointments" ON appointments FOR SELECT USING (
    EXISTS (SELECT 1 FROM patients WHERE patients.id = appointments.patient_id AND patients.user_id = auth.uid())
    OR EXISTS (SELECT 1 FROM doctors WHERE doctors.id = appointments.doctor_id AND doctors.user_id = auth.uid())
);

CREATE POLICY "Patients can create appointments" ON appointments FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM patients WHERE patients.id = appointments.patient_id AND patients.user_id = auth.uid())
);

CREATE POLICY "Doctors can update appointments" ON appointments FOR UPDATE USING (
    EXISTS (SELECT 1 FROM doctors WHERE doctors.id = appointments.doctor_id AND doctors.user_id = auth.uid())
);
