-- TABELA TRANSACAO
CREATE TABLE CaseDotz..TB_TRANSACAO
(
[Data] date,
CodigoCliente varchar(5),
CodigoParceiro varchar(3),
CodigoLoja nvarchar(4),
NumeroTicket varchar(5),
ValorTransacao float(20)
);

--DROP TABLE CaseDotz..TB_TRANSACAO

-- INSERINDO VALORES TABELA TRANSACAO
INSERT INTO CaseDotz..TB_TRANSACAO 
([Data], CodigoCliente, CodigoParceiro, CodigoLoja, NumeroTicket, ValorTransacao)
VALUES 
('2017-08-15', '12321', '554', '1021', '55487', 12.5),
('2018-05-23', '45653', '554', '1356', '65983', 58.9),
('2017-12-20', '87549', '784', '5462', '82946', 187.2)
INSERT INTO CaseDotz..TB_TRANSACAO 
VALUES
('2018-09-12', '54893', '784', '4532', '69874', 32.5)

SELECT * FROM CaseDotz..TB_TRANSACAO

-- TABELA PARCEIRO

CREATE TABLE CaseDotz..TB_PARCEIRO
(
CodigoParceiro varchar(3),
NomeParceiro varchar(20),
EstadoParceiro varchar(2),
RegionalParceiro varchar(20)
);

--DROP TABLE TB_PARCEIRO

-- INSERINDO VALORES TABELA PARCEIRO
INSERT INTO CaseDotz..TB_PARCEIRO
(CodigoParceiro, NomeParceiro, EstadoParceiro, RegionalParceiro)
VALUES 
('554', 'ParceiroX', 'SP', 'São Paulo'),
('875', 'ParceiroY', 'MG', 'Belo Horizonte'),
('784', 'ParceiroW', 'SC', 'Florianopolis')

SELECT * FROM CaseDotz..TB_PARCEIRO

-- TABELA CLIENTE
CREATE TABLE CaseDotz..TB_CLIENTE
(
CodigoCliente varchar(5),
NomeCliente varchar(20),
EstadoCliente varchar(2),
GeneroCliente varchar(20)
);

--DROP TABLE TB_CLIENTE

-- INSERINDO VALORES TABELA CLIENTE
INSERT INTO CaseDotz..TB_CLIENTE
(CodigoCliente, NomeCliente, EstadoCliente, GeneroCliente)
VALUES 
('12321', 'ClienteA', 'SP', 'Feminino'),
('45653', 'ClienteB', 'MG', 'Feminino'),
('87549', 'ClienteC', 'SC', 'Masculino')
INSERT INTO CaseDotz..TB_CLIENTE
VALUES
('11196', 'ClienteF', 'MG', 'Feminino')

SELECT * FROM CaseDotz..TB_CLIENTE

-- TABELA TRANSAÇÃO PRODUTOS
CREATE TABLE CaseDotz..TB_TRANSACAO_PRODUTOS
(
[Data] date,
CodigoCliente varchar(5),
CodigoParceiro varchar(3),
CodigoLoja nvarchar(4),
CodigoProduto varchar(5),
Quantidade int,
ValorUnitario float(20)
);

--DROP TABLE CaseDotz..TB_TRANSACAO_PRODUTOS

-- INSERINDO VALORES TABELA TRANSACAO PRODUTOS
INSERT INTO CaseDotz..TB_TRANSACAO_PRODUTOS
([Data], CodigoCliente, CodigoParceiro, CodigoLoja, CodigoProduto, Quantidade, ValorUnitario)
VALUES 
('2017-08-18', '54893', '554', '1021', '98763', 2, 4.9),
('2018-06-23', '55587', '875', '8742', '87411', 5, 1.5),
('2017-11-29', '11196', '784', '5462', '58963', 1, 12.7)

SELECT * FROM CaseDotz..TB_TRANSACAO_PRODUTOS

--TABELA PRODUTOS
CREATE TABLE CaseDotz..TB_PRODUTOS
(
CodigoParceiro varchar(3),
CodigoProduto varchar(5),
Categoria1 varchar(20),
Categoria2 varchar(20),
NomeProduto varchar(50),
Marca varchar(20)
);

--DROP TABLE CaseDotz..TB_PRODUTOS

