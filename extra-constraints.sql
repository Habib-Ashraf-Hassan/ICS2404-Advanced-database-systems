-- Add UNIQUE constraint to combination of student_ID and unit_ID in Results table
ALTER TABLE Results
ADD CONSTRAINT results_student_unit_unique UNIQUE (student_ID, unit_ID);
