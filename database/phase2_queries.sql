ALTER TABLE users ADD COLUMN IF NOT EXISTS province VARCHAR(50);
ALTER TABLE tickets ADD COLUMN IF NOT EXISTS city VARCHAR(50);
ALTER TABLE reservations ADD COLUMN IF NOT EXISTS admin_id INT REFERENCES users(id);

TRUNCATE TABLE users, tickets, reservations, payments, reports, 
               football_details, volleyball_details, basketball_details 
RESTART IDENTITY CASCADE;

-- next step  >>>>>>>>>>>>>>>>>>

-- =============================================
-- 1. INSERT USERS (10 Users: 2 Admins, 8 Spectators)
-- =============================================
INSERT INTO users (first_name, last_name, phone, email, role, city, province, password_hash, created_at) VALUES
('Raymond', 'Reddington', '09121000001', 'raymond@example.com', 'spectator', 'Tehran', 'Tehran', 'hash1', '2025-01-01 10:00:00'),
('Elizabeth', 'Keen', '09121000002', 'elizabeth@example.com', 'spectator', 'Tehran', 'Tehran', 'hash2', '2025-02-01 11:00:00'),
('Donald', 'Ressler', '09121000003', 'donald@example.com', 'spectator', 'Rey', 'Tehran', 'hash3', '2025-03-01 12:00:00'),
('Harold', 'Cooper', '09121000004', 'harold@example.com', 'admin', 'Tehran', 'Tehran', 'hash4', '2025-01-15 09:00:00'),
('Aram', 'Mojtabai', '09121000005', 'aram@example.com', 'admin', 'Shiraz', 'Fars', 'hash5', '2025-02-10 14:00:00'),
('Samar', 'Navabi', '09121000006', 'samar@example.com', 'spectator', 'Shiraz', 'Fars', 'hash6', '2025-04-01 15:30:00'),
('Dembe', 'Zuma', '09121000007', 'dembe@example.com', 'spectator', 'Isfahan', 'Isfahan', 'hash7', '2025-05-01 16:00:00'),
('Tom', 'Keen', '09121000008', 'tom@example.com', 'spectator', 'Tabriz', 'East Azerbaijan', 'hash8', '2025-06-01 17:00:00'),
('Glen', 'Carter', '09121000009', 'glen@example.com', 'spectator', 'Tehran', 'Tehran', 'hash9', '2025-07-01 18:00:00'),
('Matias', 'Solomon', '09121000010', 'matias@example.com', 'spectator', 'Mashhad', 'Razavi Khorasan', 'hash10', '2025-08-01 19:00:00');

-- =============================================
-- 2. INSERT TICKETS (10 Tickets)
-- =============================================
INSERT INTO tickets (sport_type, home_team, away_team, match_date, venue, city, price, capacity, seat_tier, organizer_id) VALUES
('football', 'Persepolis', 'Esteghlal', CURRENT_DATE - INTERVAL '1 day' + TIME '18:00:00', 'Azadi Stadium', 'Tehran', 200.00, 70000, 'VIP', 1),
('football', 'Sepahan', 'Tractor', CURRENT_DATE + INTERVAL '3 days' + TIME '17:00:00', 'Naghsh-e Jahan', 'Isfahan', 120.00, 45000, 'Regular', 1),
('football', 'Foolad', 'Gol Gohar', CURRENT_DATE + INTERVAL '5 days' + TIME '19:00:00', 'Foolad Arena', 'Ahvaz', 80.00, 30000, 'Regular', 1),
('volleyball', 'Paykan', 'Shahdab', CURRENT_DATE + INTERVAL '2 days' + TIME '16:00:00', 'Azadi Hall', 'Tehran', 90.00, 12000, 'VIP', 2),
('volleyball', 'Urmia', 'Haraz', CURRENT_DATE + INTERVAL '4 days' + TIME '15:00:00', 'Ghadir Hall', 'Urmia', 60.00, 6000, 'Regular', 2),
('volleyball', 'Saipa', 'Sirjan', CURRENT_DATE + INTERVAL '6 days' + TIME '17:30:00', 'Saipa Hall', 'Tehran', 50.00, 3000, 'Regular', 2),
('basketball', 'Mahram', 'Petrochimi', CURRENT_DATE + INTERVAL '1 day' + TIME '16:00:00', 'Azadi Basketball Hall', 'Tehran', 110.00, 3000, 'VIP', 3),
('basketball', 'Zob Ahan', 'Chemidor', CURRENT_DATE + INTERVAL '7 days' + TIME '18:00:00', 'Mellat Hall', 'Isfahan', 75.00, 2000, 'Regular', 3),
('basketball', 'Kalleh', 'Gorgan', CURRENT_DATE + INTERVAL '8 days' + TIME '15:00:00', 'Imam Hall', 'Gorgan', 65.00, 2500, 'Regular', 3),
('football', 'Esteghlal', 'Sanat Naft', CURRENT_DATE + INTERVAL '10 days' + TIME '18:30:00', 'Azadi Stadium', 'Tehran', 150.00, 70000, 'VIP', 1);

