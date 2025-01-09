--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Debian 16.4-1.pgdg110+2)
-- Dumped by pg_dump version 16.4 (Debian 16.4-1.pgdg110+2)

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

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: auth_user_group_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_group_roles (
    auth_user_id bigint NOT NULL,
    group_id bigint NOT NULL,
    role_id bigint NOT NULL
);


ALTER TABLE public.auth_user_group_roles OWNER TO postgres;

--
-- Name: auth_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_users (
    id bigint NOT NULL,
    name character varying,
    email character varying,
    password character varying,
    idno character varying,
    uuid character varying,
    tp_account character varying,
    member_type character varying,
    verify_level character varying,
    is_admin boolean DEFAULT false,
    is_active boolean DEFAULT true,
    is_whitelist boolean DEFAULT false,
    is_blacked boolean DEFAULT false,
    expired_at timestamp with time zone,
    created_at timestamp with time zone,
    login_at timestamp with time zone,
    CONSTRAINT chk_auth_users_email CHECK (((email)::text ~* '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'::text))
);


ALTER TABLE public.auth_users OWNER TO postgres;

--
-- Name: auth_users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_users_id_seq OWNER TO postgres;

--
-- Name: auth_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_users_id_seq OWNED BY public.auth_users.id;


--
-- Name: component_charts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.component_charts (
    index character varying NOT NULL,
    color character varying[],
    types character varying[],
    unit character varying
);


ALTER TABLE public.component_charts OWNER TO postgres;

--
-- Name: component_maps; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.component_maps (
    id bigint NOT NULL,
    index character varying NOT NULL,
    title character varying NOT NULL,
    type character varying NOT NULL,
    source character varying NOT NULL,
    size character varying,
    icon character varying,
    paint json,
    property json
);


ALTER TABLE public.component_maps OWNER TO postgres;

--
-- Name: component_maps_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.component_maps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.component_maps_id_seq OWNER TO postgres;

--
-- Name: component_maps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.component_maps_id_seq OWNED BY public.component_maps.id;


--
-- Name: components; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.components (
    id bigint NOT NULL,
    index character varying NOT NULL,
    name character varying NOT NULL,
    history_config json,
    map_config_ids integer[],
    map_config json,
    chart_config json,
    map_filter json,
    time_from character varying,
    time_to character varying,
    update_freq integer,
    update_freq_unit character varying,
    source character varying,
    short_desc text,
    long_desc text,
    use_case text,
    links text[],
    contributors text[],
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    query_type character varying,
    query_chart text,
    query_history text
);


ALTER TABLE public.components OWNER TO postgres;

--
-- Name: components_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.components_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.components_id_seq OWNER TO postgres;

--
-- Name: components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.components_id_seq OWNED BY public.components.id;


