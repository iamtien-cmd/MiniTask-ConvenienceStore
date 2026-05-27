--
-- PostgreSQL database cluster dump
--

-- Started on 2026-05-27 21:31:04

\restrict 9UANMzDGddpM5RMVUveG69U26d1ZSQm3y5odEpcwHojHUSO2XfjAxgI8y9jLxRm

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:L92H50sprGiVdq+B6c6WBA==$Y03klDTApNxufqis6b8pRtMfk+x+7wxD4i/Pahwgm/A=:2gKw3026awBRpY7XtE0ZIxqZZJDTH5gjeJ9+9Sc+gwg=';

--
-- User Configurations
--








\unrestrict 9UANMzDGddpM5RMVUveG69U26d1ZSQm3y5odEpcwHojHUSO2XfjAxgI8y9jLxRm

--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

\restrict vdPgqAK6SYC8QOQ9ZCAmmnLsTtqOSaokVTuC8eUVRC5I5fgMYFbxowQcaQZyZxp

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-05-27 21:31:04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-05-27 21:31:05

--
-- PostgreSQL database dump complete
--

\unrestrict vdPgqAK6SYC8QOQ9ZCAmmnLsTtqOSaokVTuC8eUVRC5I5fgMYFbxowQcaQZyZxp

--
-- Database "Task_7-eleven" dump
--

--
-- PostgreSQL database dump
--

\restrict KGCaW6oSvaLv1yvWgNdbnxQzytfkCKUGng8X50s0tzaS53WOz5eOvOqcuWp8vek

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-05-27 21:31:05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5004 (class 1262 OID 16960)
-- Name: Task_7-eleven; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "Task_7-eleven" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE "Task_7-eleven" OWNER TO postgres;

\unrestrict KGCaW6oSvaLv1yvWgNdbnxQzytfkCKUGng8X50s0tzaS53WOz5eOvOqcuWp8vek
\encoding SQL_ASCII
\connect -reuse-previous=on "dbname='Task_7-eleven'"
\restrict KGCaW6oSvaLv1yvWgNdbnxQzytfkCKUGng8X50s0tzaS53WOz5eOvOqcuWp8vek

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 234 (class 1259 OID 17168)
-- Name: cart_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cart_item (
    cart_item_id bigint NOT NULL,
    shopping_cart_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity integer DEFAULT 1
);


ALTER TABLE public.cart_item OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 17167)
-- Name: cart_item_cart_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cart_item_cart_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cart_item_cart_item_id_seq OWNER TO postgres;

--
-- TOC entry 5005 (class 0 OID 0)
-- Dependencies: 233
-- Name: cart_item_cart_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cart_item_cart_item_id_seq OWNED BY public.cart_item.cart_item_id;


--
-- TOC entry 224 (class 1259 OID 16993)
-- Name: customers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customers (
    customer_id bigint NOT NULL,
    user_id bigint
);


ALTER TABLE public.customers OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16992)
-- Name: customers_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.customers ALTER COLUMN customer_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.customers_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 232 (class 1259 OID 17142)
-- Name: order_line; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.order_line (
    order_line_id bigint NOT NULL,
    order_id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    unit_price numeric(12,2) NOT NULL
);


ALTER TABLE public.order_line OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 17141)
-- Name: order_line_order_line_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.order_line_order_line_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.order_line_order_line_id_seq OWNER TO postgres;

--
-- TOC entry 5006 (class 0 OID 0)
-- Dependencies: 231
-- Name: order_line_order_line_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.order_line_order_line_id_seq OWNED BY public.order_line.order_line_id;


--
-- TOC entry 228 (class 1259 OID 17050)
-- Name: orders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orders (
    order_id bigint NOT NULL,
    customer_id bigint,
    order_status character varying(100),
    total_amount numeric(10,2),
    payment_method text,
    order_date timestamp without time zone,
    status text DEFAULT 'PENDING'::text,
    delivery_address text,
    recipient_name character varying(255),
    phone_number character varying(20),
    shipping_amount numeric DEFAULT 0,
    tax_amount numeric DEFAULT 0
);


ALTER TABLE public.orders OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 17049)
-- Name: orders_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.orders ALTER COLUMN order_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.orders_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 226 (class 1259 OID 17021)
-- Name: products; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.products (
    product_id bigint NOT NULL,
    product_name character varying(100) NOT NULL,
    price numeric(10,2) NOT NULL,
    image_url character varying(255),
    description text,
    stock_quantity integer DEFAULT 0
);


ALTER TABLE public.products OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 17020)
-- Name: products_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.products ALTER COLUMN product_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.products_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 220 (class 1259 OID 16965)
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    role_id bigint NOT NULL,
    role_name character varying(100) NOT NULL
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16964)
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.roles ALTER COLUMN role_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.roles_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 230 (class 1259 OID 17102)
-- Name: shopping_cart; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.shopping_cart (
    shopping_cart_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.shopping_cart OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 17101)