-- =============================================
-- 3. INSERT SPORT SPECIFIC DETAILS (3NF Tables)
-- =============================================
INSERT INTO football_details VALUES
(1, 'Pro League', 'Azadi Stadium', 'VIP', 1, 10, 'Special', '{"has_parking": true, "roofed": true}'),
(2, 'Pro League', 'Naghsh-e Jahan', 'Regular', 5, 20, 'Standard', '{"has_parking": true, "roofed": false}'),
(3, 'Pro League', 'Foolad Arena', 'Regular', 3, 15, 'Standard', '{"has_parking": false, "roofed": true}'),
(10, 'Pro League', 'Azadi Stadium', 'VIP', 2, 12, 'Special', '{"has_parking": true, "roofed": true}');

INSERT INTO volleyball_details VALUES
(4, 'Super League', 'Azadi Hall', 'VIP', 1, 5, '{"court_side": true, "vip_entrance": true}'),
(5, 'Super League', 'Ghadir Hall', 'Regular', 2, 8, '{"court_side": false, "vip_entrance": false}'),
(6, 'Super League', 'Saipa Hall', 'Regular', 4, 11, '{"court_side": false, "vip_entrance": false}');

INSERT INTO basketball_details VALUES
(7, 'Super League', 'Azadi Basketball Hall', 'VIP', 1, 4, '{"front_row": true, "hospitality": true}'),
(8, 'Super League', 'Mellat Hall', 'Regular', 3, 9, '{"front_row": false, "hospitality": false}'),
(9, 'Super League', 'Imam Hall', 'Regular', 2, 14, '{"front_row": false, "hospitality": false}');

-- =============================================
-- 4. INSERT RESERVATIONS (12 Reservations)
-- =============================================
INSERT INTO reservations (user_id, ticket_id, status, reserved_at, expires_at, admin_id) VALUES
(1, 1, 'cancelled', '2026-08-10 10:00:00', '2026-08-10 10:15:00', 4),
(1, 4, 'cancelled', '2026-08-11 11:00:00', '2026-08-11 11:15:00', 4),
(1, 7, 'cancelled', '2026-08-12 12:00:00', '2026-08-12 12:15:00', 4),
(2, 1, 'paid', '2026-08-14 09:00:00', '2026-08-14 09:15:00', NULL),
(2, 4, 'paid', '2026-08-15 10:00:00', '2026-08-15 10:15:00', NULL),
(2, 7, 'paid', CURRENT_TIMESTAMP - INTERVAL '2 hours', CURRENT_TIMESTAMP + INTERVAL '10 minutes', NULL),
(3, 2, 'paid', '2026-08-12 14:00:00', '2026-08-12 14:15:00', NULL),
(6, 1, 'paid', '2026-08-13 15:00:00', '2026-08-13 15:15:00', NULL),
(7, 3, 'paid', '2026-08-01 16:00:00', '2026-08-01 16:15:00', NULL),
(8, 5, 'paid', '2026-07-15 17:00:00', '2026-07-15 17:15:00', NULL),
(9, 6, 'paid', '2026-06-20 18:00:00', '2026-06-20 18:15:00', NULL),
(10, 8, 'temporary', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '10 minutes', NULL);