-- INSERINDO VALORES TABELA PRODUTOS
INSERT INTO CaseDotz..TB_PRODUTOS
(CodigoParceiro, CodigoProduto, Categoria1, Categoria2, NomeProduto, Marca)
VALUES 
('554', '98763', 'Mercearia', 'Limpeza', 'Amaciante Comfort 1L', 'Comfort'),
('875', '87411', 'Mercearia', 'Benidas', 'Refrig.Coca-Cola 2L', 'Coca'),
('784', '58963', 'Pereciveis', 'Acougue', 'Peça Picanha Embalada Kg', 'Friboi')

SELECT * FROM CaseDotz..TB_PRODUTOS

--QUESTOES

--Produza o script para extrair, do último ano (considerar apenas 2017), qual o número de clientes, tickets, 
--valor total, e gasto médio MENSAL do cliente, por parceiro, trazendo qual o nome deste parceiro e sua
--regional.

SELECT COUNT(t.CodigoCliente) AS num_clientes,
	   t.NumeroTicket,
	   ROUND(SUM(t.ValorTransacao),2) AS valor_total,
       YEAR(t.[data]) AS ANO,
	   MONTH(t.[data]) AS MÊS,
	   (SUM(t.ValorTransacao)/COUNT(t.ValorTransacao)) AS gasto_medio,
	   p.NomeParceiro,
	   p.RegionalParceiro
FROM CaseDotz..TB_TRANSACAO AS t
JOIN CaseDotz..TB_PARCEIRO AS p
ON t.CodigoParceiro=p.CodigoParceiro
WHERE YEAR(t.[data]) = '2017'
GROUP BY p.NomeParceiro, p.RegionalParceiro, YEAR(t.[data]), MONTH(t.[data]), t.NumeroTicket

--Escreva o script que traga as 10 categorias nível 2 mais compradas (ocorrência de tickets distintos)
--no ParceiroW por clientes do sexo Feminino.

SELECT TOP(10) pr.Categoria2,
       tp.Quantidade,
	   (SELECT DISTINCT t.NumeroTicket) AS NumeroTicket,
	   tp.CodigoParceiro,
	   tp.CodigoCliente,
	   c.GeneroCliente
FROM CaseDotz..TB_TRANSACAO_PRODUTOS AS tp
JOIN CaseDotz..TB_PRODUTOS AS pr
ON tp.CodigoProduto = pr.CodigoProduto
JOIN CaseDotz..TB_TRANSACAO AS t
ON tp.CodigoParceiro = t.CodigoParceiro
JOIN CaseDotz..TB_CLIENTE AS c
ON tp.CodigoCliente = c.CodigoCliente
WHERE tp.CodigoParceiro = '784' AND c.GeneroCliente = 'Feminino'
ORDER BY tp.Quantidade

--Extraia quais as marcas que venderam mais de 15 unidades durante o período natalino de 2019 
--(considerar de 20 a 25 de dezembro).

SELECT pr.Marca,
       tp.Quantidade
FROM CaseDotz..TB_PRODUTOS AS pr
JOIN CaseDotz..TB_TRANSACAO_PRODUTOS AS tp
ON pr.CodigoProduto = tp.CodigoProduto
WHERE tp.Quantidade >= 15 AND tp.[Data] >= '2019-12-20' AND tp.[Data] <= '2019-12-25'

--Extraia por mês, quantos clientes NOVOS entraram desde 2018, no ParceiroY, e quantos desses 
--novos, apresentaram recorrência dentro de 6 meses, ou seja, voltaram a comprar no mesmo local
--no período de 6 meses após a primeira compra.

-- TO BE WORKED --
CREATE VIEW velhos_clientes
AS
SELECT YEAR([data]) AS Ano,
       MONTH([data]) AS Mês,
	   CodigoCliente
FROM CaseDotz..TB_TRANSACAO
WHERE YEAR([data]) < '2018'

SELECT * FROM velhos_clientes

SELECT YEAR(t.[data]) AS Ano,
       MONTH(t.[data]) AS Mês,
	(CASE
	   WHEN t.CodigoCliente != (SELECT CodigoCliente FROM velhos_clientes) THEN COUNT(t.CodigoCliente)
	   ELSE 'Não há'
	 END) AS contagem
FROM CaseDotz..TB_TRANSACAO AS t
JOIN CaseDotz..TB_PARCEIRO AS p
ON t.CodigoParceiro = p.CodigoParceiro
WHERE YEAR(t.[data]) >= '2018'
GROUP BY YEAR(t.[data]), MONTH(t.[data])
