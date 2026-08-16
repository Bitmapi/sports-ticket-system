CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone VARCHAR(15) UNIQUE, 
    email VARCHAR(100) UNIQUE,
    role VARCHAR(20) DEFAULT 'spectator' CHECK (role IN ('spectator', 'admin')),
    city VARCHAR(50),
    password_hash VARCHAR(255) NOT NULL,
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_contact_info CHECK (phone IS NOT NULL OR email IS NOT NULL)
);

CREATE TABLE tickets (
    id SERIAL PRIMARY KEY,
    sport_type VARCHAR(50) NOT NULL,
    home_team VARCHAR(100) NOT NULL,
    away_team VARCHAR(100) NOT NULL,
    match_date TIMESTAMP NOT NULL,
    venue VARCHAR(150) NOT NULL,
    price NUMERIC(10, 2) NOT NULL CHECK (price >= 0),
    capacity INT NOT NULL CHECK (capacity >= 0),
    seat_tier VARCHAR(50) NOT NULL,
    organizer_id INT 
);

CREATE TABLE reservations (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    ticket_id INT NOT NULL REFERENCES tickets(id) ON DELETE CASCADE,
    status VARCHAR(30) DEFAULT 'temporary' CHECK (status IN ('temporary', 'paid', 'cancelled')),
    reserved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP NOT NULL,
    CONSTRAINT chk_expiration CHECK (expires_at > reserved_at)
);