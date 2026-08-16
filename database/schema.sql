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

CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    reservation_id INT NOT NULL REFERENCES reservations(id),
    amount NUMERIC(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(30) DEFAULT 'pending' CHECK (status IN ('success', 'failed', 'pending')),
    paid_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reports (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    reference_id INT NOT NULL,
    category VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    status VARCHAR(30) DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed'))
);

CREATE TABLE football_details (
    ticket_id INT PRIMARY KEY REFERENCES tickets(id) ON DELETE CASCADE,
    tournament VARCHAR(100),
    venue_name VARCHAR(150),
    seat_tier VARCHAR(50),
    row_num INT,
    seat_num INT,
    ticket_type VARCHAR(50),
    features JSONB
);

CREATE TABLE volleyball_details (
    ticket_id INT PRIMARY KEY REFERENCES tickets(id) ON DELETE CASCADE,
    tournament VARCHAR(100),
    hall_name VARCHAR(150),
    seat_tier VARCHAR(50),
    row_num INT,
    seat_num INT,
    features JSONB
);

CREATE TABLE basketball_details (
    ticket_id INT PRIMARY KEY REFERENCES tickets(id) ON DELETE CASCADE,
    tournament VARCHAR(100),
    hall_name VARCHAR(150),
    seat_tier VARCHAR(50),
    row_num INT,
    seat_num INT,
    features JSONB
);