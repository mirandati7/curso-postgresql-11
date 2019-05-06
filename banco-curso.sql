-- SQL Manager Lite for PostgreSQL 5.9.5.52424
-- ---------------------------------------
-- Host      : localhost
-- Database  : curso_postgres
-- Version   : PostgreSQL 11.2 on x86_64-pc-mingw64, compiled by gcc.exe (Rev5, Built by MSYS2 project) 4.9.2, 64-bit



SET check_function_bodies = false;
--
-- Definition for type inteiro (OID = 17091) : 
--
SET search_path = public, pg_catalog;
CREATE DOMAIN public.inteiro AS 
  integer;
--
-- Definition for function incrementar (OID = 17211) : 
--
CREATE FUNCTION public.incrementar (
  val integer
)
RETURNS integer
AS 
$body$ 
 BEGIN     
 		RETURN val + 1; 
 END; 
 $body$
LANGUAGE plpgsql;
--
-- Definition for function somar (OID = 17212) : 
--
CREATE FUNCTION public.somar (
  a numeric,
  b numeric
)
RETURNS numeric
AS 
$body$ 
   BEGIN     
        RETURN a +  b;
     END;
     $body$
LANGUAGE plpgsql;
--
-- Definition for function subtrair (OID = 17213) : 
--
CREATE FUNCTION public.subtrair (
  a numeric,
  b numeric
)
RETURNS numeric
AS 
$body$
        BEGIN    
          RETURN a -  b; END; 
       $body$
LANGUAGE plpgsql;
--
-- Definition for function dividir (OID = 17214) : 
--
CREATE FUNCTION public.dividir (
  a numeric,
  b numeric
)
RETURNS numeric
AS 
$body$ BEGIN      RETURN a /  b; END; $body$
LANGUAGE plpgsql;
--
-- Definition for function multiplicar (OID = 17215) : 
--
CREATE FUNCTION public.multiplicar (
  a numeric,
  b numeric
)
RETURNS numeric
AS 
$body$ BEGIN     RETURN a * b; END; $body$
LANGUAGE plpgsql;
--
-- Definition for function calculos_matematicos (OID = 17216) : 
--
CREATE FUNCTION public.calculos_matematicos (
  x integer,
  y integer,
  out soma integer,
  out subtracao integer,
  out multiplicacao integer,
  out divisao integer
)
RETURNS record
AS 
$body$
 BEGIN 
      soma := x + y;
      subtracao := x - y; 
      multiplicacao := x * y; 
      divisao := x / y; 
END;           
    $body$
LANGUAGE plpgsql;
--
-- Definition for function calculadora (OID = 17217) : 
--
CREATE FUNCTION public.calculadora (
  a numeric,
  operacao character,
  b numeric,
  out resultado numeric
)
RETURNS numeric
AS 
$body$ begin            
if operacao =      '+'  then  
    resultado :=  somar(a,b);   
elsif  operacao =  '-'   then     
   resultado :=  subtrair(a,b);   
elsif  operacao = '*'   then   
  resultado :=   multiplicar(a,b);  
elsif  operacao = '/'   then 
   resultado :=   dividir(a,b); end if; END; 
$body$
LANGUAGE plpgsql;
--
-- Definition for function calculadora10 (OID = 17218) : 
--
CREATE FUNCTION public.calculadora10 (
  a numeric,
  operacao character,
  b numeric,
  out resultado numeric
)
RETURNS numeric
AS 
$body$
 begin            
if operacao =      '+'  then  
    resultado :=  somar(a,b);   
elsif  operacao =  '-'   then     
   resultado :=  subtrair(a,b);   
elsif  operacao = '*'   then   
  resultado :=   multiplicar(a,b);  
elsif  operacao = '/'   then 
   resultado :=   dividir(a,b);
 else 
   RAISE INFO 'INFORME O PARAMETRO CORRETO %',  '' ; 
 end if;
  END; 