-- Name: shopping_cart_shopping_cart_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.shopping_cart_shopping_cart_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.shopping_cart_shopping_cart_id_seq OWNER TO postgres;

--
-- TOC entry 5007 (class 0 OID 0)
-- Dependencies: 229
-- Name: shopping_cart_shopping_cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.shopping_cart_shopping_cart_id_seq OWNED BY public.shopping_cart.shopping_cart_id;


--
-- TOC entry 222 (class 1259 OID 16973)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    user_id bigint NOT NULL,
    full_name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    address character varying(255),
    role_id bigint NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16972)
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN user_id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.users_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4798 (class 2604 OID 17171)
-- Name: cart_item cart_item_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_item ALTER COLUMN cart_item_id SET DEFAULT nextval('public.cart_item_cart_item_id_seq'::regclass);


--
-- TOC entry 4796 (class 2604 OID 17145)
-- Name: order_line order_line_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line ALTER COLUMN order_line_id SET DEFAULT nextval('public.order_line_order_line_id_seq'::regclass);


--
-- TOC entry 4794 (class 2604 OID 17105)
-- Name: shopping_cart shopping_cart_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart ALTER COLUMN shopping_cart_id SET DEFAULT nextval('public.shopping_cart_shopping_cart_id_seq'::regclass);


--
-- TOC entry 4998 (class 0 OID 17168)
-- Dependencies: 234
-- Data for Name: cart_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cart_item (cart_item_id, shopping_cart_id, product_id, quantity) FROM stdin;
\.


--
-- TOC entry 4988 (class 0 OID 16993)
-- Dependencies: 224
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customers (customer_id, user_id) FROM stdin;
1	3
2	4
3	5
4	6
\.


--
-- TOC entry 4996 (class 0 OID 17142)
-- Dependencies: 232
-- Data for Name: order_line; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.order_line (order_line_id, order_id, product_id, quantity, unit_price) FROM stdin;
27	56	1	7	15000.00
28	56	2	4	10000.00
29	57	2	1	10000.00
\.


--
-- TOC entry 4992 (class 0 OID 17050)
-- Dependencies: 228
-- Data for Name: orders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orders (order_id, customer_id, order_status, total_amount, payment_method, order_date, status, delivery_address, recipient_name, phone_number, shipping_amount, tax_amount) FROM stdin;
56	1	\N	145005.00	CREDIT_CARD	2026-05-27 19:14:05.418328	CONFIRMED	a	a	a	5	0
57	1	\N	10005.00	CREDIT_CARD	2026-05-27 19:18:07.582579	SHIPPED	a	a	a	5	0
\.


--
-- TOC entry 4990 (class 0 OID 17021)
-- Dependencies: 226
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.products (product_id, product_name, price, image_url, description, stock_quantity) FROM stdin;
1	Coca Cola	15000.00	https://cdn.pixabay.com/photo/2013/03/01/18/48/can-87995_1280.jpg	Soft drink	100
2	Snack	10000.00	https://www.snackperk.com/cdn/shop/products/Bluefinal_5000x.png?v=1713202899	Potato snack	100
\.


--
-- TOC entry 4984 (class 0 OID 16965)
-- Dependencies: 220
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (role_id, role_name) FROM stdin;
1	CUSTOMER
2	ADMIN
\.


--
-- TOC entry 4994 (class 0 OID 17102)
-- Dependencies: 230
-- Data for Name: shopping_cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.shopping_cart (shopping_cart_id, customer_id, created_at) FROM stdin;
1	2	2026-05-26 13:43:36.951743
2	1	2026-05-26 13:53:41.572399
3	3	2026-05-26 15:04:36.27035
4	4	2026-05-27 19:19:58.592955
\.


--
-- TOC entry 4986 (class 0 OID 16973)
-- Dependencies: 222
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (user_id, full_name, email, password_hash, address, role_id) FROM stdin;
3	Liên Huệ Tiên	lienhuetien01@gmail.com	lienhuetien01@gmail.com	lienhuetien01@gmail.com	1
4	lienhuetien02@gmail.com	lienhuetien02@gmail.com	lienhuetien02@gmail.com	lienhuetien02@gmail.com	1
5	a	a@gmail.com	a	a	1
6	Admin	admin@gmail.com	admin@gmail.com	admin@gmail.com	2
\.


--
-- TOC entry 5008 (class 0 OID 0)
-- Dependencies: 233
-- Name: cart_item_cart_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cart_item_cart_item_id_seq', 65, true);