-- =============================================
-- 5. INSERT PAYMENTS (10 Payments)
-- =============================================
INSERT INTO payments (user_id, reservation_id, amount, payment_method, status, paid_at) VALUES
(2, 4, 200.00, 'credit_card', 'success', '2026-08-14 09:05:00'),
(2, 5, 90.00, 'online_gateway', 'success', '2026-08-15 10:05:00'),
(2, 6, 110.00, 'credit_card', 'success', CURRENT_TIMESTAMP - INTERVAL '1 hour'),
(3, 7, 120.00, 'online_gateway', 'success', '2026-08-12 14:05:00'),
(6, 8, 200.00, 'credit_card', 'success', '2026-08-13 15:05:00'),
(7, 9, 80.00, 'online_gateway', 'success', '2026-08-01 16:05:00'),
(8, 10, 60.00, 'credit_card', 'success', '2026-07-15 17:05:00'),
(9, 11, 50.00, 'online_gateway', 'success', '2026-06-20 18:05:00'),
(1, 1, 200.00, 'credit_card', 'failed', '2026-08-10 10:05:00'),
(10, 12, 75.00, 'online_gateway', 'pending', CURRENT_TIMESTAMP);

-- =============================================
-- 6. INSERT REPORTS (10 Reports)
-- =============================================
INSERT INTO reports (user_id, reference_id, category, description, status) VALUES
(1, 1, 'Pricing Issue', 'Ticket price is higher than approved rate', 'pending'),
(2, 1, 'Pricing Issue', 'Duplicate payment deducted from card', 'reviewed'),
(3, 1, 'Pricing Issue', 'Seat tier was marked incorrectly', 'reviewed'),
(6, 2, 'Venue Problem', 'Entrance gate number was wrong', 'pending'),
(7, 3, 'Seat Problem', 'Double booking on the same seat', 'reviewed'),
(8, 4, 'Cancellation', 'Match postponed without notification', 'pending'),
(9, 5, 'Venue Problem', 'No parking available despite VIP tag', 'reviewed'),
(1, 6, 'Support', 'Admin cancelled my valid reservation', 'pending'),
(2, 7, 'Support', 'Payment gateway timeout error', 'reviewed'),
(3, 8, 'Other', 'Need tax invoice for ticket purchase', 'pending');


-- next step >>>>>>>>>>>>>>>

-- 1. کاربرانی که تا به حال هیچ بلیطی رزرو نکرده‌اند
SELECT first_name, last_name 
FROM users 
WHERE id NOT IN (SELECT user_id FROM reservations);

-- 2. تمام کاربرانی که حداقل یک بلیط خریده‌اند (پرداخت موفق)
SELECT DISTINCT u.first_name, u.last_name 
FROM users u 
JOIN reservations r ON u.id = r.user_id 
WHERE r.status = 'paid';

-- 3. مجموع پرداخت‌های هر کاربر در ماه‌های مختلف
SELECT u.first_name, u.last_name, EXTRACT(MONTH FROM p.paid_at) AS month, SUM(p.amount) AS total_paid
FROM users u 
JOIN payments p ON u.id = p.user_id 
WHERE p.status = 'success' 
GROUP BY u.id, month;

-- 4. لیست کاربرانی که در هر شهر فقط یک بار بلیط خریداری کرده‌اند
SELECT u.first_name, u.last_name, t.city 
FROM users u 
JOIN reservations r ON u.id = r.user_id 
JOIN tickets t ON r.ticket_id = t.id 
WHERE r.status = 'paid' 
GROUP BY u.id, t.city 
HAVING COUNT(r.id) = 1;

