use demo;

-- create table 
create table pan_card_validation(Pan_numbers varchar(30));

-- show table
select * from pan_card_validation;

-- ------------------------------- 1. Data cleaning and preprocessing

/* -- Identify and handle missing data: PAN numbers may have missing values.
*/
select * from pan_card_validation where Pan_numbers =' '; -- no null values


/* -- Check for duplicates: Ensure there are no duplicate PAN numbers. If
duplicates exist.*/

-- how many duplictaes
select count(Pan_numbers) - count(distinct Pan_numbers) as no_of_duplicates from pan_card_validation;

-- which pan numbers are duplicates
select Pan_numbers , count(1) as cnt
from pan_card_validation
group by 1
having count(1)>1;

 -- Handle leading/trailing spaces: PAN numbers may have extra spaces before or after the actual number. Remove any such spaces.
 select * from pan_card_validation  where Pan_numbers != trim(Pan_numbers);

/* --Correct letter case: Ensure that the PAN numbers are in uppercase letters
(if any lowercase letters are present). */
select * from pan_card_validation where BINARY Pan_numbers != UPPER(Pan_numbers); -- Use binary comparison 

 -- CLEANED PAN NUMBERS
select distinct upper(trim(Pan_numbers)) as PAN_Numbers
from pan_card_validation
where Pan_numbers is not null  and trim(Pan_numbers) <>' ';

-- 2.  PAN Format Validation: A valid PAN number follows the format:
         -- It is exactly 10 characters long. 
         -- The format is as follows: AAAAA1234A
		
        -- REGULAR EXPRESSION to validate the pattern or structure of PAN Numbers
SELECT * FROM pan_card_validation
WHERE Pan_numbers REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$' ;

             -- The first five characters should be alphabetic (uppercase letters).
				/*. 1. Adjacent characters(alphabets) cannot be the same (like AABCD is
					invalid; AXBCD is valid)*/
					
DELIMITER $$

CREATE FUNCTION fn_check_adjacent_characters(p_str VARCHAR(255))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE len INT;

    SET len = CHAR_LENGTH(p_str);
    WHILE i < len DO
        IF SUBSTRING(p_str, i, 1) = SUBSTRING(p_str, i+1, 1) THEN
            RETURN TRUE;  -- Characters are adjacent and the same
        END IF;
        SET i = i + 1;
    END WHILE;
    RETURN FALSE;  -- No adjacent characters are the same
END$$

DELIMITER ;
select fn_check_adjacent_characters('VNNHA');
             /*2. All five characters cannot form a sequence (like: ABCDE, BCDEF is
					invalid; ABCDX is valid)*/   
DROP FUNCTION IF EXISTS fn_check_sequential_characters;

DELIMITER $$

CREATE FUNCTION fn_check_sequential_characters(p_str VARCHAR(255))
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE len INT;

    SET len = CHAR_LENGTH(p_str);
    WHILE i < len DO
        IF ASCII(SUBSTRING(p_str, i, 1)) <> ASCII(SUBSTRING(p_str, i+1, 1))-1 THEN
            RETURN FALSE;  -- Characters are not sequential
        END IF;
        SET i = i + 1;
    END WHILE;
    RETURN TRUE; 
END$$

DELIMITER ;   
select fn_check_sequential_characters('ABCDX');                 
                    
			/*The next four characters should be numeric (digits).
					1. Adjacent characters(digits) cannot be the same (like 1123 is invalid;
					1923 is valid)
					2. All four characters cannot form a sequence (like: 1234, 2345)
					The last character should be alphabetic (uppercase letter).
					Example of a valid PAN: AHGVE1276F*/
DELIMITER $$

CREATE FUNCTION fn_check_adjacent_numbers(p_num INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE len INT;

    SET len = LENGTH(p_num);
    WHILE i < len DO
        IF SUBSTRING(p_num, i, 1) = SUBSTRING(p_num, i+1, 1) THEN
            RETURN TRUE;  -- Characters are adjacent and the same
        END IF;
        SET i = i + 1;
    END WHILE;
    RETURN FALSE;  -- No adjacent characters are the same
END$$

DELIMITER ;
select fn_check_adjacent_numbers(34681);
             
DROP FUNCTION IF EXISTS fn_check_sequential_numbers;

DELIMITER $$

CREATE FUNCTION fn_check_sequential_numbers(p_num INT)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE len INT;

    SET len = LENGTH(p_num);
    WHILE i < len DO
        IF SUBSTRING(p_num, i, 1) <> SUBSTRING(p_num, i+1, 1)-1 THEN
            RETURN FALSE;  -- Numbers are not sequential
        END IF;
        SET i = i + 1;
    END WHILE;
    RETURN TRUE; 
END$$

DELIMITER ;   
select fn_check_sequential_numbers(1224);                           

-- 3. Categorisation:
	/* Valid PAN: If the PAN number matches the above format.
	Invalid PAN: If the PAN number does not match the correct format, is
	incomplete, or contains any non-alphanumeric characters.*/ 
CREATE VIEW pan_card_validation_status AS
WITH cte_cleaned AS (
    SELECT DISTINCT UPPER(TRIM(Pan_numbers)) AS Pan_numbers
    FROM pan_card_validation
    WHERE Pan_numbers IS NOT NULL AND TRIM(Pan_numbers) <> ''
),
cte_valid AS (
    SELECT *
    FROM cte_cleaned
    WHERE fn_check_adjacent_characters(Pan_numbers) = FALSE
      AND fn_check_sequential_characters(SUBSTRING(Pan_numbers, 1, 5)) = FALSE
      AND fn_check_adjacent_characters(SUBSTRING(Pan_numbers, 6, 4)) = FALSE
      AND Pan_numbers REGEXP '^[A-Z]{5}[0-9]{4}[A-Z]$'
)
SELECT cc.Pan_numbers,
       CASE WHEN cv.Pan_numbers IS NOT NULL THEN 'Valid PAN'
            ELSE 'Invalid PAN'
       END AS category
FROM cte_cleaned cc
LEFT JOIN cte_valid cv
ON cc.Pan_numbers = cv.Pan_numbers;
 

  
    
-- 4. Tasks:
/* Validate the PAN numbers based on the format mentioned above.
1.Create two separate categories:
	Valid PAN
	Invalid PAN
2.Create a summary report that provides the following:
	Total records processed
	Total valid PANs
	Total invalid PANs
	Total missing or incomplete PANs (if applicable)    */ 
    


WITH cte as(
SELECT (SELECT COUNT(*) FROM pan_card_validation ) AS total_processed_report, 
    COUNT(CASE WHEN category = 'Valid PAN' THEN 1 END) AS total_valid_pans,
    COUNT(CASE WHEN category = 'Invalid PAN' THEN 1 END) AS total_Invalid_pans
FROM pan_card_validation_status)

SELECT total_processed_report,total_valid_pans,total_Invalid_pans,
total_processed_report -(total_valid_pans+total_Invalid_pans) AS total_missing_pans
FROM cte ;