$body$
LANGUAGE plpgsql;
--
-- Definition for function sp_produto_audit (OID = 17225) : 
--
CREATE FUNCTION public.sp_produto_audit (
)
RETURNS trigger
AS 
$body$
     BEGIN   
    	 INSERT INTO PRODUTO_AUDIT (ID_PRODUTO,NOME,SALDO,PRECO_COMPRA,PRECO_VENDA,DATA_HORA,ID_USUARIO) 
         VALUES               
           (OLD.ID, 
           OLD.NOME,
            OLD.SALDO,
             OLD.PRECO_COMPRA,
             OLD.PRECO_VENDA,
             CURRENT_TIMESTAMP,
             NEW.ID_USUARIO);     
  	RETURN NULL;  
  	 END;
$body$
LANGUAGE plpgsql;
--
-- Definition for function sp_produto_audit_ins (OID = 17238) : 
--
CREATE FUNCTION public.sp_produto_audit_ins (
)
RETURNS trigger
AS 
$body$
BEGIN
INSERT INTO PRODUTO_AUDIT
(ID_PRODUTO,NOME,SALDO,PRECO_COMPRA,PRECO_VENDA,DATA_HORA,ID_USUARIO
) VALUES
(NEW.ID,
NEW.NOME,
NEW.SALDO,
NEW.PRECO_COMPRA,
NEW.PRECO_VENDA,
current_timestamp,
NEW.id_usuario);
RETURN NULL;
END; $body$
LANGUAGE plpgsql;
--
-- Definition for function sp_parcela_receber (OID = 17249) : 
--
CREATE FUNCTION public.sp_parcela_receber (
)
RETURNS trigger
AS 
$body$
declare var_intervalo           integer;
declare var_acum_intervalo      integer;
declare var_qtde_parcelas       integer;
declare  contador integer;
     BEGIN   
         select intervalo,quant from prazo where id = NEW.id_prazo into
          var_intervalo,var_qtde_parcelas;
          contador := 0;          
          var_acum_intervalo := var_intervalo;
          
          
          WHILE contador < var_qtde_parcelas LOOP
            
             
             INSERT INTO parcela_receber (id_cliente,data_vencimento,valor_parcela) 
        	 VALUES               
           (new.id_cliente, 
            new.data + var_acum_intervalo,
            new.valor / var_qtde_parcelas); 
            
            
             contador := contador + 1 ;
             var_acum_intervalo := var_acum_intervalo + var_intervalo;
             
             
 		  END LOOP ;
         
     
    	  
              
  	       RETURN NULL;  
  	 END;