-- 5. اطلاعات کاربری که جدیدترین بلیط را خریداری کرده است
SELECT u.* 
FROM users u 
JOIN payments p ON u.id = p.user_id 
WHERE p.status = 'success' 
ORDER BY p.paid_at DESC 
LIMIT 1;

-- 6. شماره تلفن یا ایمیل کاربرانی که پرداختشان بیشتر از میانگین پرداخت کل است
SELECT u.phone, u.email 
FROM users u 
JOIN payments p ON u.id = p.user_id 
WHERE p.status = 'success' 
GROUP BY u.id 
HAVING SUM(p.amount) > (
    SELECT AVG(total_paid) 
    FROM (SELECT SUM(amount) AS total_paid FROM payments WHERE status = 'success' GROUP BY user_id) AS sub
);

-- 7. تعداد بلیط‌های فروخته‌شده به ازای هر نوع مسابقه ورزشی
SELECT t.sport_type, COUNT(r.id) AS sold_tickets 
FROM tickets t 
JOIN reservations r ON t.id = r.ticket_id 
WHERE r.status = 'paid' 
GROUP BY t.sport_type;

-- 8. نام 3 کاربر با بیشترین خرید بلیط در هفته اخیر
SELECT u.first_name, u.last_name 
FROM users u 
JOIN reservations r ON u.id = r.user_id 
JOIN payments p ON r.id = p.reservation_id
WHERE p.status = 'success' AND p.paid_at >= CURRENT_DATE - INTERVAL '7 days' 
GROUP BY u.id 
ORDER BY COUNT(r.id) DESC 
LIMIT 3;

-- 9. تعداد بلیط‌های فروخته‌شده در استان تهران به تفکیک شهر
SELECT u.city, COUNT(r.id) AS sold_count 
FROM users u 
JOIN reservations r ON u.id = r.user_id 
WHERE r.status = 'paid' AND u.province = 'Tehran' 
GROUP BY u.city;

-- 10. نام شهرهایی که قدیمی‌ترین کاربر ثبت‌نام‌شده از آنجا خرید داشته است
SELECT DISTINCT t.city 
FROM tickets t 
JOIN reservations r ON t.id = r.ticket_id 
WHERE r.status = 'paid' AND r.user_id = (SELECT id FROM users ORDER BY created_at ASC LIMIT 1);

-- 11. نام پشتیبان‌های سایت
SELECT first_name, last_name 
FROM users 
WHERE role = 'admin';

-- 12. نام کاربرانی که حداقل 2 بلیط خریداری کرده‌اند
SELECT u.first_name, u.last_name 
FROM users u 
JOIN reservations r ON u.id = r.user_id 
WHERE r.status = 'paid' 
GROUP BY u.id 
HAVING COUNT(r.id) >= 2;

-- 13. کاربرانی که حداکثر 2 بلیط فوتبال خریده‌اند
SELECT u.first_name, u.last_name 
FROM users u 
JOIN reservations r ON u.id = r.user_id 
JOIN tickets t ON r.ticket_id = t.id 
WHERE r.status = 'paid' AND t.sport_type = 'football' 
GROUP BY u.id 
HAVING COUNT(r.id) <= 2;

-- 14. کاربرانی که از تمام انواع مسابقات حداقل یک بار بلیط خریده‌اند
SELECT u.email, u.phone 
FROM users u 
JOIN reservations r ON u.id = r.user_id 
JOIN tickets t ON r.ticket_id = t.id 
WHERE r.status = 'paid' AND t.sport_type IN ('football', 'volleyball', 'basketball') 
GROUP BY u.id 
HAVING COUNT(DISTINCT t.sport_type) = 3;

-- 15. اطلاعات بلیط‌های خریداری‌شده امروز با ترتیب ساعت
SELECT t.*, p.paid_at 
FROM tickets t 
JOIN reservations r ON t.id = r.ticket_id 
JOIN payments p ON r.id = p.reservation_id 
WHERE p.status = 'success' AND DATE(p.paid_at) = CURRENT_DATE 
ORDER BY p.paid_at ASC;

