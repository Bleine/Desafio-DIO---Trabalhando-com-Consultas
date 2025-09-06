-- criação do banco de dados para o cenário de e-commerce

drop database if exists ecommerce;
create database ecommerce;
use ecommerce;

show tables;
desc referential_constraints where constraint_schema = 'ecommerce';

-- criar tabela cliente
create table clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
    Minit char(3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(255),
    constraint unique_cpf_client unique (CPF)
);

alter table clients auto_increment=1;

-- criar tabela pedido
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado','Confirmado','Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash boolean default false,
    constraint fk_ordes_client foreign key (idOrderClient) references clients(idClient)
);

-- para ser continuado no desafio: tabela payment e criar constraits relacionadas a pagamento.
-- criar tabela pagamento
create table payments(
	idClient int,
    idPayment int auto_increment primary key,
    typePayment enum('Boleto','Cartão','Dois Cartões'),
    limitAvailable float,
	constraint fk_payment_client foreign key (idClient) references clients(idClient)
);


-- criar tabela produtos
-- size = dimensão do produto
create table products(
	idProduct int auto_increment primary key,
    Pname varchar(10),
    classification_kids bool default false,
    category enum('Eletrônico','Vestimenta','Brinquedos','Alimentos','Móveis') not null,
    avaliação float default 0,
    size varchar(10)    
    );


-- criar tabela terceiros vendedor
create table seller(
	idSeller int auto_increment primary key,
    socialName varchar(255) not null,
    abstName varchar(255),
	cnpj char(15),
    cpf char(11),
    location varchar(255),
    contact char(11) not null,
    constraint unique_seller_cnpj unique (cnpj),
    constraint unique_seller_cpf unique (cpf)
);


-- criar tabela fornecedor
create table supplier(
	idSupplier int auto_increment primary key,
    socialName varchar(255) not null,
	cnpj char(15) not null,
    contact char(11) not null,
    constraint unique_supplier unique (cnpj)
);

-- criar tabela estoque
create table productStorage(
	idProdStorage int auto_increment primary key,
    storageLocation varchar(255),
    quantity int default 0
);

-- criar tabela relação tabelas produtos e vendedor(terceiros)
create table productSeller(
	idPSeller int,
    idPproduct int,
    prodQuantity int default 1,
    primary key (idPseller, idPproduct),
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPproduct) references products(idProduct)
    );
    
    -- criar tabela (relação produto e pedido)
create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    constraint fk_productorder_product foreign key (idPOproduct) references products(idProduct),
    constraint fk_productorder_order foreign key (idPOorder) references orders(idOrder)
);


    -- criar tabela (relação estoque e produto)
create table storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
	primary key (idLproduct, idLstorage),
    constraint fk_storage_location_product foreign key (idLproduct) references products(idProduct),
    constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage)
    );

    -- criar tabela (relação fornecedor e produto)
create table storageSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
	primary key (idPsSupplier, idPsProduct),
    constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier),
    constraint fk_product_supplier_product foreign key (idPsProduct) references products(idProduct)
    );
    
    
    -- ----------------------------------------- INSERT TO -------------------------------------------------------------------------------------------------------------------
    
    -- dados insert
    
insert into clients (Fname, Minit, Lname, CPF, Address)
values 
  ('Ana', 'M.', 'Silva', '12345678901', 'Rua das Flores, 123 - São Paulo, SP'),
  ('Bruno', 'L.', 'Oliveira', '23456789012', 'Av. Paulista, 1000 - São Paulo, SP'),
  ('Carla', 'R.', 'Souza', '34567890123', 'Rua A, 10 - Rio de Janeiro, RJ'),
  ('Diego', 'F.', 'Santos', '45678901234', 'Rua B, 20 - Belo Horizonte, MG'),
  ('Elisa', 'A.', 'Pereira', '56789012345', 'Rua C, 30 - Porto Alegre, RS');
  
  SELECT * FROM clients;


insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
values
  (1, 'Confirmado', 'Compra de eletrônicos e vestuário', 15.50, true),
  (2, 'Em processamento', 'Compra de brinquedos', 12.00, false),
  (3, 'Cancelado', 'Pedido cancelado pelo cliente', 0, false),
  (4, 'Confirmado', 'Compra de alimentos', 8.75, true),
  (5, 'Em processamento', 'Compra de móveis', 25.00, false);
  
SELECT * FROM orders;

insert into payments (idClient, typePayment, limitAvailable)
values
  (1, 'Cartão', 3000.00),
  (2, 'Boleto', 0.00),
  (3, 'Dois Cartões', 5000.00),
  (4, 'Cartão', 1200.00),
  (5, 'Cartão', 2500.00);

SELECT * FROM payments;


