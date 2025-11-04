-- Criação do esquema de banco de dados para um pequeno comércio (Livraria/Cafeteria)

-- 1. Tabela de Produtos
-- Armazena informações sobre os itens disponíveis para venda.
CREATE TABLE Produtos (
    produto_id INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL DEFAULT 0
);

-- 2. Tabela de Pedidos
-- Armazena informações sobre os pedidos feitos pelos clientes.
CREATE TABLE Pedidos (
    pedido_id INT PRIMARY KEY,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'Pendente'
);

-- 3. Tabela de Itens_Pedido (Tabela de relacionamento N:M entre Produtos e Pedidos)
-- Armazena os detalhes de quais produtos estão em quais pedidos.
CREATE TABLE Itens_Pedido (
    item_pedido_id INT PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(produto_id)
);

-- Inserção de dados de exemplo

-- Inserir pelo menos 3 registros na tabela Produtos
INSERT INTO Produtos (produto_id, nome, descricao, preco, estoque) VALUES
(1, 'Café Expresso', 'Grãos selecionados, torra média.', 5.50, 150),
(2, 'Livro: O Guia do Mochileiro das Galáxias', 'Ficção científica clássica.', 45.90, 50),
(3, 'Bolo de Cenoura', 'Fatia de bolo caseiro com cobertura de chocolate.', 12.00, 30);

-- Inserir pelo menos 3 registros na tabela Pedidos
INSERT INTO Pedidos (pedido_id, data_pedido, valor_total, status) VALUES
(101, '2025-11-03', 57.90, 'Concluído'),
(102, '2025-11-03', 12.00, 'Pendente'),
(103, '2025-11-02', 45.90, 'Enviado');

-- Inserir dados na tabela Itens_Pedido para relacionar Produtos e Pedidos
INSERT INTO Itens_Pedido (item_pedido_id, pedido_id, produto_id, quantidade, preco_unitario) VALUES
(1, 101, 1, 2, 5.50),    -- 2 Cafés Expresso no Pedido 101
(2, 101, 2, 1, 45.90),   -- 1 Livro no Pedido 101
(3, 102, 3, 1, 12.00),   -- 1 Bolo de Cenoura no Pedido 102
(4, 103, 2, 1, 45.90);   -- 1 Livro no Pedido 103

-- Exemplo de consulta (opcional, mas útil para demonstrar o relacionamento)
-- SELECT
--     P.pedido_id,
--     P.data_pedido,
--     P.status,
--     PR.nome AS nome_produto,
--     IP.quantidade,
--     IP.preco_unitario
-- FROM Pedidos P
-- JOIN Itens_Pedido IP ON P.pedido_id = IP.pedido_id
-- JOIN Produtos PR ON IP.produto_id = PR.produto_id
-- WHERE P.pedido_id = 101;
