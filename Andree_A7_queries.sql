#Question 1
USE ischool_v2;

DROP TABLE IF EXISTS new_person_records;
CREATE TABLE `new_person_records` (
`new_person_record_id` int(11) NOT NULL AUTO_INCREMENT, 
`new_person_record_text` varchar(300) DEFAULT NULL,  
`new_person_record_timestamp` datetime DEFAULT NULL, PRIMARY 
KEY (`new_person_record_id`)
) ENGINE=InnoDB;  

DROP TRIGGER IF EXISTS ischool_v2.new_person;

DELIMITER //

CREATE TRIGGER ischool_v2.new_person
AFTER INSERT ON people
FOR EACH ROW

BEGIN
	DECLARE person_id_var INT;
    DECLARE last_name VARCHAR(50);
    DECLARE first_name VARCHAR(50);
    DECLARE department VARCHAR(90);
    DECLARE college varchar(50);
    
	SET person_id_var = NEW.person_id;
    SET last_name = NEW.lname;
    SET first_name = NEW.fname;
    SET department = NEW.department;
    SET college = NEW.college;
    
	INSERT INTO new_person_records VALUES(person_id_var, CONCAT('You have added a new person, ', first_name,' ,', last_name,
    ' who is affiliated with ', department,' in the ', college), SYSDATE());
END//

DELIMITER ;


INSERT INTO ischool_v2.people VALUES (7, 'Potter','Harry', 'potter@umd.edu', 'College of Information Studies', 'MIM',NULL,NOW());

SELECT * FROM new_person_records;



#Question 2
USE ischool_v2;

DROP FUNCTION IF EXISTS get_person_pronouns;

DELIMITER //

CREATE FUNCTION get_person_pronouns (
    first_name_param VARCHAR(50),
    last_name_param VARCHAR(50)
    )
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN 
    DECLARE pronouns_var VARCHAR(50);
    SELECT pronoun 
    INTO pronouns_var
    FROM people
    JOIN person_pronoun USING(person_id)
    JOIN pronouns USING(pronoun_id)
    WHERE fname = first_name_param AND lname = last_name_param;
    
    RETURN(pronouns_var);
END //
DELIMITER ;

SELECT get_person_pronouns("Kamala","Khan");

