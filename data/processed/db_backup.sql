--
-- PostgreSQL database dump
--

-- Dumped from database version 17.0
-- Dumped by pg_dump version 17.0

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
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: departments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.departments (
    department_id integer NOT NULL,
    department_name character varying(100) NOT NULL,
    location character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.departments OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.departments_department_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.departments_department_id_seq OWNER TO postgres;

--
-- Name: departments_department_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.departments_department_id_seq OWNED BY public.departments.department_id;


--
-- Name: employee_skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employee_skills (
    employee_id integer NOT NULL,
    skill_id integer NOT NULL,
    proficiency_level character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT employee_skills_proficiency_level_check CHECK (((proficiency_level)::text = ANY ((ARRAY['BEGINNER'::character varying, 'INTERMEDIATE'::character varying, 'ADVANCED'::character varying, 'EXPERT'::character varying])::text[])))
);


ALTER TABLE public.employee_skills OWNER TO postgres;

--
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employee_id integer NOT NULL,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20),
    hire_date date NOT NULL,
    department_id integer,
    position_id integer,
    manager_id integer,
    salary numeric(10,2),
    status character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT employees_status_check CHECK (((status)::text = ANY ((ARRAY['ACTIVE'::character varying, 'INACTIVE'::character varying, 'ON_LEAVE'::character varying])::text[])))
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.employees_employee_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.employees_employee_id_seq OWNER TO postgres;

--
-- Name: employees_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.employees_employee_id_seq OWNED BY public.employees.employee_id;


--
-- Name: leave_requests; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leave_requests (
    leave_id integer NOT NULL,
    employee_id integer,
    start_date date NOT NULL,
    end_date date NOT NULL,
    leave_type character varying(50),
    status character varying(20),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT leave_requests_leave_type_check CHECK (((leave_type)::text = ANY ((ARRAY['VACATION'::character varying, 'SICK'::character varying, 'PERSONAL'::character varying, 'MATERNITY'::character varying, 'PATERNITY'::character varying])::text[]))),
    CONSTRAINT leave_requests_status_check CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'APPROVED'::character varying, 'REJECTED'::character varying])::text[])))
);


ALTER TABLE public.leave_requests OWNER TO postgres;

--
-- Name: leave_requests_leave_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.leave_requests_leave_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leave_requests_leave_id_seq OWNER TO postgres;

--
-- Name: leave_requests_leave_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.leave_requests_leave_id_seq OWNED BY public.leave_requests.leave_id;


