-- Atualização do script da base (v1.1)
-- Pequenos ajustes no modelo da livraria/cafeteria

-- =========================================
-- Produtos
-- =========================================
CREATE TABLE Produtos (
    produto_id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0
);

-- Adicionei categoria e flag de ativo pra melhorar o controle
ALTER TABLE Produtos ADD categoria VARCHAR(50) DEFAULT 'Geral';
ALTER TABLE Produtos ADD ativo BOOLEAN DEFAULT TRUE;

-- =========================================
-- Pedidos
-- =========================================
CREATE TABLE Pedidos (
    pedido_id INT PRIMARY KEY,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Pendente'
);

-- Mudei o tamanho do campo status só pra deixar mais padrão
ALTER TABLE Pedidos MODIFY status VARCHAR(30) NOT NULL DEFAULT 'Pendente';

-- =========================================
-- Itens do Pedido
-- =========================================
CREATE TABLE Itens_Pedido (
    item_pedido_id INT PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(produto_id)
);

-- =========================================
-- Dados iniciais
-- =========================================
INSERT INTO Produtos (produto_id, nome, descricao, preco, estoque) VALUES
(1, 'Café Expresso', 'Grãos selecionados, torra média.', 5.50, 150),
(2, 'Livro: O Guia do Mochileiro das Galáxias', 'Ficção científica clássica.', 45.90, 50),
(3, 'Bolo de Cenoura', 'Fatia de bolo caseiro com cobertura de chocolate.', 12.00, 30);

INSERT INTO Pedidos (pedido_id, data_pedido, valor_total, status) VALUES
(101, '2025-11-03', 57.90, 'Concluído'),
(102, '2025-11-03', 12.00, 'Pendente'),
(103, '2025-11-02', 45.90, 'Enviado');

INSERT INTO Itens_Pedido (item_pedido_id, pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 101, 1, 2, 5.50),
(2, 101, 2, 1, 45.90),
(3, 102, 3, 1, 12.00),
(4, 103, 2, 1, 45.90);

-- =========================================
-- Novas inserções e ajustes
-- =========================================
-- Adicionei um novo produto e um pedido só pra testar
INSERT INTO Produtos (produto_id, nome, descricao, preco, estoque, categoria) VALUES
(4, 'Cappuccino', 'Bebida cremosa com leite vaporizado e canela.', 8.90, 80, 'Bebidas');

INSERT INTO Pedidos (pedido_id, data_pedido, valor_total, status) VALUES
(104, CURRENT_DATE, 8.90, 'Concluído');

INSERT INTO Itens_Pedido (item_pedido_id, pedido_id, produto_id, quantidade, preco_unitario)
VALUES (5, 104, 4, 1, 8.90);

-- Atualizei o estoque do livro porque chegou mais unidades
UPDATE Produtos
SET estoque = estoque + 20
WHERE nome = 'Livro: O Guia do Mochileiro das Galáxias';

-- =========================================
-- Consultas rápidas
-- =========================================

-- Produtos com bom estoque
SELECT nome, categoria, preco, estoque
FROM Produtos
WHERE estoque > 50
ORDER BY categoria, nome;

-- Resumo geral dos pedidos
SELECT
    P.pedido_id,
    P.data_pedido,
    P.status,
    SUM(IP.quantidade * IP.preco_unitario) AS valor_calculado
FROM Pedidos P
JOIN Itens_Pedido IP ON P.pedido_id = IP.pedido_id
GROUP BY P.pedido_id, P.data_pedido, P.status
ORDER BY P.data_pedido DESC;

-- Pedidos do dia atual
SELECT pedido_id, valor_total, status
FROM Pedidos
WHERE data_pedido = CURRENT_DATE;

-- =========================================
-- Updates pontuais
-- =========================================
UPDATE Produtos
SET preco = preco * 1.10
WHERE nome = 'Café Expresso'; -- aumentei 10%

UPDATE Pedidos
SET status = 'Processando'
WHERE pedido_id = 102;

-- Marquei o bolo como inativo ao invés de deletar
UPDATE Produtos
SET ativo = FALSE
WHERE nome = 'Bolo de Cenoura';

-- =========================================
-- Delete (só se precisar limpar algum vínculo)
-- =========================================
DELETE FROM Itens_Pedido WHERE produto_id = 3;
