# 📘 Projeto SQL Server – DB2NEY

Este repositório contém um exemplo completo de modelagem e integração de dados no **SQL Server**, utilizando:
- DDL (CREATE / ALTER)
- DML (INSERT)
- VIEW
- MERGE

---

## 🗄️ Script SQL Original (Completo)

```sql
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

INSERT INTO REEM(
    cod_receita,
    cod_reg,
    cod_dv_seq_1,
    cod_dv_seq_2,
    nome
) 
VALUES (34,21,12,34,'Gilbon');

ALTER TABLE REEM ADD VLR DECIMAL(4,3) DEFAULT 0.0;

INSERT INTO PREST(COD_PREST, IFANTS) 
VALUES (34211234, 'Menino ney');

CREATE VIEW TB_REEM_V AS 
SELECT 
    CAST(CONCAT(cod_receita,cod_reg,cod_dv_seq_1,cod_dv_seq_2) AS INT) AS COD_PREST,
    nome AS IFANTS, 
    VLR 
FROM REEM;

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
```

---

## 📋 Estrutura da Tabela PREST

| Coluna     | Tipo         | Regra |
|----------|--------------|------|
| COD_PREST | INT | PK / > 0 |
| IFANTS | VARCHAR(255) | Nome |
| VLR | DECIMAL(4,3) | Valor |

---

## 📋 Estrutura da Tabela REEM

| Coluna | Tipo |
|------|------|
| cod_receita | INT |
| cod_reg | INT |
| cod_dv_seq_1 | INT |
| cod_dv_seq_2 | INT |
| nome | VARCHAR(255) |
| VLR | DECIMAL(4,3) |

### 🔑 Chave Primária Composta
- cod_receita  
- cod_reg  
- cod_dv_seq_1  
- cod_dv_seq_2  

---

## 👁️ View `TB_REEM_V`

### Objetivo
A view cria um **COD_PREST único** concatenando os campos da tabela `REEM`, permitindo integração com a tabela `PREST`.

| Campo | Origem |
|----|------|
| COD_PREST | CONCAT(cod_receita, cod_reg, cod_dv_seq_1, cod_dv_seq_2) |
| IFANTS | nome |
| VLR | VLR |

---

## 🔄 MERGE – Integração de Dados

### Lógica do MERGE

| Situação | Ação |
|-------|------|
| Registro existe | UPDATE |
| Registro não existe | INSERT |

O comando `MERGE` sincroniza os dados da view `TB_REEM_V` com a tabela `PREST`.

---

## ✅ Conclusão

Este projeto demonstra:
- Criação de banco de dados
- Uso de constraints
- Chaves primárias simples e compostas
- Criação de VIEW
- MERGE para carga incremental

Projeto ideal para **estudo**, **aulas** e **versionamento no GitHub**.