--
-- Name: positions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.positions (
    position_id integer NOT NULL,
    position_title character varying(100) NOT NULL,
    min_salary numeric(10,2),
    max_salary numeric(10,2),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.positions OWNER TO postgres;

--
-- Name: positions_position_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.positions_position_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.positions_position_id_seq OWNER TO postgres;

--
-- Name: positions_position_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.positions_position_id_seq OWNED BY public.positions.position_id;


--
-- Name: skills; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.skills (
    skill_id integer NOT NULL,
    skill_name character varying(100) NOT NULL,
    description text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.skills OWNER TO postgres;

--
-- Name: skills_skill_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.skills_skill_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.skills_skill_id_seq OWNER TO postgres;

--
-- Name: skills_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.skills_skill_id_seq OWNED BY public.skills.skill_id;


--
-- Name: departments department_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments ALTER COLUMN department_id SET DEFAULT nextval('public.departments_department_id_seq'::regclass);


--
-- Name: employees employee_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees ALTER COLUMN employee_id SET DEFAULT nextval('public.employees_employee_id_seq'::regclass);


--
-- Name: leave_requests leave_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests ALTER COLUMN leave_id SET DEFAULT nextval('public.leave_requests_leave_id_seq'::regclass);


--
-- Name: positions position_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions ALTER COLUMN position_id SET DEFAULT nextval('public.positions_position_id_seq'::regclass);


--
-- Name: skills skill_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills ALTER COLUMN skill_id SET DEFAULT nextval('public.skills_skill_id_seq'::regclass);


--
-- Data for Name: departments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.departments (department_id, department_name, location, created_at, updated_at) FROM stdin;
1	Production       	\N	2024-10-28 16:25:18.175379	2024-10-28 16:25:18.175379
2	IT/IS	\N	2024-10-28 16:25:18.181406	2024-10-28 16:25:18.181406
3	Software Engineering	\N	2024-10-28 16:25:18.182476	2024-10-28 16:25:18.182476
4	Admin Offices	\N	2024-10-28 16:25:18.182964	2024-10-28 16:25:18.182964
5	Sales	\N	2024-10-28 16:25:18.183371	2024-10-28 16:25:18.183371
6	Executive Office	\N	2024-10-28 16:25:18.183733	2024-10-28 16:25:18.183733
\.


--
-- Data for Name: employee_skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employee_skills (employee_id, skill_id, proficiency_level, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employee_id, first_name, last_name, email, phone, hire_date, department_id, position_id, manager_id, salary, status, created_at, updated_at) FROM stdin;
1	Wilson  K	Adinolfi	wilsonk.adinolfi@company.com	\N	2011-07-05	\N	\N	\N	62506.00	ACTIVE	2024-10-28 16:25:18.198055	2024-10-28 16:25:18.198055
2	Karthikeyan	Ait Sidi	karthikeyan.aitsidi@company.com	\N	2015-03-30	\N	\N	\N	104437.00	ACTIVE	2024-10-28 16:25:18.204932	2024-10-28 16:25:18.204932
3	Sarah	Akinkuolie	sarah.akinkuolie@company.com	\N	2011-07-05	\N	\N	\N	64955.00	ACTIVE	2024-10-28 16:25:18.206039	2024-10-28 16:25:18.206039
4	Trina	Alagbe	trina.alagbe@company.com	\N	2008-01-07	\N	\N	\N	64991.00	ACTIVE	2024-10-28 16:25:18.207625	2024-10-28 16:25:18.207625
5	Carol	Anderson	carol.anderson@company.com	\N	2011-07-11	\N	\N	\N	50825.00	ACTIVE	2024-10-28 16:25:18.208965	2024-10-28 16:25:18.208965
6	Linda	Anderson	linda.anderson@company.com	\N	2012-01-09	\N	\N	\N	57568.00	ACTIVE	2024-10-28 16:25:18.209889	2024-10-28 16:25:18.209889
7	Colby	Andreola	colby.andreola@company.com	\N	2014-11-10	\N	\N	\N	95660.00	ACTIVE	2024-10-28 16:25:18.210658	2024-10-28 16:25:18.210658
8	Sam	Athwal	sam.athwal@company.com	\N	2013-09-30	\N	\N	\N	59365.00	ACTIVE	2024-10-28 16:25:18.211298	2024-10-28 16:25:18.211298
9	Linda	Bachiochi	linda.bachiochi@company.com	\N	2009-07-06	\N	\N	\N	47837.00	ACTIVE	2024-10-28 16:25:18.211866	2024-10-28 16:25:18.211866
10	Alejandro	Bacong	alejandro.bacong@company.com	\N	2015-01-05	\N	\N	\N	50178.00	ACTIVE	2024-10-28 16:25:18.212488	2024-10-28 16:25:18.212488
11	Rachael	Baczenski	rachael.baczenski@company.com	\N	2011-01-10	\N	\N	\N	54670.00	ACTIVE	2024-10-28 16:25:18.213065	2024-10-28 16:25:18.213065
12	Thomas	Barbara	thomas.barbara@company.com	\N	2012-04-02	\N	\N	\N	47211.00	ACTIVE	2024-10-28 16:25:18.214152	2024-10-28 16:25:18.214152
13	Hector	Barbossa	hector.barbossa@company.com	\N	2014-11-10	\N	\N	\N	92328.00	ACTIVE	2024-10-28 16:25:18.214742	2024-10-28 16:25:18.214742
14	Francesco  A	Barone	francescoa.barone@company.com	\N	2012-02-20	\N	\N	\N	58709.00	ACTIVE	2024-10-28 16:25:18.215286	2024-10-28 16:25:18.215286
15	Nader	Barton	nader.barton@company.com	\N	2012-09-24	\N	\N	\N	52505.00	ACTIVE	2024-10-28 16:25:18.216027	2024-10-28 16:25:18.216027
16	Norman	Bates	norman.bates@company.com	\N	2011-02-21	\N	\N	\N	57834.00	ACTIVE	2024-10-28 16:25:18.217057	2024-10-28 16:25:18.217057
17	Kimberly	Beak	kimberly.beak@company.com	\N	2016-07-21	\N	\N	\N	70131.00	ACTIVE	2024-10-28 16:25:18.217968	2024-10-28 16:25:18.217968
18	Courtney	Beatrice	courtney.beatrice@company.com	\N	2011-04-04	\N	\N	\N	59026.00	ACTIVE	2024-10-28 16:25:18.218696	2024-10-28 16:25:18.218696
19	Renee	Becker	renee.becker@company.com	\N	2014-07-07	\N	\N	\N	110000.00	ACTIVE	2024-10-28 16:25:18.219924	2024-10-28 16:25:18.219924
20	Scott	Becker	scott.becker@company.com	\N	2013-07-08	\N	\N	\N	53250.00	ACTIVE	2024-10-28 16:25:18.221589	2024-10-28 16:25:18.221589
21	Sean	Bernstein	sean.bernstein@company.com	\N	2012-04-02	\N	\N	\N	51044.00	ACTIVE	2024-10-28 16:25:18.222369	2024-10-28 16:25:18.222369
22	Lowan  M	Biden	lowanm.biden@company.com	\N	2013-08-19	\N	\N	\N	64919.00	ACTIVE	2024-10-28 16:25:18.223971	2024-10-28 16:25:18.223971
23	Helen	Billis	helen.billis@company.com	\N	2014-07-07	\N	\N	\N	62910.00	ACTIVE	2024-10-28 16:25:18.225145	2024-10-28 16:25:18.225145
24	Dianna	Blount	dianna.blount@company.com	\N	2011-04-04	\N	\N	\N	66441.00	ACTIVE	2024-10-28 16:25:18.225819	2024-10-28 16:25:18.225819
25	Betsy	Bondwell	betsy.bondwell@company.com	\N	2011-01-10	\N	\N	\N	57815.00	ACTIVE	2024-10-28 16:25:18.226389	2024-10-28 16:25:18.226389
26	Frank	Booth	frank.booth@company.com	\N	2014-02-17	\N	\N	\N	103613.00	ACTIVE	2024-10-28 16:25:18.226935	2024-10-28 16:25:18.226935
27	Bonalyn	Boutwell	bonalyn.boutwell@company.com	\N	2015-02-16	\N	\N	\N	106367.00	ACTIVE	2024-10-28 16:25:18.228022	2024-10-28 16:25:18.228022
28	Charles	Bozzi	charles.bozzi@company.com	\N	2013-09-30	\N	\N	\N	74312.00	ACTIVE	2024-10-28 16:25:18.228581	2024-10-28 16:25:18.228581
29	Donna	Brill	donna.brill@company.com	\N	2012-04-02	\N	\N	\N	53492.00	ACTIVE	2024-10-28 16:25:18.229144	2024-10-28 16:25:18.229144
30	Mia	Brown	mia.brown@company.com	\N	2008-10-27	\N	\N	\N	63000.00	ACTIVE	2024-10-28 16:25:18.230403	2024-10-28 16:25:18.230403
31	Joseph	Buccheri	joseph.buccheri@company.com	\N	2014-09-29	\N	\N	\N	65288.00	ACTIVE	2024-10-28 16:25:18.231186	2024-10-28 16:25:18.231186
32	Josephine	Bugali	josephine.bugali@company.com	\N	2013-11-11	\N	\N	\N	64375.00	ACTIVE	2024-10-28 16:25:18.231799	2024-10-28 16:25:18.231799
33	Jessica	Bunbury	jessica.bunbury@company.com	\N	2011-08-15	\N	\N	\N	74326.00	ACTIVE	2024-10-28 16:25:18.232596	2024-10-28 16:25:18.232596
34	Joelle	Burke	joelle.burke@company.com	\N	2012-03-05	\N	\N	\N	63763.00	ACTIVE	2024-10-28 16:25:18.233215	2024-10-28 16:25:18.233215
35	Benjamin	Burkett	benjamin.burkett@company.com	\N	2011-04-04	\N	\N	\N	62162.00	ACTIVE	2024-10-28 16:25:18.233792	2024-10-28 16:25:18.233792
36	Max	Cady	max.cady@company.com	\N	2011-08-15	\N	\N	\N	77692.00	ACTIVE	2024-10-28 16:25:18.234808	2024-10-28 16:25:18.234808
37	Calvin	Candie	calvin.candie@company.com	\N	2016-01-28	\N	\N	\N	72640.00	ACTIVE	2024-10-28 16:25:18.235522	2024-10-28 16:25:18.235522
38	Judith	Carabbio	judith.carabbio@company.com	\N	2013-11-11	\N	\N	\N	93396.00	ACTIVE	2024-10-28 16:25:18.236638	2024-10-28 16:25:18.236638
39	Michael	Carey	michael.carey@company.com	\N	2014-03-31	\N	\N	\N	52846.00	ACTIVE	2024-10-28 16:25:18.237821	2024-10-28 16:25:18.237821
40	Claudia  N	Carr	claudian.carr@company.com	\N	2016-06-30	\N	\N	\N	100031.00	ACTIVE	2024-10-28 16:25:18.238888	2024-10-28 16:25:18.238888
41	Michelle	Carter	michelle.carter@company.com	\N	2014-08-18	\N	\N	\N	71860.00	ACTIVE	2024-10-28 16:25:18.239644	2024-10-28 16:25:18.239644
42	Beatrice	Chace	beatrice.chace@company.com	\N	2014-09-29	\N	\N	\N	61656.00	ACTIVE	2024-10-28 16:25:18.240275	2024-10-28 16:25:18.240275
43	Brian	Champaigne	brian.champaigne@company.com	\N	2016-09-06	\N	\N	\N	110929.00	ACTIVE	2024-10-28 16:25:18.241327	2024-10-28 16:25:18.241327
44	Lin	Chan	lin.chan@company.com	\N	2014-05-12	\N	\N	\N	54237.00	ACTIVE	2024-10-28 16:25:18.241876	2024-10-28 16:25:18.241876
45	Donovan  E	Chang	donovane.chang@company.com	\N	2013-07-08	\N	\N	\N	60380.00	ACTIVE	2024-10-28 16:25:18.242391	2024-10-28 16:25:18.242391
46	Anton	Chigurh	anton.chigurh@company.com	\N	2012-05-14	\N	\N	\N	66808.00	ACTIVE	2024-10-28 16:25:18.243063	2024-10-28 16:25:18.243063
47	Enola	Chivukula	enola.chivukula@company.com	\N	2011-06-27	\N	\N	\N	64786.00	ACTIVE	2024-10-28 16:25:18.243878	2024-10-28 16:25:18.243878
48	Caroline	Cierpiszewski	caroline.cierpiszewski@company.com	\N	2011-10-03	\N	\N	\N	64816.00	ACTIVE	2024-10-28 16:25:18.244683	2024-10-28 16:25:18.244683
49	Rick	Clayton	rick.clayton@company.com	\N	2012-09-05	\N	\N	\N	68678.00	ACTIVE	2024-10-28 16:25:18.245317	2024-10-28 16:25:18.245317
50	Jennifer	Cloninger	jennifer.cloninger@company.com	\N	2011-05-16	\N	\N	\N	64066.00	ACTIVE	2024-10-28 16:25:18.245861	2024-10-28 16:25:18.245861
51	Phil	Close	phil.close@company.com	\N	2010-08-30	\N	\N	\N	59369.00	ACTIVE	2024-10-28 16:25:18.246411	2024-10-28 16:25:18.246411
52	Elijian	Clukey	elijian.clukey@company.com	\N	2016-07-06	\N	\N	\N	50373.00	ACTIVE	2024-10-28 16:25:18.246943	2024-10-28 16:25:18.246943
53	James	Cockel	james.cockel@company.com	\N	2013-07-08	\N	\N	\N	63108.00	ACTIVE	2024-10-28 16:25:18.247512	2024-10-28 16:25:18.247512
54	Spencer	Cole	spencer.cole@company.com	\N	2011-07-11	\N	\N	\N	59144.00	ACTIVE	2024-10-28 16:25:18.24871	2024-10-28 16:25:18.24871
55	Michael	Corleone	michael.corleone@company.com	\N	2010-07-20	\N	\N	\N	68051.00	ACTIVE	2024-10-28 16:25:18.249314	2024-10-28 16:25:18.249314
56	Vito	Corleone	vito.corleone@company.com	\N	2009-01-05	\N	\N	\N	170500.00	ACTIVE	2024-10-28 16:25:18.25006	2024-10-28 16:25:18.25006
57	Lisa	Cornett	lisa.cornett@company.com	\N	2015-01-05	\N	\N	\N	63381.00	ACTIVE	2024-10-28 16:25:18.250794	2024-10-28 16:25:18.250794
58	Frank	Costello	frank.costello@company.com	\N	2015-03-30	\N	\N	\N	83552.00	ACTIVE	2024-10-28 16:25:18.251617	2024-10-28 16:25:18.251617
59	Jean	Crimmings	jean.crimmings@company.com	\N	2016-07-06	\N	\N	\N	56149.00	ACTIVE	2024-10-28 16:25:18.252279	2024-10-28 16:25:18.252279
60	Noah	Cross	noah.cross@company.com	\N	2014-11-10	\N	\N	\N	92329.00	ACTIVE	2024-10-28 16:25:18.253373	2024-10-28 16:25:18.253373
61	Lynn	Daneault	lynn.daneault@company.com	\N	2014-05-05	\N	\N	\N	65729.00	ACTIVE	2024-10-28 16:25:18.254198	2024-10-28 16:25:18.254198
62	Ann	Daniele	ann.daniele@company.com	\N	2014-11-10	\N	\N	\N	85028.00	ACTIVE	2024-10-28 16:25:18.255254	2024-10-28 16:25:18.255254
63	Jene'ya	Darson	jene'ya.darson@company.com	\N	2012-07-02	\N	\N	\N	57583.00	ACTIVE	2024-10-28 16:25:18.255771	2024-10-28 16:25:18.255771
64	Daniel	Davis	daniel.davis@company.com	\N	2011-11-07	\N	\N	\N	56294.00	ACTIVE	2024-10-28 16:25:18.25634	2024-10-28 16:25:18.25634
65	Randy	Dee	randy.dee@company.com	\N	2018-07-09	\N	\N	\N	56991.00	ACTIVE	2024-10-28 16:25:18.256987	2024-10-28 16:25:18.256987
66	James	DeGweck	james.degweck@company.com	\N	2011-05-16	\N	\N	\N	55722.00	ACTIVE	2024-10-28 16:25:18.257806	2024-10-28 16:25:18.257806
67	Keyla	Del Bosque	keyla.delbosque@company.com	\N	2012-01-09	\N	\N	\N	101199.00	ACTIVE	2024-10-28 16:25:18.258948	2024-10-28 16:25:18.258948
68	Alex	Delarge	alex.delarge@company.com	\N	2014-09-29	\N	\N	\N	61568.00	ACTIVE	2024-10-28 16:25:18.259642	2024-10-28 16:25:18.259642
69	Carla	Demita	carla.demita@company.com	\N	2011-04-04	\N	\N	\N	58275.00	ACTIVE	2024-10-28 16:25:18.260829	2024-10-28 16:25:18.260829
70	Carl	Desimone	carl.desimone@company.com	\N	2014-07-07	\N	\N	\N	53189.00	ACTIVE	2024-10-28 16:25:18.261447	2024-10-28 16:25:18.261447
71	Tommy	DeVito	tommy.devito@company.com	\N	2017-02-15	\N	\N	\N	96820.00	ACTIVE	2024-10-28 16:25:18.262525	2024-10-28 16:25:18.262525
72	Geoff	Dickinson	geoff.dickinson@company.com	\N	2014-05-12	\N	\N	\N	51259.00	ACTIVE	2024-10-28 16:25:18.263065	2024-10-28 16:25:18.263065
73	Jenna	Dietrich	jenna.dietrich@company.com	\N	2012-02-20	\N	\N	\N	59231.00	ACTIVE	2024-10-28 16:25:18.263791	2024-10-28 16:25:18.263791
74	Lily	DiNocco	lily.dinocco@company.com	\N	2013-01-07	\N	\N	\N	61584.00	ACTIVE	2024-10-28 16:25:18.264664	2024-10-28 16:25:18.264664
75	Denisa  S	Dobrin	denisas.dobrin@company.com	\N	2012-04-02	\N	\N	\N	46335.00	ACTIVE	2024-10-28 16:25:18.265344	2024-10-28 16:25:18.265344
76	Linda	Dolan	linda.dolan@company.com	\N	2015-01-05	\N	\N	\N	70621.00	ACTIVE	2024-10-28 16:25:18.265977	2024-10-28 16:25:18.265977
77	Eric	Dougall	eric.dougall@company.com	\N	2014-01-05	\N	\N	\N	138888.00	ACTIVE	2024-10-28 16:25:18.266564	2024-10-28 16:25:18.266564
78	Elle	Driver	elle.driver@company.com	\N	2011-01-10	\N	\N	\N	74241.00	ACTIVE	2024-10-28 16:25:18.267122	2024-10-28 16:25:18.267122
79	Amy	Dunn	amy.dunn@company.com	\N	2014-09-18	\N	\N	\N	75188.00	ACTIVE	2024-10-28 16:25:18.267633	2024-10-28 16:25:18.267633
80	Amy	Dunne	amy.dunne@company.com	\N	2010-04-26	\N	\N	\N	62514.00	ACTIVE	2024-10-28 16:25:18.268147	2024-10-28 16:25:18.268147
81	Marianne	Eaton	marianne.eaton@company.com	\N	2011-04-04	\N	\N	\N	60070.00	ACTIVE	2024-10-28 16:25:18.269661	2024-10-28 16:25:18.269661
82	Jean	Engdahl	jean.engdahl@company.com	\N	2014-11-10	\N	\N	\N	48888.00	ACTIVE	2024-10-28 16:25:18.270967	2024-10-28 16:25:18.270967
83	Rex	England	rex.england@company.com	\N	2014-03-31	\N	\N	\N	54285.00	ACTIVE	2024-10-28 16:25:18.272327	2024-10-28 16:25:18.272327
84	Angela	Erilus	angela.erilus@company.com	\N	2014-07-07	\N	\N	\N	56847.00	ACTIVE	2024-10-28 16:25:18.273191	2024-10-28 16:25:18.273191
85	Miguel	Estremera	miguel.estremera@company.com	\N	2012-04-02	\N	\N	\N	60340.00	ACTIVE	2024-10-28 16:25:18.273796	2024-10-28 16:25:18.273796
86	April	Evensen	april.evensen@company.com	\N	2014-02-17	\N	\N	\N	59124.00	ACTIVE	2024-10-28 16:25:18.274346	2024-10-28 16:25:18.274346
87	Susan	Exantus	susan.exantus@company.com	\N	2011-05-02	\N	\N	\N	99280.00	ACTIVE	2024-10-28 16:25:18.274924	2024-10-28 16:25:18.274924
88	Megan	Faller	megan.faller@company.com	\N	2014-07-07	\N	\N	\N	71776.00	ACTIVE	2024-10-28 16:25:18.275798	2024-10-28 16:25:18.275798
89	Nicole	Fancett	nicole.fancett@company.com	\N	2014-02-17	\N	\N	\N	65902.00	ACTIVE	2024-10-28 16:25:18.27655	2024-10-28 16:25:18.27655
90	Susan	Ferguson	susan.ferguson@company.com	\N	2011-11-07	\N	\N	\N	57748.00	ACTIVE	2024-10-28 16:25:18.277177	2024-10-28 16:25:18.277177
91	Nilson	Fernandes	nilson.fernandes@company.com	\N	2015-05-11	\N	\N	\N	64057.00	ACTIVE	2024-10-28 16:25:18.278218	2024-10-28 16:25:18.278218
92	Boba	Fett	boba.fett@company.com	\N	2015-03-30	\N	\N	\N	53366.00	ACTIVE	2024-10-28 16:25:18.278981	2024-10-28 16:25:18.278981
93	Libby	Fidelia	libby.fidelia@company.com	\N	2012-01-09	\N	\N	\N	58530.00	ACTIVE	2024-10-28 16:25:18.279584	2024-10-28 16:25:18.279584
94	Michael  J	Fitzpatrick	michaelj.fitzpatrick@company.com	\N	2011-05-16	\N	\N	\N	72609.00	ACTIVE	2024-10-28 16:25:18.280127	2024-10-28 16:25:18.280127
95	Tanya	Foreman	tanya.foreman@company.com	\N	2011-04-04	\N	\N	\N	55965.00	ACTIVE	2024-10-28 16:25:18.280673	2024-10-28 16:25:18.280673
96	Alex	Forrest	alex.forrest@company.com	\N	2014-09-29	\N	\N	\N	70187.00	ACTIVE	2024-10-28 16:25:18.281155	2024-10-28 16:25:18.281155
97	Jason	Foss	jason.foss@company.com	\N	2011-04-15	\N	\N	\N	178000.00	ACTIVE	2024-10-28 16:25:18.281727	2024-10-28 16:25:18.281727
98	Amy	Foster-Baker	amy.foster-baker@company.com	\N	2009-01-05	\N	\N	\N	99351.00	ACTIVE	2024-10-28 16:25:18.282274	2024-10-28 16:25:18.282274
99	Maruk	Fraval	maruk.fraval@company.com	\N	2011-09-06	\N	\N	\N	67251.00	ACTIVE	2024-10-28 16:25:18.283434	2024-10-28 16:25:18.283434
100	Lisa	Galia	lisa.galia@company.com	\N	2010-05-01	\N	\N	\N	65707.00	ACTIVE	2024-10-28 16:25:18.284116	2024-10-28 16:25:18.284116
101	Raul	Garcia	raul.garcia@company.com	\N	2015-03-30	\N	\N	\N	52249.00	ACTIVE	2024-10-28 16:25:18.284989	2024-10-28 16:25:18.284989
102	Barbara	Gaul	barbara.gaul@company.com	\N	2011-05-16	\N	\N	\N	53171.00	ACTIVE	2024-10-28 16:25:18.285942	2024-10-28 16:25:18.285942
103	Mildred	Gentry	mildred.gentry@company.com	\N	2015-03-30	\N	\N	\N	51337.00	ACTIVE	2024-10-28 16:25:18.286605	2024-10-28 16:25:18.286605
104	Melisa	Gerke	melisa.gerke@company.com	\N	2011-11-07	\N	\N	\N	51505.00	ACTIVE	2024-10-28 16:25:18.287559	2024-10-28 16:25:18.287559
105	Whitney	Gill	whitney.gill@company.com	\N	2014-07-07	\N	\N	\N	59370.00	ACTIVE	2024-10-28 16:25:18.288366	2024-10-28 16:25:18.288366
106	Alex	Gilles	alex.gilles@company.com	\N	2012-04-02	\N	\N	\N	54933.00	ACTIVE	2024-10-28 16:25:18.289008	2024-10-28 16:25:18.289008
107	Evelyn	Girifalco	evelyn.girifalco@company.com	\N	2014-09-29	\N	\N	\N	57815.00	ACTIVE	2024-10-28 16:25:18.290105	2024-10-28 16:25:18.290105
108	Myriam	Givens	myriam.givens@company.com	\N	2015-02-16	\N	\N	\N	61555.00	ACTIVE	2024-10-28 16:25:18.290679	2024-10-28 16:25:18.290679
109	Taisha	Goble	taisha.goble@company.com	\N	2015-02-16	\N	\N	\N	114800.00	ACTIVE	2024-10-28 16:25:18.291222	2024-10-28 16:25:18.291222
110	Amon	Goeth	amon.goeth@company.com	\N	2015-03-30	\N	\N	\N	74679.00	ACTIVE	2024-10-28 16:25:18.291984	2024-10-28 16:25:18.291984
111	Shenice	Gold	shenice.gold@company.com	\N	2013-11-11	\N	\N	\N	53018.00	ACTIVE	2024-10-28 16:25:18.293008	2024-10-28 16:25:18.293008
112	Cayo	Gonzalez	cayo.gonzalez@company.com	\N	2011-07-11	\N	\N	\N	59892.00	ACTIVE	2024-10-28 16:25:18.293937	2024-10-28 16:25:18.293937
113	Juan	Gonzalez	juan.gonzalez@company.com	\N	2010-04-26	\N	\N	\N	68898.00	ACTIVE	2024-10-28 16:25:18.29452	2024-10-28 16:25:18.29452
114	Maria	Gonzalez	maria.gonzalez@company.com	\N	2015-01-05	\N	\N	\N	61242.00	ACTIVE	2024-10-28 16:25:18.295114	2024-10-28 16:25:18.295114
115	Susan	Good	susan.good@company.com	\N	2014-05-12	\N	\N	\N	66825.00	ACTIVE	2024-10-28 16:25:18.295729	2024-10-28 16:25:18.295729
116	David	Gordon	david.gordon@company.com	\N	2012-07-02	\N	\N	\N	48285.00	ACTIVE	2024-10-28 16:25:18.296844	2024-10-28 16:25:18.296844
117	Phylicia	Gosciminski	phylicia.gosciminski@company.com	\N	2013-09-30	\N	\N	\N	66149.00	ACTIVE	2024-10-28 16:25:18.297429	2024-10-28 16:25:18.297429
118	Roxana	Goyal	roxana.goyal@company.com	\N	2013-08-19	\N	\N	\N	49256.00	ACTIVE	2024-10-28 16:25:18.297985	2024-10-28 16:25:18.297985
119	Elijiah	Gray	elijiah.gray@company.com	\N	2015-06-02	\N	\N	\N	62957.00	ACTIVE	2024-10-28 16:25:18.298541	2024-10-28 16:25:18.298541
120	Paula	Gross	paula.gross@company.com	\N	2011-02-21	\N	\N	\N	63813.00	ACTIVE	2024-10-28 16:25:18.299112	2024-10-28 16:25:18.299112
121	Hans	Gruber	hans.gruber@company.com	\N	2017-04-20	\N	\N	\N	99020.00	ACTIVE	2024-10-28 16:25:18.299623	2024-10-28 16:25:18.299623
122	Mike	Guilianno	mike.guilianno@company.com	\N	2012-03-07	\N	\N	\N	71707.00	ACTIVE	2024-10-28 16:25:18.300186	2024-10-28 16:25:18.300186
123	Joanne	Handschiegl	joanne.handschiegl@company.com	\N	2011-11-28	\N	\N	\N	54828.00	ACTIVE	2024-10-28 16:25:18.300681	2024-10-28 16:25:18.300681
124	Earnest	Hankard	earnest.hankard@company.com	\N	2013-11-11	\N	\N	\N	64246.00	ACTIVE	2024-10-28 16:25:18.301217	2024-10-28 16:25:18.301217
125	Christie	Harrington	christie.harrington@company.com	\N	2012-01-09	\N	\N	\N	52177.00	ACTIVE	2024-10-28 16:25:18.301719	2024-10-28 16:25:18.301719
126	Kara	Harrison	kara.harrison@company.com	\N	2014-05-12	\N	\N	\N	62065.00	ACTIVE	2024-10-28 16:25:18.302545	2024-10-28 16:25:18.302545
127	Anthony	Heitzman	anthony.heitzman@company.com	\N	2012-08-13	\N	\N	\N	46998.00	ACTIVE	2024-10-28 16:25:18.303926	2024-10-28 16:25:18.303926
128	Trina	Hendrickson	trina.hendrickson@company.com	\N	2011-01-10	\N	\N	\N	68099.00	ACTIVE	2024-10-28 16:25:18.304695	2024-10-28 16:25:18.304695
129	Alfred	Hitchcock	alfred.hitchcock@company.com	\N	2014-08-18	\N	\N	\N	70545.00	ACTIVE	2024-10-28 16:25:18.305382	2024-10-28 16:25:18.305382
130	Adrienne  J	Homberger	adriennej.homberger@company.com	\N	2011-08-15	\N	\N	\N	63478.00	ACTIVE	2024-10-28 16:25:18.305941	2024-10-28 16:25:18.305941
131	Jayne	Horton	jayne.horton@company.com	\N	2015-03-30	\N	\N	\N	97999.00	ACTIVE	2024-10-28 16:25:18.306482	2024-10-28 16:25:18.306482
132	Debra	Houlihan	debra.houlihan@company.com	\N	2014-05-05	\N	\N	\N	180000.00	ACTIVE	2024-10-28 16:25:18.307083	2024-10-28 16:25:18.307083
133	Estelle	Howard	estelle.howard@company.com	\N	2015-02-16	\N	\N	\N	49920.00	ACTIVE	2024-10-28 16:25:18.307573	2024-10-28 16:25:18.307573
134	Jane	Hudson	jane.hudson@company.com	\N	2012-02-20	\N	\N	\N	55425.00	ACTIVE	2024-10-28 16:25:18.308071	2024-10-28 16:25:18.308071
135	Julissa	Hunts	julissa.hunts@company.com	\N	2016-06-06	\N	\N	\N	69340.00	ACTIVE	2024-10-28 16:25:18.308572	2024-10-28 16:25:18.308572
136	Rosalie	Hutter	rosalie.hutter@company.com	\N	2015-06-05	\N	\N	\N	64995.00	ACTIVE	2024-10-28 16:25:18.309064	2024-10-28 16:25:18.309064
137	Ming	Huynh	ming.huynh@company.com	\N	2011-02-21	\N	\N	\N	68182.00	ACTIVE	2024-10-28 16:25:18.309643	2024-10-28 16:25:18.309643
138	Walter	Immediato	walter.immediato@company.com	\N	2011-02-21	\N	\N	\N	83082.00	ACTIVE	2024-10-28 16:25:18.310694	2024-10-28 16:25:18.310694
139	Rose	Ivey	rose.ivey@company.com	\N	2013-08-19	\N	\N	\N	51908.00	ACTIVE	2024-10-28 16:25:18.31145	2024-10-28 16:25:18.31145
140	Maryellen	Jackson	maryellen.jackson@company.com	\N	2012-11-05	\N	\N	\N	61242.00	ACTIVE	2024-10-28 16:25:18.312472	2024-10-28 16:25:18.312472
141	Hannah	Jacobi	hannah.jacobi@company.com	\N	2013-09-30	\N	\N	\N	45069.00	ACTIVE	2024-10-28 16:25:18.313133	2024-10-28 16:25:18.313133
142	Tayana	Jeannite	tayana.jeannite@company.com	\N	2011-07-05	\N	\N	\N	60724.00	ACTIVE	2024-10-28 16:25:18.313729	2024-10-28 16:25:18.313729
143	Sneha	Jhaveri	sneha.jhaveri@company.com	\N	2014-01-06	\N	\N	\N	60436.00	ACTIVE	2024-10-28 16:25:18.314299	2024-10-28 16:25:18.314299
144	George	Johnson	george.johnson@company.com	\N	2011-11-07	\N	\N	\N	46837.00	ACTIVE	2024-10-28 16:25:18.314883	2024-10-28 16:25:18.314883
145	Noelle	Johnson	noelle.johnson@company.com	\N	2015-01-05	\N	\N	\N	105700.00	ACTIVE	2024-10-28 16:25:18.315452	2024-10-28 16:25:18.315452
146	Yen	Johnston	yen.johnston@company.com	\N	2014-07-07	\N	\N	\N	63322.00	ACTIVE	2024-10-28 16:25:18.315941	2024-10-28 16:25:18.315941
147	Judy	Jung	judy.jung@company.com	\N	2011-01-10	\N	\N	\N	61154.00	ACTIVE	2024-10-28 16:25:18.31687	2024-10-28 16:25:18.31687
148	Donysha	Kampew	donysha.kampew@company.com	\N	2011-11-07	\N	\N	\N	68999.00	ACTIVE	2024-10-28 16:25:18.318324	2024-10-28 16:25:18.318324
149	Kramer	Keatts	kramer.keatts@company.com	\N	2013-09-30	\N	\N	\N	50482.00	ACTIVE	2024-10-28 16:25:18.319787	2024-10-28 16:25:18.319787
150	Bartholemew	Khemmich	bartholemew.khemmich@company.com	\N	2013-08-19	\N	\N	\N	65310.00	ACTIVE	2024-10-28 16:25:18.320706	2024-10-28 16:25:18.320706
151	Janet	King	janet.king@company.com	\N	2012-07-02	\N	\N	\N	250000.00	ACTIVE	2024-10-28 16:25:18.321509	2024-10-28 16:25:18.321509
152	Kathleen	Kinsella	kathleen.kinsella@company.com	\N	2011-09-26	\N	\N	\N	54005.00	ACTIVE	2024-10-28 16:25:18.322444	2024-10-28 16:25:18.322444
153	Alexandra	Kirill	alexandra.kirill@company.com	\N	2011-09-26	\N	\N	\N	45433.00	ACTIVE	2024-10-28 16:25:18.323211	2024-10-28 16:25:18.323211
154	Bradley  J	Knapp	bradleyj.knapp@company.com	\N	2014-02-17	\N	\N	\N	46654.00	ACTIVE	2024-10-28 16:25:18.323818	2024-10-28 16:25:18.323818
155	John	Kretschmer	john.kretschmer@company.com	\N	2011-01-10	\N	\N	\N	63973.00	ACTIVE	2024-10-28 16:25:18.324835	2024-10-28 16:25:18.324835
156	Freddy	Kreuger	freddy.kreuger@company.com	\N	2011-03-07	\N	\N	\N	71339.00	ACTIVE	2024-10-28 16:25:18.325407	2024-10-28 16:25:18.325407
157	Jyoti	Lajiri	jyoti.lajiri@company.com	\N	2014-11-10	\N	\N	\N	93206.00	ACTIVE	2024-10-28 16:25:18.326016	2024-10-28 16:25:18.326016
158	Hans	Landa	hans.landa@company.com	\N	2011-01-10	\N	\N	\N	82758.00	ACTIVE	2024-10-28 16:25:18.326685	2024-10-28 16:25:18.326685
159	Lindsey	Langford	lindsey.langford@company.com	\N	2013-01-07	\N	\N	\N	66074.00	ACTIVE	2024-10-28 16:25:18.327225	2024-10-28 16:25:18.327225
160	Enrico	Langton	enrico.langton@company.com	\N	2012-07-09	\N	\N	\N	46120.00	ACTIVE	2024-10-28 16:25:18.32778	2024-10-28 16:25:18.32778
161	William	LaRotonda	william.larotonda@company.com	\N	2014-01-06	\N	\N	\N	64520.00	ACTIVE	2024-10-28 16:25:18.328488	2024-10-28 16:25:18.328488
162	Mohammed	Latif	mohammed.latif@company.com	\N	2012-04-02	\N	\N	\N	61962.00	ACTIVE	2024-10-28 16:25:18.329037	2024-10-28 16:25:18.329037
163	Binh	Le	binh.le@company.com	\N	2016-10-02	\N	\N	\N	81584.00	ACTIVE	2024-10-28 16:25:18.329579	2024-10-28 16:25:18.329579
164	Dallas	Leach	dallas.leach@company.com	\N	2011-09-26	\N	\N	\N	63676.00	ACTIVE	2024-10-28 16:25:18.330074	2024-10-28 16:25:18.330074
165	Brandon  R	LeBlanc	brandonr.leblanc@company.com	\N	2016-01-05	\N	\N	\N	93046.00	ACTIVE	2024-10-28 16:25:18.330605	2024-10-28 16:25:18.330605
166	Hannibal	Lecter	hannibal.lecter@company.com	\N	2012-05-14	\N	\N	\N	64738.00	ACTIVE	2024-10-28 16:25:18.331595	2024-10-28 16:25:18.331595
167	Giovanni	Leruth	giovanni.leruth@company.com	\N	2012-04-30	\N	\N	\N	70468.00	ACTIVE	2024-10-28 16:25:18.332125	2024-10-28 16:25:18.332125
168	Ketsia	Liebig	ketsia.liebig@company.com	\N	2013-09-30	\N	\N	\N	77915.00	ACTIVE	2024-10-28 16:25:18.332667	2024-10-28 16:25:18.332667
169	Marilyn	Linares	marilyn.linares@company.com	\N	2011-07-05	\N	\N	\N	52624.00	ACTIVE	2024-10-28 16:25:18.333447	2024-10-28 16:25:18.333447
170	Mathew	Linden	mathew.linden@company.com	\N	2013-07-08	\N	\N	\N	63450.00	ACTIVE	2024-10-28 16:25:18.333978	2024-10-28 16:25:18.333978
171	Leonara	Lindsay	leonara.lindsay@company.com	\N	2011-01-21	\N	\N	\N	51777.00	ACTIVE	2024-10-28 16:25:18.334545	2024-10-28 16:25:18.334545
172	Susan	Lundy	susan.lundy@company.com	\N	2013-07-08	\N	\N	\N	67237.00	ACTIVE	2024-10-28 16:25:18.33514	2024-10-28 16:25:18.33514
173	Lisa	Lunquist	lisa.lunquist@company.com	\N	2013-08-19	\N	\N	\N	73330.00	ACTIVE	2024-10-28 16:25:18.336456	2024-10-28 16:25:18.336456
174	Allison	Lydon	allison.lydon@company.com	\N	2015-02-16	\N	\N	\N	52057.00	ACTIVE	2024-10-28 16:25:18.337956	2024-10-28 16:25:18.337956
175	Lindsay	Lynch	lindsay.lynch@company.com	\N	2011-11-07	\N	\N	\N	47434.00	ACTIVE	2024-10-28 16:25:18.339579	2024-10-28 16:25:18.339579
176	Samuel	MacLennan	samuel.maclennan@company.com	\N	2012-09-24	\N	\N	\N	52788.00	ACTIVE	2024-10-28 16:25:18.340904	2024-10-28 16:25:18.340904
177	Lauren	Mahoney	lauren.mahoney@company.com	\N	2014-01-06	\N	\N	\N	45395.00	ACTIVE	2024-10-28 16:25:18.342129	2024-10-28 16:25:18.342129
178	Robyn	Manchester	robyn.manchester@company.com	\N	2016-05-11	\N	\N	\N	62385.00	ACTIVE	2024-10-28 16:25:18.342794	2024-10-28 16:25:18.342794
179	Karen	Mancuso	karen.mancuso@company.com	\N	2011-07-05	\N	\N	\N	68407.00	ACTIVE	2024-10-28 16:25:18.343489	2024-10-28 16:25:18.343489
180	Debbie	Mangal	debbie.mangal@company.com	\N	2013-11-11	\N	\N	\N	61349.00	ACTIVE	2024-10-28 16:25:18.34414	2024-10-28 16:25:18.34414
181	Sandra	Martin	sandra.martin@company.com	\N	2013-11-11	\N	\N	\N	105688.00	ACTIVE	2024-10-28 16:25:18.344946	2024-10-28 16:25:18.344946
182	Shana	Maurice	shana.maurice@company.com	\N	2011-05-31	\N	\N	\N	54132.00	ACTIVE	2024-10-28 16:25:18.34576	2024-10-28 16:25:18.34576
183	B'rigit	Carthy	b'rigit.carthy@company.com	\N	2015-03-30	\N	\N	\N	55315.00	ACTIVE	2024-10-28 16:25:18.346804	2024-10-28 16:25:18.346804
184	Sandy	Mckenna	sandy.mckenna@company.com	\N	2013-01-07	\N	\N	\N	62810.00	ACTIVE	2024-10-28 16:25:18.34772	2024-10-28 16:25:18.34772
185	Jac	McKinzie	jac.mckinzie@company.com	\N	2016-07-06	\N	\N	\N	63291.00	ACTIVE	2024-10-28 16:25:18.348379	2024-10-28 16:25:18.348379
186	Elizabeth	Meads	elizabeth.meads@company.com	\N	2012-04-02	\N	\N	\N	62659.00	ACTIVE	2024-10-28 16:25:18.348933	2024-10-28 16:25:18.348933
187	Jennifer	Medeiros	jennifer.medeiros@company.com	\N	2015-03-30	\N	\N	\N	55688.00	ACTIVE	2024-10-28 16:25:18.349509	2024-10-28 16:25:18.349509
188	Brannon	Miller	brannon.miller@company.com	\N	2012-08-16	\N	\N	\N	83667.00	ACTIVE	2024-10-28 16:25:18.350069	2024-10-28 16:25:18.350069
189	Ned	Miller	ned.miller@company.com	\N	2011-08-15	\N	\N	\N	55800.00	ACTIVE	2024-10-28 16:25:18.350612	2024-10-28 16:25:18.350612
190	Erasumus	Monkfish	erasumus.monkfish@company.com	\N	2011-11-07	\N	\N	\N	58207.00	ACTIVE	2024-10-28 16:25:18.351154	2024-10-28 16:25:18.351154
191	Peter	Monroe	peter.monroe@company.com	\N	2012-02-15	\N	\N	\N	157000.00	ACTIVE	2024-10-28 16:25:18.352608	2024-10-28 16:25:18.352608
192	Luisa	Monterro	luisa.monterro@company.com	\N	2013-05-13	\N	\N	\N	72460.00	ACTIVE	2024-10-28 16:25:18.354036	2024-10-28 16:25:18.354036
193	Patrick	Moran	patrick.moran@company.com	\N	2012-01-09	\N	\N	\N	72106.00	ACTIVE	2024-10-28 16:25:18.354816	2024-10-28 16:25:18.354816
194	Tanya	Morway	tanya.morway@company.com	\N	2015-02-16	\N	\N	\N	52599.00	ACTIVE	2024-10-28 16:25:18.355554	2024-10-28 16:25:18.355554
195	Dawn	Motlagh	dawn.motlagh@company.com	\N	2013-04-01	\N	\N	\N	63430.00	ACTIVE	2024-10-28 16:25:18.356122	2024-10-28 16:25:18.356122
196	Maliki	Moumanil	maliki.moumanil@company.com	\N	2013-05-13	\N	\N	\N	74417.00	ACTIVE	2024-10-28 16:25:18.356669	2024-10-28 16:25:18.356669
197	Michael	Myers	michael.myers@company.com	\N	2013-07-08	\N	\N	\N	57575.00	ACTIVE	2024-10-28 16:25:18.357224	2024-10-28 16:25:18.357224
198	Kurt	Navathe	kurt.navathe@company.com	\N	2017-02-10	\N	\N	\N	87921.00	ACTIVE	2024-10-28 16:25:18.35783	2024-10-28 16:25:18.35783
199	Colombui	Ndzi	colombui.ndzi@company.com	\N	2011-09-26	\N	\N	\N	50470.00	ACTIVE	2024-10-28 16:25:18.35837	2024-10-28 16:25:18.35837
200	Horia	Ndzi	horia.ndzi@company.com	\N	2013-04-01	\N	\N	\N	46664.00	ACTIVE	2024-10-28 16:25:18.359378	2024-10-28 16:25:18.359378
201	Richard	Newman	richard.newman@company.com	\N	2014-05-12	\N	\N	\N	48495.00	ACTIVE	2024-10-28 16:25:18.359928	2024-10-28 16:25:18.359928
202	Shari	Ngodup	shari.ngodup@company.com	\N	2013-04-01	\N	\N	\N	52984.00	ACTIVE	2024-10-28 16:25:18.360508	2024-10-28 16:25:18.360508
203	Dheepa	Nguyen	dheepa.nguyen@company.com	\N	2013-07-08	\N	\N	\N	63695.00	ACTIVE	2024-10-28 16:25:18.361297	2024-10-28 16:25:18.361297
204	Lei-Ming	Nguyen	lei-ming.nguyen@company.com	\N	2013-07-08	\N	\N	\N	62061.00	ACTIVE	2024-10-28 16:25:18.361866	2024-10-28 16:25:18.361866
205	Kristie	Nowlan	kristie.nowlan@company.com	\N	2014-11-10	\N	\N	\N	66738.00	ACTIVE	2024-10-28 16:25:18.362457	2024-10-28 16:25:18.362457
206	Lynn	O'hare	lynn.o'hare@company.com	\N	2014-03-31	\N	\N	\N	52674.00	ACTIVE	2024-10-28 16:25:18.363016	2024-10-28 16:25:18.363016
207	Brooke	Oliver	brooke.oliver@company.com	\N	2012-05-14	\N	\N	\N	71966.00	ACTIVE	2024-10-28 16:25:18.363506	2024-10-28 16:25:18.363506
208	Jasmine	Onque	jasmine.onque@company.com	\N	2013-09-30	\N	\N	\N	63051.00	ACTIVE	2024-10-28 16:25:18.364006	2024-10-28 16:25:18.364006
209	Adeel	Osturnka	adeel.osturnka@company.com	\N	2013-09-30	\N	\N	\N	47414.00	ACTIVE	2024-10-28 16:25:18.364566	2024-10-28 16:25:18.364566
210	Clinton	Owad	clinton.owad@company.com	\N	2014-02-17	\N	\N	\N	53060.00	ACTIVE	2024-10-28 16:25:18.365092	2024-10-28 16:25:18.365092
211	Travis	Ozark	travis.ozark@company.com	\N	2015-01-05	\N	\N	\N	68829.00	ACTIVE	2024-10-28 16:25:18.366052	2024-10-28 16:25:18.366052
212	Nina	Panjwani	nina.panjwani@company.com	\N	2011-02-07	\N	\N	\N	63515.00	ACTIVE	2024-10-28 16:25:18.366593	2024-10-28 16:25:18.366593
213	Lucas	Patronick	lucas.patronick@company.com	\N	2011-11-07	\N	\N	\N	108987.00	ACTIVE	2024-10-28 16:25:18.367326	2024-10-28 16:25:18.367326
214	Randall	Pearson	randall.pearson@company.com	\N	2014-12-01	\N	\N	\N	93093.00	ACTIVE	2024-10-28 16:25:18.368141	2024-10-28 16:25:18.368141
215	Martin	Smith	martin.smith@company.com	\N	2011-01-10	\N	\N	\N	53564.00	ACTIVE	2024-10-28 16:25:18.368888	2024-10-28 16:25:18.368888
216	Ermine	Pelletier	ermine.pelletier@company.com	\N	2011-07-05	\N	\N	\N	60270.00	ACTIVE	2024-10-28 16:25:18.369666	2024-10-28 16:25:18.369666
217	Shakira	Perry	shakira.perry@company.com	\N	2011-05-16	\N	\N	\N	45998.00	ACTIVE	2024-10-28 16:25:18.370343	2024-10-28 16:25:18.370343
218	Lauren	Peters	lauren.peters@company.com	\N	2011-05-16	\N	\N	\N	57954.00	ACTIVE	2024-10-28 16:25:18.370976	2024-10-28 16:25:18.370976
219	Ebonee	Peterson	ebonee.peterson@company.com	\N	2010-10-25	\N	\N	\N	74669.00	ACTIVE	2024-10-28 16:25:18.371537	2024-10-28 16:25:18.371537
220	Shana	Petingill	shana.petingill@company.com	\N	2012-04-02	\N	\N	\N	74226.00	ACTIVE	2024-10-28 16:25:18.372119	2024-10-28 16:25:18.372119
221	Thelma	Petrowsky	thelma.petrowsky@company.com	\N	2014-11-10	\N	\N	\N	93554.00	ACTIVE	2024-10-28 16:25:18.373137	2024-10-28 16:25:18.373137
222	Hong	Pham	hong.pham@company.com	\N	2011-07-05	\N	\N	\N	64724.00	ACTIVE	2024-10-28 16:25:18.373685	2024-10-28 16:25:18.373685
223	Brad	Pitt	brad.pitt@company.com	\N	2007-11-05	\N	\N	\N	47001.00	ACTIVE	2024-10-28 16:25:18.374247	2024-10-28 16:25:18.374247
224	Xana	Potts	xana.potts@company.com	\N	2012-01-09	\N	\N	\N	61844.00	ACTIVE	2024-10-28 16:25:18.375217	2024-10-28 16:25:18.375217
225	Morissa	Power	morissa.power@company.com	\N	2011-05-16	\N	\N	\N	46799.00	ACTIVE	2024-10-28 16:25:18.375937	2024-10-28 16:25:18.375937
226	Louis	Punjabhi	louis.punjabhi@company.com	\N	2014-01-06	\N	\N	\N	59472.00	ACTIVE	2024-10-28 16:25:18.376442	2024-10-28 16:25:18.376442
227	Janine	Purinton	janine.purinton@company.com	\N	2012-09-24	\N	\N	\N	46430.00	ACTIVE	2024-10-28 16:25:18.376966	2024-10-28 16:25:18.376966
228	Sean	Quinn	sean.quinn@company.com	\N	2011-02-21	\N	\N	\N	83363.00	ACTIVE	2024-10-28 16:25:18.377497	2024-10-28 16:25:18.377497
229	Maggie	Rachael	maggie.rachael@company.com	\N	2016-10-02	\N	\N	\N	95920.00	ACTIVE	2024-10-28 16:25:18.377971	2024-10-28 16:25:18.377971
230	Quinn	Rarrick	quinn.rarrick@company.com	\N	2011-09-26	\N	\N	\N	61729.00	ACTIVE	2024-10-28 16:25:18.378545	2024-10-28 16:25:18.378545
231	Kylo	Ren	kylo.ren@company.com	\N	2014-05-12	\N	\N	\N	61809.00	ACTIVE	2024-10-28 16:25:18.379083	2024-10-28 16:25:18.379083
232	Thomas	Rhoads	thomas.rhoads@company.com	\N	2011-05-16	\N	\N	\N	45115.00	ACTIVE	2024-10-28 16:25:18.380098	2024-10-28 16:25:18.380098
233	Haley	Rivera	haley.rivera@company.com	\N	2011-11-28	\N	\N	\N	46738.00	ACTIVE	2024-10-28 16:25:18.380597	2024-10-28 16:25:18.380597
234	May	Roberson	may.roberson@company.com	\N	2011-09-26	\N	\N	\N	64971.00	ACTIVE	2024-10-28 16:25:18.381162	2024-10-28 16:25:18.381162
235	Peter	Robertson	peter.robertson@company.com	\N	2011-07-05	\N	\N	\N	55578.00	ACTIVE	2024-10-28 16:25:18.381689	2024-10-28 16:25:18.381689
236	Alain	Robinson	alain.robinson@company.com	\N	2011-01-10	\N	\N	\N	50428.00	ACTIVE	2024-10-28 16:25:18.382229	2024-10-28 16:25:18.382229
237	Cherly	Robinson	cherly.robinson@company.com	\N	2011-01-10	\N	\N	\N	61422.00	ACTIVE	2024-10-28 16:25:18.382739	2024-10-28 16:25:18.382739
238	Elias	Robinson	elias.robinson@company.com	\N	2013-07-08	\N	\N	\N	63353.00	ACTIVE	2024-10-28 16:25:18.383287	2024-10-28 16:25:18.383287
239	Lori	Roby	lori.roby@company.com	\N	2015-02-16	\N	\N	\N	89883.00	ACTIVE	2024-10-28 16:25:18.383818	2024-10-28 16:25:18.383818
240	Bianca	Roehrich	bianca.roehrich@company.com	\N	2015-01-05	\N	\N	\N	120000.00	ACTIVE	2024-10-28 16:25:18.384305	2024-10-28 16:25:18.384305
241	Katie	Roper	katie.roper@company.com	\N	2017-01-07	\N	\N	\N	150290.00	ACTIVE	2024-10-28 16:25:18.384916	2024-10-28 16:25:18.384916
242	Ashley	Rose	ashley.rose@company.com	\N	2014-01-06	\N	\N	\N	60627.00	ACTIVE	2024-10-28 16:25:18.385609	2024-10-28 16:25:18.385609
243	Bruno	Rossetti	bruno.rossetti@company.com	\N	2011-04-04	\N	\N	\N	53180.00	ACTIVE	2024-10-28 16:25:18.386541	2024-10-28 16:25:18.386541
244	Simon	Roup	simon.roup@company.com	\N	2013-01-20	\N	\N	\N	140920.00	ACTIVE	2024-10-28 16:25:18.387498	2024-10-28 16:25:18.387498
245	Ricardo	Ruiz	ricardo.ruiz@company.com	\N	2012-01-09	\N	\N	\N	148999.00	ACTIVE	2024-10-28 16:25:18.388116	2024-10-28 16:25:18.388116
246	Adell	Saada	adell.saada@company.com	\N	2012-11-05	\N	\N	\N	86214.00	ACTIVE	2024-10-28 16:25:18.388857	2024-10-28 16:25:18.388857
247	Melinda	Saar-Beckles	melinda.saar-beckles@company.com	\N	2016-07-04	\N	\N	\N	47750.00	ACTIVE	2024-10-28 16:25:18.389459	2024-10-28 16:25:18.389459
248	Nore	Sadki	nore.sadki@company.com	\N	2009-01-05	\N	\N	\N	46428.00	ACTIVE	2024-10-28 16:25:18.389968	2024-10-28 16:25:18.389968
249	Adil	Sahoo	adil.sahoo@company.com	\N	2010-08-30	\N	\N	\N	57975.00	ACTIVE	2024-10-28 16:25:18.390516	2024-10-28 16:25:18.390516
250	Jason	Salter	jason.salter@company.com	\N	2015-01-05	\N	\N	\N	88527.00	ACTIVE	2024-10-28 16:25:18.391114	2024-10-28 16:25:18.391114
251	Kamrin	Sander	kamrin.sander@company.com	\N	2014-09-29	\N	\N	\N	56147.00	ACTIVE	2024-10-28 16:25:18.391674	2024-10-28 16:25:18.391674
252	Nori	Sewkumar	nori.sewkumar@company.com	\N	2013-09-30	\N	\N	\N	50923.00	ACTIVE	2024-10-28 16:25:18.392202	2024-10-28 16:25:18.392202
253	Anita	Shepard	anita.shepard@company.com	\N	2014-09-30	\N	\N	\N	50750.00	ACTIVE	2024-10-28 16:25:18.392743	2024-10-28 16:25:18.392743
254	Seffi	Shields	seffi.shields@company.com	\N	2013-08-19	\N	\N	\N	52087.00	ACTIVE	2024-10-28 16:25:18.393746	2024-10-28 16:25:18.393746
255	Kramer	Simard	kramer.simard@company.com	\N	2015-01-05	\N	\N	\N	87826.00	ACTIVE	2024-10-28 16:25:18.394298	2024-10-28 16:25:18.394298
256	Nan	Singh	nan.singh@company.com	\N	2015-05-01	\N	\N	\N	51920.00	ACTIVE	2024-10-28 16:25:18.394794	2024-10-28 16:25:18.394794
257	Constance	Sloan	constance.sloan@company.com	\N	2009-10-26	\N	\N	\N	63878.00	ACTIVE	2024-10-28 16:25:18.395479	2024-10-28 16:25:18.395479
258	Joe	Smith	joe.smith@company.com	\N	2014-09-29	\N	\N	\N	60656.00	ACTIVE	2024-10-28 16:25:18.396074	2024-10-28 16:25:18.396074
259	John	Smith	john.smith@company.com	\N	2014-05-18	\N	\N	\N	72992.00	ACTIVE	2024-10-28 16:25:18.396656	2024-10-28 16:25:18.396656
260	Leigh Ann	Smith	leighann.smith@company.com	\N	2011-09-26	\N	\N	\N	55000.00	ACTIVE	2024-10-28 16:25:18.397207	2024-10-28 16:25:18.397207
261	Sade	Smith	sade.smith@company.com	\N	2013-11-11	\N	\N	\N	58939.00	ACTIVE	2024-10-28 16:25:18.39769	2024-10-28 16:25:18.39769
262	Julia	Soto	julia.soto@company.com	\N	2011-06-10	\N	\N	\N	66593.00	ACTIVE	2024-10-28 16:25:18.398244	2024-10-28 16:25:18.398244
263	Keyser	Soze	keyser.soze@company.com	\N	2016-06-30	\N	\N	\N	87565.00	ACTIVE	2024-10-28 16:25:18.39878	2024-10-28 16:25:18.39878
264	Taylor	Sparks	taylor.sparks@company.com	\N	2012-02-20	\N	\N	\N	64021.00	ACTIVE	2024-10-28 16:25:18.399322	2024-10-28 16:25:18.399322
265	Kelley	Spirea	kelley.spirea@company.com	\N	2012-10-02	\N	\N	\N	65714.00	ACTIVE	2024-10-28 16:25:18.399876	2024-10-28 16:25:18.399876
266	Kristen	Squatrito	kristen.squatrito@company.com	\N	2013-05-13	\N	\N	\N	62425.00	ACTIVE	2024-10-28 16:25:18.401092	2024-10-28 16:25:18.401092
267	Barbara  M	Stanford	barbaram.stanford@company.com	\N	2011-01-10	\N	\N	\N	47961.00	ACTIVE	2024-10-28 16:25:18.402797	2024-10-28 16:25:18.402797
268	Norman	Stansfield	norman.stansfield@company.com	\N	2014-05-12	\N	\N	\N	58273.00	ACTIVE	2024-10-28 16:25:18.403972	2024-10-28 16:25:18.403972
269	Tyrone	Steans	tyrone.steans@company.com	\N	2014-09-29	\N	\N	\N	63003.00	ACTIVE	2024-10-28 16:25:18.404791	2024-10-28 16:25:18.404791
270	Rick	Stoica	rick.stoica@company.com	\N	2014-02-17	\N	\N	\N	61355.00	ACTIVE	2024-10-28 16:25:18.40554	2024-10-28 16:25:18.40554
271	Caitrin	Strong	caitrin.strong@company.com	\N	2010-09-27	\N	\N	\N	60120.00	ACTIVE	2024-10-28 16:25:18.406138	2024-10-28 16:25:18.406138
272	Kissy	Sullivan	kissy.sullivan@company.com	\N	2009-01-08	\N	\N	\N	63682.00	ACTIVE	2024-10-28 16:25:18.406706	2024-10-28 16:25:18.406706
273	Timothy	Sullivan	timothy.sullivan@company.com	\N	2015-01-05	\N	\N	\N	63025.00	ACTIVE	2024-10-28 16:25:18.40786	2024-10-28 16:25:18.40786
274	Barbara	Sutwell	barbara.sutwell@company.com	\N	2012-05-14	\N	\N	\N	59238.00	ACTIVE	2024-10-28 16:25:18.408515	2024-10-28 16:25:18.408515
275	Andrew	Szabo	andrew.szabo@company.com	\N	2014-07-07	\N	\N	\N	92989.00	ACTIVE	2024-10-28 16:25:18.409323	2024-10-28 16:25:18.409323
276	Biff	Tannen	biff.tannen@company.com	\N	2017-04-20	\N	\N	\N	90100.00	ACTIVE	2024-10-28 16:25:18.409901	2024-10-28 16:25:18.409901
277	Desiree	Tavares	desiree.tavares@company.com	\N	2009-04-27	\N	\N	\N	60754.00	ACTIVE	2024-10-28 16:25:18.410475	2024-10-28 16:25:18.410475
278	Lenora	Tejeda	lenora.tejeda@company.com	\N	2011-05-16	\N	\N	\N	72202.00	ACTIVE	2024-10-28 16:25:18.41101	2024-10-28 16:25:18.41101
279	Sharlene	Terry	sharlene.terry@company.com	\N	2014-09-29	\N	\N	\N	58370.00	ACTIVE	2024-10-28 16:25:18.411598	2024-10-28 16:25:18.411598
280	Sophia	Theamstern	sophia.theamstern@company.com	\N	2011-07-05	\N	\N	\N	48413.00	ACTIVE	2024-10-28 16:25:18.412145	2024-10-28 16:25:18.412145
281	Kenneth	Thibaud	kenneth.thibaud@company.com	\N	2007-06-25	\N	\N	\N	67176.00	ACTIVE	2024-10-28 16:25:18.412717	2024-10-28 16:25:18.412717
282	Jeanette	Tippett	jeanette.tippett@company.com	\N	2013-02-18	\N	\N	\N	56339.00	ACTIVE	2024-10-28 16:25:18.41323	2024-10-28 16:25:18.41323
283	Jack	Torrence	jack.torrence@company.com	\N	2006-01-09	\N	\N	\N	64397.00	ACTIVE	2024-10-28 16:25:18.413763	2024-10-28 16:25:18.413763
284	Mei	Trang	mei.trang@company.com	\N	2014-02-17	\N	\N	\N	63025.00	ACTIVE	2024-10-28 16:25:18.414765	2024-10-28 16:25:18.414765
285	Neville	Tredinnick	neville.tredinnick@company.com	\N	2015-01-05	\N	\N	\N	75281.00	ACTIVE	2024-10-28 16:25:18.415356	2024-10-28 16:25:18.415356
286	Edward	True	edward.true@company.com	\N	2013-02-18	\N	\N	\N	100416.00	ACTIVE	2024-10-28 16:25:18.416139	2024-10-28 16:25:18.416139
287	Cybil	Trzeciak	cybil.trzeciak@company.com	\N	2011-01-10	\N	\N	\N	74813.00	ACTIVE	2024-10-28 16:25:18.41678	2024-10-28 16:25:18.41678
288	Jumil	Turpin	jumil.turpin@company.com	\N	2015-03-30	\N	\N	\N	76029.00	ACTIVE	2024-10-28 16:25:18.41734	2024-10-28 16:25:18.41734
289	Jackie	Valentin	jackie.valentin@company.com	\N	2011-07-05	\N	\N	\N	57859.00	ACTIVE	2024-10-28 16:25:18.417868	2024-10-28 16:25:18.417868
290	Abdellah	Veera	abdellah.veera@company.com	\N	2012-08-13	\N	\N	\N	58523.00	ACTIVE	2024-10-28 16:25:18.418441	2024-10-28 16:25:18.418441
291	Vincent	Vega	vincent.vega@company.com	\N	2011-08-01	\N	\N	\N	88976.00	ACTIVE	2024-10-28 16:25:18.419178	2024-10-28 16:25:18.419178
292	Noah	Villanueva	noah.villanueva@company.com	\N	2012-03-05	\N	\N	\N	55875.00	ACTIVE	2024-10-28 16:25:18.420249	2024-10-28 16:25:18.420249
293	Lord	Voldemort	lord.voldemort@company.com	\N	2015-02-16	\N	\N	\N	113999.00	ACTIVE	2024-10-28 16:25:18.421485	2024-10-28 16:25:18.421485
294	Colleen	Volk	colleen.volk@company.com	\N	2011-09-26	\N	\N	\N	49773.00	ACTIVE	2024-10-28 16:25:18.422291	2024-10-28 16:25:18.422291
295	Anna	Von Massenbach	anna.vonmassenbach@company.com	\N	2015-07-05	\N	\N	\N	62068.00	ACTIVE	2024-10-28 16:25:18.422947	2024-10-28 16:25:18.422947
296	Roger	Walker	roger.walker@company.com	\N	2014-08-18	\N	\N	\N	66541.00	ACTIVE	2024-10-28 16:25:18.423544	2024-10-28 16:25:18.423544
297	Courtney  E	Wallace	courtneye.wallace@company.com	\N	2011-09-26	\N	\N	\N	80512.00	ACTIVE	2024-10-28 16:25:18.424131	2024-10-28 16:25:18.424131
298	Theresa	Wallace	theresa.wallace@company.com	\N	2012-08-13	\N	\N	\N	50274.00	ACTIVE	2024-10-28 16:25:18.424773	2024-10-28 16:25:18.424773
299	Charlie	Wang	charlie.wang@company.com	\N	2017-02-15	\N	\N	\N	84903.00	ACTIVE	2024-10-28 16:25:18.425309	2024-10-28 16:25:18.425309
300	Sarah	Warfield	sarah.warfield@company.com	\N	2015-03-30	\N	\N	\N	107226.00	ACTIVE	2024-10-28 16:25:18.42584	2024-10-28 16:25:18.42584
301	Scott	Whittier	scott.whittier@company.com	\N	2011-01-10	\N	\N	\N	58371.00	ACTIVE	2024-10-28 16:25:18.426337	2024-10-28 16:25:18.426337
302	Barry	Wilber	barry.wilber@company.com	\N	2011-05-16	\N	\N	\N	55140.00	ACTIVE	2024-10-28 16:25:18.426873	2024-10-28 16:25:18.426873
303	Annie	Wilkes	annie.wilkes@company.com	\N	2011-01-10	\N	\N	\N	58062.00	ACTIVE	2024-10-28 16:25:18.427373	2024-10-28 16:25:18.427373
304	Jacquelyn	Williams	jacquelyn.williams@company.com	\N	2012-01-09	\N	\N	\N	59728.00	ACTIVE	2024-10-28 16:25:18.427887	2024-10-28 16:25:18.427887
305	Jordan	Winthrop	jordan.winthrop@company.com	\N	2013-01-07	\N	\N	\N	70507.00	ACTIVE	2024-10-28 16:25:18.428366	2024-10-28 16:25:18.428366
306	Hang  T	Wolk	hangt.wolk@company.com	\N	2014-09-29	\N	\N	\N	60446.00	ACTIVE	2024-10-28 16:25:18.428878	2024-10-28 16:25:18.428878
307	Jason	Woodson	jason.woodson@company.com	\N	2014-07-07	\N	\N	\N	65893.00	ACTIVE	2024-10-28 16:25:18.429446	2024-10-28 16:25:18.429446
308	Catherine	Ybarra	catherine.ybarra@company.com	\N	2008-09-02	\N	\N	\N	48513.00	ACTIVE	2024-10-28 16:25:18.430015	2024-10-28 16:25:18.430015
309	Jennifer	Zamora	jennifer.zamora@company.com	\N	2010-04-10	\N	\N	\N	220450.00	ACTIVE	2024-10-28 16:25:18.43062	2024-10-28 16:25:18.43062
310	Julia	Zhou	julia.zhou@company.com	\N	2015-03-30	\N	\N	\N	89292.00	ACTIVE	2024-10-28 16:25:18.43115	2024-10-28 16:25:18.43115
311	Colleen	Zima	colleen.zima@company.com	\N	2014-09-29	\N	\N	\N	45046.00	ACTIVE	2024-10-28 16:25:18.431689	2024-10-28 16:25:18.431689
\.


--
-- Data for Name: leave_requests; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leave_requests (leave_id, employee_id, start_date, end_date, leave_type, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: positions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.positions (position_id, position_title, min_salary, max_salary, created_at, updated_at) FROM stdin;
1	Production Technician I	0.00	0.00	2024-10-28 16:25:18.184678	2024-10-28 16:25:18.184678
2	Sr. DBA	0.00	0.00	2024-10-28 16:25:18.18751	2024-10-28 16:25:18.18751
3	Production Technician II	0.00	0.00	2024-10-28 16:25:18.188306	2024-10-28 16:25:18.188306
4	Software Engineer	0.00	0.00	2024-10-28 16:25:18.188811	2024-10-28 16:25:18.188811
5	IT Support	0.00	0.00	2024-10-28 16:25:18.189398	2024-10-28 16:25:18.189398
6	Data Analyst	0.00	0.00	2024-10-28 16:25:18.189948	2024-10-28 16:25:18.189948
7	Database Administrator	0.00	0.00	2024-10-28 16:25:18.190477	2024-10-28 16:25:18.190477
8	Enterprise Architect	0.00	0.00	2024-10-28 16:25:18.190941	2024-10-28 16:25:18.190941
9	Sr. Accountant	0.00	0.00	2024-10-28 16:25:18.191332	2024-10-28 16:25:18.191332
10	Production Manager	0.00	0.00	2024-10-28 16:25:18.191669	2024-10-28 16:25:18.191669
11	Accountant I	0.00	0.00	2024-10-28 16:25:18.191895	2024-10-28 16:25:18.191895
12	Area Sales Manager	0.00	0.00	2024-10-28 16:25:18.19211	2024-10-28 16:25:18.19211
13	Software Engineering Manager	0.00	0.00	2024-10-28 16:25:18.192832	2024-10-28 16:25:18.192832
14	BI Director	0.00	0.00	2024-10-28 16:25:18.193051	2024-10-28 16:25:18.193051
15	Director of Operations	0.00	0.00	2024-10-28 16:25:18.193262	2024-10-28 16:25:18.193262
16	Sr. Network Engineer	0.00	0.00	2024-10-28 16:25:18.193484	2024-10-28 16:25:18.193484
17	Sales Manager	0.00	0.00	2024-10-28 16:25:18.193677	2024-10-28 16:25:18.193677
18	BI Developer	0.00	0.00	2024-10-28 16:25:18.19388	2024-10-28 16:25:18.19388
19	IT Manager - Support	0.00	0.00	2024-10-28 16:25:18.194076	2024-10-28 16:25:18.194076
20	Network Engineer	0.00	0.00	2024-10-28 16:25:18.194601	2024-10-28 16:25:18.194601
21	IT Director	0.00	0.00	2024-10-28 16:25:18.195014	2024-10-28 16:25:18.195014
22	Director of Sales	0.00	0.00	2024-10-28 16:25:18.195398	2024-10-28 16:25:18.195398
23	Administrative Assistant	0.00	0.00	2024-10-28 16:25:18.195739	2024-10-28 16:25:18.195739
24	President & CEO	0.00	0.00	2024-10-28 16:25:18.196052	2024-10-28 16:25:18.196052
25	Senior BI Developer	0.00	0.00	2024-10-28 16:25:18.19632	2024-10-28 16:25:18.19632
26	Shared Services Manager	0.00	0.00	2024-10-28 16:25:18.196548	2024-10-28 16:25:18.196548
27	IT Manager - Infra	0.00	0.00	2024-10-28 16:25:18.196752	2024-10-28 16:25:18.196752
28	Principal Data Architect	0.00	0.00	2024-10-28 16:25:18.196945	2024-10-28 16:25:18.196945
29	Data Architect	0.00	0.00	2024-10-28 16:25:18.197136	2024-10-28 16:25:18.197136
30	IT Manager - DB	0.00	0.00	2024-10-28 16:25:18.197326	2024-10-28 16:25:18.197326
31	Data Analyst 	0.00	0.00	2024-10-28 16:25:18.197513	2024-10-28 16:25:18.197513
32	CIO	0.00	0.00	2024-10-28 16:25:18.1977	2024-10-28 16:25:18.1977
\.


--
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.skills (skill_id, skill_name, description, created_at, updated_at) FROM stdin;
\.


--
-- Name: departments_department_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.departments_department_id_seq', 6, true);


--
-- Name: employees_employee_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.employees_employee_id_seq', 311, true);


--
-- Name: leave_requests_leave_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.leave_requests_leave_id_seq', 1, false);


--
-- Name: positions_position_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.positions_position_id_seq', 32, true);


--
-- Name: skills_skill_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.skills_skill_id_seq', 1, false);


--
-- Name: departments departments_department_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_department_name_key UNIQUE (department_name);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (department_id);


--
-- Name: employee_skills employee_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_skills
    ADD CONSTRAINT employee_skills_pkey PRIMARY KEY (employee_id, skill_id);


--
-- Name: employees employees_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_email_key UNIQUE (email);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employee_id);


--
-- Name: leave_requests leave_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_pkey PRIMARY KEY (leave_id);


--
-- Name: positions positions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_pkey PRIMARY KEY (position_id);


--
-- Name: positions positions_position_title_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.positions
    ADD CONSTRAINT positions_position_title_key UNIQUE (position_title);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (skill_id);


--
-- Name: departments update_departments_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_departments_updated_at BEFORE UPDATE ON public.departments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: employee_skills update_employee_skills_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_employee_skills_updated_at BEFORE UPDATE ON public.employee_skills FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: employees update_employees_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_employees_updated_at BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: leave_requests update_leave_requests_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_leave_requests_updated_at BEFORE UPDATE ON public.leave_requests FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: positions update_positions_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_positions_updated_at BEFORE UPDATE ON public.positions FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: skills update_skills_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER update_skills_updated_at BEFORE UPDATE ON public.skills FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: employee_skills employee_skills_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_skills
    ADD CONSTRAINT employee_skills_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- Name: employee_skills employee_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employee_skills
    ADD CONSTRAINT employee_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(skill_id);


--
-- Name: employees employees_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(department_id);


--
-- Name: employees employees_manager_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.employees(employee_id);


--
-- Name: employees employees_position_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_position_id_fkey FOREIGN KEY (position_id) REFERENCES public.positions(position_id);


--
-- Name: leave_requests leave_requests_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leave_requests
    ADD CONSTRAINT leave_requests_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- PostgreSQL database dump complete
--

