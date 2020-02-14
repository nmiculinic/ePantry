--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2 (Debian 12.2-1.pgdg100+1)
-- Dumped by pg_dump version 12.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.food_recipe_item
    DROP CONSTRAINT IF EXISTS food_recipe_item_recipe_id_fkey;
ALTER TABLE IF EXISTS ONLY public.food_recipe_item
    DROP CONSTRAINT IF EXISTS food_recipe_item_item_id_fkey;
ALTER TABLE IF EXISTS ONLY public.food_diary
    DROP CONSTRAINT IF EXISTS food_diary_recipe_id_fkey;
ALTER TABLE IF EXISTS ONLY public.schema_migrations
    DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
ALTER TABLE IF EXISTS ONLY public.items
    DROP CONSTRAINT IF EXISTS items_pkey;
ALTER TABLE IF EXISTS ONLY public.items
    DROP CONSTRAINT IF EXISTS items_name_key;
ALTER TABLE IF EXISTS ONLY public.food_recipes
    DROP CONSTRAINT IF EXISTS food_recipes_pkey;
ALTER TABLE IF EXISTS ONLY public.food_recipe_item
    DROP CONSTRAINT IF EXISTS food_recipe_item_pkey;
ALTER TABLE IF EXISTS ONLY public.food_diary
    DROP CONSTRAINT IF EXISTS food_diary_pkey;
ALTER TABLE IF EXISTS public.items
    ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.food_recipes
    ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.food_recipe_item
    ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.food_diary
    ALTER COLUMN id DROP DEFAULT;
DROP TABLE IF EXISTS public.schema_migrations;
DROP SEQUENCE IF EXISTS public.items_id_seq;
DROP TABLE IF EXISTS public.items;
DROP SEQUENCE IF EXISTS public.food_recipes_id_seq;
DROP TABLE IF EXISTS public.food_recipes;
DROP SEQUENCE IF EXISTS public.food_recipe_item_id_seq;
DROP TABLE IF EXISTS public.food_recipe_item;
DROP SEQUENCE IF EXISTS public.food_diary_id_seq;
DROP TABLE IF EXISTS public.food_diary;
DROP SCHEMA IF EXISTS public;
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: food_diary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_diary
(
    id        integer NOT NULL,
    recipe_id integer,
    "time"    timestamp without time zone,
    notes     text
);


ALTER TABLE public.food_diary
    OWNER TO postgres;

--
-- Name: food_diary_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.food_diary_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_diary_id_seq
    OWNER TO postgres;

--
-- Name: food_diary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.food_diary_id_seq OWNED BY public.food_diary.id;


--
-- Name: food_recipe_item; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_recipe_item
(
    id              integer          NOT NULL,
    recipe_id       integer          NOT NULL,
    item_id         integer          NOT NULL,
    amount_kilogram double precision NOT NULL,
    notes           text
);


ALTER TABLE public.food_recipe_item
    OWNER TO postgres;

--
-- Name: food_recipe_item_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.food_recipe_item_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_recipe_item_id_seq
    OWNER TO postgres;

--
-- Name: food_recipe_item_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.food_recipe_item_id_seq OWNED BY public.food_recipe_item.id;


--
-- Name: food_recipes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.food_recipes
(
    id        integer NOT NULL,
    name      text    NOT NULL,
    group_id  integer NOT NULL,
    meal_type text    NOT NULL,
    notes     text    NOT NULL
);


ALTER TABLE public.food_recipes
    OWNER TO postgres;

--
-- Name: food_recipes_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.food_recipes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.food_recipes_id_seq
    OWNER TO postgres;

--
-- Name: food_recipes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.food_recipes_id_seq OWNED BY public.food_recipes.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.items
(
    id                   integer NOT NULL,
    name                 text    NOT NULL,
    notes                text,
    cost_per_kilogram    double precision,
    fats_per_kilogram    double precision,
    carbs_per_kilogram   double precision,
    protein_per_kilogram double precision
);


ALTER TABLE public.items
    OWNER TO postgres;

--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_id_seq
    OWNER TO postgres;

--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations
(
    version bigint  NOT NULL,
    dirty   boolean NOT NULL
);


ALTER TABLE public.schema_migrations
    OWNER TO postgres;

--
-- Name: food_diary id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_diary
    ALTER COLUMN id SET DEFAULT nextval('public.food_diary_id_seq'::regclass);


--
-- Name: food_recipe_item id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_recipe_item
    ALTER COLUMN id SET DEFAULT nextval('public.food_recipe_item_id_seq'::regclass);


--
-- Name: food_recipes id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_recipes
    ALTER COLUMN id SET DEFAULT nextval('public.food_recipes_id_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Data for Name: food_diary; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.food_diary
VALUES (2, 3, '2020-02-14 19:48:16', NULL);
INSERT INTO public.food_diary
VALUES (3, 3, '2020-02-13 19:48:40', NULL);
INSERT INTO public.food_diary
VALUES (4, 4, '2020-02-13 15:48:46', NULL);


--
-- Data for Name: food_recipe_item; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.food_recipe_item
VALUES (1, 3, 1, 0.1, NULL);
INSERT INTO public.food_recipe_item
VALUES (2, 3, 2, 0.05, NULL);
INSERT INTO public.food_recipe_item
VALUES (3, 4, 1, 0.6, NULL);
INSERT INTO public.food_recipe_item
VALUES (4, 4, 3, 0.2, NULL);


--
-- Data for Name: food_recipes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.food_recipes
VALUES (3, 'mrkva i avokado', 1, 'dorucak', 'narezi mrvu i dodaj avokado');
INSERT INTO public.food_recipes
VALUES (4, 'mrkva i tuna', 2, 'rucak', 'pomijesaj mrvku i tunu');


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.items
VALUES (1, 'mrkva', 'mrkva notes', NULL, NULL, NULL, NULL);
INSERT INTO public.items
VALUES (2, 'avokado', 'avokado notes', NULL, NULL, NULL, NULL);
INSERT INTO public.items
VALUES (3, 'tuna', 'tuna notes', NULL, NULL, NULL, NULL);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.schema_migrations
VALUES (1, false);


--
-- Name: food_diary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_diary_id_seq', 4, true);


--
-- Name: food_recipe_item_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_recipe_item_id_seq', 4, true);


--
-- Name: food_recipes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.food_recipes_id_seq', 4, true);


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.items_id_seq', 3, true);


--
-- Name: food_diary food_diary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_diary
    ADD CONSTRAINT food_diary_pkey PRIMARY KEY (id);


--
-- Name: food_recipe_item food_recipe_item_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_recipe_item
    ADD CONSTRAINT food_recipe_item_pkey PRIMARY KEY (id);


--
-- Name: food_recipes food_recipes_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_recipes
    ADD CONSTRAINT food_recipes_pkey PRIMARY KEY (id);


--
-- Name: items items_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_name_key UNIQUE (name);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: food_diary food_diary_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_diary
    ADD CONSTRAINT food_diary_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.food_recipes (id);


--
-- Name: food_recipe_item food_recipe_item_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_recipe_item
    ADD CONSTRAINT food_recipe_item_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items (id);


--
-- Name: food_recipe_item food_recipe_item_recipe_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.food_recipe_item
    ADD CONSTRAINT food_recipe_item_recipe_id_fkey FOREIGN KEY (recipe_id) REFERENCES public.food_recipes (id);


--
-- PostgreSQL database dump complete
--