--
-- Name: contributors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contributors (
    id bigint NOT NULL,
    user_id character varying NOT NULL,
    user_name character varying NOT NULL,
    image text,
    link text NOT NULL,
    identity character varying,
    description text,
    include boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.contributors OWNER TO postgres;

--
-- Name: contributors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contributors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contributors_id_seq OWNER TO postgres;

--
-- Name: contributors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contributors_id_seq OWNED BY public.contributors.id;


--
-- Name: dashboard_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboard_groups (
    dashboard_id bigint NOT NULL,
    group_id bigint NOT NULL
);


ALTER TABLE public.dashboard_groups OWNER TO postgres;

--
-- Name: dashboards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboards (
    id bigint NOT NULL,
    index character varying NOT NULL,
    name character varying NOT NULL,
    components integer[],
    icon text,
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL
);


ALTER TABLE public.dashboards OWNER TO postgres;

--
-- Name: dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dashboards_id_seq OWNER TO postgres;

--
-- Name: dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboards_id_seq OWNED BY public.dashboards.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.groups (
    id bigint NOT NULL,
    name character varying,
    is_personal boolean DEFAULT false,
    create_by bigint
);


ALTER TABLE public.groups OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_id_seq OWNER TO postgres;

--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: incidents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.incidents (
    id bigint NOT NULL,
    type text,
    description text,
    distance numeric,
    latitude numeric,
    longitude numeric,
    place text,
    "time" timestamp with time zone,
    status text
);


ALTER TABLE public.incidents OWNER TO postgres;

--
-- Name: incidents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.incidents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.incidents_id_seq OWNER TO postgres;

--
-- Name: incidents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.incidents_id_seq OWNED BY public.incidents.id;


--
-- Name: issues; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.issues (
    id bigint NOT NULL,
    title character varying NOT NULL,
    user_name character varying NOT NULL,
    user_id character varying NOT NULL,
    context text,
    description text NOT NULL,
    decision_desc text,
    status character varying NOT NULL,
    updated_by character varying NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


ALTER TABLE public.issues OWNER TO postgres;

--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.issues_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.issues_id_seq OWNER TO postgres;

--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.issues_id_seq OWNED BY public.issues.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying,
    access_control boolean DEFAULT false,
    modify boolean DEFAULT false,
    read boolean DEFAULT false
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: view_points; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.view_points (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    center_x numeric,
    center_y numeric,
    zoom numeric,
    pitch numeric,
    bearing numeric,
    name text,
    point_type text
);


ALTER TABLE public.view_points OWNER TO postgres;

--
-- Name: view_points_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.view_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.view_points_id_seq OWNER TO postgres;

--
-- Name: view_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.view_points_id_seq OWNED BY public.view_points.id;


--
-- Name: auth_users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users ALTER COLUMN id SET DEFAULT nextval('public.auth_users_id_seq'::regclass);


--
-- Name: component_maps id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_maps ALTER COLUMN id SET DEFAULT nextval('public.component_maps_id_seq'::regclass);


--
-- Name: components id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components ALTER COLUMN id SET DEFAULT nextval('public.components_id_seq'::regclass);


--
-- Name: contributors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors ALTER COLUMN id SET DEFAULT nextval('public.contributors_id_seq'::regclass);


--
-- Name: dashboards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards ALTER COLUMN id SET DEFAULT nextval('public.dashboards_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: incidents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents ALTER COLUMN id SET DEFAULT nextval('public.incidents_id_seq'::regclass);


--
-- Name: issues id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues ALTER COLUMN id SET DEFAULT nextval('public.issues_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: view_points id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_points ALTER COLUMN id SET DEFAULT nextval('public.view_points_id_seq'::regclass);


--
-- Data for Name: auth_user_group_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_group_roles (auth_user_id, group_id, role_id) FROM stdin;
1	42	1
1	1	1
\.


--
-- Data for Name: auth_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_users (id, name, email, password, idno, uuid, tp_account, member_type, verify_level, is_admin, is_active, is_whitelist, is_blacked, expired_at, created_at, login_at) FROM stdin;
1	11144144	kenwu99034@gmail.com	728f4ceed5439e63ce541b7c88f8e295ea66e1808ccc6236489b5a42ebf1f769	\N	\N	\N	\N	\N	t	t	t	f	\N	2024-12-27 06:11:26.4581+00	2025-01-09 17:26:35.977971+00
\.


--
-- Data for Name: component_charts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.component_charts (index, color, types, unit) FROM stdin;
pump_status	{#ff9800}	{GuageChart,BarPercentChart}	站
welfare_institutions	{#F65658,#F49F36,#F5C860,#9AC17C,#4CB495,#569C9A,#60819C,#2F8AB1}	{BarChart,DonutChart}	間
building_unsued	{#d16ae2,#655fad}	{MapLegend}	處
patrol_criminalcase	{#FD5696,#00A9E0}	{TimelineSeparateChart,TimelineStackedChart,ColumnLineChart}	件
welfare_population	{#2e999b,#80e3d4,#1f9b85,#a5ece0}	{ColumnChart,BarPercentChart,DistrictChart}	人
garbage_truck	{#E6DF44,#F4633C,#D63940,#9C2A4B}	{ColumnChart}	處
speeddata	{#2e999b,#80e3d4,#1f9b85,#a5ece0,#4cb3a7}	{ColumnChart}	處
car_one	{#2e999b,#80e3d4,#1f9b85,#a5ece0}	{ColumnChart}	件
\.


--
-- Data for Name: component_maps; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.component_maps (id, index, title, type, source, size, icon, paint, property) FROM stdin;
50	patrol_rain_floodgate	抽水站	circle	geojson	big	\N	{"circle-color":["match",["get","all_pumb_lights"],"+","#ff9800","#00B2FF"]}	[{"key":"station_name","name":"站名"},{"key":"all_pumb_lights","name":"總抽水狀態"},{"key":"warning_level","name":"目前警戒值"},{"key":"start_pumping_level","name":"抽水起始值"},{"key":"door_num","name":"水門數目"},{"key":"pumb_num","name":"抽水機數目"},{"key":"river_basin","name":"流域"},{"key":"rec_time","name":"記錄時間"}]
42	building_unsued_land	閒置市有公有地	fill	geojson	\N	\N	{"fill-color":"#d16ae2","fill-opacity":0.7}	[{"key":"10712土地_1_土地權屬情形","name":"土地權屬情形"},{"key":"10712土地_1_管理機關","name":"管理機關"}]
60	patrol_rain_sewer	下水道	circle	geojson	big	\N	{"circle-color": ["interpolate", ["linear"], ["to-number", ["get", "ground_far"]], -100, "#F92623", 0.51, "#81bcf5"]}	[{"key": "station_no", "name": "NO"}, {"key": "station_name", "name": "站名"}, {"key": "ground_far", "name": "距地面高[公尺]"}, {"key": "level_out", "name": "水位高[公尺]"}, {"key": "rec_time", "name": "紀錄時間"}]
64	socl_welfare_organization_plc	社福機構	circle	geojson	big	\N	{"circle-color": ["match", ["get", "main_type"], "銀髮族服務", "#F49F36", "身障機構", "#F65658", "兒童與少年服務", "#F5C860", "社區服務、NPO", "#9AC17C", "婦女服務", "#4CB495", "貧困危機家庭服務", "#569C9A", "保護性服務", "#60819C", "#2F8AB1"]}	[{"key": "main_type", "name": "主要類別"}, {"key": "sub_type", "name": "次要分類"}, {"key": "name", "name": "名稱"}, {"key": "address", "name": "地址"}]
43	building_unsued_public	閒置市有(公用)建物	circle	geojson	big	\N	{"circle-color":"#655fad"}	[{"key":"門牌","name":"門牌"},{"key":"房屋現況","name":"房屋現況"},{"key":"目前執行情形","name":"目前執行情形"},{"key":"閒置樓層_閒置樓層/該建物總樓層","name":"閒置樓層/總樓層"},{"key":"閒置面積㎡","name":"閒置面積㎡"},{"key":"基地管理機關","name":"基地管理機關"},{"key":"建物管理機關","name":"建物管理機關"},{"key":"原使用用途","name":"原使用用途"},{"key":"基地所有權人","name":"基地所有權人"},{"key":"建物標示","name":"建物標示"},{"key":"建築完成日期","name":"建築完成日期"}]
94	speeddata	測速點位	circle	geojson	\N	\N	{\r\n  "circle-color": [\r\n    "match",                     \r\n    ["get", "速度限制"],          \r\n    "40", "#2e999b",             \r\n    "50", "#80e3d4",             \r\n    "60", "#1f9b85",             \r\n    "70", "#a5ece0",            \r\n    "80", "#4cb3a7",             \r\n    "#cccccc"                     \r\n  ]\r\n}\r\n	[\r\n  { "key": "轄區", "name": "轄區" },\r\n  { "key": "設置路段", "name": "設置路段" },\r\n  { "key": "設置地點", "name": "設置地點" },\r\n  { "key": "速度限制", "name": "速度限制" }\r\n]
91	garbage_truck	垃圾車收運點位	circle	geojson	\N	\N	{"circle-color": ["case",["<", ["get", "抵達時間"], 1700], "#E6DF44",["<", ["get", "抵達時間"], 1900], "#F4633C",["<", ["get", "抵達時間"], 2100], "#D63940","#9C2A4B"]}	[{ "key": "行政區", "name": "行政區" },{ "key": "抵達時間", "name": "抵達時間" },{ "key": "離開時間", "name": "離開時間" },{ "key": "地址", "name": "地址" }]\r\n
95	car_one	違規事件1	circle	geojson	big	\N	{"circle-color":["case",["\\u003c",["get","車輛時速"],70],"#2e999b",["\\u003c",["get","車輛時速"],80],"#80e3d4",["\\u003c",["get","車輛時速"],90],"#1f9b85","#a5ece0"]}	[{"key":"行政區","name":"行政區"},{"key":"違規地點","name":"違規地點"},{"key":"違規時間","name":"違規時間"},{"key":"道路速限","name":"道路速限"},{"key":"車輛時速","name":"車輛時速"},{"key":"車牌","name":"車牌"}]
\.


--
-- Data for Name: components; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.components (id, index, name, history_config, map_config_ids, map_config, chart_config, map_filter, time_from, time_to, update_freq, update_freq_unit, source, short_desc, long_desc, use_case, links, contributors, created_at, updated_at, query_type, query_chart, query_history) FROM stdin;
90	welfare_population	社福人口	\N	{}	\N	\N	\N	static	\N	\N	\N	社會局	顯示社會福利人口（身障、低收、中低收、低收身障）的比例	顯示社會福利人口（身障、低收、中低收、低收身障）的比例，資料來源為台北市社會局內部資料，每月15號更新。	社福人口比例的資料能讓我們了解台北市社會福利的需求變化，從而規劃更貼近民眾需求的社會福利措施。	{}	{tuic}	2023-12-20 05:56:00+00	2024-01-09 03:32:59.233032+00	three_d	SELECT x_axis, y_axis, data FROM (SELECT district AS x_axis, '低收' AS y_axis, is_low_income AS data FROM app_calcu_monthly_socl_welfare_people_ppl UNION ALL SELECT district AS x_axis, '中低收' AS y_axis, is_low_middle_income AS data FROM app_calcu_monthly_socl_welfare_people_ppl UNION ALL SELECT district AS x_axis, '身障補助' AS y_axis, is_disabled_allowance AS data FROM app_calcu_monthly_socl_welfare_people_ppl UNION ALL SELECT district AS x_axis, '身障' AS y_axis, is_disabled AS data FROM app_calcu_monthly_socl_welfare_people_ppl) AS combined_data WHERE x_axis != 'e' ORDER BY ARRAY_POSITION(ARRAY['北投區', '士林區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大同區', '中正區', '萬華區', '大安區', '文山區']::varchar[], combined_data.x_axis), ARRAY_POSITION(ARRAY['低收', '中低收', '身障補助', '身障'], combined_data.y_axis);	\N
82	welfare_institutions	社福機構	\N	{64}	\N	\N	{"mode": "byParam", "byParam": {"xParam": "main_type"}}	static	\N	\N	\N	社會局	顯示社會福利機構點位及機構類型	顯示社會福利機構點位及機構類型，資料來源為台北市社會局內部資料，每月15日更新。	根據機構空間的分佈情況，檢視社會福利機構是否均勻分布，同時整合市有土地、社會住宅等潛在可使用之空間，以研擬增設位置與類型的方案。	{https://data.taipei/dataset/detail?id=cabdf272-e0ec-4e4e-9136-f4b8596f35d9}	{tuic}	2023-12-20 05:56:00+00	2023-12-20 05:56:00+00	two_d	select main_type as x_axis,count(*) as data from socl_welfare_organization_plc group by main_type order by data desc	\N
7	patrol_criminalcase	刑事統計	\N	{}	\N	\N	\N	year_ago	now	1	month	警察局	顯示近兩年每月的刑案統計資訊	顯示近兩年每月的刑案統計資訊，資料來源為台北市主計處開放資料，每月更新。	藉由掌握台北市刑事案件近2年的統計資訊，我們可以瞭解案件的增減趨勢及相關特徵，有助於制定更有效的治安策略。	{https://data.taipei/dataset/detail?id=dc7e246a-a88e-42f8-8cd6-9739209af774}	{tuic}	2023-12-20 05:56:00+00	2024-01-17 06:53:41.810511+00	time	WITH date_range AS (\n  SELECT\n    '%s'::timestamp with time zone AS start_time,\n    '%s'::timestamp with time zone AS end_time\n)\nSELECT "年月別" as x_axis, '發生件數' as y_axis, "發生件數[件]" as data FROM public.patrol_criminal_case \nWHERE 年月別 BETWEEN  (SELECT start_time FROM date_range) AND (SELECT end_time FROM date_range)\nUNION ALL\nSELECT "年月別" as x_axis, '破獲件數' as y_axis, "破獲件數/總計[件]" as data FROM public.patrol_criminal_case\nWHERE 年月別 BETWEEN  (SELECT start_time FROM date_range) AND (SELECT end_time FROM date_range)	\N
30	building_unsued	閒置市有財產	\N	{42,43}	\N	\N	{"mode":"byLayer"}	static	\N	\N	\N	財政局	\N	\N	\N	{}	{tuic}	2023-12-20 05:56:00+00	2024-01-11 06:01:02.392686+00	map_legend	select '閒置市有公有地' as name, count(*) as value, 'fill' as type from building_unsued_land\nunion all\nselect '閒置市有(公用)建物' as name, count(*) as value, 'circle' as type from building_unsued_public	\N
43	pump_status	抽水站狀態	\N	{50}	\N	\N	{"mode":"byParam","byParam":{"yParam":"all_pumb_lights"}}	current	\N	10	minute	工務局水利處	顯示當前全市開啟的抽水站數量	顯示當前全市開啟的抽水站數量，資料來源為工務局水利處內部資料，每十分鐘更新。	考慮當日天氣及「水位監測」組件的資料，來探討抽水站的運作狀況與水位異常之間的關聯性。	{}	{tuic}	2023-12-20 05:56:00+00	2024-01-25 09:36:14.565347+00	percent	select '啟動抽水站' as x_axis, y_axis, data from \n(\nselect '啟動中' as y_axis, count(*) as data from patrol_rain_floodgate where all_pumb_lights = '+'\nunion all\nselect '未啟動' as y_axis, count(*) as data from patrol_rain_floodgate where all_pumb_lights != '+'\n) as parsed_data	\N
69	garbage_truck	垃圾車收運點位	\N	{91}	\N	\N	\N	static	\N	\N	\N	環保局	顯示垃圾車收運點位資料	顯示當前全市開啟的垃圾車點位，資料來源為環保局內部資料，不更新。	考慮當日天氣組件的資料，來探討垃圾車的運作狀況與垃圾異常之間的關聯性。	{https://data.taipei/dataset/detail?id=6bb3304b-4f46-4bb0-8cd1-60c66dcd1cae}	{}	2024-12-30 19:03:00+00	2024-12-30 19:03:00+00	three_d	SELECT * FROM (\n    SELECT \n        行政區 AS x_axis,\n        CASE\n            WHEN 抵達時間 BETWEEN 0 AND 1659 THEN '1700前'\n            WHEN 抵達時間 BETWEEN 1700 AND 1859 THEN '1700-1900'\n            WHEN 抵達時間 BETWEEN 1900 AND 2059 THEN '1900-2100'\n            ELSE '2100後'\n        END AS y_axis,\n        COUNT(*) AS data\n    FROM garbage_truck\n    GROUP BY \n        行政區,\n        CASE\n            WHEN 抵達時間 BETWEEN 0 AND 1659 THEN '1700前'\n            WHEN 抵達時間 BETWEEN 1700 AND 1859 THEN '1700-1900'\n            WHEN 抵達時間 BETWEEN 1900 AND 2059 THEN '1900-2100'\n            ELSE '2100後'\n        END\n) AS t\nORDER BY \n    ARRAY_POSITION(ARRAY['北投區', '士林區', '南港區', '松山區', '信義區', '中山區', '大同區','中正區','萬華區','大安區','文山區'], t.x_axis),\n    ARRAY_POSITION(ARRAY['1700前', '1700-1900', '1900-2100', '2100後'], t.y_axis);\n	\N
76	speeddata	測速點位	\N	{94}	\N	\N	\N	static	\N	\N	\N	警察局交通大隊	顯示測速點位資料	顯示當前全市開啟的測速點位，資料來源為警察局交通大隊公開資料，不更新。	提供臺北市現有車輛超速自動照相設備之設置地點及地點路段之限速值及區間測速舉發件數等資料。	{https://data.taipei/dataset/detail?id=745b8808-061f-4f5b-9a62-da1590c049a9}	{}	2025-01-03 03:30:00+00	2025-01-03 03:30:00+00	three_d	SELECT \n    轄區 AS x_axis,    -- 使用資料表內的「轄區」欄位作為 x 軸\n    速度限制::integer AS y_axis,    -- 轉換速度限制為數值型別\n    COUNT(*) AS data   -- 計算每個速度限制在該轄區的比數\nFROM speeddata\nWHERE 功能 = '測速'      -- 只篩選功能為「測速」的資料\n  AND 速度限制 IN ('40','50', '60', '70', '80') -- 確保使用文字型別的值\nGROUP BY 轄區, 速度限制\nHAVING COUNT(*) > 0      -- 確保該速度限制在該轄區中有資料\nORDER BY \n    ARRAY_POSITION(ARRAY['北投分隊', '士林分隊', '內湖分隊', '南港分隊', '松山分隊', '信義分隊', '中山分隊', '大同分隊', '中正一分隊', '中正二分隊', '萬華分隊', '大安分隊', '文山一分隊', '文山二分隊'], 轄區),\n    ARRAY_POSITION(ARRAY[40, 50,60,70,80], 速度限制::integer);	\N
77	car_one	違規事件1	null	{95}	\N	\N	null	static	\N	\N	\N	中原大學	顯示違規案件的資訊	顯示違規案件的資訊，不定期更新	藉由掌握台北市違規案件統計資訊，我們可以瞭解案件的增減趨勢及相關特徵，有助於制定更有效的治安策略。	{}	{}	2025-01-09 00:01:00+00	2025-01-09 17:30:29.250771+00	three_d	WITH speed_ranges AS (\n    SELECT unnest(ARRAY['60-69', '70-79', '80-89', '90以上']) AS y_axis\n),\ndistricts AS (\n    SELECT DISTINCT 行政區 AS x_axis FROM car_one\n),\ndata_count AS (\n    SELECT \n        行政區 AS x_axis,\n        CASE\n            WHEN 車輛時速 BETWEEN 60 AND 69 THEN '60-69'\n            WHEN 車輛時速 BETWEEN 70 AND 79 THEN '70-79'\n            WHEN 車輛時速 BETWEEN 80 AND 89 THEN '80-89'\n            ELSE '90以上'\n        END AS y_axis,\n        COUNT(*) AS data\n    FROM car_one\n    GROUP BY \n        行政區,\n        CASE\n            WHEN 車輛時速 BETWEEN 60 AND 69 THEN '60-69'\n            WHEN 車輛時速 BETWEEN 70 AND 79 THEN '70-79'\n            WHEN 車輛時速 BETWEEN 80 AND 89 THEN '80-89'\n            ELSE '90以上'\n        END\n)\nSELECT \n    d.x_axis,\n    s.y_axis,\n    COALESCE(dc.data, 0) AS data\nFROM districts d\nCROSS JOIN speed_ranges s\nLEFT JOIN data_count dc ON d.x_axis = dc.x_axis AND s.y_axis = dc.y_axis\nORDER BY \n    ARRAY_POSITION(ARRAY['北投區', '士林區', '內湖區', '南港區', '松山區', '信義區', '中山區', '大同區', '中正區', '萬華區', '大安區', '文山區'], d.x_axis),\n    ARRAY_POSITION(ARRAY['60-69', '70-79', '80-89', '90以上'], s.y_axis);	\N
\.


--
-- Data for Name: contributors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contributors (id, user_id, user_name, image, link, identity, description, include, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: dashboard_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboard_groups (dashboard_id, group_id) FROM stdin;
1	1
2	1
72	42
\.


--
-- Data for Name: dashboards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboards (id, index, name, components, icon, updated_at, created_at) FROM stdin;
2	map-layers	圖資資訊	{30}	public	2024-01-11 09:32:32.465099+00	2024-01-11 09:32:32.465099+00
72	1dabc4200004	收藏組件	\N	favorite	2024-12-27 06:11:26.484478+00	2024-12-27 06:11:26.484478+00
1	demo-components	範例組件	{43,82,69,76,77}	bug_report	2025-01-08 16:11:06.396702+00	2023-12-27 06:11:56.841132+00
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (id, name, is_personal, create_by) FROM stdin;
1	public	f	\N
42	user: 1's personal group	t	1
\.


--
-- Data for Name: incidents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.incidents (id, type, description, distance, latitude, longitude, place, "time", status) FROM stdin;
\.


--
-- Data for Name: issues; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.issues (id, title, user_name, user_id, context, description, decision_desc, status, updated_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, access_control, modify, read) FROM stdin;
1	admin	t	t	t
2	editor	f	t	t
3	viewer	f	f	t
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: view_points; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.view_points (id, user_id, center_x, center_y, zoom, pitch, bearing, name, point_type) FROM stdin;
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: auth_users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_users_id_seq', 1, true);


--
-- Name: component_maps_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.component_maps_id_seq', 95, true);


--
-- Name: components_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.components_id_seq', 77, true);


--
-- Name: contributors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contributors_id_seq', 1, false);


--
-- Name: dashboards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dashboards_id_seq', 72, true);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq', 42, true);


--
-- Name: incidents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.incidents_id_seq', 1, false);


--
-- Name: issues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.issues_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 3, true);


--
-- Name: view_points_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.view_points_id_seq', 1, false);


--
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: postgres
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- Name: auth_user_group_roles auth_user_group_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_group_roles
    ADD CONSTRAINT auth_user_group_roles_pkey PRIMARY KEY (auth_user_id, group_id, role_id);


--
-- Name: auth_users auth_users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_email_key UNIQUE (email);


--
-- Name: auth_users auth_users_idno_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_idno_key UNIQUE (idno);


--
-- Name: auth_users auth_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_pkey PRIMARY KEY (id);


--
-- Name: auth_users auth_users_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_users
    ADD CONSTRAINT auth_users_uuid_key UNIQUE (uuid);


--
-- Name: component_charts component_charts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_charts
    ADD CONSTRAINT component_charts_pkey PRIMARY KEY (index);


--
-- Name: component_maps component_maps_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.component_maps
    ADD CONSTRAINT component_maps_pkey PRIMARY KEY (id);


--
-- Name: components components_index_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_index_key UNIQUE (index);


--
-- Name: components components_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (id);


--
-- Name: contributors contributors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contributors
    ADD CONSTRAINT contributors_pkey PRIMARY KEY (id);


--
-- Name: dashboard_groups dashboard_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_groups
    ADD CONSTRAINT dashboard_groups_pkey PRIMARY KEY (dashboard_id, group_id);


--
-- Name: dashboards dashboards_index_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_index_key UNIQUE (index);


--
-- Name: dashboards dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboards
    ADD CONSTRAINT dashboards_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: incidents incidents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.incidents
    ADD CONSTRAINT incidents_pkey PRIMARY KEY (id);


--
-- Name: issues issues_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: view_points view_points_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_points
    ADD CONSTRAINT view_points_pkey PRIMARY KEY (id);


--
-- Name: auth_user_group_roles fk_auth_user_group_roles_auth_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_group_roles
    ADD CONSTRAINT fk_auth_user_group_roles_auth_user FOREIGN KEY (auth_user_id) REFERENCES public.auth_users(id);


--
-- Name: auth_user_group_roles fk_auth_user_group_roles_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_group_roles
    ADD CONSTRAINT fk_auth_user_group_roles_group FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: auth_user_group_roles fk_auth_user_group_roles_role; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_group_roles
    ADD CONSTRAINT fk_auth_user_group_roles_role FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: dashboard_groups fk_dashboard_groups_dashboard; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_groups
    ADD CONSTRAINT fk_dashboard_groups_dashboard FOREIGN KEY (dashboard_id) REFERENCES public.dashboards(id);


--
-- Name: dashboard_groups fk_dashboard_groups_group; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_groups
    ADD CONSTRAINT fk_dashboard_groups_group FOREIGN KEY (group_id) REFERENCES public.groups(id);


--
-- Name: groups fk_groups_auth_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT fk_groups_auth_user FOREIGN KEY (create_by) REFERENCES public.auth_users(id);


--
-- Name: view_points fk_view_points_auth_user; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.view_points
    ADD CONSTRAINT fk_view_points_auth_user FOREIGN KEY (user_id) REFERENCES public.auth_users(id);


--
-- PostgreSQL database dump complete
--