-- 16. دومین بلیط پرفروش
SELECT t.id, t.home_team, t.away_team 
FROM tickets t 
JOIN reservations r ON t.id = r.ticket_id 
WHERE r.status = 'paid' 
GROUP BY t.id 
ORDER BY COUNT(r.id) DESC 
LIMIT 1 OFFSET 1;

-- 17. نام پشتیبان با بیشترین لغو رزرو به همراه درصد
SELECT a.first_name, a.last_name, COUNT(r.id) AS cancels, 
       (COUNT(r.id) * 100.0 / (SELECT COUNT(*) FROM reservations WHERE status = 'cancelled')) AS percent_of_total 
FROM users a 
JOIN reservations r ON a.id = r.admin_id 
WHERE r.status = 'cancelled' 
GROUP BY a.id 
ORDER BY cancels DESC 
LIMIT 1;

-- 18. تغییر فامیلی کاربری که بیشترین کنسلی را داشته به "Reddington"
UPDATE users 
SET last_name = 'Reddington' 
WHERE id = (
    SELECT user_id 
    FROM reservations 
    WHERE status = 'cancelled' 
    GROUP BY user_id 
    ORDER BY COUNT(id) DESC 
    LIMIT 1
);

-- 19. حذف تمام بلیط‌های کنسل‌شده کاربر ردینگتون
DELETE FROM reservations 
WHERE status = 'cancelled' AND user_id = (SELECT id FROM users WHERE last_name = 'Reddington' LIMIT 1);

-- 20. پاک کردن تمام بلیط‌های کنسل‌شده در سیستم
DELETE FROM reservations 
WHERE status = 'cancelled';

-- 21. کاهش 10 درصدی قیمت بلیط‌های دیروز آزادی
UPDATE tickets 
SET price = price * 0.9 
WHERE venue = 'Azadi Stadium' AND DATE(match_date) = CURRENT_DATE - INTERVAL '1 day';

-- 22. موضوع و تعداد گزارش‌ها برای بلیط با بیشترین گزارش
SELECT category, COUNT(*) AS report_count 
FROM reports 
WHERE reference_id = (
    SELECT reference_id 
    FROM reports 
    GROUP BY reference_id 
    ORDER BY COUNT(id) DESC 
    LIMIT 1
) 
GROUP BY category;


-- next step >>>>>>>>>>>>>>>>>>>>>>>>

-- 1. دریافت ایمیل/تلفن و بازگرداندن لیست بلیط‌ها
CREATE OR REPLACE FUNCTION get_user_tickets(p_contact VARCHAR)
RETURNS TABLE(ticket_id INT, home_team VARCHAR, away_team VARCHAR, paid_at TIMESTAMP) AS $$
BEGIN
    RETURN QUERY
    SELECT t.id, t.home_team, t.away_team, p.paid_at
    FROM tickets t 
    JOIN reservations r ON t.id = r.ticket_id 
    JOIN payments p ON r.id = p.reservation_id 
    JOIN users u ON r.user_id = u.id
    WHERE (u.email = p_contact OR u.phone = p_contact) AND p.status = 'success' 
    ORDER BY p.paid_at;
END;
$$ LANGUAGE plpgsql;

