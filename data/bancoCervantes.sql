--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-05-19 20:29:41

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
-- TOC entry 4905 (class 1262 OID 16391)
-- Name: testeCervantes; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE "testeCervantes" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';


ALTER DATABASE "testeCervantes" OWNER TO postgres;

\connect "testeCervantes"

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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 220 (class 1255 OID 16417)
-- Name: log_cadastros_changes(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.log_cadastros_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Quando um novo cadastro é inserido
    IF TG_OP = 'INSERT' THEN
        INSERT INTO logs (acao, coduser, nome)
        VALUES ('INSERÇÃO', NEW.coduser, NEW.name);

    -- Quando um cadastro é atualizado
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO logs (acao, coduser, nome)
        VALUES ('ATUALIZAÇÃO', NEW.coduser, NEW.name);

    -- Quando um cadastro é deletado
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO logs (acao, coduser, nome)
        VALUES ('REMOÇÃO', OLD.coduser, OLD.name);
    END IF;

    RETURN NULL; -- Trigger AFTER não precisa retornar a linha
END;
$$;


ALTER FUNCTION public.log_cadastros_changes() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 16393)
-- Name: cadastros; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cadastros (
    coduser integer NOT NULL,
    name text NOT NULL,
    CONSTRAINT coduser_non_negative CHECK ((coduser >= 0))
);


ALTER TABLE public.cadastros OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16407)
-- Name: logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.logs (
    id integer NOT NULL,
    acao text NOT NULL,
    coduser integer,
    nome text,
    data_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.logs OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 16406)
-- Name: logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logs_id_seq OWNER TO postgres;

--
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 218
-- Name: logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.logs_id_seq OWNED BY public.logs.id;


--
-- TOC entry 4747 (class 2604 OID 16410)
-- Name: logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs ALTER COLUMN id SET DEFAULT nextval('public.logs_id_seq'::regclass);


--
-- TOC entry 4753 (class 2606 OID 16415)
-- Name: logs logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.logs
    ADD CONSTRAINT logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4751 (class 2606 OID 16405)
-- Name: cadastros unique_coduser; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cadastros
    ADD CONSTRAINT unique_coduser UNIQUE (coduser);


--
-- TOC entry 4754 (class 2620 OID 16418)
-- Name: cadastros trg_log_cadastros; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_log_cadastros AFTER INSERT OR DELETE OR UPDATE ON public.cadastros FOR EACH ROW EXECUTE FUNCTION public.log_cadastros_changes();


-- Completed on 2025-05-19 20:29:41

--
-- PostgreSQL database dump complete
--