$body$
LANGUAGE plpgsql;
--
-- Structure for table cliente (OID = 17101) : 
--
CREATE TABLE public.cliente (
    id serial NOT NULL,
    nome varchar(100) NOT NULL,
    cpf char(11) NOT NULL,
    data_nasc date
)
WITH (oids = false);
--
-- Structure for table endereco (OID = 17106) : 
--
CREATE TABLE public.endereco (
    id serial NOT NULL,
    id_cliente integer,
    cep char(9),
    logradouro varchar(100),
    bairro varchar(100),
    cidade varchar(100),
    uf varchar(2),
    complemento varchar(50),
    numero varchar(10) NOT NULL
)
WITH (oids = false);
--
-- Structure for table fornecedor (OID = 17111) : 
--
CREATE TABLE public.fornecedor (
    id serial NOT NULL,
    nome varchar(50)
)
WITH (oids = false);
--
-- Structure for table itens_venda (OID = 17116) : 
--
CREATE TABLE public.itens_venda (
    id serial NOT NULL,
    id_venda integer,
    id_produto integer,
    qtde numeric(9,3),
    valor_unitario numeric(9,3),
    valor_venda numeric(9,3)
)
WITH (oids = false);
--
-- Structure for table prod_fornecedor (OID = 17121) : 
--
CREATE TABLE public.prod_fornecedor (
    id serial NOT NULL,
    id_produto integer,
    id_fornecedor integer
)
WITH (oids = false);
--
-- Structure for table produto (OID = 17126) : 
--
CREATE TABLE public.produto (
    id serial NOT NULL,
    nome varchar(100) NOT NULL,
    saldo numeric(9,3),
    preco_compra numeric(10,4),
    preco_venda numeric(10,4),
    id_usuario integer
)
WITH (oids = false);
--
-- Structure for table telefone (OID = 17136) : 
--
CREATE TABLE public.telefone (
    id serial NOT NULL,
    id_cliente integer,
    numero varchar(15) NOT NULL,
    padrao boolean
)
WITH (oids = false);
--
-- Structure for table venda (OID = 17141) : 
--
CREATE TABLE public.venda (
    id serial NOT NULL,
    data date NOT NULL,
    id_cliente integer,
    valor numeric(10,4) NOT NULL,
    id_prazo integer
)
WITH (oids = false);
--
-- Structure for table produto_audit (OID = 17221) : 
--
CREATE TABLE public.produto_audit (
    id serial NOT NULL,
    id_produto integer,
    nome varchar(100) NOT NULL,
    saldo numeric(9,3),
    preco_compra numeric(10,4),
    preco_venda numeric(10,4),
    data_hora timestamp without time zone,
    id_usuario integer
)
WITH (oids = false);
--
-- Structure for table usuario (OID = 17229) : 
--
CREATE TABLE public.usuario (
    id serial NOT NULL,
    nome varchar(60)
)
WITH (oids = false);
--
-- Structure for table parcela_receber (OID = 17243) : 
--
CREATE TABLE public.parcela_receber (
    id serial NOT NULL,
    id_cliente integer,
    data_vencimento date,
    valor_parcela numeric(9,2)
)
WITH (oids = false);
--
-- Structure for table prazo (OID = 17255) : 
--
CREATE TABLE public.prazo (
    id serial NOT NULL,
    intervalo integer,
    quant integer
)
WITH (oids = false);
--
-- Data for table public.cliente (OID = 17101) (LIMIT 0,7)
--
INSERT INTO cliente (id, nome, cpf, data_nasc)
VALUES (1, 'ALEX', '96489688104', '2019-04-28');

INSERT INTO cliente (id, nome, cpf, data_nasc)
VALUES (3, 'MARIA', '96489688106', '1983-08-26');

INSERT INTO cliente (id, nome, cpf, data_nasc)
VALUES (4, 'JOAO', '65489688106', '1989-12-26');

INSERT INTO cliente (id, nome, cpf, data_nasc)
VALUES (5, 'PEDRO', '75488888106', '1994-12-26');

INSERT INTO cliente (id, nome, cpf, data_nasc)
VALUES (6, 'THIAGO', '85489688106', '1989-12-26');

INSERT INTO cliente (id, nome, cpf, data_nasc)
VALUES (7, 'MIGUEL', '12334567899', '1000-01-01');

INSERT INTO cliente (id, nome, cpf, data_nasc)
VALUES (8, 'Novo Cliente', '96480688104', '1983-08-26');

--
-- Data for table public.endereco (OID = 17106) (LIMIT 0,6)
--
INSERT INTO endereco (id, id_cliente, cep, logradouro, bairro, cidade, uf, complemento, numero)
VALUES (1, 1, '74425-010', 'AVENIDA PIO XII', 'CIDADE JARDIM', 'GOIANIA', 'GO', '', '618');

INSERT INTO endereco (id, id_cliente, cep, logradouro, bairro, cidade, uf, complemento, numero)
VALUES (4, 4, '74425-010', 'AVENIDA PIO XII', 'CIDADE JARDIM', 'SAO PAULO', 'SP', '', '618');

INSERT INTO endereco (id, id_cliente, cep, logradouro, bairro, cidade, uf, complemento, numero)
VALUES (5, 3, '74425-010', 'AVENIDA PIO XII', 'CIDADE DE DEUS', 'RIO DE JANEIRO', 'RJ', '', '618');

INSERT INTO endereco (id, id_cliente, cep, logradouro, bairro, cidade, uf, complemento, numero)
VALUES (2, 6, '74425-010', 'AVENIDA PIO XII', 'CIDADE JARDIM', 'PALMAS', 'TO', '', '618');

INSERT INTO endereco (id, id_cliente, cep, logradouro, bairro, cidade, uf, complemento, numero)
VALUES (3, 5, '74425-010', 'AVENIDA PIO XII', 'CIDADE JARDIM', 'UBERLANDIA', 'MG', '', '618');

