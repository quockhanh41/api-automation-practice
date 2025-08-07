/*******************************************************************************
   Additional Users for Spike Testing
********************************************************************************/

/** Additional Users for Performance Testing **/
INSERT INTO `users` (`id`, `first_name`, `last_name`, `address`, `city`, `state`, `country`, `postcode`, `phone`, `dob`,
                     `email`, `password`, `role`)
VALUES 
       (4, 'Jane', 'Smith', 'Test street 456', 'Amsterdam', NULL, 'The Netherlands', NULL, NULL, '1985-01-15',
        'jane@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (5, 'John', 'Johnson', 'Test street 789', 'Rotterdam', NULL, 'The Netherlands', NULL, NULL, '1982-03-20',
        'john@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (6, 'Alice', 'Williams', 'Test street 321', 'The Hague', NULL, 'The Netherlands', NULL, NULL, '1990-05-10',
        'alice@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (7, 'Bob', 'Brown', 'Test street 654', 'Eindhoven', NULL, 'The Netherlands', NULL, NULL, '1988-07-25',
        'bob@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (8, 'Charlie', 'Davis', 'Test street 987', 'Tilburg', NULL, 'The Netherlands', NULL, NULL, '1983-09-12',
        'charlie@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (9, 'Diana', 'Miller', 'Test street 147', 'Groningen', NULL, 'The Netherlands', NULL, NULL, '1987-11-08',
        'diana@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (10, 'Eve', 'Wilson', 'Test street 258', 'Almere', NULL, 'The Netherlands', NULL, NULL, '1984-12-03',
        'eve@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (11, 'Frank', 'Moore', 'Test street 369', 'Breda', NULL, 'The Netherlands', NULL, NULL, '1986-02-18',
        'frank@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (12, 'Grace', 'Taylor', 'Test street 741', 'Nijmegen', NULL, 'The Netherlands', NULL, NULL, '1989-04-22',
        'grace@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (13, 'Henry', 'Anderson', 'Test street 852', 'Enschede', NULL, 'The Netherlands', NULL, NULL, '1981-06-14',
        'henry@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (14, 'Irene', 'Thomas', 'Test street 963', 'Apeldoorn', NULL, 'The Netherlands', NULL, NULL, '1992-08-30',
        'irene@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (15, 'Jack', 'Jackson', 'Test street 159', 'Haarlem', NULL, 'The Netherlands', NULL, NULL, '1985-10-05',
        'jack@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (16, 'Karen', 'White', 'Test street 357', 'Arnhem', NULL, 'The Netherlands', NULL, NULL, '1988-01-28',
        'karen@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (17, 'Leo', 'Harris', 'Test street 468', 'Zaanstad', NULL, 'The Netherlands', NULL, NULL, '1983-03-17',
        'leo@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (18, 'Mike', 'Clark', 'Test street 579', 'Amersfoort', NULL, 'The Netherlands', NULL, NULL, '1987-05-09',
        'mike@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (19, 'Nancy', 'Lewis', 'Test street 680', 'Den Haag', NULL, 'The Netherlands', NULL, NULL, '1990-07-31',
        'nancy@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user'),
       (20, 'Oscar', 'Robinson', 'Test street 791', 'Leeuwarden', NULL, 'The Netherlands', NULL, NULL, '1984-09-13',
        'oscar@example.com', '9e2ed9cb4bf54a6b9dc4669a1d295466b2585c4346092bffb5333098431cd61d', 'user');

/*******************************************************************************
   Note: 
   - Password hash is the same as existing users: 'welcome01' 
   - All users have 'user' role for testing purposes
   - Addresses are set to Dutch cities for consistency
   - IDs continue from existing users (4-20)
********************************************************************************/ 