--
-- TOC entry 5009 (class 0 OID 0)
-- Dependencies: 223
-- Name: customers_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customers_customer_id_seq', 4, true);


--
-- TOC entry 5010 (class 0 OID 0)
-- Dependencies: 231
-- Name: order_line_order_line_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.order_line_order_line_id_seq', 29, true);


--
-- TOC entry 5011 (class 0 OID 0)
-- Dependencies: 227
-- Name: orders_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orders_order_id_seq', 57, true);


--
-- TOC entry 5012 (class 0 OID 0)
-- Dependencies: 225
-- Name: products_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_product_id_seq', 4, true);


--
-- TOC entry 5013 (class 0 OID 0)
-- Dependencies: 219
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_role_id_seq', 2, true);


--
-- TOC entry 5014 (class 0 OID 0)
-- Dependencies: 229
-- Name: shopping_cart_shopping_cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.shopping_cart_shopping_cart_id_seq', 4, true);


--
-- TOC entry 5015 (class 0 OID 0)
-- Dependencies: 221
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_user_id_seq', 6, true);


--
-- TOC entry 4823 (class 2606 OID 17177)
-- Name: cart_item cart_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_item
    ADD CONSTRAINT cart_item_pkey PRIMARY KEY (cart_item_id);


--
-- TOC entry 4807 (class 2606 OID 16998)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (customer_id);


--
-- TOC entry 4809 (class 2606 OID 17000)
-- Name: customers customers_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_user_id_key UNIQUE (user_id);


--
-- TOC entry 4819 (class 2606 OID 17153)
-- Name: order_line order_line_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT order_line_pkey PRIMARY KEY (order_line_id);


--
-- TOC entry 4813 (class 2606 OID 17055)
-- Name: orders orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id);


--
-- TOC entry 4811 (class 2606 OID 17030)
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (product_id);


--
-- TOC entry 4801 (class 2606 OID 16971)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (role_id);


--
-- TOC entry 4815 (class 2606 OID 17112)
-- Name: shopping_cart shopping_cart_customer_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart
    ADD CONSTRAINT shopping_cart_customer_id_key UNIQUE (customer_id);


--
-- TOC entry 4817 (class 2606 OID 17110)
-- Name: shopping_cart shopping_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart
    ADD CONSTRAINT shopping_cart_pkey PRIMARY KEY (shopping_cart_id);


--
-- TOC entry 4825 (class 2606 OID 17191)
-- Name: cart_item uk_cart_item; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_item
    ADD CONSTRAINT uk_cart_item UNIQUE (shopping_cart_id, product_id);


--
-- TOC entry 4827 (class 2606 OID 17179)
-- Name: cart_item uq_cart_product; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_item
    ADD CONSTRAINT uq_cart_product UNIQUE (shopping_cart_id, product_id);


--
-- TOC entry 4821 (class 2606 OID 17155)
-- Name: order_line uq_order_product; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT uq_order_product UNIQUE (order_id, product_id);


--
-- TOC entry 4803 (class 2606 OID 16986)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4805 (class 2606 OID 16984)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);


--
-- TOC entry 4831 (class 2606 OID 17113)
-- Name: shopping_cart fk_cart_customer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.shopping_cart
    ADD CONSTRAINT fk_cart_customer FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 4829 (class 2606 OID 17001)
-- Name: customers fk_customer_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT fk_customer_user FOREIGN KEY (user_id) REFERENCES public.users(user_id);


--
-- TOC entry 4834 (class 2606 OID 17180)
-- Name: cart_item fk_item_cart; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_item
    ADD CONSTRAINT fk_item_cart FOREIGN KEY (shopping_cart_id) REFERENCES public.shopping_cart(shopping_cart_id);


--
-- TOC entry 4835 (class 2606 OID 17185)
-- Name: cart_item fk_item_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cart_item
    ADD CONSTRAINT fk_item_product FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 4830 (class 2606 OID 17056)
-- Name: orders fk_order_customer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orders
    ADD CONSTRAINT fk_order_customer FOREIGN KEY (customer_id) REFERENCES public.customers(customer_id);


--
-- TOC entry 4832 (class 2606 OID 17156)
-- Name: order_line fk_orderline_order; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT fk_orderline_order FOREIGN KEY (order_id) REFERENCES public.orders(order_id) ON DELETE CASCADE;


--
-- TOC entry 4833 (class 2606 OID 17161)
-- Name: order_line fk_orderline_product; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.order_line
    ADD CONSTRAINT fk_orderline_product FOREIGN KEY (product_id) REFERENCES public.products(product_id);


--
-- TOC entry 4828 (class 2606 OID 16987)
-- Name: users fk_user_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_user_role FOREIGN KEY (role_id) REFERENCES public.roles(role_id);