-- 2. نام کاربرانی که رزروشان توسط ادمین خاصی لغو شده
CREATE OR REPLACE FUNCTION get_cancelled_users_by_admin(p_admin_contact VARCHAR)
RETURNS TABLE(first_name VARCHAR, last_name VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT u.first_name, u.last_name
    FROM users u 
    JOIN reservations r ON u.id = r.user_id 
    JOIN users admin ON r.admin_id = admin.id
    WHERE (admin.email = p_admin_contact OR admin.phone = p_admin_contact) 
      AND admin.role = 'admin' 
      AND r.status = 'cancelled';
END;
$$ LANGUAGE plpgsql;

-- 3. لیست بلیط‌های یک شهر خاص
CREATE OR REPLACE FUNCTION get_tickets_by_city(p_city VARCHAR)
RETURNS TABLE(ticket_id INT, home_team VARCHAR, away_team VARCHAR, venue VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT t.id, t.home_team, t.away_team, t.venue
    FROM tickets t 
    JOIN reservations r ON t.id = r.ticket_id 
    WHERE t.city = p_city AND r.status = 'paid';
END;
$$ LANGUAGE plpgsql;

-- 4. جستجو با یک عبارت (در تیم‌ها، جایگاه، نام کاربر، ورزشگاه)
CREATE OR REPLACE FUNCTION search_tickets(search_term VARCHAR)
RETURNS TABLE(ticket_id INT, home_team VARCHAR, away_team VARCHAR, venue VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT DISTINCT t.id, t.home_team, t.away_team, t.venue
    FROM tickets t 
    LEFT JOIN reservations r ON t.id = r.ticket_id 
    LEFT JOIN users u ON r.user_id = u.id
    WHERE t.home_team ILIKE '%' || search_term || '%' 
       OR t.away_team ILIKE '%' || search_term || '%' 
       OR t.venue ILIKE '%' || search_term || '%' 
       OR t.seat_tier ILIKE '%' || search_term || '%'
       OR u.first_name ILIKE '%' || search_term || '%' 
       OR u.last_name ILIKE '%' || search_term || '%';
END;
$$ LANGUAGE plpgsql;

-- 5. دریافت اطلاعات همشهری‌های یک کاربر
CREATE OR REPLACE FUNCTION get_users_in_same_city(p_contact VARCHAR)
RETURNS TABLE(first_name VARCHAR, last_name VARCHAR, city VARCHAR) AS $$
DECLARE 
    user_city VARCHAR;
BEGIN
    SELECT u.city INTO user_city 
    FROM users u 
    WHERE u.email = p_contact OR u.phone = p_contact 
    LIMIT 1;

    RETURN QUERY
    SELECT u.first_name, u.last_name, u.city 
    FROM users u 
    WHERE u.city = user_city 
      AND u.email != p_contact 
      AND u.phone != p_contact;
END;
$$ LANGUAGE plpgsql;

-- 6. لیست n کاربر با بیشترین خرید از یک تاریخ به بعد
CREATE OR REPLACE FUNCTION get_top_users_since(p_date TIMESTAMP, p_limit INT)
RETURNS TABLE(first_name VARCHAR, last_name VARCHAR, purchase_count BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT u.first_name, u.last_name, COUNT(p.id)
    FROM users u 
    JOIN reservations r ON u.id = r.user_id 
    JOIN payments p ON r.id = p.reservation_id
    WHERE p.status = 'success' AND p.paid_at >= p_date 
    GROUP BY u.id 
    ORDER BY COUNT(p.id) DESC 
    LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

-- 7. بلیط‌های کنسل شده یک نوع مسابقه
CREATE OR REPLACE FUNCTION get_cancelled_by_sport(p_sport_type VARCHAR)
RETURNS TABLE(ticket_id INT, home_team VARCHAR, away_team VARCHAR, match_date TIMESTAMP) AS $$
BEGIN
    RETURN QUERY
    SELECT t.id, t.home_team, t.away_team, t.match_date
    FROM tickets t 
    JOIN reservations r ON t.id = r.ticket_id
    WHERE r.status = 'cancelled' AND t.sport_type = p_sport_type 
    ORDER BY t.match_date DESC;
END;
$$ LANGUAGE plpgsql;

-- 8. کاربرانی که بیشترین گزارش را در یک موضوع خاص ثبت کرده‌اند
CREATE OR REPLACE FUNCTION get_top_reporters_by_category(p_category VARCHAR)
RETURNS TABLE(first_name VARCHAR, last_name VARCHAR, report_count BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT u.first_name, u.last_name, COUNT(rep.id)
    FROM users u 
    JOIN reports rep ON u.id = rep.user_id
    WHERE rep.category = p_category 
    GROUP BY u.id 
    ORDER BY COUNT(rep.id) DESC;
END;
$$ LANGUAGE plpgsql;