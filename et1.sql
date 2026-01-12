CREATE DATABASE DB2NEY;

USE DB2NEY; 

CREATE TABLE PREST(
	COD_PREST INT,
	IFANTS   VARCHAR(255),
	
	CONSTRAINT ck check(COD_PREST>0),
	CONSTRAINT pk_cod primary key(COD_PREST)
);

ALTER TABLE PREST  ADD  VLR DECIMAL(4,3);

CREATE TABLE REEM (
	cod_receita int,
	cod_reg int,
	cod_dv_seq_1 int,
	cod_dv_seq_2 int,
	nome varchar(255),
	constraint pk_composta primary key(cod_receita,cod_reg,cod_dv_seq_1,cod_dv_seq_2)

);

INSERT INTO REEM(cod_receita,cod_reg,cod_dv_seq_1,cod_dv_seq_2,nome) values(34,21,12,34,'Gilbon');

ALTER TABLE REEM ADD VLR DECIMAL(4,3) DEFAULT 0.0
 

INSERT INTO PREST(COD_PREST, IFANTS) VALUES(34211234, 'Menino ney');

 
CREATE VIEW TB_REEM_V AS SELECT cast(CONCAT(cod_receita,cod_reg,cod_dv_seq_1,cod_dv_seq_2) as int )
AS COD_PREST,nome AS IFANTS, VLR FROM REEM;

MERGE INTO PREST AS ALVO
USING TB_REEM_V AS origem
ON origem.COD_PREST = ALVO.COD_PREST

WHEN MATCHED THEN 
    UPDATE SET 
        ALVO.COD_PREST = origem.COD_PREST,
        ALVO.IFANTS   = origem.IFANTS,
        ALVO.VLR      = origem.VLR

WHEN NOT MATCHED BY TARGET THEN
    INSERT (COD_PREST, IFANTS, VLR)
    VALUES (origem.COD_PREST, origem.IFANTS, origem.VLR);
