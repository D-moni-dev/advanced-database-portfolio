
-- ==========================================================
-- PORTFOLIO 3: TRANSACTIONS AND CONCURRENCY CONTROL
-- Course: MIT 8103 - Advanced Database Systems
-- Project: University Student Result Management System
-- Database: university_result_db
-- ==========================================================


-- SECTION 1: CHECK THE ORIGINAL ACADEMIC SESSION
SELECT registration_id, academic_session
FROM registrations
WHERE registration_id = 1;


-- SECTION 2: TRANSACTION AND ROLLBACK
-- Demonstrates that an uncommitted update can be cancelled.
BEGIN;

UPDATE registrations
SET academic_session = 'TEST2026'
WHERE registration_id = 1;

SELECT registration_id, academic_session
FROM registrations
WHERE registration_id = 1;

ROLLBACK;

-- Verify that the original value is restored.
SELECT registration_id, academic_session
FROM registrations
WHERE registration_id = 1;


-- SECTION 3: TRANSACTION AND COMMIT
-- Demonstrates that a committed update is permanent.
BEGIN;

UPDATE registrations
SET academic_session = 'COMMIT26'
WHERE registration_id = 1;

SELECT registration_id, academic_session
FROM registrations
WHERE registration_id = 1;

COMMIT;

-- Verify the committed value.
SELECT registration_id, academic_session
FROM registrations
WHERE registration_id = 1;


-- SECTION 4: RESTORE THE ORIGINAL VALUE
-- Run after the COMMIT demonstration.
UPDATE registrations
SET academic_session = '2026/2027'
WHERE registration_id = 1;

-- Verify restoration.
SELECT registration_id, academic_session
FROM registrations
WHERE registration_id = 1;


-- SECTION 5: CONCURRENCY EXPERIMENT
-- SESSION A: Run this block in Query Tool A.
-- Keep the transaction open while testing Session B.
BEGIN;

UPDATE registrations
SET academic_session = 'TEST2026'
WHERE registration_id = 1;

SELECT registration_id, academic_session
FROM registrations
WHERE registration_id = 1;

-- IMPORTANT:
-- Do not execute COMMIT or ROLLBACK yet.
-- Switch to Query Tool B and run the SELECT statement below.


-- SESSION B: Run separately in Query Tool B.
-- This should show the last committed value while Session A
-- has an uncommitted update.
SELECT registration_id, academic_session
FROM registrations
WHERE registration_id = 1;

-- SESSION A: After checking Session B, run separately:
-- ROLLBACK;
-- Then verify:
-- SELECT registration_id, academic_session
-- FROM registrations
-- WHERE registration_id = 1;


-- SECTION 6: ROW-LEVEL LOCKING
-- SESSION A: Run in Query Tool A.
BEGIN;

SELECT registration_id, academic_session
FROM registrations
WHERE registration_id = 1
FOR UPDATE;

-- Keep this transaction open.
-- Switch to Query Tool B and run the UPDATE below.


-- SESSION B: Run separately in Query Tool B.
-- This update should wait while Session A holds the row lock.
UPDATE registrations
SET academic_session = 'LOCKTEST'
WHERE registration_id = 1;

-- SESSION A: Run separately to release the lock:
-- ROLLBACK;

-- SESSION B:
-- If the UPDATE was still waiting, it may now complete.
-- If it completed in autocommit mode, restore the original value:
UPDATE registrations
SET academic_session = '2026/2027'
WHERE registration_id = 1;

-- FINAL VERIFICATION
SELECT registration_id, academic_session
FROM registrations
WHERE registration_id = 1;
