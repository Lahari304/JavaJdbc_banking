--------------------------------------------------------
--  File created - Wednesday-July-20-2022   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table BANK
--------------------------------------------------------

  CREATE TABLE "SCOTT"."BANK" 
   (	"ACC_NO" NUMBER(6,0), 
	"USER_NAME" VARCHAR2(10 BYTE), 
	"AUTH_PIN" VARCHAR2(4 BYTE), 
	"BALANCE" NUMBER(10,2) DEFAULT 0
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Function CHECKBAL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCOTT"."CHECKBAL" 
(ACNO IN NUMBER, PIN IN NUMBER) 
RETURN NUMBER AS 

AC BANK%ROWTYPE;

BEGIN

    SELECT * INTO AC FROM BANK WHERE ACC_NO = ACNO;
    
    IF AC.acc_no IS NULL OR AC.AUTH_PIN != PIN THEN RETURN -1;
    END IF;
    
    RETURN AC.BALANCE;
    
END CHECKBAL;

/
--------------------------------------------------------
--  DDL for Function CREATEACC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCOTT"."CREATEACC" 
(
  UNAME IN VARCHAR2 , PIN IN NUMBER
) RETURN NUMBER AS 
LAST_NUM BANK.acc_no%TYPE;
OCCURS NUMBER(1);
BEGIN

    SELECT COUNT(*) INTO OCCURS FROM (SELECT * FROM BANK WHERE USER_NAME = UNAME);
    IF (OCCURS = 1) THEN
            RETURN 0;
        END IF;
    
    SELECT COUNT(*) INTO LAST_NUM FROM BANK;
    INSERT INTO BANK VALUES((LAST_NUM+100000), UNAME, PIN, 0);
    RETURN LAST_NUM+100000;
END CREATEACC;

/
--------------------------------------------------------
--  DDL for Function CREATEACC1
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCOTT"."CREATEACC1" 
(
  UNAME IN VARCHAR2 , PIN IN NUMBER
) RETURN BOOLEAN AS 
LAST_NUM BANK.acc_no%TYPE;
OCCURS NUMBER(1);
BEGIN

    SELECT COUNT(*) INTO OCCURS FROM (SELECT * FROM BANK WHERE USER_NAME = UNAME);
    IF (OCCURS = 1) THEN
            RETURN FALSE;
        END IF;
    
    SELECT COUNT(*) INTO LAST_NUM FROM BANK;
    INSERT INTO BANK VALUES((LAST_NUM+100000), UNAME, PIN, 0);
    RETURN TRUE;
END CREATEACC1;

/
--------------------------------------------------------
--  DDL for Function DEPOSIT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCOTT"."DEPOSIT" 
(
  ACNO IN NUMBER , 
  PIN IN NUMBER ,
  AMOUNT IN NUMBER
) RETURN NUMBER AS 

CUR_BAL bank.balance%TYPE;

BEGIN

    CUR_BAL := CHECKBAL(ACNO, PIN);
    IF CUR_BAL = -1 THEN RETURN -1;
    END IF;
    
    UPDATE BANK
    SET BALANCE = BALANCE + AMOUNT
    WHERE ACC_NO = ACNO;
    
  RETURN CUR_BAL+AMOUNT;
END DEPOSIT;

/
--------------------------------------------------------
--  DDL for Function WITHDRAWAL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCOTT"."WITHDRAWAL" 
(
  ACNO IN NUMBER ,
  PIN IN NUMBER ,
  AMOUNT IN NUMBER
) RETURN NUMBER AS 

CUR_BAL bank.balance%TYPE;
BEGIN

    CUR_BAL:= CHECKBAL(ACNO, PIN);
    
    IF CUR_BAL = -1 OR CUR_BAL < AMOUNT THEN RETURN CUR_BAL;
    END IF;
    
    UPDATE BANK 
    SET BALANCE = BALANCE - AMOUNT
    WHERE ACC_NO = ACNO;
    
  RETURN CHECKBAL(ACNO, PIN);
END WITHDRAWAL;

/
--------------------------------------------------------
--------------------------------------------------------
--  Constraints for Table BANK
--------------------------------------------------------

  ALTER TABLE "SCOTT"."BANK" ADD PRIMARY KEY ("ACC_NO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
 
  ALTER TABLE "SCOTT"."BANK" ADD UNIQUE ("USER_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE;
--------------------------------------------------------