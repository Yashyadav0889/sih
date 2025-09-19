# Digital Health Plus

A comprehensive digital health platform built with React, TypeScript, and modern web technologies.

## Getting Started

### Prerequisites

Make sure you have Node.js and npm installed on your system.

### Installation

1. Clone this repository
2. Install dependencies:
   ```bash
   npm install
   ```
3. Set up your Supabase database (see Database Setup section below)

### Development

```bash
npm run dev
```

This will start the development server at `http://localhost:8080`.

### Building for Production

To build the project for production:

```bash
npm run build
```

### Preview Production Build

To preview the production build locally:

```bash
npm run preview
```

## Database Setup

This project uses Supabase as the database backend. Follow these steps to set up your database:

### 1. Create a Supabase Project

1. Go to [Supabase](https://supabase.com) and create a new account
2. Create a new project
3. Wait for the project to be set up

### 2. Configure Environment Variables

1. Copy `.env.example` to `.env`
2. Update the environment variables with your Supabase project details:
   ```bash
   VITE_SUPABASE_URL=your_supabase_project_url
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

### 3. Set Up Database Schema

1. Go to your Supabase project dashboard
2. Navigate to the SQL Editor
3. Copy and paste the contents of `database-schema.sql`
4. Run the SQL to create all necessary tables and sample data

### 4. Configure Authentication

1. In your Supabase dashboard, go to Authentication > Settings
2. Configure your site URL and redirect URLs as needed
3. Enable email authentication or other providers as required

## Technologies Used

This project is built with modern web technologies:

- **Vite** - Fast build tool and development server
- **React** - UI library for building user interfaces
- **TypeScript** - Type-safe JavaScript
- **Tailwind CSS** - Utility-first CSS framework
- **shadcn/ui** - Re-usable components built with Radix UI and Tailwind CSS
- **React Router** - Client-side routing
- **Lucide React** - Beautiful & consistent icons
- **Supabase** - Backend-as-a-Service with PostgreSQL database
- **React Query** - Data fetching and caching library

## Features

- Patient dashboard with health records management
- Doctor dashboard for patient management
- Admin dashboard for system administration
- Government dashboard for health data oversight
- Company dashboard for corporate health programs
- AI-powered health assistant
- Appointment booking system
- Multi-language support
- Responsive design

## Project Structure

```
src/
├── components/     # Reusable UI components
├── pages/         # Page components
├── hooks/         # Custom React hooks
├── lib/           # Utility functions
└── main.tsx       # Application entry point
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test your changes
5. Submit a pull request

## License

This project is licensed under the MIT License.