INSERT INTO endereco (id, id_cliente, cep, logradouro, bairro, cidade, uf, complemento, numero)
VALUES (6, 7, '94425-010', 'AVENIDA PIO XII', 'CIDADE JARDIM', 'FLORIANOPOLIS', 'GO', '', '618');

--
-- Data for table public.fornecedor (OID = 17111) (LIMIT 0,5)
--
INSERT INTO fornecedor (id, nome)
VALUES (1, 'PELLEGRINO');

INSERT INTO fornecedor (id, nome)
VALUES (2, 'DPK');

INSERT INTO fornecedor (id, nome)
VALUES (3, 'POLIPECAS');

INSERT INTO fornecedor (id, nome)
VALUES (4, 'BOM PRECO');

INSERT INTO fornecedor (id, nome)
VALUES (5, 'ARAGUAIA');

--
-- Data for table public.itens_venda (OID = 17116) (LIMIT 0,28)
--
INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (1, 1, 1, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (2, 1, 2, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (3, 1, 3, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (4, 1, 4, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (5, 1, 5, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (6, 2, 1, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (7, 2, 2, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (8, 2, 3, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (9, 2, 4, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (10, 2, 5, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (11, 3, 2, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (12, 3, 4, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (13, 4, 1, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (14, 4, 2, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (15, 4, 4, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (16, 5, 1, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (17, 5, 2, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (18, 5, 4, 5.000, 10.000, 50.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (19, 6, 1, 7.000, 10.000, 900.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (20, 6, 2, 7.000, 10.000, 900.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (21, 6, 3, 7.000, 10.000, 900.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (22, 6, 4, 7.000, 10.000, 900.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (23, 6, 5, 7.000, 10.000, 900.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (24, 7, 1, 4.000, 10.000, 900.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (25, 7, 2, 4.000, 10.000, 900.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (26, 7, 3, 4.000, 10.000, 900.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (27, 7, 4, 4.000, 10.000, 900.000);

INSERT INTO itens_venda (id, id_venda, id_produto, qtde, valor_unitario, valor_venda)
VALUES (28, 7, 5, 4.000, 10.000, 900.000);

--
-- Data for table public.prod_fornecedor (OID = 17121) (LIMIT 0,10)
--
INSERT INTO prod_fornecedor (id, id_produto, id_fornecedor)
VALUES (1, 1, 1);

INSERT INTO prod_fornecedor (id, id_produto, id_fornecedor)
VALUES (2, 2, 1);

INSERT INTO prod_fornecedor (id, id_produto, id_fornecedor)
VALUES (3, 3, 1);

INSERT INTO prod_fornecedor (id, id_produto, id_fornecedor)
VALUES (4, 4, 1);

INSERT INTO prod_fornecedor (id, id_produto, id_fornecedor)
VALUES (5, 5, 1);

INSERT INTO prod_fornecedor (id, id_produto, id_fornecedor)
VALUES (6, 1, 2);

INSERT INTO prod_fornecedor (id, id_produto, id_fornecedor)
VALUES (7, 2, 2);

INSERT INTO prod_fornecedor (id, id_produto, id_fornecedor)
VALUES (8, 3, 2);

INSERT INTO prod_fornecedor (id, id_produto, id_fornecedor)
VALUES (9, 4, 2);

INSERT INTO prod_fornecedor (id, id_produto, id_fornecedor)
VALUES (10, 5, 2);

--
-- Data for table public.produto (OID = 17126) (LIMIT 0,9)
--
INSERT INTO produto (id, nome, saldo, preco_compra, preco_venda, id_usuario)
VALUES (1, 'AMORTECEDOR', 10.000, 90.9000, 123.9000, 1);

INSERT INTO produto (id, nome, saldo, preco_compra, preco_venda, id_usuario)
VALUES (5, 'PNEU AR0 13', 7.000, 98.9000, 129.9000, 1);

INSERT INTO produto (id, nome, saldo, preco_compra, preco_venda, id_usuario)
VALUES (3, 'COIFA CORSA', 10.000, 98.9000, 329.9000, 1);

INSERT INTO produto (id, nome, saldo, preco_compra, preco_venda, id_usuario)
VALUES (9, 'COPO AMERICANO', 15.000, 90.0800, 198.0000, 3);

INSERT INTO produto (id, nome, saldo, preco_compra, preco_venda, id_usuario)
VALUES (2, 'BUCHA GOL', 10.000, 98.9000, 229.9000, 2);

INSERT INTO produto (id, nome, saldo, preco_compra, preco_venda, id_usuario)
VALUES (6, 'PRODUTO NOVO', 90.000, 98.0000, 150.0000, 2);

INSERT INTO produto (id, nome, saldo, preco_compra, preco_venda, id_usuario)
VALUES (4, 'VIRABREQUIM NEW CIVIC', 20.000, 98.9000, 329.9000, 2);

INSERT INTO produto (id, nome, saldo, preco_compra, preco_venda, id_usuario)
VALUES (16, 'MOUSE', 90.000, 15.0000, 43.0000, 1);

INSERT INTO produto (id, nome, saldo, preco_compra, preco_venda, id_usuario)
VALUES (17, 'MOUSE BATMAN', 90.000, 15.0000, 43.0000, 1);

--
-- Data for table public.telefone (OID = 17136) (LIMIT 0,10)
--
INSERT INTO telefone (id, id_cliente, numero, padrao)
VALUES (7, 1, '62 1000-7999', false);

INSERT INTO telefone (id, id_cliente, numero, padrao)
VALUES (8, 3, '62 2000-7999', false);

INSERT INTO telefone (id, id_cliente, numero, padrao)
VALUES (9, 4, '62 3000-7999', false);

INSERT INTO telefone (id, id_cliente, numero, padrao)
VALUES (10, 5, '62 4000-7999', false);

INSERT INTO telefone (id, id_cliente, numero, padrao)
VALUES (11, 6, '62 5000-7999', false);

INSERT INTO telefone (id, id_cliente, numero, padrao)
VALUES (1, 1, '62 9000-7999', true);

INSERT INTO telefone (id, id_cliente, numero, padrao)
VALUES (3, 3, '62 8000-7999', true);

INSERT INTO telefone (id, id_cliente, numero, padrao)
VALUES (4, 4, '62 7000-7999', true);

INSERT INTO telefone (id, id_cliente, numero, padrao)
VALUES (5, 5, '62 6000-7999', true);

INSERT INTO telefone (id, id_cliente, numero, padrao)
VALUES (6, 6, '62 5000-7999', true);

--
-- Data for table public.venda (OID = 17141) (LIMIT 0,30)
--
INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (1, '2019-10-03', 1, 900.0000, 1);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (2, '2019-09-03', 6, 800.0000, 1);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (3, '2019-08-03', 3, 700.0000, 1);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (4, '2019-07-03', 4, 600.0000, 1);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (5, '2019-06-03', 5, 500.0000, 1);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (6, '2019-06-03', 7, 900.0000, 1);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (7, '2019-06-03', 6, 900.0000, 1);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (8, '2019-05-05', 5, 90.0000, 1);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (9, '2019-05-05', 6, 90.0000, 1);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (10, '2019-05-05', 6, 90.0000, 1);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (11, '2019-05-05', 6, 876.0000, 1);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (12, '2019-05-05', 6, 900.0000, 1);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (13, '2019-05-05', 6, 900.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (14, '2019-05-05', 5, 900.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (15, '2019-05-05', 5, 1000.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (16, '2019-05-05', 4, 90.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (17, '2019-05-05', 4, 90.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (18, '2019-05-05', 4, 90.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (19, '2019-05-05', 4, 90.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (20, '2019-05-05', 4, 90.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (21, '2019-05-05', 4, 90.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (22, '2019-05-05', 4, 1000.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (23, '2019-05-05', 4, 1000.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (24, '2019-05-05', 4, 1000.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (25, '2019-05-05', 4, 1000.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (26, '2019-05-05', 4, 1000.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (27, '2019-05-05', 4, 1000.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (28, '2019-05-05', 4, 1000.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (29, '2019-05-05', 4, 1000.0000, 2);

INSERT INTO venda (id, data, id_cliente, valor, id_prazo)
VALUES (30, '2019-05-05', 4, 1000.0000, 2);

--
-- Data for table public.produto_audit (OID = 17221) (LIMIT 0,24)
--
INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (1, 4, 'VIRABREQUIM NEW CIVIC', 9.000, 98.9000, 329.9000, NULL, NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (2, 4, 'VIRABREQUIM NEW CIVIC', 10.000, 98.9000, 329.9000, NULL, NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (3, 4, 'VIRABREQUIM NEW CIVIC', 11.000, 98.9000, 329.9000, '2019-05-05 14:14:46.652085', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (4, 4, 'VIRABREQUIM NEW CIVIC', 12.000, 98.9000, 329.9000, '2019-05-05 14:15:36.675372', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (5, 1, 'AMORTECEDOR', 10.000, 90.9000, 123.9000, '2019-05-05 14:21:13.570341', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (6, 5, 'PNEU AR0 13', 7.000, 98.9000, 129.9000, '2019-05-05 14:21:13.570341', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (7, 3, 'COIFA CORSA', 10.000, 98.9000, 329.9000, '2019-05-05 14:21:13.570341', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (8, 2, 'BUCHA GOL', 10.000, 98.9000, 229.9000, '2019-05-05 14:21:26.220599', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (9, 6, 'PRODUTO NOVO', 90.000, 98.0000, 150.0000, '2019-05-05 14:21:26.220599', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (10, 4, 'VIRABREQUIM NEW CIVIC', 11.000, 98.9000, 329.9000, '2019-05-05 14:21:26.220599', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (11, 7, 'PRODUTO NOVO 33', 90.000, 98.0000, 150.0000, '2019-05-05 14:21:42.466451', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (12, 9, 'COPO AMERICANO', 15.000, 90.0800, 198.0000, '2019-05-05 14:21:42.466451', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (13, 2, 'BUCHA GOL', 10.000, 98.9000, 229.9000, '2019-05-05 14:22:07.450063', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (14, 6, 'PRODUTO NOVO', 90.000, 98.0000, 150.0000, '2019-05-05 14:22:07.450063', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (15, 4, 'VIRABREQUIM NEW CIVIC', 11.000, 98.9000, 329.9000, '2019-05-05 14:22:07.450063', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (16, 4, 'VIRABREQUIM NEW CIVIC', 11.000, 98.9000, 329.9000, '2019-05-05 14:24:35.873384', 2);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (17, 4, 'VIRABREQUIM NEW CIVIC', 10.000, 98.9000, 329.9000, '2019-05-05 14:25:31.166277', 2);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (18, 7, 'PRODUTO NOVO 33', 90.000, 98.0000, 150.0000, '2019-05-05 14:35:10.561586', NULL);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (19, 11, 'MOUSE', 90.000, 15.0000, 43.0000, '2019-05-05 14:44:24.407186', 1);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (20, 12, 'MOUSE', 90.000, 15.0000, 43.0000, '2019-05-05 14:44:26.206378', 1);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (21, 13, 'MOUSE', 90.000, 15.0000, 43.0000, '2019-05-05 14:44:32.687369', 1);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (22, 14, 'MOUSE', 90.000, 15.0000, 43.0000, '2019-05-05 14:44:53.743494', 1);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (23, 15, 'MOUSE', 90.000, 15.0000, 43.0000, '2019-05-05 14:45:10.349911', 1);

INSERT INTO produto_audit (id, id_produto, nome, saldo, preco_compra, preco_venda, data_hora, id_usuario)
VALUES (24, 17, 'MOUSE BATMAN', 90.000, 15.0000, 43.0000, '2019-05-05 14:46:43.68828', 1);

--
-- Data for table public.usuario (OID = 17229) (LIMIT 0,3)
--
INSERT INTO usuario (id, nome)
VALUES (1, 'ALEX');

INSERT INTO usuario (id, nome)
VALUES (2, 'KENNEDY');

INSERT INTO usuario (id, nome)
VALUES (3, 'ARTHUR');

--
-- Data for table public.parcela_receber (OID = 17243) (LIMIT 0,4)
--
INSERT INTO parcela_receber (id, id_cliente, data_vencimento, valor_parcela)
VALUES (179, 4, '2019-06-04', 250.00);

INSERT INTO parcela_receber (id, id_cliente, data_vencimento, valor_parcela)
VALUES (180, 4, '2019-07-04', 250.00);

INSERT INTO parcela_receber (id, id_cliente, data_vencimento, valor_parcela)
VALUES (181, 4, '2019-08-03', 250.00);

INSERT INTO parcela_receber (id, id_cliente, data_vencimento, valor_parcela)
VALUES (182, 4, '2019-09-02', 250.00);

--
-- Data for table public.prazo (OID = 17255) (LIMIT 0,2)
--
INSERT INTO prazo (id, intervalo, quant)
VALUES (2, 30, 4);

INSERT INTO prazo (id, intervalo, quant)
VALUES (1, 45, 1);

--
-- Definition for index cliente_cpf_key (OID = 17155) : 
--
ALTER TABLE ONLY cliente
    ADD CONSTRAINT cliente_cpf_key
    UNIQUE (cpf);
--
-- Definition for index cliente_pkey (OID = 17157) : 
--
ALTER TABLE ONLY cliente
    ADD CONSTRAINT cliente_pkey
    PRIMARY KEY (id);
--
-- Definition for index endereco_pkey (OID = 17159) : 
--
ALTER TABLE ONLY endereco
    ADD CONSTRAINT endereco_pkey
    PRIMARY KEY (id);
--
-- Definition for index fornecedor_pkey (OID = 17161) : 
--
ALTER TABLE ONLY fornecedor
    ADD CONSTRAINT fornecedor_pkey
    PRIMARY KEY (id);
--
-- Definition for index itens_venda_pkey (OID = 17163) : 
--
ALTER TABLE ONLY itens_venda
    ADD CONSTRAINT itens_venda_pkey
    PRIMARY KEY (id);
--
-- Definition for index prod_fornecedor_pkey (OID = 17165) : 
--
ALTER TABLE ONLY prod_fornecedor
    ADD CONSTRAINT prod_fornecedor_pkey
    PRIMARY KEY (id);
--
-- Definition for index produto_pkey (OID = 17167) : 
--
ALTER TABLE ONLY produto
    ADD CONSTRAINT produto_pkey
    PRIMARY KEY (id);
--
-- Definition for index telefone_pkey (OID = 17169) : 
--
ALTER TABLE ONLY telefone
    ADD CONSTRAINT telefone_pkey
    PRIMARY KEY (id);
--
-- Definition for index venda_pkey (OID = 17171) : 
--
ALTER TABLE ONLY venda
    ADD CONSTRAINT venda_pkey
    PRIMARY KEY (id);
--
-- Definition for index endereco_id_cliente_fkey (OID = 17176) : 
--
ALTER TABLE ONLY endereco
    ADD CONSTRAINT endereco_id_cliente_fkey
    FOREIGN KEY (id_cliente) REFERENCES cliente(id);
--
-- Definition for index itens_venda_id_produto_fkey (OID = 17181) : 
--
ALTER TABLE ONLY itens_venda
    ADD CONSTRAINT itens_venda_id_produto_fkey
    FOREIGN KEY (id_produto) REFERENCES produto(id);
--
-- Definition for index itens_venda_id_venda_fkey (OID = 17186) : 
--
ALTER TABLE ONLY itens_venda
    ADD CONSTRAINT itens_venda_id_venda_fkey
    FOREIGN KEY (id_venda) REFERENCES venda(id);
--
-- Definition for index prod_fornecedor_id_fornecedor_fkey (OID = 17191) : 
--
ALTER TABLE ONLY prod_fornecedor
    ADD CONSTRAINT prod_fornecedor_id_fornecedor_fkey
    FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id);
--
-- Definition for index prod_fornecedor_id_produto_fkey (OID = 17196) : 
--
ALTER TABLE ONLY prod_fornecedor
    ADD CONSTRAINT prod_fornecedor_id_produto_fkey
    FOREIGN KEY (id_produto) REFERENCES produto(id);
--
-- Definition for index telefone_id_cliente_fkey (OID = 17201) : 
--
ALTER TABLE ONLY telefone
    ADD CONSTRAINT telefone_id_cliente_fkey
    FOREIGN KEY (id_cliente) REFERENCES cliente(id);
--
-- Definition for index venda_id_cliente_fkey (OID = 17206) : 
--
ALTER TABLE ONLY venda
    ADD CONSTRAINT venda_id_cliente_fkey
    FOREIGN KEY (id_cliente) REFERENCES cliente(id);
--
-- Definition for index usuario_pkey (OID = 17233) : 
--
ALTER TABLE ONLY usuario
    ADD CONSTRAINT usuario_pkey
    PRIMARY KEY (id);
--
-- Definition for index parcela_receber_pkey (OID = 17247) : 
--
ALTER TABLE ONLY parcela_receber
    ADD CONSTRAINT parcela_receber_pkey
    PRIMARY KEY (id);
--
-- Definition for index prazo_pkey (OID = 17259) : 
--
ALTER TABLE ONLY prazo
    ADD CONSTRAINT prazo_pkey
    PRIMARY KEY (id);
--
-- Definition for trigger tr_produto_up (OID = 17226) : 
--
CREATE TRIGGER tr_produto_up
    AFTER UPDATE ON produto
    FOR EACH ROW
    EXECUTE PROCEDURE sp_produto_audit ();
--
-- Definition for trigger tr_produto_del (OID = 17235) : 
--
CREATE TRIGGER tr_produto_del
    AFTER DELETE ON produto
    FOR EACH ROW
    EXECUTE PROCEDURE sp_produto_audit ();
--
-- Definition for trigger tr_produto_ins (OID = 17240) : 
--
CREATE TRIGGER tr_produto_ins
    AFTER INSERT ON produto
    FOR EACH ROW
    EXECUTE PROCEDURE sp_produto_audit_ins ();
--
-- Definition for trigger tr_parcela_receber_ins (OID = 17250) : 
--
CREATE TRIGGER tr_parcela_receber_ins
    AFTER INSERT ON venda
    FOR EACH ROW
    EXECUTE PROCEDURE sp_parcela_receber ();
--
-- Data for sequence public.cliente_id_seq (OID = 17104)
--
SELECT pg_catalog.setval('cliente_id_seq', 8, true);
--
-- Data for sequence public.endereco_id_seq (OID = 17109)
--
SELECT pg_catalog.setval('endereco_id_seq', 6, true);
--
-- Data for sequence public.fornecedor_id_seq (OID = 17114)
--
SELECT pg_catalog.setval('fornecedor_id_seq', 5, true);
--
-- Data for sequence public.itens_venda_id_seq (OID = 17119)
--
SELECT pg_catalog.setval('itens_venda_id_seq', 28, true);
--
-- Data for sequence public.prod_fornecedor_id_seq (OID = 17124)
--
SELECT pg_catalog.setval('prod_fornecedor_id_seq', 10, true);
--
-- Data for sequence public.produto_id_seq (OID = 17134)
--
SELECT pg_catalog.setval('produto_id_seq', 17, true);
--
-- Data for sequence public.telefone_id_seq (OID = 17139)
--
SELECT pg_catalog.setval('telefone_id_seq', 11, true);
--
-- Data for sequence public.venda_id_seq (OID = 17144)
--
SELECT pg_catalog.setval('venda_id_seq', 30, true);
--
-- Data for sequence public.produto_audit_id_seq (OID = 17219)
--
SELECT pg_catalog.setval('produto_audit_id_seq', 24, true);
--
-- Data for sequence public.usuario_id_seq (OID = 17227)
--
SELECT pg_catalog.setval('usuario_id_seq', 3, true);
--
-- Data for sequence public.parcela_receber_id_seq (OID = 17241)
--
SELECT pg_catalog.setval('parcela_receber_id_seq', 182, true);
--
-- Data for sequence public.prazo_id_seq (OID = 17253)
--
SELECT pg_catalog.setval('prazo_id_seq', 2, true);
--
-- Comments
--
COMMENT ON SCHEMA public IS 'standard public schema';
