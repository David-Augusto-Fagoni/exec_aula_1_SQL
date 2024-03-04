/*Uma empresa tem clientes, fornecedores e funcionários.
Considere o MER abaixo do domínio de palestras em uma Faculdade. Palestrantes apresentarão 
palestras para alunos e não alunos. Para o caso de alunos, seus dados já são referenciáveis em 
outro sistema, portanto, basta saber seu RA, no entanto, para não alunos, para prover 
certificados, é importante saber seu RG e Órgão Expedidor. 
O problema está no momento de gerar a lista de presença. A lista de presença deverá vir de uma 
consulta que retorna (Num_Documento, Nome_Pessoa, Titulo_Palestra, Nome_Palestrante, 
Carga_Horária e Data). A lista deverá ser uma só, por palestra (A condição da consulta é o código 
da palestra) e contemplar alunos e não alunos (O Num_Documento se referencia ao RA para 
alunos e RG + Orgao_Exp para não alunos) e estar ordenada pelo Nome_Pessoa.
*/
 
CREATE DATABASE exec_aula_1
GO
USE exec_aula_1
GO
 
CREATE TABLE curso (
Codigo_Curso	INT				NOT NULL,
Nome			VARCHAR(70)		NOT NULL,
Sigla			VARCHAR(10)		NOT NULL
PRIMARY KEY (Codigo_Curso)
)
GO
CREATE TABLE aluno (
Ra				CHAR(7)			NOT NULL,
Nome			VARCHAR(250)	NOT NULL,
Codigo_Curso	INT				NOT NULL
PRIMARY KEY (Ra)
FOREIGN KEY (Codigo_Curso) REFERENCES curso(Codigo_Curso)
)
GO
CREATE TABLE palestrante ( 
Codigo_Palestrante		INT				IDENTITY,
Nome					VARCHAR(250)	NOT NULL,
Empresa					VARCHAR(100)	NOT NULL
PRIMARY KEY (Codigo_Palestrante)
)
GO
CREATE TABLE nao_alunos (
RG			VARCHAR(9)		NOT NULL,
Orgao_Exp	CHAR(5)			NOT NULL,
Nome		VARCHAR(250)	NOT NULL
PRIMARY KEY (RG, Orgao_Exp)
)
GO
CREATE TABLE palestra( 
Codigo_Palestra		INT			IDENTITY,
Titulo				VARCHAR(MAX)	NOT NULL,
Carga_Horaria		INT				NOT NULL,
Datas				DATETIME		NOT NULL,
Codigo_Palestrante	INT				NOT NULL
PRIMARY KEY (Codigo_Palestra)
FOREIGN KEY (Codigo_Palestrante) REFERENCES palestrante(Codigo_Palestrante)
)
GO
CREATE TABLE nao_alunos_inscritos (
Codigo_Palestra		INT			NOT NULL,
RG					VARCHAR(9)	NOT NULL,
Orgao_Exp			CHAR(5)		NOT NULL
PRIMARY KEY (Codigo_Palestra,RG,Orgao_Exp)
FOREIGN KEY	(Codigo_Palestra) REFERENCES palestra(Codigo_Palestra),
FOREIGN KEY	(RG,Orgao_Exp) REFERENCES nao_alunos(RG,Orgao_Exp)
)
GO
CREATE TABLE alunos_inscritos (
Ra					CHAR(7)		NOT NULL,
Codigo_Palestra		INT			NOT NULL
PRIMARY KEY (Ra, Codigo_Palestra)
FOREIGN KEY (Ra) REFERENCES aluno(Ra),
FOREIGN KEY (Codigo_Palestra) REFERENCES palestra(Codigo_Palestra)
)
 
SELECT * FROM nao_alunos
SELECT * FROM palestrante
SELECT * FROM curso
SELECT * FROM aluno
SELECT * FROM palestra
SELECT * FROM nao_alunos_inscritos
 
INSERT INTO curso (Codigo_Curso, nome, sigla) 
VALUES 
    (1, 'Engenharia Elétrica', 'EE'),
    (2, 'Ciência da Computação', 'CC'),
    (3, 'Administração', 'ADM');
-- Inserir dados na tabela aluno
INSERT INTO aluno (ra, nome, Codigo_Curso) 
VALUES 
    ('1234567', 'João Silva', 1),
    ('2345678', 'Maria Souza', 2),
    ('3456789', 'Pedro Santos', 1);
-- Inserir dados na tabela nao_alunos
INSERT INTO nao_alunos (rg, orgao_exp, nome) 
VALUES 
    ('123456789', 'SSP', 'José Oliveira'),
    ('234567890', 'SSP', 'Ana Pereira');
-- Inserir dados na tabela palestrante
INSERT INTO palestrante (nome, empresa) 
VALUES 
    ('Carlos Oliveira', 'Tech Solutions'),
    ('Ana Santos', 'Data Analysis Co.');
-- Inserir dados na tabela palestra
INSERT INTO palestra (Titulo, Carga_Horaria, Datas, Codigo_Palestrante) 
VALUES 
    ('Gestão de Projetos Ágeis', 1, '10-03-2024', 2),
    ('Introdução à Inteligência Artificial', 2,	'20-03-2023', 1)
 

-- Inserir dados na tabela nao_alunos_inscritos
INSERT INTO nao_alunos_inscritos (Codigo_Palestra, rg, orgao_exp) 
VALUES 
    (1, '123456789', 'SSP'),
    (2, '234567890', 'SSP');
-- Inserir dados na tabela alunos_inscritos
INSERT INTO alunos_inscritos (ra, Codigo_Palestra) 
VALUES 
    ('1234567', 1),
    ('2345678', 2)
 
CREATE VIEW palestra_escola AS
	SELECT a.Ra as Num_Documento, a.Nome as Nome_Pessoa, p.Titulo as Titulo_Palestra, pa.Nome as Nome_Palestrante, p.Carga_Horaria as Carga_Horária, p.Datas as Datas, 'Aluno' as Tipo
	FROM aluno a, alunos_inscritos ai, palestra p, palestrante pa
	WHERE a.Ra = ai.Ra AND ai.Codigo_Palestra = p.Codigo_Palestrante AND p.Codigo_Palestrante = pa.Codigo_Palestrante
	UNION
	SELECT CONCAT(na.RG,na.Orgao_Exp) AS Num_Documento,na.Nome as Nome_Pessoa, p.Titulo as Titulo_Palestra, pa.Nome as Nome_Palestrante, p.Carga_Horaria as Carga_Horária, p.Datas as Datas, 'Não Aluno' as Tipo
	FROM nao_alunos na, nao_alunos_inscritos nai,palestra p, palestrante pa
	WHERE (nai.rg = na.rg AND nai.orgao_exp = na.orgao_exp) AND nai.Codigo_Palestra = p.Codigo_Palestra AND p.Codigo_Palestrante  = pa.Codigo_Palestrante

SELECT * FROM palestra_escola
ORDER BY Tipo ASC




