-- Add UNIQUE constraint to combination of student_ID and unit_ID in Results table
ALTER TABLE Results
ADD CONSTRAINT results_student_unit_unique UNIQUE (student_ID, unit_ID);

-- Change delimiter temporarily
DELIMITER $$

-- Create a trigger that checks fee balance before allowing unit registration
CREATE TRIGGER check_fee_balance
BEFORE INSERT ON StudentUnitRegistration
FOR EACH ROW
BEGIN
    DECLARE has_fees_record INT;
    DECLARE has_unpaid_balance INT;
    
    -- Check if student exists in Fees table
    SELECT COUNT(*) INTO has_fees_record
    FROM Fees
    WHERE student_ID = NEW.student_ID;
    
    -- If student doesn't exist in Fees table, raise an error
    IF has_fees_record = 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Student has no fee records. Registration not allowed.';
    END IF;
    
    -- Check if student has any unpaid balance (fee_balance > 0)
    SELECT COUNT(*) INTO has_unpaid_balance
    FROM Fees
    WHERE student_ID = NEW.student_ID
    AND fees_balance > 0;
    
    -- If student has any unpaid balance, raise an error
    IF has_unpaid_balance > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student has unpaid fee balance. Registration not allowed.';
    END IF;
END$$

-- Change delimiter back to semicolon
DELIMITER ;
