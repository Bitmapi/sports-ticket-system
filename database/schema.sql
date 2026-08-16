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

CREATE INDEX idx_tickets_match_date ON tickets(match_date);
CREATE INDEX idx_reservations_status ON reservations(status);

INSERT INTO users (first_name, last_name, phone, email, role, city, password_hash)
VALUES ('علی', 'محمدی', '09121112233', 'ali@example.com', 'spectator', 'تهران', 'hash_pass_123');

INSERT INTO tickets (sport_type, home_team, away_team, match_date, venue, price, capacity, seat_tier, organizer_id)
VALUES ('football', 'پرسپولیس', 'استقلال', '2026-09-20 18:00:00', 'ورزشگاه آزادی', 150000.00, 50000, 'VIP', 1);

INSERT INTO football_details (ticket_id, tournament, venue_name, seat_tier, row_num, seat_num, ticket_type, features)
VALUES (1, 'لیگ برتر', 'آزادی', 'VIP', 5, 12, 'ویژه', '{"has_parking": true, "roofed": true}');

INSERT INTO reservations (user_id, ticket_id, status, expires_at)
VALUES (1, 1, 'temporary', CURRENT_TIMESTAMP + INTERVAL '10 minutes');

SELECT t.id, t.home_team, t.away_team, t.price, f.venue_name, f.seat_num, f.features
FROM tickets t
JOIN football_details f ON t.id = f.ticket_id;

SELECT u.first_name, u.last_name, r.status, r.expires_at
FROM reservations r
JOIN users u ON r.user_id = u.id;