-- Completed on 2026-05-27 21:31:05

--
-- PostgreSQL database dump complete
--

\unrestrict KGCaW6oSvaLv1yvWgNdbnxQzytfkCKUGng8X50s0tzaS53WOz5eOvOqcuWp8vek

--
-- Database "duoenglish" dump
--

--
-- PostgreSQL database dump
--

\restrict FOCKAHfyAy1aaUnUAlO6LEbfuUE6MbO8g8xm50Rc0zqc2Ts0IRi9GsbKGpHgHQ9

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-05-27 21:31:05

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4927 (class 1262 OID 16928)
-- Name: duoenglish; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE duoenglish WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_United States.1252';


ALTER DATABASE duoenglish OWNER TO postgres;

\unrestrict FOCKAHfyAy1aaUnUAlO6LEbfuUE6MbO8g8xm50Rc0zqc2Ts0IRi9GsbKGpHgHQ9
\connect duoenglish
\restrict FOCKAHfyAy1aaUnUAlO6LEbfuUE6MbO8g8xm50Rc0zqc2Ts0IRi9GsbKGpHgHQ9

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 220 (class 1259 OID 16930)
-- Name: password_reset_token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.password_reset_token (
    id bigint NOT NULL,
    expiry_date timestamp(6) without time zone,
    token character varying(255),
    user_id bigint
);


ALTER TABLE public.password_reset_token OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16929)
-- Name: password_reset_token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.password_reset_token ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.password_reset_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 222 (class 1259 OID 16937)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    full_name character varying(255),
    password character varying(255) NOT NULL,
    role character varying(255) NOT NULL,
    username character varying(255) NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16936)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.users ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4919 (class 0 OID 16930)
-- Dependencies: 220
-- Data for Name: password_reset_token; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.password_reset_token (id, expiry_date, token, user_id) FROM stdin;
\.


--
-- TOC entry 4921 (class 0 OID 16937)
-- Dependencies: 222
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, email, full_name, password, role, username) FROM stdin;
1	lienhuetien01@gmail.com	\N	$2a$10$vecDZvTWpzuyuIfkQ/SFMu9SVdvkxgBtebHVozbUVUZehreN4pQsm	USER	lienhuetien01@gmail.com
2	admin@gmail.com	admin@gmail.com	$2a$10$NATUPI84WgCYmgcLMMANCuGyjlYKM6A5OalJsgFaisGnMkCKVoxhm	ADMIN	admin
\.


--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 219
-- Name: password_reset_token_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.password_reset_token_id_seq', 1, false);


--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 221
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 2, true);


--
-- TOC entry 4761 (class 2606 OID 16935)
-- Name: password_reset_token password_reset_token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_token
    ADD CONSTRAINT password_reset_token_pkey PRIMARY KEY (id);


--
-- TOC entry 4765 (class 2606 OID 16952)
-- Name: users uk6dotkott2kjsp8vw4d0m25fb7; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uk6dotkott2kjsp8vw4d0m25fb7 UNIQUE (email);


--
-- TOC entry 4763 (class 2606 OID 16950)
-- Name: password_reset_token ukf90ivichjaokvmovxpnlm5nin; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_token
    ADD CONSTRAINT ukf90ivichjaokvmovxpnlm5nin UNIQUE (user_id);


--
-- TOC entry 4767 (class 2606 OID 16954)
-- Name: users ukr43af9ap4edm43mmtq01oddj6; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT ukr43af9ap4edm43mmtq01oddj6 UNIQUE (username);


--
-- TOC entry 4769 (class 2606 OID 16948)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4770 (class 2606 OID 16955)
-- Name: password_reset_token fk83nsrttkwkb6ym0anu051mtxn; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.password_reset_token
    ADD CONSTRAINT fk83nsrttkwkb6ym0anu051mtxn FOREIGN KEY (user_id) REFERENCES public.users(id);


-- Completed on 2026-05-27 21:31:06

--
-- PostgreSQL database dump complete
--

\unrestrict FOCKAHfyAy1aaUnUAlO6LEbfuUE6MbO8g8xm50Rc0zqc2Ts0IRi9GsbKGpHgHQ9

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

\restrict cXubQP2V6O4obK80ErtWHpP7Zbsj3lAvqf3HSF1K4zJS81SAmeGjXCNStOce8XC

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

-- Started on 2026-05-27 21:31:06

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

-- Completed on 2026-05-27 21:31:06

--
-- PostgreSQL database dump complete
--

\unrestrict cXubQP2V6O4obK80ErtWHpP7Zbsj3lAvqf3HSF1K4zJS81SAmeGjXCNStOce8XC

-- Completed on 2026-05-27 21:31:06

--
-- PostgreSQL database cluster dump complete
--

