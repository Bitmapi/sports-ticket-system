ALTER TABLE users ADD COLUMN IF NOT EXISTS province VARCHAR(50);
ALTER TABLE tickets ADD COLUMN IF NOT EXISTS city VARCHAR(50);
ALTER TABLE reservations ADD COLUMN IF NOT EXISTS admin_id INT REFERENCES users(id);

TRUNCATE TABLE users, tickets, reservations, payments, reports, 
               football_details, volleyball_details, basketball_details 
RESTART IDENTITY CASCADE;