insert into products (Pname, classification_kids, category, avaliação, size)
values
  ('Fone JBL', false, 'Eletrônico', 4.5, 'Único'),
  ('Camiseta', false, 'Vestimenta', 4.2, 'M'),
  ('Lego Kit', true, 'Brinquedos', 4.8, 'Médio'),
  ('Arroz 5kg', false, 'Alimentos', 4.0, '5kg'),
  ('Sofá 2L', false, 'Móveis', 4.6, '2L');
  
  SELECT * FROM products;


insert into seller (socialName, abstName, cnpj, cpf, location, contact)
values
  ('Tech Comércio Eletrônico Ltda', 'Tech Store', '12345678000199', null, 'São Paulo - SP', '11999999999'),
  ('Loja das Roupas Ltda', 'Roupas e Estilo', '22345678000188', null, 'Rio de Janeiro - RJ', '21988888888'),
  ('Brinquedos Felizes ME', 'Happy Toys', '32345678000177', null, 'Belo Horizonte - MG', '31977777777'),
  ('João da Silva', null, null, '12345678901', 'Curitiba - PR', '41966666666'),
  ('Maria Oliveira', null, null, '23456789012', 'Salvador - BA', '71955555555');

SELECT * FROM seller;


insert into supplier (socialName, cnpj, contact)
values
  ('Distribuidora Tech Ltda', '11111111000191', '11333333333'),
  ('Indústria Têxtil Brasil', '22222222000182', '11944444444'),
  ('Alimentos Boa Mesa SA', '33333333000173', '11955555555'),
  ('Moveis Conforto EIRELI', '44444444000164', '11466666666'),
  ('Mundo dos Brinquedos Ltda', '55555555000155', '11977777777');

SELECT * FROM supplier;


insert into productStorage (storageLocation, quantity)
values
  ('Centro de Distribuição São Paulo - SP', 150),
  ('Galpão Rio de Janeiro - RJ', 80),
  ('Depósito Belo Horizonte - MG', 200),
  ('Armazém Curitiba - PR', 120),
  ('CD Salvador - BA', 95);

SELECT * FROM productStorage;


insert into productSeller (idPSeller, idPproduct, prodQuantity)
values
  (1, 1, 10),  -- Vendedor 1 vende Fone JBL
  (1, 2, 5),   -- Vendedor 1 também vende Camiseta
  (2, 3, 15),  -- Vendedor 2 vende Lego Kit
  (3, 4, 20),  -- Vendedor 3 vende Arroz 5kg
  (4, 2, 8),   -- Vendedor 4 também vende Camiseta
  (5, 5, 12);  -- Vendedor 5 vende Sofá 2L

SELECT * FROM productSeller;


insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus)
values
  (1, 1, 1, 'Disponível'),       -- Pedido 1 com 1 Fone JBL
  (2, 1, 2, 'Disponível'),       -- Pedido 1 com 2 Camisetas
  (3, 2, 1, 'Sem estoque'),      -- Pedido 2 com 1 Lego Kit, mas está indisponível
  (4, 3, 5, 'Disponível'),       -- Pedido 3 com 5 Arroz 5kg
  (5, 4, 1, 'Disponível'),       -- Pedido 4 com 1 Sofá 2L
  (2, 5, 3, 'Disponível');       -- Pedido 5 com 3 Camisetas

SELECT * FROM productOrder;


insert into storageLocation (idLproduct, idLstorage, location)
values
  (1, 1, 'Setor A - Prateleira 1'),
  (2, 1, 'Setor A - Prateleira 2'),
  (3, 2, 'Setor B - Prateleira 1'),
  (4, 3, 'Setor C - Palete 1'),
  (5, 4, 'Setor D - Prateleira 3'),
  (2, 5, 'Setor E - Prateleira 1'); -- mesmo produto em mais de um estoque

SELECT * FROM storageLocation;

insert into storageSupplier (idPsSupplier, idPsProduct, quantity)
values
  (1, 1, 50),  -- Fornecedor 1 fornece Fone JBL
  (2, 2, 70),  -- Fornecedor 2 fornece Camiseta
  (3, 3, 30),  -- Fornecedor 3 fornece Lego Kit
  (4, 5, 20),  -- Fornecedor 4 fornece Sofá
  (5, 4, 90),  -- Fornecedor 5 fornece Arroz
  (1, 2, 40);  -- Fornecedor 1 também fornece Camiseta

SELECT * FROM storageSupplier;

-- ----------------------------------- QUERIES --------------------------------------------------------------------------------------------------------------------------

select count(*) from clients;

select * from clients c, orders o where c.idClient = idOrderClient;

select Fname, Lname, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
select concat(Fname,' ',Lname) as 'Client', idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
select * from clients;
select * from orders;

insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash)
values
  (2, default, 'Compra compra via aplicativo', null, false)
;
select * from orders;

select * from clients c, orders o 
	where c.idClient = idOrderClient;
    
-- Recuperar quantos pedidos foram realizados pelos clientes?
select c.idClient, Fname, count(*) as Number_of_orders from clients c 
						inner JOIN orders o ON idClient = idOrderClient
						inner join productOrder on idPOorder = idOrder
				group by idClient;