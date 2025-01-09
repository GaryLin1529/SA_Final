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


--
-- Name: trigger_auto_accumulate_been_used_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_auto_accumulate_been_used_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.been_used_count = OLD.been_used_count + 1;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_auto_accumulate_been_used_count() OWNER TO postgres;

--
-- Name: trigger_been_used_count_accumulator(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_been_used_count_accumulator() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.been_used_count = been_used_count + 1;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_been_used_count_accumulator() OWNER TO postgres;

--
-- Name: trigger_set_backup_time(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_set_backup_time() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.backup_time = NOW();
	RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_backup_time() OWNER TO postgres;

--
-- Name: trigger_set_timestamp(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.trigger_set_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW._mtime = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.trigger_set_timestamp() OWNER TO postgres;

--
-- Name: update_app_calcu_hourly_patrol_rainfall_view(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_app_calcu_hourly_patrol_rainfall_view() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
		CREATE or replace VIEW "app_calcu_hourly_patrol_rainfall_view" AS
			select  distinct on (d."station_no") d."station_no", a2."ogc_fid", d."station_name", a2."rec_time", a2."hr_acc_rain", 
				a2."this_hr", a2."last_hr", a2."_ctime" , a2."_mtime", d."wkb_geometry"
			from (
				select station_no,station_name,wkb_geometry from work_rainfall_station_location
				union
				select station_no,station_name,wkb_geometry from cwb_rainfall_station_location
				)as d
			JOIN "app_calcu_hourly_patrol_rainfall" AS a2 ON d."station_no"  = a2."station_no"
			where EXTRACT(EPOCH FROM (NOW() - a2."rec_time")) < 3600
			order by d."station_no", a2."rec_time";
	RETURN NULL;
	END;
$$;


ALTER FUNCTION public.update_app_calcu_hourly_patrol_rainfall_view() OWNER TO postgres;

--
-- Name:  building_publand_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public." building_publand_ogc_fid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public." building_publand_ogc_fid_seq" OWNER TO postgres;

--
-- Name: SOCL_export_filter_ppl_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."SOCL_export_filter_ppl_ogc_fid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."SOCL_export_filter_ppl_ogc_fid_seq" OWNER TO postgres;

--
-- Name: app_calcu_daily_sentiment_voice1999_109_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_daily_sentiment_voice1999_109_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_daily_sentiment_voice1999_109_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_calcu_hour_traffic_info_histories_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_hour_traffic_info_histories_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_hour_traffic_info_histories_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_calcu_hour_traffic_youbike_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_hour_traffic_youbike_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_hour_traffic_youbike_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_calcu_hourly_it_5g_smart_all_pole_device_log_dev13_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_hourly_it_5g_smart_all_pole_device_log_dev13_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_hourly_it_5g_smart_all_pole_device_log_dev13_seq OWNER TO postgres;

--
-- Name: app_calcu_month_traffic_info_histories_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_month_traffic_info_histories_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_month_traffic_info_histories_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_calcu_monthly_socl_welfare_people_ppl_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_monthly_socl_welfare_people_ppl_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_monthly_socl_welfare_people_ppl_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: app_calcu_monthly_socl_welfare_people_ppl; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.app_calcu_monthly_socl_welfare_people_ppl (
    district character varying,
    is_low_middle_income double precision,
    is_disabled double precision,
    is_disabled_allowance double precision,
    is_low_income double precision,
    _ctime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    _mtime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    ogc_fid integer DEFAULT nextval('public.app_calcu_monthly_socl_welfare_people_ppl_seq'::regclass) NOT NULL
);


ALTER TABLE public.app_calcu_monthly_socl_welfare_people_ppl OWNER TO postgres;

--
-- Name: app_calcu_patrol_rainfall_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_patrol_rainfall_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_patrol_rainfall_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_calcu_sentiment_dispatch_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_sentiment_dispatch_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_sentiment_dispatch_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_calcu_traffic_todaywork_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_traffic_todaywork_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_traffic_todaywork_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_calcu_weekly_dispatching_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_weekly_dispatching_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_weekly_dispatching_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_calcu_weekly_hellotaipei_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_weekly_hellotaipei_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_weekly_hellotaipei_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_calcu_weekly_metro_capacity_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_weekly_metro_capacity_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_weekly_metro_capacity_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_calcu_weekly_metro_capacity_threshould_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcu_weekly_metro_capacity_threshould_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcu_weekly_metro_capacity_threshould_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_calcul_weekly_hellotaipei_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_calcul_weekly_hellotaipei_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_calcul_weekly_hellotaipei_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_traffic_lives_accident_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_traffic_lives_accident_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_traffic_lives_accident_ogc_fid_seq OWNER TO postgres;

--
-- Name: app_traffic_metro_capacity_realtime_stat_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.app_traffic_metro_capacity_realtime_stat_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_traffic_metro_capacity_realtime_stat_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_age_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_age_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_age_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_cadastralmap_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_cadastralmap_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_cadastralmap_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_landuse_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_landuse_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_landuse_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_license_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_license_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_license_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_license_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_license_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_license_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_permit_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_permit_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_permit_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_permit_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_permit_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_permit_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_publand_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_publand_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_publand_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_publand_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_publand_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_publand_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_renewarea_10_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_renewarea_10_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_renewarea_10_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_renewarea_10_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_renewarea_10_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_renewarea_10_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_renewarea_40_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_renewarea_40_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_renewarea_40_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_renewarea_40_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_renewarea_40_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_renewarea_40_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_renewunit_12_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_renewunit_12_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_renewunit_12_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_renewunit_12_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_renewunit_12_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_renewunit_12_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_renewunit_20_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_renewunit_20_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_renewunit_20_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_renewunit_20_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_renewunit_20_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_renewunit_20_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_renewunit_30_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_renewunit_30_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_renewunit_30_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_renewunit_30_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_renewunit_30_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_renewunit_30_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_social_house_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_social_house_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_social_house_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_social_house_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_social_house_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_social_house_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_unsued_land_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_unsued_land_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_unsued_land_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_unsued_land; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.building_unsued_land (
    thekey character varying,
    thename character varying,
    thelink character varying,
    aa48 character varying,
    aa49 character varying,
    aa10 double precision,
    aa21 double precision,
    aa22 double precision,
    kcnt character varying,
    cada_text character varying,
    aa17 double precision,
    aa16 double precision,
    aa46 character varying,
    "cadastral map_key_地籍圖key值" character varying,
    "10712土地_1_土地權屬情形" character varying,
    "10712土地_1_管理機關" character varying,
    area double precision,
    _ctime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    _mtime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    ogc_fid integer DEFAULT nextval('public.building_unsued_land_ogc_fid_seq'::regclass) NOT NULL
);


ALTER TABLE public.building_unsued_land OWNER TO postgres;

--
-- Name: building_unsued_land_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_unsued_land_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_unsued_land_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_unsued_nonpublic_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_unsued_nonpublic_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_unsued_nonpublic_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_unsued_nonpublic_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_unsued_nonpublic_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_unsued_nonpublic_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_unsued_public; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.building_unsued_public (
    full_key character varying,
    "建物管理機關" character varying,
    "行政區" character varying,
    "門牌" character varying,
    "建物標示" character varying,
    "建築完成日期" character varying,
    "閒置樓層_閒置樓層/該建物總樓層" character varying,
    "閒置面積㎡" character varying,
    "房屋現況" character varying,
    "原使用用途" character varying,
    "基地所有權人" character varying,
    "基地管理機關" character varying,
    "土地使用分區" character varying,
    "目前執行情形" character varying,
    _ctime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    _mtime timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.building_unsued_public OWNER TO postgres;

--
-- Name: building_unsued_public_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_unsued_public_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_unsued_public_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: building_unsued_public_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.building_unsued_public_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.building_unsued_public_ogc_fid_seq OWNER TO postgres;

--
-- Name: car_one; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.car_one (
    "照片ID" text,
    "違規地點" text,
    "違規時間" text,
    "紀錄設備ID" text,
    "道路速限" integer,
    "車輛時速" integer,
    "經度" numeric,
    "緯度" numeric,
    "行政區" text,
    "車牌" text
);


ALTER TABLE public.car_one OWNER TO postgres;

--
-- Name: cvil_public_opinion_evn_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cvil_public_opinion_evn_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cvil_public_opinion_evn_ogc_fid_seq OWNER TO postgres;

--
-- Name: cvil_public_opinion_maintype_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cvil_public_opinion_maintype_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cvil_public_opinion_maintype_ogc_fid_seq OWNER TO postgres;

--
-- Name: cvil_public_opinion_subtype_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cvil_public_opinion_subtype_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cvil_public_opinion_subtype_ogc_fid_seq OWNER TO postgres;

--
-- Name: cwb_city_weather_forecast_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cwb_city_weather_forecast_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cwb_city_weather_forecast_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: cwb_city_weather_forecast_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cwb_city_weather_forecast_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cwb_city_weather_forecast_ogc_fid_seq OWNER TO postgres;

--
-- Name: cwb_daily_weather_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cwb_daily_weather_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cwb_daily_weather_ogc_fid_seq OWNER TO postgres;

--
-- Name: cwb_hourly_weather_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cwb_hourly_weather_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cwb_hourly_weather_ogc_fid_seq OWNER TO postgres;

--
-- Name: cwb_now_weather_auto_station_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cwb_now_weather_auto_station_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cwb_now_weather_auto_station_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: cwb_now_weather_auto_station_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cwb_now_weather_auto_station_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cwb_now_weather_auto_station_ogc_fid_seq OWNER TO postgres;

--
-- Name: cwb_now_weather_bureau_station_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cwb_now_weather_bureau_station_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cwb_now_weather_bureau_station_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: cwb_now_weather_bureau_station_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cwb_now_weather_bureau_station_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cwb_now_weather_bureau_station_ogc_fid_seq OWNER TO postgres;

--
-- Name: cwb_rainfall_station_location_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cwb_rainfall_station_location_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cwb_rainfall_station_location_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: cwb_rainfall_station_location_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cwb_rainfall_station_location_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cwb_rainfall_station_location_ogc_fid_seq OWNER TO postgres;

--
-- Name: cwb_town_weather_forecast_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cwb_town_weather_forecast_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cwb_town_weather_forecast_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: cwb_town_weather_forecast_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cwb_town_weather_forecast_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cwb_town_weather_forecast_ogc_fid_seq OWNER TO postgres;

--
-- Name: edu_elementary_school_district_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_elementary_school_district_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_elementary_school_district_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: edu_elementary_school_district_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_elementary_school_district_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_elementary_school_district_ogc_fid_seq OWNER TO postgres;

--
-- Name: edu_eleschool_dist_by_administrative_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_eleschool_dist_by_administrative_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_eleschool_dist_by_administrative_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: edu_eleschool_dist_by_administrative_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_eleschool_dist_by_administrative_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_eleschool_dist_by_administrative_ogc_fid_seq OWNER TO postgres;

--
-- Name: edu_jhschool_dist_by_administrative_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_jhschool_dist_by_administrative_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_jhschool_dist_by_administrative_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: edu_jhschool_dist_by_administrative_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_jhschool_dist_by_administrative_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_jhschool_dist_by_administrative_ogc_fid_seq OWNER TO postgres;

--
-- Name: edu_junior_high_school_district_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_junior_high_school_district_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_junior_high_school_district_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: edu_junior_high_school_district_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_junior_high_school_district_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_junior_high_school_district_ogc_fid_seq OWNER TO postgres;

--
-- Name: edu_school_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_school_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_school_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: edu_school_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_school_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_school_ogc_fid_seq OWNER TO postgres;

--
-- Name: edu_school_romm_status_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_school_romm_status_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_school_romm_status_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: edu_school_romm_status_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.edu_school_romm_status_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.edu_school_romm_status_ogc_fid_seq OWNER TO postgres;

--
-- Name: eoc_accommodate_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eoc_accommodate_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eoc_accommodate_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: eoc_accommodate_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eoc_accommodate_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eoc_accommodate_ogc_fid_seq OWNER TO postgres;

--
-- Name: eoc_disaster_case_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eoc_disaster_case_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eoc_disaster_case_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: eoc_disaster_case_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eoc_disaster_case_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eoc_disaster_case_ogc_fid_seq OWNER TO postgres;

--
-- Name: eoc_leave_house_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eoc_leave_house_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eoc_leave_house_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: eoc_leave_house_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.eoc_leave_house_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.eoc_leave_house_ogc_fid_seq OWNER TO postgres;

--
-- Name: ethc_building_check_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ethc_building_check_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ethc_building_check_ogc_fid_seq OWNER TO postgres;

--
-- Name: ethc_check_calcu_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ethc_check_calcu_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ethc_check_calcu_ogc_fid_seq OWNER TO postgres;

--
-- Name: ethc_check_summary_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ethc_check_summary_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ethc_check_summary_ogc_fid_seq OWNER TO postgres;

--
-- Name: ethc_fire_check_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ethc_fire_check_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ethc_fire_check_ogc_fid_seq OWNER TO postgres;

--
-- Name: fire_hydrant_location_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fire_hydrant_location_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fire_hydrant_location_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: fire_hydrant_location_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fire_hydrant_location_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fire_hydrant_location_ogc_fid_seq OWNER TO postgres;

--
-- Name: fire_to_hospital_ppl_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fire_to_hospital_ppl_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fire_to_hospital_ppl_ogc_fid_seq OWNER TO postgres;

--
-- Name: garbage_truck; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.garbage_truck (
    "行政區" text,
    "里別" text,
    "分隊" text,
    "局編" text,
    "車號" text,
    "路線" text,
    "車次" text,
    "抵達時間" integer,
    "離開時間" integer,
    "地點" text,
    "經度" numeric,
    "緯度" numeric
);


ALTER TABLE public.garbage_truck OWNER TO postgres;

--
-- Name: heal_aed_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.heal_aed_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.heal_aed_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: heal_aed_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.heal_aed_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.heal_aed_ogc_fid_seq OWNER TO postgres;

--
-- Name: heal_clinic_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.heal_clinic_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.heal_clinic_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: heal_clinic_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.heal_clinic_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.heal_clinic_ogc_fid_seq OWNER TO postgres;

--
-- Name: heal_hospital_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.heal_hospital_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.heal_hospital_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: heal_hospital_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.heal_hospital_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.heal_hospital_ogc_fid_seq OWNER TO postgres;

--
-- Name: heal_suicide_evn_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.heal_suicide_evn_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.heal_suicide_evn_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_5G_smart_pole_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."it_5G_smart_pole_ogc_fid_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."it_5G_smart_pole_ogc_fid_seq" OWNER TO postgres;

--
-- Name: it_5g_smart_all_pole_device_log_history_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_5g_smart_all_pole_device_log_history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_5g_smart_all_pole_device_log_history_seq OWNER TO postgres;

--
-- Name: it_5g_smart_all_pole_device_log_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_5g_smart_all_pole_device_log_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_5g_smart_all_pole_device_log_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_5g_smart_all_pole_log_history_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_5g_smart_all_pole_log_history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_5g_smart_all_pole_log_history_seq OWNER TO postgres;

--
-- Name: it_5g_smart_all_pole_log_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_5g_smart_all_pole_log_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_5g_smart_all_pole_log_seq OWNER TO postgres;

--
-- Name: it_5g_smart_pole_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_5g_smart_pole_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_5g_smart_pole_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_signal_population_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_signal_population_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_signal_population_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_signal_population_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_signal_population_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_signal_population_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_signal_tourist_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_signal_tourist_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_signal_tourist_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_signal_tourist_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_signal_tourist_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_signal_tourist_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_taipeiexpo_people_flow_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_taipeiexpo_people_flow_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_taipeiexpo_people_flow_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_taipeiexpo_people_flow_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_taipeiexpo_people_flow_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_taipeiexpo_people_flow_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_tpe_ticket_event_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_tpe_ticket_event_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_tpe_ticket_event_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_tpe_ticket_member_hold_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_tpe_ticket_member_hold_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_tpe_ticket_member_hold_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_tpe_ticket_place_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_tpe_ticket_place_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_tpe_ticket_place_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_tpe_ticket_ticket_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_tpe_ticket_ticket_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_tpe_ticket_ticket_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_tpefree_daily_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_tpefree_daily_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_tpefree_daily_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_tpefree_daily_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_tpefree_daily_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_tpefree_daily_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_tpefree_location_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_tpefree_location_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_tpefree_location_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_tpefree_location_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_tpefree_location_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_tpefree_location_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_tpefree_realtime_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_tpefree_realtime_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_tpefree_realtime_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_tpefree_realtime_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_tpefree_realtime_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_tpefree_realtime_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_tpmo_poc_location_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_tpmo_poc_location_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_tpmo_poc_location_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_tpmo_poc_location_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_tpmo_poc_location_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_tpmo_poc_location_ogc_fid_seq OWNER TO postgres;

--
-- Name: it_venue_people_flow_history_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_venue_people_flow_history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_venue_people_flow_history_seq OWNER TO postgres;

--
-- Name: it_venue_people_flow_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.it_venue_people_flow_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.it_venue_people_flow_ogc_fid_seq OWNER TO postgres;

--
-- Name: mrtp_carweight_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mrtp_carweight_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mrtp_carweight_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: mrtp_carweight_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mrtp_carweight_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mrtp_carweight_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_artificial_slope_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_artificial_slope_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_artificial_slope_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_artificial_slope_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_artificial_slope_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_artificial_slope_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_box_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_box_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_box_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_camera_hls_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_camera_hls_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_camera_hls_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_car_theft_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_car_theft_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_car_theft_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_criminal_case_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_criminal_case_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_criminal_case_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_criminal_case; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patrol_criminal_case (
    "破獲件數/總計[件]" integer,
    "破獲率[%]" double precision,
    "犯罪人口率[人/十萬人]" double precision,
    "嫌疑犯[人]" integer,
    "發生件數[件]" integer,
    "破獲件數/他轄[件]" character varying,
    "破獲件數/積案[件]" character varying,
    _id character varying,
    "破獲件數/當期[件]" character varying,
    "發生率[件/十萬人]" double precision,
    "實際員警人數[人]" character varying,
    "年月別" timestamp with time zone,
    _ctime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    _mtime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    ogc_fid integer DEFAULT nextval('public.patrol_criminal_case_ogc_fid_seq'::regclass) NOT NULL
);


ALTER TABLE public.patrol_criminal_case OWNER TO postgres;

--
-- Name: patrol_debris_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_debris_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_debris_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_debris_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_debris_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_debris_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_debrisarea_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_debrisarea_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_debrisarea_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_debrisarea_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_debrisarea_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_debrisarea_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_designate_place_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_designate_place_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_designate_place_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_designate_place_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_designate_place_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_designate_place_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_district_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_district_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_district_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_eoc_case_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_eoc_case_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_eoc_case_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_eoc_case_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_eoc_case_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_eoc_case_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_eoc_designate_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_eoc_designate_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_eoc_designate_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_eoc_designate_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_eoc_designate_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_eoc_designate_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_fire_brigade_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_fire_brigade_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_fire_brigade_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_fire_brigade_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_fire_brigade_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_fire_brigade_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_fire_disqualified_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_fire_disqualified_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_fire_disqualified_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_fire_disqualified_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_fire_disqualified_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_fire_disqualified_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_fire_rescure_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_fire_rescure_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_fire_rescure_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_fire_rescure_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_fire_rescure_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_fire_rescure_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_flood_100_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_flood_100_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_flood_100_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_flood_130_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_flood_130_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_flood_130_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_flood_78_8_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_flood_78_8_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_flood_78_8_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_motorcycle_theft_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_motorcycle_theft_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_motorcycle_theft_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_old_settlement_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_old_settlement_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_old_settlement_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_old_settlement_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_old_settlement_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_old_settlement_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_police_region_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_police_region_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_police_region_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_police_station_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_police_station_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_police_station_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_police_station_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_police_station_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_police_station_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_police_station_ogc_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_police_station_ogc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_police_station_ogc_id_seq OWNER TO postgres;

--
-- Name: patrol_rain_floodgate_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_rain_floodgate_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_rain_floodgate_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_rain_floodgate; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.patrol_rain_floodgate (
    ogc_fid integer DEFAULT nextval('public.patrol_rain_floodgate_ogc_fid_seq'::regclass) NOT NULL,
    station_no character varying,
    station_name character varying,
    rec_time timestamp with time zone,
    all_pumb_lights character varying,
    pumb_num integer,
    door_num integer,
    river_basin character varying,
    warning_level character varying,
    start_pumping_level character varying,
    lng double precision,
    lat double precision,
    _ctime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    _mtime timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.patrol_rain_floodgate OWNER TO postgres;

--
-- Name: patrol_rain_floodgate_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_rain_floodgate_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_rain_floodgate_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_rain_rainfall_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_rain_rainfall_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_rain_rainfall_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_rain_rainfall_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_rain_rainfall_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_rain_rainfall_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_rain_sewer_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_rain_sewer_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_rain_sewer_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_rain_sewer_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_rain_sewer_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_rain_sewer_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_rain_sewer_ogc_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_rain_sewer_ogc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_rain_sewer_ogc_id_seq OWNER TO postgres;

--
-- Name: patrol_random_robber_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_random_robber_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_random_robber_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_random_snatch_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_random_snatch_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_random_snatch_ogc_fid_seq OWNER TO postgres;

--
-- Name: patrol_residential_burglary_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.patrol_residential_burglary_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.patrol_residential_burglary_ogc_fid_seq OWNER TO postgres;

--
-- Name: poli_traffic_violation_evn_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.poli_traffic_violation_evn_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.poli_traffic_violation_evn_ogc_fid_seq OWNER TO postgres;

--
-- Name: poli_traffic_violation_mapping_code_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.poli_traffic_violation_mapping_code_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.poli_traffic_violation_mapping_code_ogc_fid_seq OWNER TO postgres;

--
-- Name: record_db_mtime_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.record_db_mtime_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.record_db_mtime_ogc_fid_seq OWNER TO postgres;

--
-- Name: sentiment_councillor_109_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sentiment_councillor_109_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sentiment_councillor_109_ogc_fid_seq OWNER TO postgres;

--
-- Name: sentiment_dispatching_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sentiment_dispatching_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sentiment_dispatching_ogc_fid_seq OWNER TO postgres;

--
-- Name: sentiment_hello_taipei_109_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sentiment_hello_taipei_109_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sentiment_hello_taipei_109_ogc_fid_seq OWNER TO postgres;

--
-- Name: sentiment_hello_taipei_109_test_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sentiment_hello_taipei_109_test_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sentiment_hello_taipei_109_test_ogc_fid_seq OWNER TO postgres;

--
-- Name: sentiment_hotnews_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sentiment_hotnews_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sentiment_hotnews_ogc_fid_seq OWNER TO postgres;

--
-- Name: sentiment_voice1999_109_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sentiment_voice1999_109_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sentiment_voice1999_109_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_case_study_ppl_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_case_study_ppl_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_case_study_ppl_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_dept_epidemic_info_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_dept_epidemic_info_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_dept_epidemic_info_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_domestic_violence_evn_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_domestic_violence_evn_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_domestic_violence_evn_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_export_filter_ppl_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_export_filter_ppl_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_export_filter_ppl_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_order_concern_mapping_code_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_order_concern_mapping_code_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_order_concern_mapping_code_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_order_concern_ppl_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_order_concern_ppl_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_order_concern_ppl_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_welfare_dis_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_welfare_dis_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_welfare_dis_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_welfare_dis_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_welfare_dis_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_welfare_dis_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_welfare_dislow_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_welfare_dislow_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_welfare_dislow_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_welfare_dislow_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_welfare_dislow_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_welfare_dislow_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_welfare_low_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_welfare_low_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_welfare_low_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_welfare_low_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_welfare_low_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_welfare_low_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_welfare_midlow_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_welfare_midlow_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_welfare_midlow_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_welfare_midlow_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_welfare_midlow_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_welfare_midlow_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_welfare_organization_plc_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_welfare_organization_plc_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_welfare_organization_plc_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_welfare_organization_plc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.socl_welfare_organization_plc (
    main_type character varying,
    sub_type character varying,
    name character varying,
    address character varying,
    lon double precision,
    lat double precision,
    _ctime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    _mtime timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    ogc_fid integer DEFAULT nextval('public.socl_welfare_organization_plc_ogc_fid_seq'::regclass) NOT NULL
);


ALTER TABLE public.socl_welfare_organization_plc OWNER TO postgres;

--
-- Name: socl_welfare_organization_plc_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_welfare_organization_plc_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_welfare_organization_plc_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: socl_welfare_people_ppl_history_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_welfare_people_ppl_history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_welfare_people_ppl_history_seq OWNER TO postgres;

--
-- Name: socl_welfare_people_ppl_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.socl_welfare_people_ppl_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.socl_welfare_people_ppl_ogc_fid_seq OWNER TO postgres;

--
-- Name: speeddata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.speeddata (
    "編號" integer,
    "功能" text,
    "設置路段" text,
    "設置地點" text,
    "經度" numeric,
    "緯度" numeric,
    "轄區" text,
    "拍攝方向" text,
    "速度限制" text
);


ALTER TABLE public.speeddata OWNER TO postgres;

--
-- Name: tdx_bus_live_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tdx_bus_live_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tdx_bus_live_ogc_fid_seq OWNER TO postgres;

--
-- Name: tdx_bus_route_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tdx_bus_route_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tdx_bus_route_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: tdx_bus_route_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tdx_bus_route_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tdx_bus_route_ogc_fid_seq OWNER TO postgres;

--
-- Name: tdx_bus_station_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tdx_bus_station_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tdx_bus_station_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: tdx_bus_station_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tdx_bus_station_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tdx_bus_station_ogc_fid_seq OWNER TO postgres;

--
-- Name: tdx_metro_line_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tdx_metro_line_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tdx_metro_line_ogc_fid_seq OWNER TO postgres;

--
-- Name: tdx_metro_station_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tdx_metro_station_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tdx_metro_station_ogc_fid_seq OWNER TO postgres;

--
-- Name: tour_2023_lantern_festival_mapping_table_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tour_2023_lantern_festival_mapping_table_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tour_2023_lantern_festival_mapping_table_ogc_fid_seq OWNER TO postgres;

--
-- Name: tour_2023_lantern_festival_zone_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tour_2023_lantern_festival_zone_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tour_2023_lantern_festival_zone_ogc_fid_seq OWNER TO postgres;

--
-- Name: tour_2023_latern_festival_mapping_table_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tour_2023_latern_festival_mapping_table_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tour_2023_latern_festival_mapping_table_ogc_fid_seq OWNER TO postgres;

--
-- Name: tour_2023_latern_festival_point_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tour_2023_latern_festival_point_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tour_2023_latern_festival_point_ogc_fid_seq OWNER TO postgres;

--
-- Name: tour_lantern_festival_sysmemorialhall_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tour_lantern_festival_sysmemorialhall_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tour_lantern_festival_sysmemorialhall_ogc_fid_seq OWNER TO postgres;

--
-- Name: tp_building_bim_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tp_building_bim_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_building_bim_ogc_fid_seq OWNER TO postgres;

--
-- Name: tp_building_height_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tp_building_height_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_building_height_ogc_fid_seq OWNER TO postgres;

--
-- Name: tp_cht_grid_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tp_cht_grid_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_cht_grid_ogc_fid_seq OWNER TO postgres;

--
-- Name: tp_district_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tp_district_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_district_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: tp_fet_age_hr_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tp_fet_age_hr_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_fet_age_hr_ogc_fid_seq OWNER TO postgres;

--
-- Name: tp_fet_hourly_popu_by_vil_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tp_fet_hourly_popu_by_vil_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_fet_hourly_popu_by_vil_ogc_fid_seq OWNER TO postgres;

--
-- Name: tp_fet_work_live_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tp_fet_work_live_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_fet_work_live_ogc_fid_seq OWNER TO postgres;

--
-- Name: tp_road_center_line_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tp_road_center_line_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_road_center_line_ogc_fid_seq OWNER TO postgres;

--
-- Name: tp_village_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tp_village_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_village_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: tp_village_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tp_village_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_village_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_accident_location_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_accident_location_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_accident_location_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_accident_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_accident_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_accident_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_bus_route_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_bus_route_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_bus_route_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_bus_route_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_bus_route_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_bus_route_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_bus_station_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_bus_station_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_bus_station_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_bus_station_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_bus_station_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_bus_station_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_bus_stop_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_bus_stop_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_bus_stop_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_info_histories_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_info_histories_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_info_histories_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_lives_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_lives_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_lives_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_lives_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_lives_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_lives_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_metro_capacity_realtime_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_metro_capacity_realtime_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_metro_capacity_realtime_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_metro_capacity_realtime_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_metro_capacity_realtime_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_metro_capacity_realtime_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_metro_capacity_rtime_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_metro_capacity_rtime_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_metro_capacity_rtime_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_metro_line_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_metro_line_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_metro_line_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_metro_line_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_metro_line_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_metro_line_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_metro_realtime_position_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_metro_realtime_position_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_metro_realtime_position_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_metro_realtime_position_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_metro_realtime_position_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_metro_realtime_position_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_metro_station_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_metro_station_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_metro_station_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_metro_station_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_metro_station_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_metro_station_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_metro_unusual_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_metro_unusual_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_metro_unusual_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_metro_unusual_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_metro_unusual_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_metro_unusual_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_todayworks_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_todayworks_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_todayworks_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_youbike_one_realtime_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_youbike_one_realtime_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_youbike_one_realtime_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_youbike_realtime_histories_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_youbike_realtime_histories_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_youbike_realtime_histories_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_youbike_station_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_youbike_station_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_youbike_station_ogc_fid_seq OWNER TO postgres;

--
-- Name: traffic_youbike_two_realtime_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.traffic_youbike_two_realtime_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.traffic_youbike_two_realtime_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: tran_parking_capacity_realtime_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tran_parking_capacity_realtime_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tran_parking_capacity_realtime_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: tran_parking_capacity_realtime_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tran_parking_capacity_realtime_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tran_parking_capacity_realtime_ogc_fid_seq OWNER TO postgres;

--
-- Name: tran_parking_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tran_parking_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tran_parking_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: tran_parking_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tran_parking_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tran_parking_ogc_fid_seq OWNER TO postgres;

--
-- Name: tran_ubike_realtime_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tran_ubike_realtime_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tran_ubike_realtime_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: tran_ubike_realtime_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tran_ubike_realtime_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tran_ubike_realtime_ogc_fid_seq OWNER TO postgres;

--
-- Name: tran_ubike_station_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tran_ubike_station_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tran_ubike_station_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: tran_ubike_station_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tran_ubike_station_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tran_ubike_station_ogc_fid_seq OWNER TO postgres;

--
-- Name: tran_urban_bike_path_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tran_urban_bike_path_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tran_urban_bike_path_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: tran_urban_bike_path_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tran_urban_bike_path_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tran_urban_bike_path_ogc_fid_seq OWNER TO postgres;

--
-- Name: tw_village_center_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tw_village_center_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tw_village_center_ogc_fid_seq OWNER TO postgres;

--
-- Name: tw_village_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tw_village_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tw_village_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_eco_park_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_eco_park_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_eco_park_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_eco_park_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_eco_park_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_eco_park_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_floodgate_location_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_floodgate_location_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_floodgate_location_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_floodgate_location_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_floodgate_location_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_floodgate_location_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_garden_city_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_garden_city_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_garden_city_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_garden_city_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_garden_city_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_garden_city_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_goose_sanctuary_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_goose_sanctuary_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_goose_sanctuary_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_goose_sanctuary_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_goose_sanctuary_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_goose_sanctuary_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_nature_reserve_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_nature_reserve_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_nature_reserve_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_nature_reserve_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_nature_reserve_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_nature_reserve_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_park_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_park_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_park_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_park_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_park_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_park_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_pumping_station_location_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_pumping_station_location_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_pumping_station_location_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_pumping_station_location_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_pumping_station_location_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_pumping_station_location_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_rainfall_station_location_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_rainfall_station_location_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_rainfall_station_location_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_rainfall_station_location_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_rainfall_station_location_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_rainfall_station_location_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_riverside_bike_path_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_riverside_bike_path_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_riverside_bike_path_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_riverside_bike_path_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_riverside_bike_path_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_riverside_bike_path_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_riverside_park_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_riverside_park_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_riverside_park_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_riverside_park_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_riverside_park_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_riverside_park_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_school_greening_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_school_greening_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_school_greening_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_school_greening_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_school_greening_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_school_greening_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_sewer_location_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_sewer_location_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_sewer_location_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_sewer_location_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_sewer_location_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_sewer_location_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_sidewalk_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_sidewalk_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_sidewalk_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_sidewalk_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_sidewalk_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_sidewalk_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_soil_liquefaction_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_soil_liquefaction_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_soil_liquefaction_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_soil_liquefaction_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_soil_liquefaction_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_soil_liquefaction_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_street_light_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_street_light_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_street_light_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_street_light_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_street_light_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_street_light_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_street_tree_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_street_tree_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_street_tree_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_street_tree_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_street_tree_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_street_tree_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_underpass_location_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_underpass_location_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_underpass_location_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_underpass_location_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_underpass_location_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_underpass_location_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_urban_agricultural_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_urban_agricultural_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_urban_agricultural_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_urban_agricultural_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_urban_agricultural_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_urban_agricultural_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_urban_reserve_history_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_urban_reserve_history_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_urban_reserve_history_ogc_fid_seq OWNER TO postgres;

--
-- Name: work_urban_reserve_ogc_fid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.work_urban_reserve_ogc_fid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.work_urban_reserve_ogc_fid_seq OWNER TO postgres;

--
-- Data for Name: app_calcu_monthly_socl_welfare_people_ppl; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.app_calcu_monthly_socl_welfare_people_ppl (district, is_low_middle_income, is_disabled, is_disabled_allowance, is_low_income, _ctime, _mtime, ogc_fid) FROM stdin;
士林區	1754	13285	706	5302	2023-09-02 00:00:09.443476+00	2023-09-02 00:00:09.443476+00	235
大安區	753	11388	249	1895	2023-09-02 00:00:09.443476+00	2023-09-02 00:00:09.443476+00	236
文山區	2180	12441	697	5803	2023-09-02 00:00:09.443476+00	2023-09-02 00:00:09.443476+00	238
南港區	1161	6055	431	2555	2023-09-02 00:00:09.443476+00	2023-09-02 00:00:09.443476+00	239
松山區	560	7963	188	1701	2023-09-02 00:00:09.443476+00	2023-09-02 00:00:09.443476+00	240
大同區	987	6390	353	3040	2023-09-02 00:00:09.443476+00	2023-09-02 00:00:09.443476+00	241
中山區	920	9531	354	2474	2023-09-02 00:00:09.443476+00	2023-09-02 00:00:09.443476+00	242
內湖區	1415	10711	573	3215	2023-09-02 00:00:09.443476+00	2023-09-02 00:00:09.443476+00	243
北投區	1533	11783	634	4453	2023-09-02 00:00:09.443476+00	2023-09-02 00:00:09.443476+00	244
中正區	513	6415	238	1785	2023-09-02 00:00:09.443476+00	2023-09-02 00:00:09.443476+00	245
萬華區	2549	11303	763	6807	2023-09-02 00:00:09.443476+00	2023-09-02 00:00:09.443476+00	246
信義區	1242	10239	444	3208	2023-09-02 00:00:09.443476+00	2023-09-02 00:00:09.443476+00	247
\.


--
-- Data for Name: building_unsued_land; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.building_unsued_land (thekey, thename, thelink, aa48, aa49, aa10, aa21, aa22, kcnt, cada_text, aa17, aa16, aa46, "cadastral map_key_地籍圖key值", "10712土地_1_土地權屬情形", "10712土地_1_管理機關", area, _ctime, _mtime, ogc_fid) FROM stdin;
000502160000	段名：永昌段五小段 地號：216號	\N	0005	02160000	628	2768796.4	\N	永昌段五小段	216	55800	211000	03	永昌段五小段02160000	臺北市	警察局	628	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19335
095003790000	段名：翠山段一小段 地號：379號	\N	0950	03790000	3681	2777645	\N	翠山段一小段	379	12800	47700	15	翠山段一小段03790000	臺北市	公共運輸處	3681	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19336
027103950008	段名：大龍段一小段 地號：395-8號	\N	0271	03950008	496	2774018.4	\N	大龍段一小段	395-8	45725	170573	09	大龍段一小段03950008	臺北市	消防局	496	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19337
007506670000	段名：實踐段二小段 地號：667號	\N	0075	06670000	1305.48	2763647.1	\N	實踐段二小段	667	53000	196000	11	實踐段二小段06670000	臺北市	市場處	1305.48	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19338
089600800003	段名：立農段五小段 地號：80-3號	\N	0896	00800003	179	2779077.2	\N	立農段五小段	80-3	73500	273000	16	立農段五小段00800003	臺北市	市場處	179	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19339
089601090004	段名：立農段五小段 地號：109-4號	\N	0896	01090004	266	2779085.725	\N	立農段五小段	109-4	73500	273000	16	立農段五小段01090004	臺北市	市場處	266	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19340
089601090005	段名：立農段五小段 地號：109-5號	\N	0896	01090005	375	2779084.6	\N	立農段五小段	109-5	73500	273000	16	立農段五小段01090005	臺北市	市場處	375	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19341
089601340000	段名：立農段五小段 地號：134號	\N	0896	01340000	6	2779075.9	\N	立農段五小段	134	73500	273000	16	立農段五小段01340000	臺北市	市場處	6	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19342
089601350000	段名：立農段五小段 地號：135號	\N	0896	01350000	103	2779079.31	\N	立農段五小段	135	73500	273000	16	立農段五小段01350000	臺北市	市場處	103	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19343
089601370001	段名：立農段五小段 地號：137-1號	\N	0896	01370001	244	2779089.983	\N	立農段五小段	137-1	73500	273000	16	立農段五小段01370001	臺北市	市場處	244	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19344
089601380002	段名：立農段五小段 地號：138-2號	\N	0896	01380002	4	2779096.4	\N	立農段五小段	138-2	73500	273000	16	立農段五小段01380002	臺北市	市場處	4	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19345
089601420002	段名：立農段五小段 地號：142-2號	\N	0896	01420002	10	2779092.8	\N	立農段五小段	142-2	73500	273000	16	立農段五小段01420002	臺北市	市場處	10	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19346
021903350003	段名：仁愛段三小段 地號：335-3號	\N	0219	03350003	314	2769653.3	\N	仁愛段三小段	335-3	166000	627000	02	仁愛段三小段03350003	臺北市	大安地政事務所	314	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19347
021903350004	段名：仁愛段三小段 地號：335-4號	\N	0219	03350004	221	2769591.7	\N	仁愛段三小段	335-4	237013	907413	02	仁愛段三小段03350004	臺北市	大安地政事務所	221	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19348
021903740003	段名：仁愛段三小段 地號：374-3號	\N	0219	03740003	25	2769591.5	\N	仁愛段三小段	374-3	286000	1097000	02	仁愛段三小段03740003	臺北市	大安地政事務所	25	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19349
046000170000	段名：康寧段一小段 地號：17號	\N	0460	00170000	6932	2775493.9	\N	康寧段一小段	17	7000	25800	14	康寧段一小段00170000	臺北市	體育局	6932	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19350
046000170001	段名：康寧段一小段 地號：17-1號	\N	0460	00170001	1539	2775546.6	\N	康寧段一小段	17-1	7000	25800	14	康寧段一小段00170001	臺北市	體育局	1539	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19351
046000170003	段名：康寧段一小段 地號：17-3號	\N	0460	00170003	44	2775456.2	\N	康寧段一小段	17-3	7000	25800	14	康寧段一小段00170003	臺北市	體育局	44	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19352
046000170004	段名：康寧段一小段 地號：17-4號	\N	0460	00170004	1	2775418.8	\N	康寧段一小段	17-4	7000	25800	14	康寧段一小段00170004	臺北市	體育局	1	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19353
046000170006	段名：康寧段一小段 地號：17-6號	\N	0460	00170006	8155	2775425.956	\N	康寧段一小段	17-6	7000	25800	14	康寧段一小段00170006	臺北市	體育局	8155	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19354
046000170015	段名：康寧段一小段 地號：17-15號	\N	0460	00170015	1	2775429.4	\N	康寧段一小段	17-15	7000	25800	14	康寧段一小段00170015	臺北市	體育局	1	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19355
046000170022	段名：康寧段一小段 地號：17-22號	\N	0460	00170022	2	2775450.5	\N	康寧段一小段	17-22	40400	152000	14	康寧段一小段00170022	臺北市	體育局	2	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19356
085205630000	段名：天山段一小段 地號：563號	\N	0852	05630000	794	2779530.1	\N	天山段一小段	563	53000	199000	15	天山段一小段05630000	臺北市	財政局	794	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19357
085303370000	段名：天山段二小段 地號：337號	\N	0853	03370000	221	2779217.579	\N	天山段二小段	337	53000	199000	15	天山段二小段03370000	臺北市	財政局	221	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19358
085303380000	段名：天山段二小段 地號：338號	\N	0853	03380000	221	2779223.146	\N	天山段二小段	338	53000	199000	15	天山段二小段03380000	臺北市	財政局	221	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19359
085304070000	段名：天山段二小段 地號：407號	\N	0853	04070000	14	2779203.609	\N	天山段二小段	407	53000	199000	15	天山段二小段04070000	臺北市	財政局	14	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19360
082800240001	段名：芝山段一小段 地號：24-1號	\N	0828	00240001	366	2777865.723	\N	芝山段一小段	24-1	80400	302000	15	芝山段一小段00240001	臺北市	財政局	366	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19361
084400420000	段名：溪洲段三小段 地號：42號	\N	0844	00420000	812	2777122.8	\N	溪洲段三小段	42	8700	32600	15	溪洲段三小段00420000	臺北市	財政局	812	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19362
084400430000	段名：溪洲段三小段 地號：43號	\N	0844	00430000	815	2777115.074	\N	溪洲段三小段	43	8700	32600	15	溪洲段三小段00430000	臺北市	財政局	815	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19363
027806620000	段名：大同段二小段 地號：662號	\N	0278	06620000	389	2773163.568	\N	大同段二小段	662	62351	232391	09	大同段二小段06620000	臺北市	財政局	389	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19364
040305530000	段名：中山段四小段 地號：553號	\N	0403	05530000	182	2771921.65	\N	中山段四小段	553	100000	385000	10	中山段四小段05530000	臺北市	財政局	182	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19365
040305540000	段名：中山段四小段 地號：554號	\N	0403	05540000	119	2771921.328	\N	中山段四小段	554	100000	385000	10	中山段四小段05540000	臺北市	財政局	119	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19366
040305550000	段名：中山段四小段 地號：555號	\N	0403	05550000	119	2771921.028	\N	中山段四小段	555	100000	385000	10	中山段四小段05550000	臺北市	財政局	119	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19367
040305560000	段名：中山段四小段 地號：556號	\N	0403	05560000	186	2771920.659	\N	中山段四小段	556	100000	385000	10	中山段四小段05560000	臺北市	財政局	186	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19368
040500820013	段名：北安段一小段 地號：82-13號	\N	0405	00820013	847	2775456.7	\N	北安段一小段	82-13	49500	185000	10	北安段一小段00820013	臺北市	財政局	847	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19369
041302380000	段名：正義段四小段 地號：238號	\N	0413	02380000	1235	2771493.9	\N	正義段四小段	238	102000	390000	10	正義段四小段02380000	臺北市	財政局	1050	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19370
041304290000	段名：正義段四小段 地號：429號	\N	0413	04290000	542	2771332.1	\N	正義段四小段	429	85433	324422	10	正義段四小段04290000	臺北市	財政局	542	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19371
041304290003	段名：正義段四小段 地號：429-3號	\N	0413	04290003	334	2771327.4	\N	正義段四小段	429-3	85096	323150	10	正義段四小段04290003	臺北市	財政局	334	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19372
041803320000	段名：吉林段五小段 地號：332號	\N	0418	03320000	571	2771918.7	\N	吉林段五小段	332	131000	492000	10	吉林段五小段03320000	臺北市	財政局	571	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19373
042307250000	段名：長春段一小段 地號：725號	\N	0423	07250000	619	2771842.2	\N	長春段一小段	725	93200	357000	10	長春段一小段07250000	臺北市	財政局	619	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19374
042705010000	段名：榮星段二小段 地號：501號	\N	0427	05010000	932	2773024.626	\N	榮星段二小段	501	81400	311000	10	榮星段二小段05010000	臺北市	財政局	932	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19375
020502460000	段名：中正段二小段 地號：246號	\N	0205	02460000	47.22	2769963.066	\N	中正段二小段	246	121000	462000	03	中正段二小段02460000	臺北市	財政局	47.22	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19376
020502560000	段名：中正段二小段 地號：256號	\N	0205	02560000	502	2769946	\N	中正段二小段	256	121000	462000	03	中正段二小段02560000	臺北市	財政局	502	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19377
020502570000	段名：中正段二小段 地號：257號	\N	0205	02570000	7	2769958.3	\N	中正段二小段	257	121000	462000	03	中正段二小段02570000	臺北市	財政局	7	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19378
001503390000	段名：南海段二小段 地號：339號	\N	0015	03390000	589	2768969.1	\N	南海段二小段	339	113113	426413	03	南海段二小段03390000	臺北市	財政局	589	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19379
001503400000	段名：南海段二小段 地號：340號	\N	0015	03400000	113	2768969.3	\N	南海段二小段	340	98700	373000	03	南海段二小段03400000	臺北市	財政局	113	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19380
001503570002	段名：南海段二小段 地號：357-2號	\N	0015	03570002	41	2768971.7	\N	南海段二小段	357-2	164000	615000	03	南海段二小段03570002	臺北市	財政局	41	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19381
002001710008	段名：福和段二小段 地號：171-8號	\N	0020	01710008	478	2767670.618	\N	福和段二小段	171-8	59900	225000	03	福和段二小段01710008	臺北市	財政局	478	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19382
023103030000	段名：臨沂段一小段 地號：303號	\N	0231	03030000	157	2770502.4	\N	臨沂段一小段	303	121000	462000	03	臨沂段一小段03030000	臺北市	財政局	157	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19383
023103060000	段名：臨沂段一小段 地號：306號	\N	0231	03060000	162	2770508.5	\N	臨沂段一小段	306	121000	462000	03	臨沂段一小段03060000	臺北市	財政局	162	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19384
023103070000	段名：臨沂段一小段 地號：307號	\N	0231	03070000	156	2770510.6	\N	臨沂段一小段	307	121000	462000	03	臨沂段一小段03070000	臺北市	財政局	156	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19385
023103080000	段名：臨沂段一小段 地號：308號	\N	0231	03080000	156	2770512.6	\N	臨沂段一小段	308	121000	462000	03	臨沂段一小段03080000	臺北市	財政局	156	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19386
023103630000	段名：臨沂段一小段 地號：363號	\N	0231	03630000	144	2770606.1	\N	臨沂段一小段	363	127875	485375	03	臨沂段一小段03630000	臺北市	財政局	144	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19387
023103630001	段名：臨沂段一小段 地號：363-1號	\N	0231	03630001	68	2770599.307	\N	臨沂段一小段	363-1	121735	463654	03	臨沂段一小段03630001	臺北市	財政局	68	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19388
023103630002	段名：臨沂段一小段 地號：363-2號	\N	0231	03630002	7.62	2770596.861	\N	臨沂段一小段	363-2	121000	462000	03	臨沂段一小段03630002	臺北市	財政局	7.62	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19389
023103640000	段名：臨沂段一小段 地號：364號	\N	0231	03640000	105	2770602.3	\N	臨沂段一小段	364	128000	486000	03	臨沂段一小段03640000	臺北市	財政局	105	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19390
023103640001	段名：臨沂段一小段 地號：364-1號	\N	0231	03640001	45	2770595.201	\N	臨沂段一小段	364-1	121000	462000	03	臨沂段一小段03640001	臺北市	財政局	45	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19391
045704560000	段名：西湖段一小段 地號：456號	\N	0457	04560000	364	2775354.4	\N	西湖段一小段	456	51700	194000	14	西湖段一小段04560000	臺北市	財政局	364	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19392
046002020001	段名：康寧段一小段 地號：202-1號	\N	0460	02020001	626	2775504.045	\N	康寧段一小段	202-1	7000	25800	14	康寧段一小段02020001	臺北市	財政局	626	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19393
046304520000	段名：康寧段四小段 地號：452號	\N	0463	04520000	734	2774603.4	\N	康寧段四小段	452	67800	252011	14	康寧段四小段04520000	臺北市	財政局	734	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19394
046304520002	段名：康寧段四小段 地號：452-2號	\N	0463	04520002	431	2774679.3	\N	康寧段四小段	452-2	64942	241538	14	康寧段四小段04520002	臺北市	財政局	431	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19395
046701670000	段名：碧湖段四小段 地號：167號	\N	0467	01670000	370	2775349.5	\N	碧湖段四小段	167	33100	123000	14	碧湖段四小段01670000	臺北市	財政局	370	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19396
012703360000	段名：木柵段三小段 地號：336號	\N	0127	03360000	1004	2764602.2	\N	木柵段三小段	336	50993	188392	11	木柵段三小段03360000	臺北市	財政局	1004	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19397
015604900000	段名：博嘉段四小段 地號：490號	\N	0156	04900000	566.68	2765900.3	\N	博嘉段四小段	490	4800	17400	11	博嘉段四小段04900000	臺北市	財政局	566.68	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19398
005103790000	段名：景美段二小段 地號：379號	\N	0051	03790000	822	2765500.8	\N	景美段二小段	379	50600	188000	11	景美段二小段03790000	臺北市	財政局	822	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19399
011500040005	段名：萬芳段一小段 地號：4-5號	\N	0115	00040005	328	2766304.1	\N	萬芳段一小段	4-5	45100	167000	11	萬芳段一小段00040005	臺北市	財政局	328	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19400
006500140002	段名：興安段二小段 地號：14-2號	\N	0065	00140002	187	2765922.9	\N	興安段二小段	14-2	80400	302000	11	興安段二小段00140002	臺北市	財政局	187	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19401
006500150000	段名：興安段二小段 地號：15號	\N	0065	00150000	23	2765916.7	\N	興安段二小段	15	80400	302000	11	興安段二小段00150000	臺北市	財政局	23	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19402
006500200005	段名：興安段二小段 地號：20-5號	\N	0065	00200005	19	2765934.9	\N	興安段二小段	20-5	80400	302000	11	興安段二小段00200005	臺北市	財政局	19	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19403
006500200006	段名：興安段二小段 地號：20-6號	\N	0065	00200006	96	2765930.6	\N	興安段二小段	20-6	80400	302000	11	興安段二小段00200006	臺北市	財政局	96	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19404
006507110000	段名：興安段二小段 地號：711號	\N	0065	07110000	371	2765693.9	\N	興安段二小段	711	50750	188550	11	興安段二小段07110000	臺北市	財政局	371	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19405
006203990011	段名：興隆段三小段 地號：399-11號	\N	0062	03990011	78	2766384.8	\N	興隆段三小段	399-11	48600	181000	11	興隆段三小段03990011	臺北市	財政局	78	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19406
006205590007	段名：興隆段三小段 地號：559-7號	\N	0062	05590007	49	2766378.5	\N	興隆段三小段	559-7	48600	181000	11	興隆段三小段05590007	臺北市	財政局	49	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19407
006205590009	段名：興隆段三小段 地號：559-9號	\N	0062	05590009	20	2766387.9	\N	興隆段三小段	559-9	48600	181000	11	興隆段三小段05590009	臺北市	財政局	20	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19408
006205600000	段名：興隆段三小段 地號：560號	\N	0062	05600000	145	2766378.4	\N	興隆段三小段	560	48600	181000	11	興隆段三小段05600000	臺北市	財政局	145	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19409
006205600007	段名：興隆段三小段 地號：560-7號	\N	0062	05600007	62	2766387.7	\N	興隆段三小段	560-7	48600	181000	11	興隆段三小段05600007	臺北市	財政局	62	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19410
006205620013	段名：興隆段三小段 地號：562-13號	\N	0062	05620013	84	2766381	\N	興隆段三小段	562-13	48600	181000	11	興隆段三小段05620013	臺北市	財政局	84	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19411
006205630013	段名：興隆段三小段 地號：563-13號	\N	0062	05630013	6	2766382.3	\N	興隆段三小段	563-13	48600	181000	11	興隆段三小段05630013	臺北市	財政局	6	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19412
090402910001	段名：大業段一小段 地號：291-1號	\N	0904	02910001	724	2780741.8	\N	大業段一小段	291-1	90477	340466	16	大業段一小段02910001	臺北市	財政局	724	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19413
090702230000	段名：大業段四小段 地號：223號	\N	0907	02230000	1081	2780044.126	\N	大業段四小段	223	44500	167000	16	大業段四小段02230000	臺北市	財政局	1081	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19414
090702240001	段名：大業段四小段 地號：224-1號	\N	0907	02240001	109	2780058.567	\N	大業段四小段	224-1	44500	167000	16	大業段四小段02240001	臺北市	財政局	109	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19415
099201670000	段名：湖山段二小段 地號：167號	\N	0992	01670000	1202.1	2782525	\N	湖山段二小段	167	13100	49400	16	湖山段二小段01670000	臺北市	財政局	1202.1	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19416
090001180000	段名：新民段四小段 地號：118號	\N	0900	01180000	765	2781188.3	\N	新民段四小段	118	16900	62900	16	新民段四小段01180000	臺北市	財政局	765	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19417
060106750004	段名：西松段二小段 地號：675-4號	\N	0601	06750004	138	2771331.2	\N	西松段二小段	675-4	92600	349000	01	西松段二小段06750004	臺北市	財政局	138	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19418
060106750005	段名：西松段二小段 地號：675-5號	\N	0601	06750005	175	2771302.6	\N	西松段二小段	675-5	92600	349000	01	西松段二小段06750005	臺北市	財政局	175	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19419
064007900000	段名：吳興段三小段 地號：790號	\N	0640	07900000	94	2767954.193	\N	吳興段三小段	790	55800	211000	17	吳興段三小段07900000	臺北市	財政局	94	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19420
064007920000	段名：吳興段三小段 地號：792號	\N	0640	07920000	569	2767967.402	\N	吳興段三小段	792	55800	211000	17	吳興段三小段07920000	臺北市	財政局	569	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19421
067403610001	段名：新光段二小段 地號：361-1號	\N	0674	03610001	848	2770390.021	\N	新光段二小段	361-1	50300	193000	13	新光段二小段03610001	臺北市	財政局	848	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19422
067403610005	段名：新光段二小段 地號：361-5號	\N	0674	03610005	5	2770407.7	\N	新光段二小段	361-5	50300	193000	13	新光段二小段03610005	臺北市	財政局	5	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19423
067403610006	段名：新光段二小段 地號：361-6號	\N	0674	03610006	16	2770392.3	\N	新光段二小段	361-6	50300	193000	13	新光段二小段03610006	臺北市	財政局	16	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19424
067403830001	段名：新光段二小段 地號：383-1號	\N	0674	03830001	1171	2770369.7	\N	新光段二小段	383-1	50300	193000	13	新光段二小段03830001	臺北市	財政局	1171	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19425
067403850005	段名：新光段二小段 地號：385-5號	\N	0674	03850005	2	2770400.6	\N	新光段二小段	385-5	50300	193000	13	新光段二小段03850005	臺北市	財政局	2	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19426
067403850006	段名：新光段二小段 地號：385-6號	\N	0674	03850006	1	2770377	\N	新光段二小段	385-6	50300	193000	13	新光段二小段03850006	臺北市	財政局	1	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19427
003203050000	段名：華中段二小段 地號：305號	\N	0032	03050000	490	2768265.398	\N	華中段二小段	305	53078	200673	05	華中段二小段03050000	臺北市	財政局	490	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19428
003205420007	段名：華中段二小段 地號：542-7號	\N	0032	05420007	888	2768334.622	\N	華中段二小段	542-7	41300	156000	05	華中段二小段05420007	臺北市	財政局	888	2023-05-24 19:00:45.305729+00	2023-05-24 19:00:45.305729+00	19429
\.


--
-- Data for Name: building_unsued_public; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.building_unsued_public (full_key, "建物管理機關", "行政區", "門牌", "建物標示", "建築完成日期", "閒置樓層_閒置樓層/該建物總樓層", "閒置面積㎡", "房屋現況", "原使用用途", "基地所有權人", "基地管理機關", "土地使用分區", "目前執行情形", _ctime, _mtime) FROM stdin;
1	\N	萬華區	桂林路52號3樓	萬華段一小段01157建號	731205	\N	\N	\N	辦公廳舍	臺北市	\N	\N	參與都市更新計畫，目前進度權利變換分配中。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
2	\N	萬華區	桂林路52號4樓	萬華段一小段01158建號	731205	\N	\N	\N	辦公廳舍	臺北市	\N	\N	參與都市更新計畫，目前進度權利變換分配中。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
3	\N	萬華區	桂林路52號5樓	萬華段一小段01159建號	731205	\N	\N	\N	辦公廳舍	臺北市	\N	\N	參與都市更新計畫，目前進度權利變換分配中。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
4	\N	中山區	林森北路487號5樓之6	吉林段三小段04721建號	611117	\N	\N	\N	宿舍、眷舍	臺北市	\N	\N	併同毗鄰新興國中評估以EOD方式辦理改建。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
5	\N	中山區	林森北路487號4樓之10	吉林段三小段04724建號	611117	\N	\N	\N	宿舍、眷舍	臺北市	\N	\N	併同毗鄰新興國中評估以EOD方式辦理改建。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
6	\N	中山區	林森北路487號3樓之18	吉林段三小段04697建號	611117	\N	\N	\N	宿舍、眷舍	臺北市	\N	\N	併同毗鄰新興國中評估以EOD方式辦理改建。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
7	\N	中山區	林森北路487號3樓之20	吉林段三小段04698建號	611117	\N	\N	\N	宿舍、眷舍	臺北市	\N	\N	併同毗鄰新興國中評估以EOD方式辦理改建。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
8	\N	中山區	林森北路487號3樓之21	吉林段三小段04693建號	611117	\N	\N	\N	宿舍、眷舍	臺北市	\N	\N	併同毗鄰新興國中評估以EOD方式辦理改建。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
9	\N	中山區	林森北路487號5樓之1	吉林段三小段04705建號	611117	\N	\N	\N	宿舍、眷舍	臺北市	\N	\N	併同毗鄰新興國中評估以EOD方式辦理改建。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
10	\N	中山區	林森北路487號4樓之6	吉林段三小段04720建號	611117	\N	\N	\N	宿舍、眷舍	臺北市	\N	\N	併同毗鄰新興國中評估以EOD方式辦理改建。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
11	\N	松山區	八德路4段688號2樓	寶清段七小段01201建號	720715	\N	\N	\N	檔案室	臺北市	\N	\N	該綜合大樓經耐震能力評估後，決議拆除重建。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
12	\N	松山區	八德路4段688號地下一層	寶清段七小段01202建號	720715	\N	\N	\N	停車場	臺北市	\N	\N	該綜合大樓經耐震能力評估後，決議拆除重建。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
13	\N	信義區	松德路25巷58號5樓	永春段一小段02408建號	790511	\N	\N	\N	兒少庇護性團體家庭(含自立宿舍)	臺北市	\N	\N	評估辦理標租	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
14	\N	信義區	松德路25巷60號5樓	永春段一小段02414建號	790511	\N	\N	\N	兒少庇護性團體家庭(含自立宿舍)	臺北市	\N	\N	評估辦理標租	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
15	\N	中山區	長春路299號3樓	長春段一小段01114建號	640611	\N	\N	\N	辦公廳舍	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
16	\N	中山區	長春路299號4樓	長春段一小段01381建號	640611	\N	\N	\N	辦公廳舍	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
17	\N	北投區	中山路5-8號	新民段二小段E0001-000建號	550101	\N	\N	\N	辦公廳舍	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
18	\N	士林區	大東路80號	光華段三小段E0080-000建號	580428	\N	\N	\N	辦公廳舍	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
19	\N	中正區	博愛路119號	公園段二小段E0833-001建號	520601	\N	\N	\N	辦公廳舍	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
20	\N	士林區	仰德大道2段2巷50號	至善段五小段50106建號	540101	\N	\N	\N	倉庫	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
21	\N	大同區	敦煌路臨160-2號	文昌段一小段E0001-001建號	870320	\N	\N	\N	老師區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
22	\N	大同區	敦煌路臨151-1號	文昌段一小段E0001-002建號	720730	\N	\N	\N	慶昌區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
23	\N	大同區	保安街47-1號3樓	延平段一小段02730建號	871116	\N	\N	\N	延平區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
24	\N	中山區	長春路299號3樓之1	長春段一小段01582建號	640611	\N	\N	\N	長春區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
25	\N	內湖區	環山路2段68巷14號	碧湖段四小段05443建號	780110	\N	\N	\N	港華區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
26	\N	內湖區	金龍路136-1號2樓	碧湖段一小段02820建號	940519	\N	\N	\N	金龍區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
27	\N	士林區	中正路589號	福順段一小段E0012-000建號	850917	\N	\N	\N	葫東區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
28	\N	北投區	大度路3段301巷1號1樓	豐年段四小段40674建號	770129	\N	\N	\N	關渡區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
29	\N	北投區	崇仰一路7號1、2樓	奇岩段一小段10851建號	560220	\N	\N	\N	崇仰區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
30	\N	信義區	吳興街156巷6號6樓	三興段一小段05156建號	940715	\N	\N	\N	景勤區民活動中心	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
31	\N	萬華區	萬大路411號2樓	青年段一小段12432建號	880918	\N	\N	\N	萬青區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
32	\N	萬華區	萬大路臨614-1號	華中段四小段E1112-000建號	830516	\N	\N	\N	萬大第一區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
33	\N	萬華區	萬大路臨600-1號	華中段四小段E1113-000建號	901103	\N	\N	\N	萬大第二區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
34	\N	萬華區	西園路2段臨370-1號	雙園段一小段E0624-000建號	700415	\N	\N	\N	光復區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
35	\N	萬華區	環河南路2段臨5-1號	直興段二小段E0001-000建號	880101	\N	\N	\N	青山區民活動中心	臺北市	\N	\N	民政局檢討釋出，未完成媒合前，仍按區民活動中心經營管理。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
36	\N	中正區	北平東路1號4樓之2	成功段三小段00077建號	570509	\N	\N	\N	辦公室	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
37	\N	中正區	北平東路1號4樓之3	成功段三小段00077建號	570509	\N	\N	\N	辦公室	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
38	\N	中正區	北平東路1號4樓之4	成功段三小段00077建號	570509	\N	\N	\N	辦公室	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
39	\N	中正區	北平東路1號4樓之5	成功段三小段00077建號	570509	\N	\N	\N	辦公室	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
40	\N	中正區	北平東路1號4樓之12	成功段三小段00077建號	570509	\N	\N	\N	辦公室	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
41	\N	中正區	北平東路1號4樓之10	成功段三小段00077建號	570509	\N	\N	\N	辦公室	臺北市	\N	\N	無使用需求，徵詢各機關有無公務需求。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
42	\N	士林區	陽明路1段48巷3號2樓	力行段三小段E0000-001建號	600705	\N	\N	\N	宿舍	臺北市	\N	\N	基地為國有，使用受限。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
43	\N	北投區	勝利街29號	湖山段二小段E0385建號	560510	\N	\N	\N	宿舍	臺北市	\N	\N	基地為國有，使用受限。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
44	\N	士林區	陽明路1段48巷8號2樓	力行段三小段EO381建號	600110	\N	\N	\N	宿舍	臺北市	\N	\N	基地為國有，使用受限。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
45	\N	南港區	同德路100號	玉成段五小段03213建號	670626	\N	\N	\N	提供標租使用	臺北市	\N	\N	現況維管。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
46	\N	中山區	長春路75號	吉林段四小段03818建號	420101	\N	\N	\N	辦公廳舍	臺北市	\N	\N	已納入都市更新範圍，待參與都市更新改建。	2023-09-19 19:00:21.881162+00	2023-09-19 19:00:21.881162+00
\.


--
-- Data for Name: car_one; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.car_one ("照片ID", "違規地點", "違規時間", "紀錄設備ID", "道路速限", "車輛時速", "經度", "緯度", "行政區", "車牌") FROM stdin;
A01	台北市中正區信義路三段23號	2024-01-10 00:00:00	ID004	50	70	25.035202348798737	121.525591537447650	中正區	AFF-0666
A02	台北市大安區信義路三段23號	2024-01-10 00:01:00	ID005	50	75	25.033909150131706	121.534006049087030	大安區	ALN-7568
A03	台北市大安區信義路四段1-106號	2024-01-10 00:02:00	ID006	50	65	25.033784303543637	121.544237995119620	大安區	BGR-5851
A04	台北市信義區信義路五段23號	2024-01-10 00:03:00	ID007	60	80	25.033430229635430	121.568820623955690	信義區	重複車牌
\.


--
-- Data for Name: garbage_truck; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.garbage_truck ("行政區", "里別", "分隊", "局編", "車號", "路線", "車次", "抵達時間", "離開時間", "地點", "經度", "緯度") FROM stdin;
中山區	力行里	長安分隊	100-021	119-BQ	長安-3	第1車	1630	1638	臺北市中山區建國北路1段69號前	121.53694	25.05111
中山區	力行里	長安分隊	100-021	119-BQ	長安-3	第1車	1640	1649	臺北市中山區南京東路3段176號前(遼寧街口)	121.54222	25.05194
中山區	力行里	長安分隊	100-021	119-BQ	長安-3	第1車	1650	1658	臺北市中山區南京東路3段214號前	121.54338	25.05172
中山區	力行里	長安分隊	100-021	119-BQ	長安-3	第1車	1700	1709	臺北市中山區復興北路66號	121.54385	25.05082
中山區	力行里	長安分隊	100-021	119-BQ	長安-3	第1車	1710	1716	臺北市中山區復興北路28號前	121.54381	25.04886
中山區	朱崙里	長安分隊	100-021	119-BQ	長安-3	第2車	1845	1851	臺北市中山區八德路2段335號前	121.54361	25.0475
中山區	朱崙里	長安分隊	100-021	119-BQ	長安-3	第2車	1852	1902	臺北市中山區八德路2段291號前	121.54194	25.04722
中山區	朱崙里	長安分隊	100-021	119-BQ	長安-3	第2車	1904	1914	臺北市中山區龍江路23號	121.54042	25.04788
中山區	朱崙里	長安分隊	100-021	119-BQ	長安-3	第2車	1920	1925	臺北市中山區長安東路2段158號前	121.53899	25.04832
中山區	朱崙里	長安分隊	100-021	119-BQ	長安-3	第2車	1932	1938	臺北市中山區八德路2段167巷16號(建興公園旁)	121.53801	25.04751
中山區	力行里	長安分隊	100-021	119-BQ	長安-3	第3車	2100	2108	臺北市中山區龍江路70號	121.54056	25.05111
中山區	力行里	長安分隊	100-021	119-BQ	長安-3	第3車	2110	2118	臺北市中山區朱崙街36號	121.53867	25.04987
中山區	力行里	長安分隊	100-021	119-BQ	長安-3	第3車	2120	2128	臺北市中山區長安東路2段197號	121.54324	25.04834
中山區	力行里	長安分隊	100-021	119-BQ	長安-3	第3車	2130	2138	臺北市中山區長安東路2段171號前	121.54177	25.04841
中山區	力行里	長安分隊	100-021	119-BQ	長安-3	第3車	2140	2150	臺北市中山區龍江路55號	121.54044	25.04957
中山區	朱馥里	南京分隊	100-022	121-BQ	南京-1	第1車	1700	1705	臺北市中山區民生東路3段10號旁	121.53886	25.05761
中山區	朱馥里	南京分隊	100-022	121-BQ	南京-1	第1車	1706	1711	臺北市中山區民生東路3段36號前	121.54012	25.05766
中山區	朱馥里	南京分隊	100-022	121-BQ	南京-1	第1車	1712	1720	臺北市中山區民生東路3段67號對面	121.5421	25.0577
中山區	龍洲里	南京分隊	100-022	121-BQ	南京-1	第1車	1721	1730	臺北市中山區復興北路234號(土地銀行前)	121.54389	25.05738
中山區	龍洲里	南京分隊	100-022	121-BQ	南京-1	第1車	1731	1745	臺北市中山區興安街75號	121.54284	25.05625
中山區	朱馥里	南京分隊	100-022	121-BQ	南京-1	第2車	1915	1925	臺北市中山區建國北路2段51號	121.53726	25.05554
中山區	朱馥里	南京分隊	100-022	121-BQ	南京-1	第2車	1926	1931	臺北市中山區興安街24號	121.53813	25.0562
中山區	朱馥里	南京分隊	100-022	121-BQ	南京-1	第2車	1932	1940	臺北市中山區興安街50號前	121.53918	25.05612
中山區	朱馥里	南京分隊	100-022	121-BQ	南京-1	第2車	1941	1950	臺北市中山區興安街64號前	121.54016	25.05596
中山區	朱馥里	南京分隊	100-022	121-BQ	南京-1	第2車	1951	2000	臺北市中山區龍江路172之2號前	121.54045	25.05538
中山區	朱馥里	南京分隊	100-022	121-BQ	南京-1	第2車	2001	2015	臺北市中山區長春路235號前	121.53932	25.05475
中山區	朱馥里	南京分隊	100-022	121-BQ	南京-1	第3車	2135	2143	臺北市中山區興安街53之4號對面	121.5418	25.05609
中山區	龍洲里	南京分隊	100-022	121-BQ	南京-1	第3車	2144	2158	臺北市中山區興安街100號	121.54283	25.05573
中山區	龍洲里	南京分隊	100-022	121-BQ	南京-1	第3車	2159	2208	臺北市中山區復興北路204號前	121.54369	25.05572
中山區	龍洲里	南京分隊	100-022	121-BQ	南京-1	第3車	2209	2220	臺北市中山區長春路325號前	121.54335	25.0548
文山區	樟樹里	復興分隊	100-032	123-BQ	復興-1	第1車	1755	1800	臺北市文山區忠順街1段26巷11弄2號前	121.55743	24.98293
文山區	樟文里	復興分隊	100-032	123-BQ	復興-1	第1車	1801	1804	臺北市文山區木新路3段236號前	121.55911	24.98128
文山區	樟文里	復興分隊	100-032	123-BQ	復興-1	第1車	1805	1809	臺北市文山區木新路3段310巷12弄1號旁	121.55693	24.98201
文山區	樟文里	復興分隊	100-032	123-BQ	復興-1	第1車	1811	1814	臺北市文山區忠順街1段8號前	121.55819	24.98384
文山區	樟樹里	復興分隊	100-032	123-BQ	復興-1	第1車	1815	1820	臺北市文山區忠順街1段50號前	121.56005	24.98419
文山區	樟樹里	復興分隊	100-032	123-BQ	復興-1	第1車	1821	1824	臺北市文山區興隆路4段76號前	121.56185	24.98392
文山區	樟樹里	復興分隊	100-032	123-BQ	復興-1	第1車	1824	1828	臺北市文山區興隆路4段98號前	121.5621	24.98323
文山區	樟樹里	復興分隊	100-032	123-BQ	復興-1	第1車	1828	1830	臺北市文山區興隆路4段124號前	121.56221	24.98251
文山區	明興里	復興分隊	100-032	123-BQ	復興-1	第2車	1930	1933	臺北市文山區木柵路2段163號前	121.56309	24.98921
文山區	明興里	復興分隊	100-032	123-BQ	復興-1	第2車	1934	1938	臺北市文山區木柵路2段95號前	121.56137	24.98891
文山區	樟樹里	復興分隊	100-032	123-BQ	復興-1	第2車	1944	1948	臺北市文山區木新路3段176號前	121.56057	24.98187
文山區	樟樹里	復興分隊	100-032	123-BQ	復興-1	第2車	1951	1956	臺北市文山區樟新街58號前	121.55569	24.97757
文山區	樟新里	復興分隊	100-032	123-BQ	復興-1	第2車	1957	2000	臺北市文山區一壽街48-54號旁	121.55441	24.97894
文山區	樟文里	復興分隊	100-032	123-BQ	復興-1	第2車	2002	2006	臺北市文山區木新路3段336號前	121.5552	24.98031
文山區	樟文里	復興分隊	100-032	123-BQ	復興-1	第2車	2008	2011	臺北市文山區辛亥路7段73號前	121.55432	24.98412
文山區	樟新里	復興分隊	100-032	123-BQ	復興-1	第2車	2014	2016	臺北市文山區木新路3段289號前	121.55751	24.98082
文山區	樟新里	復興分隊	100-032	123-BQ	復興-1	第2車	2017	2019	臺北市文山區木新路3段239號前	121.55883	24.9811
文山區	樟新里	復興分隊	100-032	123-BQ	復興-1	第2車	2019	2021	臺北市文山區木新路3段213號前	121.55966	24.9813
文山區	樟腳里	復興分隊	100-032	123-BQ	復興-1	第2車	2021	2022	臺北市文山區木新路3段181號前	121.56041	24.98147
文山區	樟腳里	復興分隊	100-032	123-BQ	復興-1	第2車	2023	2025	臺北市文山區木新路3段153號前	121.56128	24.98172
文山區	樟腳里	復興分隊	100-032	123-BQ	復興-1	第2車	2025	2027	臺北市文山區木新路3段125號前	121.5621	24.98186
文山區	明義里	復興分隊	100-032	123-BQ	復興-1	第2車	2030	2032	臺北市文山區興隆路4段101巷明義公園旁(建築年鑑大廈前)	121.56102	24.98823
文山區	明義里	復興分隊	100-032	123-BQ	復興-1	第2車	2040	2043	臺北市文山區興隆路4段105巷46號	121.55939	24.98743
文山區	明義里	復興分隊	100-032	123-BQ	復興-1	第2車	2040	2043	臺北市文山區興隆路4段105巷46號前	121.56218	24.98748
文山區	樟林里	復興分隊	100-032	123-BQ	復興-1	第3車	2130	2132	臺北市文山區興隆路4段64號前	121.56137	24.98518
文山區	樟林里	復興分隊	100-032	123-BQ	復興-1	第3車	2132	2134	臺北市文山區忠順街1段143號前	121.56087	24.98447
文山區	樟林里	復興分隊	100-032	123-BQ	復興-1	第3車	2134	2137	臺北市文山區忠順街1段9巷1號旁	121.55678	24.98446
文山區	樟新里	復興分隊	100-032	123-BQ	復興-1	第3車	2140	2144	臺北市文山區樟新街8巷2號旁	121.55458	24.97954
文山區	樟新里	復興分隊	100-032	123-BQ	復興-1	第3車	2144	2148	臺北市文山區樟新街28號前	121.5553	24.97886
文山區	樟新里	復興分隊	100-032	123-BQ	復興-1	第3車	2148	2152	臺北市文山區樟新街58號前	121.55579	24.97753
文山區	樟新里	復興分隊	100-032	123-BQ	復興-1	第3車	2152	2157	臺北市文山區一壽街48-54號旁	121.55441	24.97894
文山區	樟新里	復興分隊	100-032	123-BQ	復興-1	第3車	2159	2202	臺北市文山區一壽街3巷2號前	121.55656	24.97988
文山區	樟文里	復興分隊	100-032	123-BQ	復興-1	第3車	2203	2206	臺北市文山區木新路3段310巷12弄1號前	121.55691	24.98201
文山區	樟樹里	復興分隊	100-032	123-BQ	復興-1	第3車	2208	2210	臺北市文山區忠順街1段26巷11弄2號前	121.55961	24.98254
士林區	名山里	蘭雅分隊	100-033	111-BQ	蘭雅-1	第1車	1600	1800	臺北市士林區陽明醫院雨聲街側面對面空地	121.53133	25.1046
信義區	安康里	三張犁分隊	100-035	118-BQ	三張犁-3	第1車	1800	1820	臺北市信義區松德路171號旁	121.57487	25.0358
信義區	安康里	三張犁分隊	100-035	118-BQ	三張犁-3	第2車	2030	2045	臺北市信義區松德路171號前	121.57487	25.0358
信義區	安康里	三張犁分隊	100-035	118-BQ	三張犁-3	第2車	2047	2100	臺北市信義區松德路46號前	121.57655	25.03897
信義區	廣居里	三張犁分隊	100-035	118-BQ	三張犁-3	第2車	2105	2120	臺北市信義區忠孝東路5段248號	121.57258	25.04078
信義區	廣居里	三張犁分隊	100-035	118-BQ	三張犁-3	第2車	2125	2130	臺北市信義區忠孝東路5段420號	121.57535	25.0407
內湖區	安泰里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1644	1646	臺北市內湖區安泰街164號(每星期一、四收運)	121.61564	25.08081
內湖區	安泰里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1647	1649	臺北市內湖區安泰街174號(每星期一、四收運)	121.61535	25.082
內湖區	安泰里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1650	1653	臺北市內湖區安泰街192號(每星期一、四收運)	121.61341	25.08585
內湖區	內溝里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1658	1700	臺北市內湖區康樂街291巷內(魚池)旁	121.61415	25.0972
內湖區	內溝里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1701	1703	臺北市內湖區康樂街291號（福德宮）前	121.61415	25.0972
內湖區	內溝里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1704	1706	臺北市內湖區康樂街275號（土地公廟）前	121.62215	25.09365
內湖區	內溝里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1707	1710	臺北市內湖區康樂街265號前100公尺(明舉橋)前	121.62353	25.08789
內湖區	內溝里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1711	1713	臺北市內湖區康樂街234號前	121.62369	25.086
內湖區	內溝里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1714	1717	臺北市內湖區康樂街220巷口	121.62394	25.08471
內湖區	內溝里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1718	1720	臺北市內湖區康樂街206號(敦厚宮)前	121.62353	25.07884
內湖區	明湖里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1750	1755	臺北市內湖區康寧路3段165巷23弄1號	121.61222	25.07142
內湖區	康寧里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1800	1810	臺北市內湖區康寧路3段189巷96號	121.61262	25.07341
內湖區	康寧里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1812	1820	臺北市內湖區康寧路3段189巷163弄15號	121.61183	25.07574
內湖區	康寧里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1822	1830	臺北市內湖區康寧路3段99巷39弄70號	121.61062	25.07433
內湖區	安湖里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1833	1836	臺北市內湖區東湖路43巷21號旁	121.61361	25.0698
內湖區	安湖里	東湖分隊	100-603	070-BQ	東湖-1	第1車	1836	1845	臺北市內湖區東湖路113巷95弄164號對面	121.61443	25.06959
內湖區	蘆洲里	東湖分隊	100-603	070-BQ	東湖-1	第2車	1905	1935	臺北市內湖區安美街181號斜對面	121.60134	25.05998
內湖區	五分里	東湖分隊	100-603	070-BQ	東湖-1	第3車	2010	2015	臺北市內湖區東湖路12號前	121.61264	25.06878
內湖區	安泰里	東湖分隊	100-603	070-BQ	東湖-1	第3車	2020	2045	臺北市內湖區安泰街98號旁	121.61638	25.07652
內湖區	安泰里	東湖分隊	100-603	070-BQ	東湖-1	第3車	2200	2215	臺北市內湖區安泰街45巷18號對面	121.61836	25.07428
內湖區	樂康里	東湖分隊	100-603	070-BQ	東湖-1	第3車	2216	2220	臺北市內湖區康樂街136巷29弄17號對面	121.61767	25.07274
內湖區	蘆洲里	東湖分隊	100-603	070-BQ	東湖-1	第4車	2105	2130	臺北市內湖區安美街181號前200公尺	121.60283	25.06015
士林區	福中里	後港分隊	101-038	650-BS	後港-1	第1車	1630	1658	臺北市士林區大南路與通河東街1段口	121.51548	25.08939
士林區	福中里	後港分隊	101-038	650-BS	後港-1	第1車	1659	1703	臺北市士林區大南路323號	121.51778	25.08891
士林區	福中里	後港分隊	101-038	650-BS	後港-1	第1車	1704	1713	臺北市士林區福港街152號	121.51783	25.08752
士林區	福中里	後港分隊	101-038	650-BS	後港-1	第1車	1714	1722	臺北市士林區福港街218號	121.51755	25.08554
士林區	前港里	後港分隊	101-038	650-BS	後港-1	第1車	1723	1728	臺北市士林區華齡街168號	121.51962	25.08687
士林區	前港里	後港分隊	101-038	650-BS	後港-1	第1車	1729	1733	臺北市士林區後港街134巷口	121.52131	25.08678
士林區	前港里	後港分隊	101-038	650-BS	後港-1	第1車	1734	1738	臺北市士林區前港街與後港街口(前港街16號前)	121.52129	25.0848
士林區	承德里	後港分隊	101-038	650-BS	後港-1	第1車	1739	1748	臺北市士林區後港街與劍潭路口	121.52277	25.08409
士林區	後港里	後港分隊	101-038	650-BS	後港-1	第2車	1858	1903	臺北市士林區大南路423號前	121.51626	25.09041
士林區	福中里	後港分隊	101-038	650-BS	後港-1	第2車	1904	1908	臺北市士林區大南路325號	121.51775	25.08894
士林區	後港里	後港分隊	101-038	650-BS	後港-1	第2車	1909	1917	臺北市士林區大南路287號	121.51893	25.08875
士林區	前港里	後港分隊	101-038	650-BS	後港-1	第2車	1918	1925	臺北市士林區大南路與後港街口	121.5207	25.08844
士林區	後港里	後港分隊	101-038	650-BS	後港-1	第2車	1929	1938	臺北市士林區承德路4段279號	121.51969	25.08983
士林區	後港里	後港分隊	101-038	650-BS	後港-1	第2車	1939	1947	臺北市士林區承德路4段297巷口	121.51865	25.08998
士林區	後港里	後港分隊	101-038	650-BS	後港-1	第2車	1948	1953	臺北市士林區承德路4段325號	121.5177	25.09039
士林區	後港里	後港分隊	101-038	650-BS	後港-1	第2車	1954	1957	臺北市士林區中正路與士商路口(士商路116號)	121.51871	25.09229
士林區	後港里	後港分隊	101-038	650-BS	後港-1	第2車	1958	2003	臺北市士林區士商路70號前	121.51984	25.09092
士林區	百齡里	後港分隊	101-038	650-BS	後港-1	第3車	2058	2108	臺北市士林區華齡街與前港街口	121.51936	25.08506
士林區	前港里	後港分隊	101-038	650-BS	後港-1	第3車	2109	2113	臺北市士林區華齡街184號	121.5197	25.08747
士林區	前港里	後港分隊	101-038	650-BS	後港-1	第3車	2114	2117	臺北市士林區華齡街214號	121.51994	25.0885
士林區	前港里	後港分隊	101-038	650-BS	後港-1	第3車	2118	2122	臺北市士林區大南路233號	121.52087	25.08844
士林區	後港里	後港分隊	101-038	650-BS	後港-1	第3車	2126	2132	臺北市士林區福港街20號	121.51812	25.09103
士林區	後港里	後港分隊	101-038	650-BS	後港-1	第3車	2134	2138	臺北市士林區福港街91號對面	121.51843	25.08934
士林區	福中里	後港分隊	101-038	650-BS	後港-1	第3車	2139	2143	臺北市士林區福港街112號	121.51804	25.0885
士林區	福中里	後港分隊	101-038	650-BS	後港-1	第3車	2144	2153	臺北市士林區福港街164號	121.51774	25.08691
士林區	福中里	後港分隊	101-038	650-BS	後港-1	第3車	2154	2203	臺北市士林區福港街218號	121.51755	25.08554
萬華區	富福里	昆明分隊	101-041	053-BV	昆明-1	第1車	1710	1718	臺北市萬華區和平西路3段120號(行政中心)	121.49987	25.03503
萬華區	福音里	昆明分隊	101-041	053-BV	昆明-1	第1車	1720	1725	臺北市萬華區昆明街316號 	121.503367	25.0357342
萬華區	仁德里	昆明分隊	101-041	053-BV	昆明-1	第1車	1735	1738	臺北市萬華區桂林路41號	121.50441	25.03812
萬華區	富民里	昆明分隊	101-041	053-BV	昆明-1	第1車	1740	1743	臺北市萬華區桂林路101號	121.50119	25.03864
萬華區	青山里	昆明分隊	101-041	053-BV	昆明-1	第1車	1745	1749	臺北市萬華區桂林路137號前	121.49935	25.0387
萬華區	柳鄉里	昆明分隊	101-041	053-BV	昆明-1	第1車	1756	1758	臺北市萬華區環河南路2段48號前	121.49673	25.0383
萬華區	柳鄉里	昆明分隊	101-041	053-BV	昆明-1	第1車	1759	1803	臺北市萬華區環河南路2段52號前	121.49622	25.03781
萬華區	柳鄉里	昆明分隊	101-041	053-BV	昆明-1	第1車	1803	1810	臺北市萬華區環河南路2段102號前	121.49546	25.03693
萬華區	柳鄉里	昆明分隊	101-041	053-BV	昆明-1	第1車	1810	1816	臺北市萬華區環河南路2段132號前	121.49485	25.03619
萬華區	柳鄉里	昆明分隊	101-041	053-BV	昆明-1	第1車	1817	1823	臺北市萬華區和平西路3段261號之7	121.49442	25.03581
萬華區	柳鄉里	昆明分隊	101-041	053-BV	昆明-1	第1車	1824	1827	臺北市萬華區和平西路3段359號前	121.49191	25.03568
萬華區	柳鄉里	昆明分隊	101-041	053-BV	昆明-1	第1車	1828	1831	臺北市萬華區桂林路246巷42弄33號	121.492	25.03641
萬華區	柳鄉里	昆明分隊	101-041	053-BV	昆明-1	第1車	1831	1835	臺北市萬華區桂林路246巷42弄44號	121.49232	25.0361
萬華區	柳鄉里	昆明分隊	101-041	053-BV	昆明-1	第1車	1835	1839	臺北市萬華區桂林路246巷16號	121.49353	25.03728
萬華區	柳鄉里	昆明分隊	101-041	053-BV	昆明-1	第1車	1839	1841	臺北市萬華區桂林路244巷26號	121.49441	25.0377
萬華區	柳鄉里	昆明分隊	101-041	053-BV	昆明-1	第1車	1842	1846	臺北市萬華區桂林路242巷4號	121.49544	25.03821
萬華區	青山里	昆明分隊	101-041	053-BV	昆明-1	第2車	2030	2035	臺北市萬華區西園路1段134號前	121.49958	25.03779
萬華區	青山里	昆明分隊	101-041	053-BV	昆明-1	第2車	2035	2038	臺北市萬華區西園路1段158號前	121.4993	25.03712
萬華區	青山里	昆明分隊	101-041	053-BV	昆明-1	第2車	2038	2043	臺北市萬華區西園路1段192號	121.49916	25.03619
萬華區	青山里	昆明分隊	101-041	053-BV	昆明-1	第2車	2043	2045	臺北市萬華區西園路1段216號前	121.49924	25.03555
萬華區	仁德里	昆明分隊	101-041	053-BV	昆明-1	第2車	2050	2055	臺北市萬華區桂林路38號前	121.50473	25.0378
萬華區	仁德里	昆明分隊	101-041	053-BV	昆明-1	第2車	2056	2100	臺北市萬華區中華路1段212號前	121.5064	25.0374
萬華區	仁德里	昆明分隊	101-041	053-BV	昆明-1	第2車	2103	2108	臺北市萬華區廣州街79號前	121.50428	25.03664
萬華區	福音里	昆明分隊	101-041	053-BV	昆明-1	第2車	2109	2112	臺北市萬華區昆明街285號前	121.50371	25.03679
萬華區	福音里	昆明分隊	101-041	053-BV	昆明-1	第2車	2112	2116	臺北市萬華區廣州街90號對面	121.50257	25.03659
萬華區	福音里	昆明分隊	101-041	053-BV	昆明-1	第2車	2116	2119	臺北市萬華區廣州街116號對面	121.50187	25.0366
萬華區	富民里	昆明分隊	101-041	053-BV	昆明-1	第2車	2122	2127	臺北市萬華區廣州街207號前	121.50026	25.03674
萬華區	青山里	昆明分隊	101-041	053-BV	昆明-1	第2車	2132	2135	臺北市萬華區環河南路2段73號前	121.49653	25.0376
萬華區	青山里	昆明分隊	101-041	053-BV	昆明-1	第2車	2136	2144	臺北市萬華區桂林路164號前	121.49755	25.03844
萬華區	青山里	昆明分隊	101-041	053-BV	昆明-1	第2車	2144	2150	臺北市萬華區桂林路142號前	121.49832	25.03845
信義區	大仁里	福德分隊	101-044	057-BV	福德-1	第1車	1820	1840	臺北市信義區大道路108號	121.58033	25.04
信義區	大仁里	福德分隊	101-044	057-BV	福德-1	第1車	1842	1850	臺北市信義區福德街84巷與林口街24巷交叉口	121.58094	25.03805
信義區	大仁里	福德分隊	101-044	057-BV	福德-1	第1車	1852	1900	臺北市信義區大道路96巷口與福德街84巷交叉口	121.5806	25.039
信義區	國業里	福德分隊	101-044	057-BV	福德-1	第1車	1905	1920	臺北市信義區信義路6段103號前	121.57792	25.03627
信義區	松友里	福德分隊	101-044	057-BV	福德-1	第2車	2100	2130	臺北市信義區信義路6段74號前	121.57687	25.03515
信義區	西村里	三張犁分隊	101-045	058-BV	三張犁-2	第1車	1800	1840	臺北市信義區基隆路1段380巷5號旁(中興公園)	121.55969	25.03463
信義區	中興里	三張犁分隊	101-045	058-BV	三張犁-2	第1車	1845	1900	臺北市信義區基隆路2段72號前	121.55816	25.03093
信義區	興隆里	三張犁分隊	101-045	058-BV	三張犁-2	第2車	2100	2125	臺北市信義區忠孝東路4段556號	121.563	25.0416
信義區	新仁里	三張犁分隊	101-045	058-BV	三張犁-2	第2車	2130	2150	臺北市信義區忠孝東路4段553巷48號旁	121.56293	25.04437
信義區	新仁里	三張犁分隊	101-045	058-BV	三張犁-2	第2車	2155	2200	臺北市信義區忠孝東路4段563號	121.56405	25.04159
中正區	新營里	南昌分隊	101-046	059-BV	南昌-1	第1車	1720	1724	臺北市中正區杭州南路2段54之1號前	121.52205	25.03041
中正區	新營里	南昌分隊	101-046	059-BV	南昌-1	第1車	1725	1728	臺北市中正區杭州南路2段102號前	121.52172	25.02881
中正區	新營里	南昌分隊	101-046	059-BV	南昌-1	第1車	1734	1737	臺北市中正區金華街59號旁	121.5209	25.03158
中正區	新營里	南昌分隊	101-046	059-BV	南昌-1	第1車	1738	1741	臺北市中正區金華街19號前	121.51885	25.03252
中正區	新營里	南昌分隊	101-046	059-BV	南昌-1	第1車	1742	1745	臺北市中正區羅斯福路1段25號前	121.51849	25.03284
中正區	新營里	南昌分隊	101-046	059-BV	南昌-1	第1車	1746	1750	臺北市中正區羅斯福路1段7號旁	121.51794	25.03356
中正區	新營里	南昌分隊	101-046	059-BV	南昌-1	第1車	1751	1753	臺北市中正區愛國東路22號前	121.51784	25.03435
中正區	新營里	南昌分隊	101-046	059-BV	南昌-1	第1車	1754	1757	臺北市中正區愛國東路60號旁	121.51899	25.03387
中正區	新營里	南昌分隊	101-046	059-BV	南昌-1	第1車	1758	1800	臺北市中正區愛國東路76號前	121.51969	25.03352
中正區	新營里	南昌分隊	101-046	059-BV	南昌-1	第1車	1801	1803	臺北市中正區愛國東路106號前	121.52086	25.03292
中正區	龍福里	南昌分隊	101-046	059-BV	南昌-1	第1車	1813	1818	臺北市中正區羅斯福路1段20號	121.51887	25.03185
中正區	南福里	南昌分隊	101-046	059-BV	南昌-1	第1車	1819	1823	臺北市中正區羅斯福路1段40號前	121.51911	25.03128
中正區	南福里	南昌分隊	101-046	059-BV	南昌-1	第1車	1824	1828	臺北市中正區羅斯福路1段94號前	121.51992	25.03008
中正區	南福里	南昌分隊	101-046	059-BV	南昌-1	第1車	1829	1833	臺北市中正區羅斯福路2段10號前	121.52107	25.02861
中正區	南福里	南昌分隊	101-046	059-BV	南昌-1	第1車	1834	1838	臺北市中正區羅斯福路2段36號前	121.52153	25.02812
中正區	南福里	南昌分隊	101-046	059-BV	南昌-1	第1車	1839	1842	臺北市中正區羅斯福路2段70號前	121.52207	25.02729
中正區	頂東里	南昌分隊	101-046	059-BV	南昌-1	第2車	2010	2013	臺北市中正區羅斯福路2段140號前	121.52294	25.02581
中正區	頂東里	南昌分隊	101-046	059-BV	南昌-1	第2車	2014	2018	臺北市中正區羅斯福路3段16號前	121.52503	25.02324
中正區	頂東里	南昌分隊	101-046	059-BV	南昌-1	第2車	2019	2023	臺北市中正區羅斯福路3段26號前	121.52574	25.02254
中正區	頂東里	南昌分隊	101-046	059-BV	南昌-1	第2車	2024	2028	臺北市中正區羅斯福路3段82號前	121.52647	25.02199
中正區	頂東里	南昌分隊	101-046	059-BV	南昌-1	第2車	2029	2033	臺北市中正區羅斯福路3段98號前	121.52702	25.0216
中正區	螢雪里	南昌分隊	101-046	059-BV	南昌-1	第2車	2038	2042	臺北市中正區水源路153號	121.51591	25.02359
中正區	螢雪里	南昌分隊	101-046	059-BV	南昌-1	第2車	2043	2047	臺北市中正區水源路167之3號前	121.51482	25.02413
中正區	螢雪里	南昌分隊	101-046	059-BV	南昌-1	第2車	2048	2052	臺北市中正區泉州街153號前	121.51265	25.02453
中正區	螢雪里	南昌分隊	101-046	059-BV	南昌-1	第2車	2053	2057	臺北市中正區泉州街131之5號旁	121.51316	25.0252
中正區	頂東里	南昌分隊	101-046	059-BV	南昌-1	第2車	2107	2111	臺北市中正區師大路144號前	121.52679	25.02092
中正區	頂東里	南昌分隊	101-046	059-BV	南昌-1	第2車	2112	2116	臺北市中正區師大路170號前	121.52529	25.02103
中正區	頂東里	南昌分隊	101-046	059-BV	南昌-1	第2車	2117	2121	臺北市中正區汀州路2段311號前	121.52474	25.02175
中正區	頂東里	南昌分隊	101-046	059-BV	南昌-1	第2車	2122	2127	臺北市中正區汀州路2段265號前	121.52382	25.02264
中正區	頂東里	南昌分隊	101-046	059-BV	南昌-1	第2車	2128	2132	臺北市中正區汀州路2段243號前	121.52301	25.02318
中正區	頂東里	南昌分隊	101-046	059-BV	南昌-1	第2車	2133	2137	臺北市中正區汀州路2段193號旁	121.52216	25.02382
中正區	板溪里	南昌分隊	101-046	059-BV	南昌-1	第2車	2138	2142	臺北市中正區汀州路2段145號前	121.5206	25.02482
中正區	板溪里	南昌分隊	101-046	059-BV	南昌-1	第2車	2143	2147	臺北市中正區汀州路2段125號前	121.51943	25.02508
中正區	螢圃里	南昌分隊	101-046	059-BV	南昌-1	第2車	2148	2152	臺北市中正區汀州路2段97號前	121.51821	25.02536
中正區	螢雪里	南昌分隊	101-046	059-BV	南昌-1	第2車	2153	2157	臺北市中正區汀州路2段53號前	121.51563	25.02597
中正區	螢雪里	南昌分隊	101-046	059-BV	南昌-1	第2車	2158	2202	臺北市中正區汀州路2段11號前	121.51448	25.02623
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第1車	1730	1735	臺北市中正區汀州路1段239號前	121.51263	25.02665
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第1車	1736	1740	臺北市中正區汀州路1段207號前	121.5117	25.02676
中正區	龍興里	泉州分隊	101-047	060-BV	泉州-1	第1車	1741	1755	臺北市中正區汀州路1段230號對面	121.50999	25.02747
中正區	龍興里	泉州分隊	101-047	060-BV	泉州-1	第1車	1756	1759	臺北市中正區汀州路1段123號(永義宮)	121.5095	25.02819
中正區	忠勤里	泉州分隊	101-047	060-BV	泉州-1	第1車	1800	1803	臺北市中正區汀州路1段67號前	121.50805	25.02984
中正區	廈安里	泉州分隊	101-047	060-BV	泉州-1	第1車	1804	1811	臺北市中正區西藏路30號前	121.50696	25.03089
中正區	廈安里	泉州分隊	101-047	060-BV	泉州-1	第1車	1812	1814	臺北市中正區中華路2段177號前	121.5043	25.03037
中正區	廈安里	泉州分隊	101-047	060-BV	泉州-1	第1車	1815	1817	臺北市中正區中華路2段165號前	121.50426	25.03085
中正區	廈安里	泉州分隊	101-047	060-BV	泉州-1	第1車	1818	1821	臺北市中正區中華路2段151號前	121.50418	25.03133
中正區	廈安里	泉州分隊	101-047	060-BV	泉州-1	第1車	1822	1825	臺北市中正區中華路2段117號前	121.50488	25.03238
中正區	廈安里	泉州分隊	101-047	060-BV	泉州-1	第1車	1826	1829	臺北市中正區大埔街21巷9號旁	121.50492	25.03224
中正區	廈安里	泉州分隊	101-047	060-BV	泉州-1	第1車	1830	1832	臺北市中正區汀州路1段58號	121.50625	25.03178
中正區	廈安里	泉州分隊	101-047	060-BV	泉州-1	第1車	1833	1835	臺北市中正區莒光路76號前	121.50508	25.03142
中正區	廈安里	泉州分隊	101-047	060-BV	泉州-1	第1車	1836	1839	臺北市中正區莒光路91號前	121.50503	25.03112
中正區	廈安里	泉州分隊	101-047	060-BV	泉州-1	第1車	1840	1842	臺北市中正區莒光路7號前	121.50746	25.03105
中正區	廈安里	泉州分隊	101-047	060-BV	泉州-1	第1車	1843	1845	臺北市中正區和平西路2段106號前	121.508	25.03097
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第2車	2000	2003	臺北市中正區泉州街32號旁	121.51371	25.02611
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第2車	2004	2006	臺北市中正區泉州街、紹安街口	121.51304	25.02524
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第2車	2007	2010	臺北市中正區中華路2段481號前	121.51158	25.02448
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第2車	2011	2024	臺北市中正區寧波西街225號前(古亭國中旁)	121.51028	25.02544
中正區	永昌里	泉州分隊	101-047	060-BV	泉州-1	第2車	2025	2028	臺北市中正區寧波西街234號旁	121.51085	25.02669
中正區	龍興里	泉州分隊	101-047	060-BV	泉州-1	第2車	2030	2033	臺北市中正區三元街100號前	121.50973	25.02873
中正區	龍興里	泉州分隊	101-047	060-BV	泉州-1	第2車	2034	2036	臺北市中正區三元街158號前	121.51043	25.02832
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第2車	2037	2040	臺北市中正區三元街176號前	121.51142	25.02788
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第2車	2041	2047	臺北市中正區三元街232號前	121.51296	25.02746
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第2車	2048	2050	臺北市中正區三元街264號前	121.51383	25.02741
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第2車	2051	2053	臺北市中正區泉州街18-1號前	121.5142	25.02689
中正區	永昌里	泉州分隊	101-047	060-BV	泉州-1	第2車	2056	2059	臺北市中正區中華路2段439號前	121.50915	25.02499
中正區	永昌里	泉州分隊	101-047	060-BV	泉州-1	第2車	2100	2103	臺北市中正區中華路2段405號旁	121.50821	25.02606
中正區	永昌里	泉州分隊	101-047	060-BV	泉州-1	第2車	2104	2107	臺北市中正區中華路2段377號前	121.50763	25.02646
中正區	永昌里	泉州分隊	101-047	060-BV	泉州-1	第2車	2108	2111	臺北市中正區南海路112號前	121.50769	25.02743
中正區	永昌里	泉州分隊	101-047	060-BV	泉州-1	第2車	2112	2115	臺北市中正區南海路96號前	121.50829	25.02832
中正區	龍興里	泉州分隊	101-047	060-BV	泉州-1	第2車	2116	2119	臺北市中正區南海路70號前	121.50881	25.0292
中正區	龍興里	泉州分隊	101-047	060-BV	泉州-1	第2車	2120	2122	臺北市中正區三元街69號旁	121.50921	25.0295
中正區	龍興里	泉州分隊	101-047	060-BV	泉州-1	第2車	2124	2127	臺北市中正區和平西路2段96號前	121.51073	25.02961
中正區	龍興里	泉州分隊	101-047	060-BV	泉州-1	第2車	2128	2131	臺北市中正區和平西路2段68號前	121.51154	25.02912
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第2車	2132	2134	臺北市中正區和平西路2段50號前	121.51241	25.0285
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第2車	2135	2137	臺北市中正區和平西路2段34號前	121.51301	25.02829
中正區	永功里	泉州分隊	101-047	060-BV	泉州-1	第2車	2138	2140	臺北市中正區和平西路2段10號前	121.5139	25.02795
中正區	黎明里	博愛分隊	101-048	061-BV	博愛-1	第1車	1710	1715	臺北市中正區襄陽路19號	121.5155	25.04345
中正區	黎明里	博愛分隊	101-048	061-BV	博愛-1	第1車	1716	1720	臺北市中正區館前路42號	121.51497	25.04441
中正區	光復里	博愛分隊	101-048	061-BV	博愛-1	第1車	1722	1730	臺北市中正區重慶南路1段38號	121.51319	25.04482
中正區	光復里	博愛分隊	101-048	061-BV	博愛-1	第1車	1746	1751	臺北市中正區中華路1段41號	121.50934	25.04494
中正區	光復里	博愛分隊	101-048	061-BV	博愛-1	第1車	1752	1757	臺北市中正區中華路1段25號	121.5096	25.04624
中正區	光復里	博愛分隊	101-048	061-BV	博愛-1	第1車	1758	1803	臺北市中正區中華路1段1號	121.51068	25.04751
中正區	光復里	博愛分隊	101-048	061-BV	博愛-1	第1車	1804	1810	臺北市中正區延平南路16號	121.51098	25.04699
中正區	光復里	博愛分隊	101-048	061-BV	博愛-1	第1車	1811	1813	臺北市中正區延平南路36號	121.5108	25.04639
中正區	光復里	博愛分隊	101-048	061-BV	博愛-1	第1車	1814	1820	臺北市中正區延平南路42號	121.51065	25.04587
中正區	光復里	博愛分隊	101-048	061-BV	博愛-1	第1車	1821	1825	臺北市中正區漢口街1段107號	121.51061	25.0452
中正區	光復里	博愛分隊	101-048	061-BV	博愛-1	第1車	1828	1832	臺北市中正區重慶南路1段60號	121.51318	25.04383
中正區	光復里	博愛分隊	101-048	061-BV	博愛-1	第1車	1834	1839	臺北市中正區重慶南路1段96號	121.51316	25.04269
中正區	光復里	博愛分隊	101-048	061-BV	博愛-1	第2車	2032	2039	臺北市中正區重慶南路1段44號	121.51319	25.04459
中正區	黎明里	博愛分隊	101-048	061-BV	博愛-1	第2車	2041	2044	臺北市中正區館前路65號	121.51508	25.04426
中正區	黎明里	博愛分隊	101-048	061-BV	博愛-1	第2車	2050	2100	臺北市中正區公園路13號	121.51724	25.04558
中正區	黎明里	博愛分隊	101-048	061-BV	博愛-1	第2車	2102	2107	臺北市中正區中山北路1段30號	121.51997	25.04677
中正區	黎明里	博愛分隊	101-048	061-BV	博愛-1	第2車	2110	2112	臺北市中正區青島西路7號	121.51816	25.04481
中正區	黎明里	博愛分隊	101-048	061-BV	博愛-1	第2車	2113	2119	臺北市中正區公園路30號(信陽街口)	121.51689	25.04437
中正區	建國里	博愛分隊	101-048	061-BV	博愛-1	第2車	2122	2126	臺北市中正區衡陽路118號	121.50979	25.04215
中正區	建國里	博愛分隊	101-048	061-BV	博愛-1	第2車	2127	2131	臺北市中正區延平南路117號對面(憲兵隊之延平南路後門處)	121.50909	25.04049
中正區	建國里	博愛分隊	101-048	061-BV	博愛-1	第2車	2132	2137	臺北市中正區延平南路156號	121.50846	25.03831
大安區	芳和里	臥龍分隊	101-049	062-BV	臥龍-1	第1車	1810	1825	臺北市大安區臥龍街131巷13弄1號	121.55185	25.01969
大安區	芳和里	臥龍分隊	101-049	062-BV	臥龍-1	第1車	1833	1840	臺北市大安區樂業街70號	121.55067	25.02194
大安區	芳和里	臥龍分隊	101-049	062-BV	臥龍-1	第1車	1842	1855	臺北市大安區樂業街118巷1號	121.55209	25.02082
大安區	黎孝里	臥龍分隊	101-049	062-BV	臥龍-1	第1車	1857	1907	臺北市大安區和平東路3段228巷37號	121.55354	25.0209
大安區	群英里	臥龍分隊	101-049	062-BV	臥龍-1	第2車	2020	2030	臺北市大安區復興南路2段151巷30弄1號	121.54533	25.02822
大安區	黎孝里	臥龍分隊	101-049	062-BV	臥龍-1	第2車	2040	2100	臺北市大安區和平東路3段308巷15弄12號	121.5562	25.01951
大安區	黎元里	臥龍分隊	101-049	062-BV	臥龍-1	第2車	2104	2108	臺北市大安區臥龍街211號	121.55367	25.01832
大安區	黎元里	臥龍分隊	101-049	062-BV	臥龍-1	第2車	2109	2113	臺北市大安區臥龍街199號	121.55278	25.01796
大安區	芳和里	臥龍分隊	101-049	062-BV	臥龍-1	第2車	2114	2119	臺北市大安區臥龍街131巷1號(新增)	121.55045	25.01873
大安區	芳和里	臥龍分隊	101-049	062-BV	臥龍-1	第2車	2122	2130	臺北市大安區基隆路2段289號	121.54948	25.02154
大安區	芳和里	臥龍分隊	101-049	062-BV	臥龍-1	第2車	2132	2140	臺北市大安區基隆路2段211號	121.55142	25.02329
大安區	黎孝里	臥龍分隊	101-049	062-BV	臥龍-1	第2車	2145	2150	臺北市大安區富陽街172號(慈仁八村)	121.55707	25.01706
大安區	黎和里	臥龍分隊	101-049	062-BV	臥龍-1	第2車	2155	2215	臺北市大安區臥龍街271號前	121.5569	25.0185
大安區	昌隆里	新生分隊	101-050	063-BV	新生-1	第1車	1740	1805	臺北市大安區忠孝東路3段215號(臺北富邦銀行)前	121.5396146	25.0418644
大安區	民炤里	新生分隊	101-050	063-BV	新生-1	第1車	1825	1835	臺北市大安區新生南路1段163號前	121.53297	25.03428
大安區	民炤里	新生分隊	101-050	063-BV	新生-1	第1車	1836	1840	臺北市大安區新生南路1段155號前	121.53293	25.0351
大安區	民炤里	新生分隊	101-050	063-BV	新生-1	第1車	1841	1855	臺北市大安區新生南路1段143號前	121.533	25.03607
大安區	民炤里	新生分隊	101-050	063-BV	新生-1	第1車	1856	1905	臺北市大安區新生南路1段141號前	121.53291	25.03665
大安區	民輝里	新生分隊	101-050	063-BV	新生-1	第2車	2025	2030	臺北市大安區忠孝東路3段86號前	121.5359	25.04162
大安區	誠安里	新生分隊	101-050	063-BV	新生-1	第2車	2040	2100	臺北市大安區安東街40號前	121.54222	25.04398
大安區	誠安里	新生分隊	101-050	063-BV	新生-1	第2車	2103	2105	臺北市大安區復興南路1段132號前	121.54357	25.04289
大安區	誠安里	新生分隊	101-050	063-BV	新生-1	第2車	2108	2115	臺北市大安區忠孝東路3段287號	121.54288	25.04185
大安區	誠安里	新生分隊	101-050	063-BV	新生-1	第2車	2116	2124	臺北市大安區忠孝東路3段249號前	121.54143	25.04179
大安區	誠安里	新生分隊	101-050	063-BV	新生-1	第2車	2125	2130	臺北市大安區忠孝東路3段235號前	121.54059	25.04189
大安區	民輝里	新生分隊	101-050	063-BV	新生-1	第2車	2136	2143	臺北市大安區八德路2段1號前	121.53321	25.04494
大安區	民輝里	新生分隊	101-050	063-BV	新生-1	第2車	2144	2155	臺北市大安區八德路2段28號前	121.53454	25.04478
中山區	集英里	圓山分隊	101-054	068-BV	圓山-1	第1車	1630	1640	臺北市中山區中山北路3段34號前	121.522	25.06533
中山區	集英里	圓山分隊	101-054	068-BV	圓山-1	第1車	1641	1650	臺北市中山區中山北路3段2號前	121.52245	25.06512
中山區	集英里	圓山分隊	101-054	068-BV	圓山-1	第1車	1651	1705	臺北市中山區中山北路2段132號前	121.52257	25.06202
中山區	集英里	圓山分隊	101-054	068-BV	圓山-1	第1車	1706	1715	臺北市中山區中山北路2段96號前	121.52266	25.05948
中山區	圓山里	圓山分隊	101-054	068-BV	圓山-1	第2車	1850	1900	臺北市中山區新生北路3段88巷1號前	121.52742	25.06798
中山區	圓山里	圓山分隊	101-054	068-BV	圓山-1	第2車	1903	1910	臺北市中山區德惠街13號前	121.52587	25.06673
中山區	恆安里	圓山分隊	101-054	068-BV	圓山-1	第2車	1920	1930	臺北市中山區中山北路3段1號前	121.5225	25.06397
中山區	圓山里	圓山分隊	101-054	068-BV	圓山-1	第2車	1935	1945	臺北市中山區民族東路28號前	121.52449	25.06837
中山區	圓山里	圓山分隊	101-054	068-BV	圓山-1	第3車	2110	2125	臺北市中山區林森北路628號前	121.52567	25.06743
中山區	圓山里	圓山分隊	101-054	068-BV	圓山-1	第3車	2126	2135	臺北市中山區雙城街38號前	121.52429	25.06703
中山區	圓山里	圓山分隊	101-054	068-BV	圓山-1	第3車	2136	2145	臺北市中山區德惠街5號前	121.52313	25.06682
中山區	恆安里	圓山分隊	101-054	068-BV	圓山-1	第3車	2150	2200	臺北市中山區農安街12號前	121.52414	25.06492
中山區	集英里	圓山分隊	101-055	069-BV	圓山-2	第1車	1630	1635	臺北市中山區民權西路11號前	121.52184	25.063
中山區	集英里	圓山分隊	101-055	069-BV	圓山-2	第1車	1637	1648	臺北市中山區撫順街30號前	121.51948	25.06332
中山區	集英里	圓山分隊	101-055	069-BV	圓山-2	第1車	1650	1700	臺北市中山區撫順街21號對面	121.52072	25.0636
中山區	集英里	圓山分隊	101-055	069-BV	圓山-2	第1車	1705	1715	臺北市中山區天祥路58號前	121.521	25.0621
中山區	集英里	圓山分隊	101-055	069-BV	圓山-2	第2車	1900	1910	臺北市中山區民生西路7號前	121.52166	25.05796
中山區	集英里	圓山分隊	101-055	069-BV	圓山-2	第2車	1911	1916	臺北市中山區民生西路45巷39號前(巷口)	121.52086	25.05953
中山區	集英里	圓山分隊	101-055	069-BV	圓山-2	第2車	1920	1930	臺北市中山區錦西街34號前	121.52078	25.06034
中山區	集英里	圓山分隊	101-055	069-BV	圓山-2	第2車	1935	1945	臺北市中山區錦西街7號前	121.52174	25.06038
中山區	集英里	圓山分隊	101-055	069-BV	圓山-2	第3車	2110	2120	臺北市中山區天祥路18號前	121.52101	25.06113
中山區	晴光里	圓山分隊	101-055	069-BV	圓山-2	第3車	2130	2140	臺北市中山區林森北路577號(台灣銀行前)	121.52582	25.06519
中山區	晴光里	圓山分隊	101-055	069-BV	圓山-2	第3車	2141	2150	臺北市中山區林森北路609號前	121.52576	25.06628
中山區	晴光里	圓山分隊	101-055	069-BV	圓山-2	第3車	2151	2200	臺北市中山區德惠街56號前	121.52724	25.06668
北投區	吉利里	石牌分隊	101-056	101-BV	石牌-1	第1車	1720	1830	臺北市北投區石牌公園	121.50952	25.11727
北投區	八仙里	石牌分隊	101-056	101-BV	石牌-1	第2車	1930	1935	臺北市北投區西安街2段359號前	121.50432	25.12088
北投區	立農里	石牌分隊	101-056	101-BV	石牌-1	第2車	1935	1937	臺北市北投區立農街1段279巷口	121.50628	25.12061
北投區	立農里	石牌分隊	101-056	101-BV	石牌-1	第2車	1937	1939	臺北市北投區西安街2段257號前	121.50755	25.12032
北投區	立農里	石牌分隊	101-056	101-BV	石牌-1	第2車	1941	1944	臺北市北投區西安街2段229號前	121.50883	25.12007
北投區	立農里	石牌分隊	101-056	101-BV	石牌-1	第2車	1944	1948	臺北市北投區西安街2段吉利街口	121.50993	25.11994
北投區	立農里	石牌分隊	101-056	101-BV	石牌-1	第2車	1948	1952	臺北市北投區西安街2段立農街口	121.51139	25.1194
北投區	立農里	石牌分隊	101-056	101-BV	石牌-1	第2車	1952	1954	臺北市北投區西安街2段133號前	121.51224	25.11873
北投區	吉利里	石牌分隊	101-056	101-BV	石牌-1	第2車	1955	2005	臺北市北投區西安街2段致遠二路口	121.51321	25.11759
北投區	榮光里	石牌分隊	101-056	101-BV	石牌-1	第2車	2005	2007	臺北市北投區西安街1段355號前	121.51548	25.11403
北投區	榮光里	石牌分隊	101-056	101-BV	石牌-1	第2車	2007	2009	臺北市北投區西安街1段343號前	121.51585	25.11361
北投區	榮光里	石牌分隊	101-056	101-BV	石牌-1	第2車	2009	2011	臺北市北投區西安街1段311號前	121.51631	25.1129
北投區	榮光里	石牌分隊	101-056	101-BV	石牌-1	第2車	2013	2015	臺北市北投區西安街1段291號	121.5167	25.11231
北投區	吉慶里	石牌分隊	101-056	101-BV	石牌-1	第3車	2100	2105	臺北市北投區石牌路1段71巷口	121.51124	25.11361
北投區	吉慶里	石牌分隊	101-056	101-BV	石牌-1	第3車	2106	2110	臺北市北投區石牌路1段39巷口	121.51025	25.11309
北投區	吉慶里	石牌分隊	101-056	101-BV	石牌-1	第3車	2115	2118	臺北市北投區承德路7段168號巷口	121.50811	25.11375
北投區	吉慶里	石牌分隊	101-056	101-BV	石牌-1	第3車	2119	2130	臺北市北投區承德路7段188號巷口	121.50779	25.11401
北投區	福興里	石牌分隊	101-056	101-BV	石牌-1	第3車	2138	2143	臺北市北投區石牌路1段自強街5巷口	121.51032	25.11306
北投區	福興里	石牌分隊	101-056	101-BV	石牌-1	第3車	2144	2148	臺北市北投區石牌路1段58巷口	121.51094	25.11337
北投區	振華里	石牌分隊	101-056	101-BV	石牌-1	第3車	2152	2156	臺北市北投區裕民四路4號	121.51587	25.11546
北投區	振華里	石牌分隊	101-056	101-BV	石牌-1	第3車	2157	2207	臺北市北投區裕民二路、裕民三路口	121.51699	25.11593
信義區	景新里	吳興分隊	101-605	016-BV	吳興-1	第1車	1800	1830	臺北市信義區莊敬路239巷10號對面(信義國小後門)	121.563428	25.0304577
信義區	六合里	吳興分隊	101-605	016-BV	吳興-1	第2車	2000	2003	臺北市信義區信義路5段150巷477號	121.57779	25.02185
信義區	六合里	吳興分隊	101-605	016-BV	吳興-1	第2車	2005	2007	臺北市信義區信義路5段150巷471號	121.579	25.0203
信義區	六合里	吳興分隊	101-605	016-BV	吳興-1	第2車	2008	2010	臺北市信義區景雲街24之1號	121.57542	25.01888
信義區	六合里	吳興分隊	101-605	016-BV	吳興-1	第2車	2011	2016	臺北市信義區祥雲街35號	121.57513	25.01861
信義區	六合里	吳興分隊	101-605	016-BV	吳興-1	第2車	2017	2022	臺北市信義區紫雲街49號	121.57489	25.01679
信義區	六合里	吳興分隊	101-605	016-BV	吳興-1	第2車	2023	2028	臺北市信義區紫雲街51號	121.57482	25.01671
信義區	六合里	吳興分隊	101-605	016-BV	吳興-1	第2車	2029	2032	臺北市信義區紫雲街70號~75號打鈴	121.57504	25.01787
信義區	六合里	吳興分隊	101-605	016-BV	吳興-1	第2車	2033	2038	臺北市信義區瑞雲街40號	121.57668	25.01626
信義區	六合里	吳興分隊	101-605	016-BV	吳興-1	第2車	2039	2041	臺北市信義區景雲街46號	121.57545	25.01751
信義區	六合里	吳興分隊	101-605	016-BV	吳興-1	第2車	2042	2045	臺北市信義區景雲街15號	121.57542	25.0187
信義區	六合里	吳興分隊	101-605	016-BV	吳興-1	第2車	2046	2050	臺北市信義區景雲街22號	121.57542	25.01888
信義區	三犁里	吳興分隊	101-605	016-BV	吳興-1	第2車	2107	2112	臺北市信義區松智路31巷口	121.56534	25.031
信義區	景新里	吳興分隊	101-605	016-BV	吳興-1	第2車	2115	2119	臺北市信義區松勤街47號(松勤路信義國小正對面)	121.56332	25.03218
信義區	景新里	吳興分隊	101-605	016-BV	吳興-1	第2車	2120	2128	臺北市信義區松勤街50號前(莊敬路松勤路口)	121.56179	25.03197
信義區	新仁里	三張犁分隊	101-S416	013-BV	三張犁-5	第1車	1955	2000	臺北市信義區忠孝東路5段236巷15號（松山工農大門前）	121.57204	25.03972
信義區	新仁里	三張犁分隊	101-S416	013-BV	三張犁-5	第1車	2032	2035	臺北市信義區市民大道24號前	121.56065	25.04601
信義區	新仁里	三張犁分隊	101-S416	013-BV	三張犁-5	第1車	2050	2100	臺北市信義區逸仙路26巷1號前	121.56254	25.03948
信義區	興隆里	三張犁分隊	101-S416	013-BV	三張犁-5	第1車	2102	2105	臺北市信義區逸仙路與忠孝東路4段500號	121.56177	25.041
信義區	興雅里	三張犁分隊	101-S416	013-BV	三張犁-5	第1車	2110	2130	臺北市信義區忠孝東路5段63號(勤工國宅)前	121.56657	25.04148
士林區	福德里	文林分隊	102-057	229-BV	文林-2	第1車	1830	1837	臺北市士林區基河路福德路口	121.5212	25.09185
士林區	福佳里	文林分隊	102-057	229-BV	文林-2	第1車	1842	1848	臺北市士林區文林路490號前	121.52437	25.09641
士林區	福佳里	文林分隊	102-057	229-BV	文林-2	第1車	1850	1900	臺北市士林區文林路587巷1號前	121.52308	25.09818
士林區	福佳里	文林分隊	102-057	229-BV	文林-2	第1車	1901	1910	臺北市士林區美崙街62巷17號旁	121.52213	25.09797
士林區	福佳里	文林分隊	102-057	229-BV	文林-2	第1車	1912	1917	臺北市士林區文林路587巷29號前	121.5216	25.09797
士林區	福佳里	文林分隊	102-057	229-BV	文林-2	第1車	1918	1925	臺北市士林區文昌路179巷9號對面	121.51942	25.09851
士林區	福佳里	文林分隊	102-057	229-BV	文林-2	第1車	1926	1931	臺北市士林區文昌路155巷11號旁	121.51981	25.09742
士林區	福佳里	文林分隊	102-057	229-BV	文林-2	第1車	1935	1940	臺北市士林區文昌路77號前	121.52139	25.09552
士林區	福佳里	文林分隊	102-057	229-BV	文林-2	第1車	1941	1946	臺北市士林區中正路408號前	121.5207	25.09393
士林區	福德里	文林分隊	102-057	229-BV	文林-2	第1車	1948	1950	臺北市士林區基河路238號前	121.52152	25.09132
士林區	福德里	文林分隊	102-057	229-BV	文林-2	第1車	1951	1955	臺北市士林區基河路236號前	121.52179	25.09099
士林區	福佳里	文林分隊	102-057	229-BV	文林-2	第2車	2100	2110	臺北市士林區文林路531號前	121.52398	25.09724
士林區	福佳里	文林分隊	102-057	229-BV	文林-2	第2車	2111	2116	臺北市士林區文林路485號前	121.52426	25.09622
士林區	福佳里	文林分隊	102-057	229-BV	文林-2	第2車	2117	2122	臺北市士林區文林路453號	121.5244	25.09569
士林區	福德里	文林分隊	102-057	229-BV	文林-2	第2車	2125	2140	臺北市士林區大東路152號對面	121.52534	25.0923
士林區	仁勇里	文林分隊	102-057	229-BV	文林-2	第2車	2141	2146	臺北市士林區大東路117號前	121.52554	25.09146
士林區	仁勇里	文林分隊	102-057	229-BV	文林-2	第2車	2147	2152	臺北市士林區大東路93號前	121.52566	25.09108
士林區	仁勇里	文林分隊	102-057	229-BV	文林-2	第2車	2153	2203	臺北市士林區大東路75號前	121.52557	25.09053
士林區	仁勇里	文林分隊	102-057	229-BV	文林-2	第2車	2204	2207	臺北市士林區文林路251號對面	121.52682	25.09083
士林區	義信里	文林分隊	102-057	229-BV	文林-2	第3車	11	13	臺北市士林區文林路16號對面	121.52549	25.08664
士林區	仁勇里	文林分隊	102-057	229-BV	文林-2	第3車	14	16	臺北市士林區基河路13號	121.52458	25.08679
士林區	義信里	文林分隊	102-057	229-BV	文林-2	第3車	17	20	臺北市士林區基河路100號對面	121.52395	25.08798
士林區	仁勇里	文林分隊	102-057	229-BV	文林-2	第3車	2350	10	臺北市士林區文林路113號前	121.52625	25.0883
士林區	明勝里	後港分隊	102-058	230-BV	後港-2	第1車	1630	1700	臺北市士林區承德路4段9巷口	121.5219	25.07937
士林區	承德里	後港分隊	102-058	230-BV	後港-2	第1車	1701	1709	臺北市士林區承德路4段35號	121.52284	25.08092
士林區	承德里	後港分隊	102-058	230-BV	後港-2	第1車	1710	1719	臺北市士林區承德路4段80巷口	121.52295	25.0822
士林區	承德里	後港分隊	102-058	230-BV	後港-2	第1車	1720	1725	臺北市士林區承德路4段56號	121.52267	25.08147
士林區	福華里	後港分隊	102-058	230-BV	後港-2	第1車	1726	1734	臺北市士林區承德路4段42號	121.52227	25.08094
士林區	福華里	後港分隊	102-058	230-BV	後港-2	第1車	1735	1745	臺北市士林區承德路4段40巷73號	121.52114	25.08147
士林區	福華里	後港分隊	102-058	230-BV	後港-2	第2車	1850	1910	臺北市士林區華齡街口(靠近2巷口公園邊)	121.51959	25.08217
士林區	百齡里	後港分隊	102-058	230-BV	後港-2	第2車	1911	1925	臺北市士林區華齡街38號	121.51949	25.08365
士林區	明勝里	後港分隊	102-058	230-BV	後港-2	第3車	2030	2035	臺北市士林區承德路4段3巷，通河街2巷30號	121.52275	25.07835
士林區	明勝里	後港分隊	102-058	230-BV	後港-2	第3車	2038	2041	臺北市士林區承德路4段58巷10弄口	121.52207	25.08176
士林區	承德里	後港分隊	102-058	230-BV	後港-2	第3車	2042	2051	臺北市士林區承德路4段58巷31弄口	121.52127	25.0816
士林區	明勝里	後港分隊	102-058	230-BV	後港-2	第3車	2053	2058	臺北市士林區承德路4段28號	121.52198	25.08041
士林區	明勝里	後港分隊	102-058	230-BV	後港-2	第3車	2101	2106	臺北市士林區通河街78號	121.52046	25.08091
士林區	明勝里	後港分隊	102-058	230-BV	後港-2	第3車	2107	2113	臺北市士林區承德路4段10巷46號	121.51999	25.08009
士林區	明勝里	後港分隊	102-058	230-BV	後港-2	第3車	2116	2120	臺北市士林區承德路4段10巷2號	121.52148	25.07947
士林區	承德里	後港分隊	102-058	230-BV	後港-2	第3車	2122	2134	臺北市士林區承德路4段6巷2號	121.51906	25.07906
士林區	明勝里	後港分隊	102-058	230-BV	後港-2	第3車	2136	2141	臺北市士林區通河街19號	121.52335	25.08006
士林區	明勝里	後港分隊	102-058	230-BV	後港-2	第3車	2142	2155	臺北市士林區承德路4段35號	121.52284	25.08092
士林區	明勝里	後港分隊	102-058	230-BV	後港-2	第3車	2156	2206	臺北市士林區後港街與劍潭路口（原後港街38巷口）	121.52282	25.08379
士林區	社子里	社子分隊	102-059	231-BV	社子-1	第1車	1630	1640	臺北市士林區延平北路6段81號	121.50874	25.08826
士林區	永倫里	社子分隊	102-059	231-BV	社子-1	第1車	1643	1653	臺北市士林區延平北路6段378號	121.50082	25.09108
士林區	永倫里	社子分隊	102-059	231-BV	社子-1	第1車	1654	1659	臺北市士林區延平北路6段466號	121.49886	25.09307
士林區	永倫里	社子分隊	102-059	231-BV	社子-1	第1車	1701	1706	臺北市士林區通河西街2段228號	121.501	25.09372
士林區	永倫里	社子分隊	102-059	231-BV	社子-1	第1車	1707	1717	臺北市士林區通河西街2段221號	121.50184	25.09366
士林區	永倫里	社子分隊	102-059	231-BV	社子-1	第1車	1718	1724	臺北市士林區通河西街2段198號	121.50352	25.09343
士林區	永倫里	社子分隊	102-059	231-BV	社子-1	第1車	1725	1731	臺北市士林區通河西街2段181號	121.50474	25.09324
士林區	社園里	社子分隊	102-059	231-BV	社子-1	第1車	1732	1738	臺北市士林區通河西街2段138號	121.50596	25.09311
士林區	社園里	社子分隊	102-059	231-BV	社子-1	第1車	1739	1745	臺北市士林區通河西街2段122號	121.50677	25.09293
士林區	社園里	社子分隊	102-059	231-BV	社子-1	第1車	1746	1752	臺北市士林區通河西街2段107號	121.50804	25.09271
士林區	社子里	社子分隊	102-059	231-BV	社子-1	第1車	1753	1758	臺北市士林區通河西街2段93號	121.50888	25.09248
士林區	社子里	社子分隊	102-059	231-BV	社子-1	第1車	1759	1802	臺北市士林區通河西街2段60號	121.51042	25.0914
士林區	社子里	社子分隊	102-059	231-BV	社子-1	第1車	1803	1806	臺北市士林區通河西街2段54號	121.51082	25.09094
士林區	社子里	社子分隊	102-059	231-BV	社子-1	第1車	1813	1818	臺北市士林區延平北路6段122號	121.50787	25.08913
士林區	社園里	社子分隊	102-059	231-BV	社子-1	第1車	1819	1824	臺北市士林區延平北路6段180號	121.50596	25.08958
士林區	永倫里	社子分隊	102-059	231-BV	社子-1	第1車	1825	1830	臺北市士林區延平北路6段208號	121.50502	25.0895
士林區	社新里	社子分隊	102-059	231-BV	社子-1	第2車	2030	2045	臺北市士林區社子街27號	121.50799	25.08767
士林區	社新里	社子分隊	102-059	231-BV	社子-1	第2車	2046	2110	臺北市士林區社子街65號	121.50676	25.08751
士林區	社新里	社子分隊	102-059	231-BV	社子-1	第2車	2111	2123	臺北市士林區社子街99號	121.50559	25.08778
士林區	社新里	社子分隊	102-059	231-BV	社子-1	第2車	2124	2136	臺北市士林區社子街127號	121.50508	25.08868
士林區	社新里	社子分隊	102-059	231-BV	社子-1	第2車	2137	2148	臺北市士林區延平北路6段152號對面	121.50684	25.08967
士林區	社新里	社子分隊	102-059	231-BV	社子-1	第2車	2149	2154	臺北市士林區延平北路6段111號	121.50833	25.08851
士林區	社新里	社子分隊	102-059	231-BV	社子-1	第2車	2155	2200	臺北市士林區中正路618號前	121.50877	25.08686
士林區	蘭雅里	蘭雅分隊	102-060	232-BV	蘭雅-2	第1車	1620	1640	臺北市士林區德行東路109巷77號對面	121.52854	25.10959
士林區	聖山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第1車	1645	1650	臺北市士林區忠義街147號前	121.53274	25.10857
士林區	聖山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第1車	1651	1655	臺北市士林區忠義街98號對面送車	121.53246	25.10694
士林區	德行里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1830	1833	臺北市士林區中山北路5段841號	121.52553	25.10226
士林區	名山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1836	1840	臺北市士林區至誠路2段49號前	121.52813	25.10148
士林區	名山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1841	1844	臺北市士林區至誠路2段35號旁	121.52902	25.10181
士林區	名山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1845	1850	臺北市士林區至誠路2段1號	121.53079	25.10181
士林區	名山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1851	1854	臺北市士林區至誠路2段20號	121.52978	25.10223
士林區	名山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1855	1900	臺北市士林區至誠路2段82號前	121.52777	25.10143
士林區	蘭雅里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1913	1916	臺北市士林區德行東路127號前	121.52902	25.10795
士林區	蘭雅里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1917	1920	臺北市士林區德行東路111號	121.5285	25.10779
士林區	蘭雅里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1921	1923	臺北市士林區德行東路5號前	121.5251	25.1066
士林區	蘭雅里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1928	1934	臺北市士林區中山北路6段188號前	121.52517	25.10775
士林區	蘭雅里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1935	1940	臺北市士林區中山北路6段238號前	121.52536	25.10902
士林區	蘭雅里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1941	1944	臺北市士林區中山北路6段314號前	121.52569	25.11098
士林區	蘭興里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1947	1954	臺北市士林區中山北路6段275號旁	121.52538	25.11005
士林區	蘭興里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	1955	2000	臺北市士林區中山北路6段193號前	121.52503	25.10786
士林區	蘭興里	蘭雅分隊	102-060	232-BV	蘭雅-2	第2車	2001	2005	臺北市士林區中山北路6段155號送車	121.52488	25.10684
士林區	名山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第3車	2115	2118	臺北市士林區至誠路2段20號	121.52987	25.10232
士林區	聖山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第3車	2123	2133	臺北市士林區忠義街147號	121.53277	25.10858
士林區	岩山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第3車	2135	2140	臺北市士林區芝玉路1段197巷1號旁	121.53335	25.10766
士林區	岩山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第3車	2141	2143	臺北市士林區芝玉路1段124巷口	121.53492	25.10612
士林區	岩山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第3車	2144	2146	臺北市士林區芝玉路1段62巷口	120.98811	24.77829
士林區	岩山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第3車	2147	2149	臺北市士林區芝玉路1段53巷口	120.98811	24.77829
士林區	岩山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第3車	2150	2152	臺北市士林區芝玉路1段24巷口	120.98811	24.77829
士林區	岩山里	蘭雅分隊	102-060	232-BV	蘭雅-2	第3車	2153	2155	臺北市士林區芝玉路1段6號	121.53519	25.10146
士林區	蘭興里	蘭雅分隊	102-061	233-BV	蘭雅-3	第1車	1640	1650	臺北市士林區德行西路77號右對面	121.5222	25.10483
士林區	德華里	蘭雅分隊	102-061	233-BV	蘭雅-3	第1車	1652	1657	臺北市士林區福華路159號前	121.52209	25.10379
士林區	德華里	蘭雅分隊	102-061	233-BV	蘭雅-3	第1車	1658	1703	臺北市士林區福國路108號	121.52164	25.10194
士林區	德華里	蘭雅分隊	102-061	233-BV	蘭雅-3	第1車	1704	1709	臺北市士林區文林路738號送車	121.52031	25.10277
士林區	蘭興里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	1840	1850	臺北市士林區磺溪街57號	121.52315	25.10755
士林區	蘭興里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	1851	1853	臺北市士林區磺溪街88號	121.52336	25.10883
士林區	蘭興里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	1855	1907	臺北市士林區克強路8號前	121.52449	25.10883
士林區	德行里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	1909	1914	臺北市士林區中山北路6段37號前	121.52468	25.10336
士林區	蘭興里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	1921	1926	臺北市士林區德行西路109號前	121.5209	25.10406
士林區	蘭興里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	1927	1932	臺北市士林區德行西路135號前	121.52004	25.10355
士林區	德華里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	1933	1938	臺北市士林區文林路755號	121.51955	25.10321
士林區	德華里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	1939	1944	臺北市士林區文林路731號	121.51962	25.10312
士林區	德華里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	1945	1950	臺北市士林區文林路683號	121.52207	25.10114
士林區	德華里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	1951	1956	臺北市士林區文林路663號	121.52251	25.10077
士林區	德華里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	1957	1959	臺北市士林區文林路619號	121.52333	25.09973
士林區	德華里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	2000	2002	臺北市士林區文昌路211號	121.52033	25.09978
士林區	德行里	蘭雅分隊	102-061	233-BV	蘭雅-3	第2車	2008	2013	臺北市士林區福國路45號送車	121.52372	25.10189
士林區	名山里	蘭雅分隊	102-061	233-BV	蘭雅-3	第3車	2040	2110	臺北市士林區陽明醫院對面	121.53241	25.10437
士林區	德行里	蘭雅分隊	102-061	233-BV	蘭雅-3	第3車	2120	2125	臺北市士林區福國路15巷31號	121.52462	25.10089
士林區	德行里	蘭雅分隊	102-061	233-BV	蘭雅-3	第3車	2127	2132	臺北市士林區福國路48號	121.52382	25.1021
士林區	德行里	蘭雅分隊	102-061	233-BV	蘭雅-3	第3車	2133	2138	臺北市士林區福華路130號	121.52277	25.10298
士林區	德行里	蘭雅分隊	102-061	233-BV	蘭雅-3	第3車	2139	2144	臺北市士林區福華路160號	121.52262	25.10391
士林區	德行里	蘭雅分隊	102-061	233-BV	蘭雅-3	第3車	2145	2150	臺北市士林區福華路164-1號	121.52254	25.10431
士林區	岩山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第1車	1600	1605	臺北市士林區仰德大道1段12巷1號旁	121.53773	25.10092
士林區	岩山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第1車	1607	1614	臺北市士林區至誠路1段16號	121.53692	25.10119
士林區	岩山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第1車	1616	1623	臺北市士林區至誠路1段62巷70號對面	121.53553	25.10242
士林區	岩山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第1車	1624	1629	臺北市士林區至誠路1段150號旁	121.53403	25.10132
士林區	名山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第1車	1631	1639	臺北市士林區雨聲街81號	121.52895	25.10408
士林區	名山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第1車	1640	1645	臺北市士林區雨聲街61號	121.52862	25.10297
士林區	名山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第1車	1650	1654	臺北市士林區忠誠路1段21號對面(靠公園側)	121.52665	25.10409
士林區	名山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第1車	1655	1700	臺北市士林區中山北路5段848號對面(靠公園側)	121.52636	25.10193
士林區	忠誠里	蘭雅分隊	102-062	235-BV	蘭雅-4	第2車	1830	1832	臺北市士林區忠誠路1段16巷1號	121.5255	25.1042
士林區	忠誠里	蘭雅分隊	102-062	235-BV	蘭雅-4	第2車	1835	1840	臺北市士林區中山北路6段90號前	121.5249	25.10506
士林區	忠誠里	蘭雅分隊	102-062	235-BV	蘭雅-4	第2車	1841	1850	臺北市士林區德行東路6號（陽信大樓）	121.52528	25.1066
士林區	忠誠里	蘭雅分隊	102-062	235-BV	蘭雅-4	第2車	1851	1854	臺北市士林區德行東路46巷口（石油新村）	121.5262	25.10692
士林區	忠誠里	蘭雅分隊	102-062	235-BV	蘭雅-4	第2車	1855	1904	臺北市士林區德行東路74巷口	121.52738	25.10735
士林區	忠誠里	蘭雅分隊	102-062	235-BV	蘭雅-4	第2車	1905	1910	臺北市士林區德行東路100號前	121.5281	25.10759
士林區	聖山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第2車	1911	1918	臺北市士林區德行東路200號	121.53157	25.10883
士林區	芝山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第2車	1919	1925	臺北市士林區德行東路252號	121.53422	25.10972
士林區	芝山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第2車	1926	1934	臺北市士林區德行東路286號前	121.53594	25.11003
士林區	芝山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第2車	1935	1941	臺北市士林區德行東路356號前	121.53872	25.1105
士林區	忠誠里	蘭雅分隊	102-062	235-BV	蘭雅-4	第2車	1943	1953	臺北市士林區德行東路132巷7弄1號旁	121.52975	25.10691
士林區	忠誠里	蘭雅分隊	102-062	235-BV	蘭雅-4	第2車	1953	1958	臺北市士林區忠誠路1段98號前	121.5282	25.10508
士林區	岩山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第3車	2050	2100	臺北市士林區雨聲街105號(陽明醫院急診室側)僅收運一般專用袋垃圾)	121.53239	25.1044
士林區	名山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第3車	2120	2125	臺北市士林區忠誠路1段103號	121.52847	25.10503
士林區	聖山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第3車	2126	2135	臺北市士林區忠誠路1段149號前	121.52986	25.10657
士林區	聖山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第3車	2136	2142	臺北市士林區忠誠路1段169號前	121.53021	25.10745
士林區	名山里	蘭雅分隊	102-062	235-BV	蘭雅-4	第3車	2143	2147	臺北市士林區忠義街1號(雨農國小後門、雨聲街側)	121.53028	25.10464
內湖區	金瑞里	內湖分隊	102-066	239-BV	內湖-4	第1車	1740	1745	臺北市內湖區金龍路219號前	121.58688	25.08833
內湖區	金瑞里	內湖分隊	102-066	239-BV	內湖-4	第1車	1747	1757	臺北市內湖區內湖路3段191巷20號對面	121.58843	25.08773
內湖區	金瑞里	內湖分隊	102-066	239-BV	內湖-4	第1車	1800	1825	臺北市內湖區金龍路194號旁	121.58771	25.08742
內湖區	金龍里	內湖分隊	102-066	239-BV	內湖-4	第1車	1827	1835	臺北市內湖區金龍路152號前	121.58921	25.08614
內湖區	清白里	內湖分隊	102-066	239-BV	內湖-4	第1車	1845	1900	臺北市內湖區金湖路21號前	121.58689	25.08833
內湖區	湖濱里	內湖分隊	102-066	239-BV	內湖-4	第2車	2020	2030	臺北市內湖區內湖路2段179巷59號旁	121.58456	25.0845
內湖區	清白里	內湖分隊	102-066	239-BV	內湖-4	第2車	2040	2050	臺北市內湖區星雲街208號對面	121.59698	25.08099
內湖區	紫雲里	內湖分隊	102-066	239-BV	內湖-4	第2車	2055	2105	臺北市內湖區康寧路1段265號	121.59815	25.07869
內湖區	紫雲里	內湖分隊	102-066	239-BV	內湖-4	第2車	2106	2110	臺北市內湖區康寧路1段197號前	121.59695	25.0786
內湖區	紫雲里	內湖分隊	102-066	239-BV	內湖-4	第2車	2111	2120	臺北市內湖區康寧路1段181巷口	121.59579	25.07844
內湖區	紫雲里	內湖分隊	102-066	239-BV	內湖-4	第2車	2125	2135	臺北市內湖區康寧路1段157號前	121.59456	25.07914
內湖區	紫星里	內湖分隊	102-066	239-BV	內湖-4	第2車	2140	2145	臺北市內湖區成功路4段61巷29號對面	121.59339	25.08076
內湖區	清白里	內湖分隊	102-066	239-BV	內湖-4	第2車	2150	2155	臺北市內湖區成功路4段219號旁	121.5933	25.08084
內湖區	港墘里	內湖分隊	102-066	239-BV	內湖-4	第2車	2210	2215	臺北市內湖區港墘路221巷2號	121.5743432	25.0735333
松山區	民有里	東社分隊	102-068	963-BS	東社-1	第1車	1830	1930	臺北市松山區民權東路3段140巷口	121.54686	25.06196
松山區	民有里	東社分隊	102-068	963-BS	東社-1	第2車	2100	2200	臺北市松山區民權東路3段140巷口(二次收集)	121.54686	25.06196
松山區	精忠里	東社分隊	102-068	963-BS	東社-1	第2車	2206	2215	臺北市松山區民生東路4段131巷3號斜對面	121.55394	25.05886
北投區	洲美里	關渡分隊	102-069	965-BS	關渡-1	第1車	1730	1739	臺北市北投區福美路178號	121.50595	25.10051
北投區	洲美里	關渡分隊	102-069	965-BS	關渡-1	第1車	1740	1749	臺北市北投區福美路236號	121.50595	25.10051
北投區	洲美里	關渡分隊	102-069	965-BS	關渡-1	第1車	1750	1753	臺北市北投區洲美街196巷口	121.50239	25.10114
北投區	洲美里	關渡分隊	102-069	965-BS	關渡-1	第1車	1753	1758	臺北市北投區洲美街230巷口	121.50156	25.10159
北投區	洲美里	關渡分隊	102-069	965-BS	關渡-1	第1車	1758	1800	臺北市北投區洲美街275號對面	121.50006	25.103
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	1843	1845	臺北市北投區立德路60號	121.47182	25.12565
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	1850	1852	臺北市北投區立功路79巷口	121.4692	25.12602
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	1853	1856	臺北市北投區中央北路4段595號五金行旁邊	121.46514	25.12438
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	1857	1900	臺北市北投區中央北路4段583巷口	121.46576	25.12562
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	1901	1904	臺北市北投區中央北路4段577巷口	121.46691	25.12692
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	1904	1907	臺北市北投區中央北路4段541巷口	121.46789	25.12746
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	1908	1911	臺北市北投區中央北路4段515巷口	121.46926	25.1274
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	1912	1915	臺北市北投區中央北路4段一德宮前	121.46939	25.1283
北投區	桃源里	關渡分隊	102-069	965-BS	關渡-1	第2車	1935	1939	臺北市北投區中央北路3段48號	121.48533	25.1383
北投區	桃源里	關渡分隊	102-069	965-BS	關渡-1	第2車	1940	1944	臺北市北投區中央北路3段92巷口	121.48421	25.13804
北投區	桃源里	關渡分隊	102-069	965-BS	關渡-1	第2車	1945	1949	臺北市北投區中央北路3段148巷口	121.48262	25.13765
北投區	桃源里	關渡分隊	102-069	965-BS	關渡-1	第2車	1950	1954	臺北市北投區中央北路3段168巷口	121.482	25.13736
北投區	桃源里	關渡分隊	102-069	965-BS	關渡-1	第2車	1955	1959	臺北市北投區中央北路3段220巷口	121.48072	25.13628
北投區	桃源里	關渡分隊	102-069	965-BS	關渡-1	第2車	2000	2004	臺北市北投區中央北路3段252巷口	121.47992	25.13586
北投區	桃源里	關渡分隊	102-069	965-BS	關渡-1	第2車	2005	2009	臺北市北投區中央北路3段276巷口	121.47893	25.13594
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	2010	2014	臺北市北投區中央北路4段30巷口	121.47821	25.13511
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	2015	2019	臺北市北投區中央北路4段142巷口	121.47556	25.13385
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	2020	2024	臺北市北投區中央北路4段188號旁	121.47487	25.13268
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	2025	2027	臺北市北投區中央北路4段316巷口	121.47271	25.13085
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	2028	2030	臺北市北投區中央北路4段354巷口	121.47182	25.13026
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	2031	2034	臺北市北投區中央北路4段404巷口	121.47072	25.12966
北投區	一德里	關渡分隊	102-069	965-BS	關渡-1	第2車	2035	2040	臺北市北投區中央北路4段456巷口	121.46975	25.12908
北投區	關渡里	關渡分隊	102-069	965-BS	關渡-1	第3車	2127	2130	臺北市北投區知行路316巷關渡路口	121.46953	25.12228
北投區	關渡里	關渡分隊	102-069	965-BS	關渡-1	第3車	2130	2132	臺北市北投區知行路316巷22弄口	121.46879	25.12242
北投區	關渡里	關渡分隊	102-069	965-BS	關渡-1	第3車	2135	2138	臺北市北投區知行路316巷20弄口	121.46836	25.12244
北投區	關渡里	關渡分隊	102-069	965-BS	關渡-1	第3車	2139	2141	臺北市北投區知行路316巷口	121.46715	25.12256
北投區	關渡里	關渡分隊	102-069	965-BS	關渡-1	第3車	2142	2146	臺北市北投區知行路293巷口	121.46741	25.12187
北投區	關渡里	關渡分隊	102-069	965-BS	關渡-1	第3車	2147	2151	臺北市北投區知行路245巷口	121.46715	25.12067
北投區	關渡里	關渡分隊	102-069	965-BS	關渡-1	第3車	2152	2154	臺北市北投區知行路208號前	121.46679	25.11945
北投區	關渡里	關渡分隊	102-069	965-BS	關渡-1	第3車	2155	2200	臺北市北投區知行路201巷口	121.46635	25.11915
大同區	鄰江里	蘭州分隊	102-070	063-BT	蘭州-1	第1車	1630	1635	臺北市大同區酒泉街192號	121.51084	25.07209
大同區	鄰江里	蘭州分隊	102-070	063-BT	蘭州-1	第1車	1636	1640	臺北市大同區延平北路4段66號	121.5108	25.07055
大同區	鄰江里	蘭州分隊	102-070	063-BT	蘭州-1	第1車	1641	1645	臺北市大同區延平北路4段48號	121.51075	25.06997
大同區	鄰江里	蘭州分隊	102-070	063-BT	蘭州-1	第1車	1646	1650	臺北市大同區延平北路4段20號	121.51075	25.06923
大同區	國順里	蘭州分隊	102-070	063-BT	蘭州-1	第1車	1651	1655	臺北市大同區民族西路、迪化街2段220號	121.51084	25.06867
大同區	國順里	蘭州分隊	102-070	063-BT	蘭州-1	第1車	1656	1701	臺北市大同區延平北路3段116號之2	121.51086	25.06702
大同區	國順里	蘭州分隊	102-070	063-BT	蘭州-1	第1車	1702	1705	臺北市大同區延平北路3段104巷口	121.51098	25.06649
大同區	國順里	蘭州分隊	102-070	063-BT	蘭州-1	第1車	1706	1711	臺北市大同區延平北路3段82號、昌吉街口	121.51092	25.06586
大同區	景星里	蘭州分隊	102-070	063-BT	蘭州-1	第1車	1712	1716	臺北市大同區延平北路3段、伊寧街口	121.51109	25.06464
大同區	景星里	蘭州分隊	102-070	063-BT	蘭州-1	第1車	1717	1720	臺北市大同區延平北路3段18號巷口	121.51104	25.06385
大同區	老師里	蘭州分隊	102-070	063-BT	蘭州-1	第2車	1920	1925	臺北市大同區重慶北路3段322巷口	121.51377	25.07554
大同區	老師里	蘭州分隊	102-070	063-BT	蘭州-1	第2車	1926	1928	臺北市大同區重慶北路3段310號	121.51357	25.07395
大同區	老師里	蘭州分隊	102-070	063-BT	蘭州-1	第2車	1929	1932	臺北市大同區重慶北路3段296巷口	121.5137	25.07352
大同區	老師里	蘭州分隊	102-070	063-BT	蘭州-1	第2車	1933	1938	臺北市大同區重慶北路3段278號之2、哈密街口	121.51372	25.0728
大同區	鄰江里	蘭州分隊	102-070	063-BT	蘭州-1	第2車	1940	1945	臺北市大同區重慶北路3段252巷口	121.51368	25.07129
大同區	鄰江里	蘭州分隊	102-070	063-BT	蘭州-1	第2車	1946	1949	臺北市大同區重慶北3段236巷口	121.51362	25.07044
大同區	國慶里	蘭州分隊	102-070	063-BT	蘭州-1	第2車	1950	1953	臺北市大同區民族西路221巷口	121.51349	25.06952
大同區	國慶里	蘭州分隊	102-070	063-BT	蘭州-1	第2車	1954	1959	臺北市大同區重慶北路3段152巷口	121.51369	25.06817
大同區	國慶里	蘭州分隊	102-070	063-BT	蘭州-1	第2車	2001	2003	臺北市大同區重慶北路3段136巷口	121.51365	25.06769
大同區	國慶里	蘭州分隊	102-070	063-BT	蘭州-1	第2車	2004	2007	臺北市大同區重慶北路3段96號	121.51346	25.06663
大同區	隆和里	蘭州分隊	102-070	063-BT	蘭州-1	第2車	2008	2012	臺北市大同區重慶北路3段、伊寧街口	121.51343	25.06428
大同區	隆和里	蘭州分隊	102-070	063-BT	蘭州-1	第3車	2130	2135	臺北市大同區民權西路、延平北路口	121.51129	25.06352
大同區	隆和里	蘭州分隊	102-070	063-BT	蘭州-1	第3車	2136	2139	臺北市大同區延平北路3段17巷口	121.51116	25.06381
大同區	隆和里	蘭州分隊	102-070	063-BT	蘭州-1	第3車	2140	2145	臺北市大同區延平北路3段、景化街口	121.5111	25.06512
大同區	國慶里	蘭州分隊	102-070	063-BT	蘭州-1	第3車	2146	2151	臺北市大同區延平北路3段63號	121.51107	25.06594
大同區	國慶里	蘭州分隊	102-070	063-BT	蘭州-1	第3車	2152	2157	臺北市大同區延平北路3段85號	121.51105	25.06737
大同區	國慶里	蘭州分隊	102-070	063-BT	蘭州-1	第3車	2158	2202	臺北市大同區延平北路3段107號	121.511	25.06806
大同區	鄰江里	蘭州分隊	102-070	063-BT	蘭州-1	第3車	2203	2208	臺北市大同區延平北路4段19號	121.51097	25.06929
大同區	鄰江里	蘭州分隊	102-070	063-BT	蘭州-1	第3車	2209	2215	臺北市大同區延平北路4段93號	121.51101	25.07084
士林區	葫東里	社子分隊	103-073	820-BT	社子-2	第1車	1610	1624	臺北市士林區中正路601號	121.51033	25.08653
士林區	葫東里	社子分隊	103-073	820-BT	社子-2	第1車	1626	1639	臺北市士林區重慶北路4段243號	121.51102	25.08556
士林區	葫東里	社子分隊	103-073	820-BT	社子-2	第1車	1640	1649	臺北市士林區重慶北路4段195號	121.51153	25.08439
士林區	福順里	社子分隊	103-073	820-BT	社子-2	第1車	1650	1656	臺北市士林區重慶北路4段125號	121.51225	25.08265
士林區	福順里	社子分隊	103-073	820-BT	社子-2	第1車	1657	1702	臺北市士林區重慶北路4段113號前	121.51239	25.08233
士林區	福順里	社子分隊	103-073	820-BT	社子-2	第1車	1703	1708	臺北市士林區重慶北路4段75號	121.51271	25.08157
士林區	福順里	社子分隊	103-073	820-BT	社子-2	第1車	1709	1715	臺北市士林區重慶北路4段57號	121.51289	25.08113
士林區	福順里	社子分隊	103-073	820-BT	社子-2	第1車	1720	1730	臺北市士林區延平北路5段86號	121.51063	25.08103
士林區	福順里	社子分隊	103-073	820-BT	社子-2	第1車	1731	1740	臺北市士林區延平北路5段138號	121.51038	25.08215
士林區	葫東里	社子分隊	103-073	820-BT	社子-2	第1車	1741	1750	臺北市士林區延平北路5段180號	121.51031	25.0831
士林區	葫東里	社子分隊	103-073	820-BT	社子-2	第1車	1751	1800	臺北市士林區延平北路5段246號	121.50992	25.08456
士林區	葫東里	社子分隊	103-073	820-BT	社子-2	第1車	1801	1806	臺北市士林區延平北路5段296號	121.50966	25.08573
士林區	葫東里	社子分隊	103-073	820-BT	社子-2	第2車	2030	2040	臺北市士林區中正路707巷1號	121.50692	25.08581
士林區	葫蘆里	社子分隊	103-073	820-BT	社子-2	第2車	2042	2049	臺北市士林區中正路625號前	121.50874	25.08641
士林區	葫蘆里	社子分隊	103-073	820-BT	社子-2	第2車	2051	2100	臺北市士林區延平北路5段283號	121.50953	25.0856
士林區	葫蘆里	社子分隊	103-073	820-BT	社子-2	第2車	2101	2110	臺北市士林區延平北路5段259號	121.50968	25.08498
士林區	葫蘆里	社子分隊	103-073	820-BT	社子-2	第2車	2111	2120	臺北市士林區延平北路5段193號	121.51002	25.08343
士林區	葫蘆里	社子分隊	103-073	820-BT	社子-2	第2車	2121	2130	臺北市士林區延平北路5段161號	121.51018	25.08259
士林區	富光里	社子分隊	103-073	820-BT	社子-2	第2車	2131	2140	臺北市士林區延平北路5段57號	121.51072	25.08041
士林區	天壽里	天母分隊	103-074	821-BT	天母-1	第1車	1630	1640	臺北市士林區天母西路46號	121.52547	25.11844
士林區	天壽里	天母分隊	103-074	821-BT	天母-1	第1車	1641	1651	臺北市士林區天母西路20號	121.52724	25.1184
士林區	天壽里	天母分隊	103-074	821-BT	天母-1	第1車	1652	1700	臺北市士林區天母西路10號〈地下室旁〉	121.52844	25.11839
士林區	天福里	天母分隊	103-074	821-BT	天母-1	第1車	1701	1710	臺北市士林區天母東路10號	121.53182	25.11799
士林區	天山里	天母分隊	103-074	821-BT	天母-1	第2車	1900	1905	臺北市士林區中山北路7段20號前	121.53079	25.11934
士林區	天山里	天母分隊	103-074	821-BT	天母-1	第2車	1906	1911	臺北市士林區天玉街42號對面	121.52969	25.12123
士林區	天玉里	天母分隊	103-074	821-BT	天母-1	第2車	1912	1923	臺北市士林區天玉街38巷18弄6號對面	121.52979	25.11952
士林區	天玉里	天母分隊	103-074	821-BT	天母-1	第2車	1924	1929	臺北市士林區天母西路15號前	121.52831	25.11842
士林區	天玉里	天母分隊	103-074	821-BT	天母-1	第2車	1930	1935	臺北市士林區天母西路87號前	121.5248	25.1185
士林區	東山里	天母分隊	103-074	821-BT	天母-1	第3車	2030	2045	臺北市士林區天母轉運站天母國中後門	121.53843	25.11643
士林區	天壽里	天母分隊	103-074	821-BT	天母-1	第3車	2100	2105	臺北市士林區天母西路20號	121.52721	25.1184
士林區	天山里	天母分隊	103-074	821-BT	天母-1	第3車	2107	2112	臺北市士林區中山北路7段42號前	121.53116	25.12031
士林區	天山里	天母分隊	103-074	821-BT	天母-1	第3車	2113	2120	臺北市士林區中山北路7段86號前	121.5317	25.12167
士林區	天山里	天母分隊	103-074	821-BT	天母-1	第3車	2121	2126	臺北市士林區中山北路7段118號前	121.53192	25.12228
士林區	天山里	天母分隊	103-074	821-BT	天母-1	第3車	2127	2134	臺北市士林區中山北路7段178號前	121.53279	25.12453
士林區	天母里	天母分隊	103-074	821-BT	天母-1	第3車	2135	2140	臺北市士林區中山北路7段218之1號前	121.53287	25.12604
士林區	天母里	天母分隊	103-074	821-BT	天母-1	第3車	2141	2146	臺北市士林區中山北路7段136號對面	121.53202	25.12297
士林區	天玉里	天母分隊	103-074	821-BT	天母-1	第3車	2147	2149	臺北市士林區中山北路7段61號	121.53119	25.1207
士林區	天玉里	天母分隊	103-074	821-BT	天母-1	第3車	2150	2155	臺北市士林區中山北路7段49號前	121.53096	25.12014
士林區	天玉里	天母分隊	103-074	821-BT	天母-1	第3車	2156	2200	臺北市士林區中山北路7段33號前	121.5307	25.11943
信義區	雅祥里	五分埔分隊	103-075	822-BT	五分埔-4	第2車	1725	1745	臺北市信義區松信路38號對面	121.57206	25.04799
信義區	雅祥里	五分埔分隊	103-075	822-BT	五分埔-4	第2車	1746	1755	臺北市信義區松信路與松隆路交叉口	121.57216	25.04689
信義區	雅祥里	五分埔分隊	103-075	822-BT	五分埔-4	第2車	1758	1804	臺北市信義區永吉路37號	121.56889	25.04673
信義區	雅祥里	五分埔分隊	103-075	822-BT	五分埔-4	第2車	1805	1810	臺北市信義區基隆路1段37巷47號	121.56859	25.04781
信義區	雅祥里	五分埔分隊	103-075	822-BT	五分埔-4	第2車	1811	1826	臺北市信義區基隆路1段35巷7弄4號	121.57055	25.04785
信義區	雅祥里	五分埔分隊	103-075	822-BT	五分埔-4	第2車	1827	1830	臺北市信義區永吉路127巷與基隆路1段83巷交叉口(興雅國小邊)	121.57038	25.04669
信義區	永吉里	五分埔分隊	103-075	822-BT	五分埔-4	第3車	1950	1959	臺北市信義區永吉路517巷口	121.58011	25.04596
信義區	永吉里	五分埔分隊	103-075	822-BT	五分埔-4	第3車	2000	2009	臺北市信義區永吉路443巷口	121.57839	25.04668
信義區	永吉里	五分埔分隊	103-075	822-BT	五分埔-4	第3車	2010	2020	臺北市信義區松山路161巷口	121.57816	25.04631
信義區	永吉里	五分埔分隊	103-075	822-BT	五分埔-4	第3車	2022	2025	臺北市信義區松山路294號 (永春市場)	121.57758	25.04307
信義區	富台里	五分埔分隊	103-075	822-BT	五分埔-4	第3車	2025	2035	臺北市信義區松山路332號	121.57761	25.04199
信義區	長春里	五分埔分隊	103-075	822-BT	五分埔-4	第3車	2040	2110	臺北市信義區虎林街119巷內(虎林市場)	121.57723	25.04211
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第1車	1623	1628	臺北市中山區松江路27號前	121.53307	25.04726
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第1車	1630	1636	臺北市中山區松江路59號	121.53309	25.04834
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第1車	1640	1650	臺北市中山區松江路75號	121.53312	25.04971
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第1車	1652	1702	臺北市中山區南京東路2段140號	121.53346	25.05189
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第1車	1703	1712	臺北市中山區南京東路2段172號前	121.53452	25.0519
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第1車	1713	1718	臺北市中山區南京東路2段216號	121.53614	25.05188
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第1車	1720	1724	臺北市中山區建國北路1段48號	121.53642	25.0479
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第2車	1850	1909	臺北市中山區伊通街25號前	121.53472	25.04944
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第2車	1910	1915	臺北市中山區松江路25巷9號旁	121.53479	25.0484
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第2車	1920	1928	臺北市中山區渭水路3巷1號	121.53361	25.04583
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第2車	1930	1935	臺北市中山區市民大道3段37號	121.53446	25.04515
中山區	埤頭里	長安分隊	103-076	823-BT	長安-1	第2車	1937	1943	臺北市中山區八德路2段96號	121.53592	25.04577
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第3車	2110	2118	臺北市中山區長安東路2段127號	121.53585	25.04853
中山區	興亞里	長安分隊	103-076	823-BT	長安-1	第3車	2120	2129	臺北市中山區長安東路2段35之1號前	121.53136	25.04856
中山區	興亞里	長安分隊	103-076	823-BT	長安-1	第3車	2130	2138	臺北市中山區新生北路1段71號前	121.52876	25.04982
中山區	興亞里	長安分隊	103-076	823-BT	長安-1	第3車	2140	2145	臺北市中山區松江路90巷9號對面	121.53139	25.05056
中山區	朱園里	長安分隊	103-076	823-BT	長安-1	第3車	2147	2152	臺北市中山區南京東路2段172號前	121.53447	25.05191
中山區	成功里	大直分隊	103-077	825-BT	大直-2	第1車	1700	1704	臺北市中山區明水路709號	121.5514	25.08523
中山區	金泰里	大直分隊	103-077	825-BT	大直-2	第1車	1710	1713	臺北市中山區樂群二路266巷28號旁(中430公園對面)	121.56181	25.07838
中山區	金泰里	大直分隊	103-077	825-BT	大直-2	第1車	1715	1735	臺北市中山區植福路215號對面	121.56051	25.08284
中山區	金泰里	大直分隊	103-077	825-BT	大直-2	第1車	1742	1750	臺北市中山區敬業三路162巷109號前	121.55961	25.0792
中山區	金泰里	大直分隊	103-077	825-BT	大直-2	第1車	1752	1800	臺北市中山區敬業三路162巷71號前	121.55938	25.07821
中山區	金泰里	大直分隊	103-077	825-BT	大直-2	第1車	1802	1810	臺北市中山區敬業三路162巷36號前	121.55806	25.07819
中山區	金泰里	大直分隊	103-077	825-BT	大直-2	第1車	1812	1820	臺北市中山區敬業三路162巷9號前	121.55697	25.07907
中山區	成功里	大直分隊	103-077	825-BT	大直-2	第2車	1945	1955	臺北市中山區北安路608巷5號前	121.54917	25.08201
中山區	成功里	大直分隊	103-077	825-BT	大直-2	第2車	2000	2015	臺北市中山區北安路630巷8號	121.54975	25.08276
中山區	成功里	大直分隊	103-077	825-BT	大直-2	第2車	2017	2020	臺北市中山區北安路630巷25弄3號前	121.55038	25.08305
中山區	成功里	大直分隊	103-077	825-BT	大直-2	第2車	2022	2030	臺北市中山區北安路588巷23弄34號前(公園旁)	121.55084	25.08124
中山區	成功里	大直分隊	103-077	825-BT	大直-2	第2車	2033	2036	臺北市中山區明水路672巷46號前	121.55212	25.08348
中山區	北安里	大直分隊	103-077	825-BT	大直-2	第2車	2040	2050	臺北市中山區北安路821巷2弄1號前	121.55628	25.08529
中山區	北安里	大直分隊	103-077	825-BT	大直-2	第2車	2051	2056	臺北市中山區北安路821巷4弄8號前	121.55614	25.08561
中山區	北安里	大直分隊	103-077	825-BT	大直-2	第2車	2058	2108	臺北市中山區北安路779號旁	121.55374	25.08554
中山區	北安里	大直分隊	103-077	825-BT	大直-2	第2車	2109	2112	臺北市中山區北安路759巷3號前	121.55292	25.0862
中山區	金泰里	大直分隊	103-077	825-BT	大直-2	第2車	2142	2150	臺北市中山區敬業三路162巷92號後	121.55907	25.07817
中山區	金泰里	大直分隊	103-077	825-BT	大直-2	第2車	2151	2200	臺北市中山區敬業三路178號後	121.55639	25.07828
內湖區	湖元里	文德分隊	103-080	829-BT	文德-1	第1車	1735	1745	臺北市內湖區民權東路6段46巷與行忠路交叉口	121.58301	25.06725
內湖區	石潭里	文德分隊	103-080	829-BT	文德-1	第1車	1800	1808	臺北市內湖區新明路102號	121.58936	25.05961
內湖區	石潭里	文德分隊	103-080	829-BT	文德-1	第1車	1810	1815	臺北市內湖區新明路143巷7號	121.58966	25.05882
內湖區	週美里	文德分隊	103-080	829-BT	文德-1	第1車	1827	1840	臺北市內湖區新明路250號	121.58374	25.05662
內湖區	石潭里	文德分隊	103-080	829-BT	文德-1	第1車	1843	1848	臺北市內湖區新明路225號	121.5876	25.0582
內湖區	石潭里	文德分隊	103-080	829-BT	文德-1	第1車	1851	1855	臺北市內湖區新明路85號	121.35264	25.03365
內湖區	石潭里	文德分隊	103-080	829-BT	文德-1	第2車	2008	2015	臺北市內湖區民權東路6段180巷150號	121.59257	25.06498
內湖區	週美里	文德分隊	103-080	829-BT	文德-1	第2車	2024	2034	臺北市內湖區新明路168號	121.58563	25.05756
內湖區	週美里	文德分隊	103-080	829-BT	文德-1	第2車	2036	2043	臺北市內湖區新明路290號	121.58243	25.05599
內湖區	週美里	文德分隊	103-080	829-BT	文德-1	第2車	2044	2049	臺北市內湖區新明路298巷14弄1號	121.58195	25.05664
內湖區	週美里	文德分隊	103-080	829-BT	文德-1	第2車	2053	2055	臺北市內湖區行善路289號	121.58336	25.06113
內湖區	週美里	文德分隊	103-080	829-BT	文德-1	第2車	2058	2103	臺北市內湖區民權東路6段46巷與行忠路交叉路口	121.58301	25.06725
內湖區	週美里	文德分隊	103-080	829-BT	文德-1	第3車	2205	2208	臺北市內湖區行善路59巷40弄41號	121.58004	25.05745
內湖區	行善里	文德分隊	103-080	829-BT	文德-1	第3車	2212	2218	臺北市內湖區行善路9號	121.34286	25.03211
內湖區	行善里	文德分隊	103-080	829-BT	文德-1	第3車	2219	2225	臺北市內湖區行善路55號	121.57781	25.05765
大安區	華聲里	敦化分隊	103-081	827-BT	敦化-2	第1車	1700	1705	臺北市大安區市民大道4段200號前	121.55571	25.04448
大安區	華聲里	敦化分隊	103-081	827-BT	敦化-2	第1車	1710	1715	臺北市大安區忠孝東路4段343號前	121.55747	25.04158
大安區	光武里	敦化分隊	103-081	827-BT	敦化-2	第1車	1725	1735	臺北市大安區敦化南路1段160巷口	121.54864	25.04357
大安區	光武里	敦化分隊	103-081	827-BT	敦化-2	第2車	1905	1925	臺北市大安區敦化南路1段160巷口	121.54864	25.04357
大安區	華聲里	敦化分隊	103-081	827-BT	敦化-2	第2車	1935	1945	臺北市大安區延吉街131巷43號對面(第1次收集)	121.55591	25.04291
大安區	建倫里	敦化分隊	103-081	827-BT	敦化-2	第3車	2105	2110	臺北市大安區安和路1段33號前	121.55099	25.03874
大安區	建倫里	敦化分隊	103-081	827-BT	敦化-2	第3車	2112	2115	臺北市大安區安和路1段7號前	121.54974	25.03976
大安區	光武里	敦化分隊	103-081	827-BT	敦化-2	第3車	2125	2130	臺北市大安區復興南路1段133號	121.54409	25.04281
大安區	華聲里	敦化分隊	103-081	827-BT	敦化-2	第3車	2140	2145	臺北市大安區光復南路96巷2號前	121.55669	25.04399
大安區	華聲里	敦化分隊	103-081	827-BT	敦化-2	第3車	2148	2153	臺北市大安區市民大道4段200號前(第2次收集)	121.55571	25.04448
松山區	吉祥里	松山分隊	113-G18	KEU-5759	松山-1	第1車	1700	1710	臺北市松山區光復北路11巷13號左側	121.55938	25.0497
松山區	吉祥里	松山分隊	113-G18	KEU-5759	松山-1	第1車	1720	1730	臺北市松山區南京東路5段42號	121.55929	25.05141
松山區	吉祥里	松山分隊	113-G18	KEU-5759	松山-1	第1車	1733	1741	臺北市松山區南京東路5段96號	121.56176	25.05135
松山區	吉祥里	松山分隊	113-G18	KEU-5759	松山-1	第1車	1745	1758	臺北市松山區吉祥路29號對面(中崙高中)	121.56252	25.04982
松山區	復盛里	松山分隊	113-G18	KEU-5759	松山-1	第1車	1803	1812	臺北市松山區八德路4段196號	121.56393	25.04881
松山區	新聚里	松山分隊	113-G18	KEU-5759	松山-1	第1車	1820	1830	臺北市松山區南京東路5段252號	121.56623	25.05125
松山區	新聚里	松山分隊	113-G18	KEU-5759	松山-1	第2車	2000	2010	臺北市松山區寶清街8號	121.5689	25.04983
松山區	慈祐里	松山分隊	113-G18	KEU-5759	松山-1	第2車	2020	2025	臺北市松山區八德路4段500號	121.57053	25.04981
松山區	慈祐里	松山分隊	113-G18	KEU-5759	松山-1	第2車	2030	2035	臺北市松山區八德路4段622號	121.5736	25.04992
松山區	慈祐里	松山分隊	113-G18	KEU-5759	松山-1	第2車	2035	2040	臺北市松山區八德路4段676號前	121.57634	25.04998
松山區	慈祐里	松山分隊	113-G18	KEU-5759	松山-1	第2車	2045	2055	臺北市松山區八德路4段689號	121.57639	25.05009
松山區	慈祐里	松山分隊	113-G18	KEU-5759	松山-1	第2車	2058	2105	臺北市松山區八德路4段605號	121.57445	25.05005
松山區	慈祐里	松山分隊	113-G18	KEU-5759	松山-1	第2車	2108	2115	臺北市松山區八德路4段465號	121.57098	25.04987
松山區	慈祐里	松山分隊	113-G18	KEU-5759	松山-1	第2車	2125	2130	臺北市松山區塔悠路15號	121.57201	25.05031
松山區	慈祐里	松山分隊	113-G18	KEU-5759	松山-1	第2車	2135	2145	臺北市松山區松河街270號	121.57945	25.05201
松山區	慈祐里	松山分隊	113-G18	KEU-5759	松山-1	第2車	2150	2200	臺北市松山區八德路4段803號對面(松山國小前)	121.57881	25.05126
萬華區	華江里	大理分隊	104-083	AAB-273	大理-2	第1車	1630	1635	臺北市萬華區環河南路2段278號前	121.49131	25.03208
萬華區	華江里	大理分隊	104-083	AAB-273	大理-2	第1車	1636	1641	臺北市萬華區長順街91號	121.49025	25.03174
萬華區	華江里	大理分隊	104-083	AAB-273	大理-2	第1車	1642	1647	臺北市萬華區長順街111號	121.4893	25.0322
萬華區	華江里	大理分隊	104-083	AAB-273	大理-2	第1車	1649	1654	臺北市萬華區和平西路3段380號前	121.49132	25.03538
萬華區	華江里	大理分隊	104-083	AAB-273	大理-2	第1車	1655	1659	臺北市萬華區環河南路2段162號前	121.4939	25.03533
萬華區	華江里	大理分隊	104-083	AAB-273	大理-2	第1車	1700	1704	臺北市萬華區環河南路2段218號前	121.49289	25.0338
萬華區	和平里	大理分隊	104-083	AAB-273	大理-2	第2車	1832	1834	臺北市萬華區艋舺大道338號	121.49599	25.03261
萬華區	雙園里	大理分隊	104-083	AAB-273	大理-2	第2車	1836	1839	臺北市萬華區西園路2段33號	121.49763	25.03191
萬華區	雙園里	大理分隊	104-083	AAB-273	大理-2	第2車	1840	1843	臺北市萬華區艋舺大道204號	121.4994	25.03264
萬華區	華江里	大理分隊	104-083	AAB-273	大理-2	第2車	1848	1851	臺北市萬華區環河南路2段250巷52號	121.49038	25.03401
萬華區	華江里	大理分隊	104-083	AAB-273	大理-2	第2車	1852	1855	臺北市萬華區和平西路3段382巷12弄54號	121.49017	25.03458
萬華區	華江里	大理分隊	104-083	AAB-273	大理-2	第2車	1856	1900	臺北市萬華區和平西路3段300-9號前	121.49328	25.03535
萬華區	和平里	大理分隊	104-083	AAB-273	大理-2	第2車	1904	1910	臺北市萬華區雙園街21號	121.49465	25.02943
萬華區	和平里	大理分隊	104-083	AAB-273	大理-2	第2車	1911	1916	臺北市萬華區雙園街69號	121.49378	25.03028
萬華區	綠堤里	大理分隊	104-083	AAB-273	大理-2	第2車	1917	1920	臺北市萬華區長順街35號	121.49308	25.03059
萬華區	綠堤里	大理分隊	104-083	AAB-273	大理-2	第2車	1921	1923	臺北市萬華區長順街65號	121.49122	25.03114
萬華區	綠堤里	大理分隊	104-083	AAB-273	大理-2	第2車	1925	1930	臺北市萬華區大理街170巷66號	121.49269	25.0325
萬華區	綠堤里	大理分隊	104-083	AAB-273	大理-2	第2車	1931	1936	臺北市萬華區大理街170巷12號	121.49352	25.03347
萬華區	華江里	大理分隊	104-083	AAB-273	大理-2	第2車	1937	1944	臺北市萬華區環河南路2段250巷1號	121.4915	25.03337
萬華區	糖部里	大理分隊	104-083	AAB-273	大理-2	第3車	1950	1953	臺北市萬華區和平西路3段200號	121.49709	25.03526
萬華區	綠堤里	大理分隊	104-083	AAB-273	大理-2	第3車	2111	2114	臺北市萬華區雙園街116號	121.49218	25.03156
萬華區	綠堤里	大理分隊	104-083	AAB-273	大理-2	第3車	2115	2119	臺北市萬華區環河南路2段161號	121.49268	25.03339
萬華區	糖部里	大理分隊	104-083	AAB-273	大理-2	第3車	2120	2123	臺北市萬華區環河南路2段125巷1號	121.49358	25.03435
萬華區	糖部里	大理分隊	104-083	AAB-273	大理-2	第3車	2124	2127	臺北市萬華區和平西路3段292號前	121.49463	25.03522
萬華區	糖部里	大理分隊	104-083	AAB-273	大理-2	第3車	2128	2132	臺北市萬華區和平西路3段258號前	121.49581	25.03527
萬華區	糖部里	大理分隊	104-083	AAB-273	大理-2	第3車	2133	2137	臺北市萬華區和平西路3段194號前	121.49723	25.03526
萬華區	糖部里	大理分隊	104-083	AAB-273	大理-2	第3車	2138	2141	臺北市萬華區大理街89號	121.49849	25.03443
萬華區	糖部里	大理分隊	104-083	AAB-273	大理-2	第3車	2142	2145	臺北市萬華區大理街131號	121.49741	25.0343
萬華區	糖部里	大理分隊	104-083	AAB-273	大理-2	第3車	2146	2149	臺北市萬華區大理街132號	121.49646	25.03411
萬華區	糖部里	大理分隊	104-083	AAB-273	大理-2	第3車	2150	2153	臺北市萬華區大理街173號	121.49465	25.03384
萬華區	綠堤里	大理分隊	104-083	AAB-273	大理-2	第3車	2154	2157	臺北市萬華區大理街160巷22弄2號	121.49391	25.03278
萬華區	綠堤里	大理分隊	104-083	AAB-273	大理-2	第3車	2158	2201	臺北市萬華區大理街160巷26弄2號	121.49389	25.03195
萬華區	和平里	大理分隊	104-083	AAB-273	大理-2	第3車	2202	2205	臺北市萬華區西園路2段140巷52號	121.49491	25.03154
萬華區	和平里	大理分隊	104-083	AAB-273	大理-2	第3車	2206	2210	臺北市萬華區西園路2段96巷24號	121.49581	25.0311
松山區	新東里	上塔悠分隊	113-G16	KEU-5753	上塔悠-1	第1車	1625	1645	臺北市松山區塔悠路351號(撫遠抽水站)	121.56861	25.06234
松山區	介壽里	上塔悠分隊	113-G16	KEU-5753	上塔悠-1	第1車	1830	1910	臺北市松山區延壽街319號前	121.56094	25.05672
松山區	三民里	上塔悠分隊	113-G16	KEU-5753	上塔悠-1	第1車	1920	1950	臺北市松山區民生東路5段163號(圓環)	121.56305	25.05917
松山區	富錦里	上塔悠分隊	113-G16	KEU-5753	上塔悠-1	第1車	1955	2015	臺北市松山區民生東路5段169號(郵局邊)	121.56491	25.05912
松山區	東榮里	上塔悠分隊	113-G16	KEU-5753	上塔悠-1	第1車	2040	2105	臺北市松山區新中街52號(民權公園邊)	121.5603	25.0615
松山區	莊敬里	上塔悠分隊	113-G16	KEU-5753	上塔悠-1	第1車	2115	2140	臺北市松山區撫遠街403巷8號(距離垃圾收集點15公尺)	121.5656	25.06602
士林區	天福里	天母分隊	104-085	AAB-277	天母-2	第1車	1615	1625	臺北市士林區忠誠路2段178號前	121.53359	25.11595
士林區	天福里	天母分隊	104-085	AAB-277	天母-2	第1車	1630	1645	臺北市士林區忠誠路2段207巷與東山路交叉口	121.53897	25.11636
士林區	東山里	天母分隊	104-085	AAB-277	天母-2	第1車	1630	1645	臺北市士林區忠誠路2段207巷與東山路交叉口	121.53854	25.11643
士林區	天祿里	天母分隊	104-085	AAB-277	天母-2	第2車	1810	1840	臺北市士林區士東路100號前(士東市場)	121.52914	25.11212
士林區	東山里	天母分隊	104-085	AAB-277	天母-2	第2車	1950	2000	臺北市士林區天母轉運站天母國中後門	121.53844	25.11644
士林區	天母里	天母分隊	104-085	AAB-277	天母-2	第3車	2038	2048	臺北市士林區中山北路7段141巷5號對面	121.55311	25.12309
士林區	天母里	天母分隊	104-085	AAB-277	天母-2	第3車	2050	2105	臺北市士林區中山北路7段81巷28弄12號對面	121.52941	25.12281
士林區	天福里	天母分隊	104-085	AAB-277	天母-2	第3車	2120	2135	臺北市士林區天母東路10號	121.53182	25.118
士林區	天福里	天母分隊	104-085	AAB-277	天母-2	第3車	2138	2143	臺北市士林區忠誠路2段188號前〈誠品大樓〉	121.5338	25.1163
士林區	三玉里	天母分隊	104-085	AAB-277	天母-2	第3車	2150	2153	臺北市士林區忠誠路2段46-1號前	121.53049	25.11028
士林區	三玉里	天母分隊	104-085	AAB-277	天母-2	第3車	2154	2200	臺北市士林區忠誠路2段6-1號前	121.53023	25.10857
內湖區	港墘里	內湖分隊	104-086	AAB-278	內湖-1	第1車	1700	1720	臺北市內湖區港墘路221巷2號	121.57352	25.07397
內湖區	秀湖里	內湖分隊	104-086	AAB-278	內湖-1	第1車	1745	1750	臺北市內湖區大湖街166巷與168巷交會處	121.60229	25.0814
內湖區	大湖里	內湖分隊	104-086	AAB-278	內湖-1	第2車	1920	1930	臺北市內湖區大湖山莊街219巷1號旁	121.59944	25.08814
內湖區	大湖里	內湖分隊	104-086	AAB-278	內湖-1	第2車	1935	1940	臺北市內湖區大湖山莊街171號對面	121.60149	25.08769
內湖區	大湖里	內湖分隊	104-086	AAB-278	內湖-1	第2車	1945	1950	臺北市內湖區大湖山莊街117號對面	121.60167	25.0859
內湖區	紫雲里	內湖分隊	104-086	AAB-278	內湖-1	第2車	2000	2020	臺北市內湖區康寧路1段116號旁	121.59347	25.07949
內湖區	紫星里	內湖分隊	104-086	AAB-278	內湖-1	第2車	2022	2025	臺北市內湖區星雲街35號前	121.59157	25.07863
內湖區	紫星里	內湖分隊	104-086	AAB-278	內湖-1	第3車	2140	2200	臺北市內湖區成功路3段133號前	121.58982	25.07931
內湖區	秀湖里	內湖分隊	104-086	AAB-278	內湖-1	第3車	2205	2215	臺北市內湖區成功路4段317號前10公尺處	121.59861	25.08451
內湖區	湖濱里	內湖分隊	104-086	AAB-278	內湖-1	第3車	2220	2225	臺北市內湖區成功路3段146號前	121.5898	25.07983
內湖區	紫星里	內湖分隊	104-086	AAB-278	內湖-1	第3車	2230	2235	臺北市內湖區康寧路1段66號旁	121.5922	25.08011
內湖區	週美里	文德分隊	104-087	AAB-279	文德-2	第1車	1715	1728	臺北市內湖區民權東路6段46巷與行忠路交叉路口	121.58301	25.06725
內湖區	瑞陽里	文德分隊	104-087	AAB-279	文德-2	第1車	1740	1750	臺北市內湖區文德路208巷68號	121.58356	25.07587
內湖區	瑞陽里	文德分隊	104-087	AAB-279	文德-2	第1車	1752	1800	臺北市內湖區文德路66巷38弄6號	121.58189	25.0758
內湖區	瑞光里	文德分隊	104-087	AAB-279	文德-2	第1車	1802	1810	臺北市內湖區陽光街186號	121.58085	25.07452
內湖區	瑞光里	文德分隊	104-087	AAB-279	文德-2	第1車	1811	1816	臺北市內湖區江南街71巷66號	121.57926	25.07409
內湖區	瑞光里	文德分隊	104-087	AAB-279	文德-2	第1車	1822	1827	臺北市內湖區民權東路6段74號	121.58532	25.06872
內湖區	瑞陽里	文德分隊	104-087	AAB-279	文德-2	第2車	1950	2000	臺北市內湖區文德路208巷40號	121.58336	25.07698
內湖區	瑞陽里	文德分隊	104-087	AAB-279	文德-2	第2車	2003	2010	臺北市內湖區文德路66巷10弄1號	121.58131	25.07783
內湖區	瑞陽里	文德分隊	104-087	AAB-279	文德-2	第2車	2014	2024	臺北市內湖區瑞光路253巷30號	121.57871	25.07532
內湖區	湖元里	文德分隊	104-087	AAB-279	文德-2	第2車	2027	2035	臺北市內湖區民權東路6段122號	121.5873	25.06888
內湖區	寶湖里	文德分隊	104-087	AAB-279	文德-2	第2車	2040	2045	臺北市內湖區民權東路6段191巷38弄27號	121.59709	25.06906
內湖區	寶湖里	文德分隊	104-087	AAB-279	文德-2	第3車	2130	2132	臺北市內湖區民權東路6段180巷41弄38號	121.59354	25.06704
內湖區	寶湖里	文德分隊	104-087	AAB-279	文德-2	第3車	2133	2135	臺北市內湖區民權東路6段190巷35弄16號	121.59468	25.06682
內湖區	湖興里	文德分隊	104-087	AAB-279	文德-2	第3車	2143	2150	臺北市內湖區民權東路6段83號	121.58844	25.06929
內湖區	瑞元里	文德分隊	104-087	AAB-279	文德-2	第3車	2152	2157	臺北市內湖區瑞光路112巷50號對面	121.58006	25.07126
內湖區	瑞光里	文德分隊	104-087	AAB-279	文德-2	第3車	2200	2210	臺北市內湖區瑞光路235巷30號	121.57913	25.07454
內湖區	紫陽里	文德分隊	104-087	AAB-279	文德-2	第3車	2214	2216	臺北市內湖區文德路230號	121.58819	25.07876
內湖區	紫陽里	文德分隊	104-087	AAB-279	文德-2	第3車	2219	2225	臺北市內湖區陽光街55號	121.58681	25.07643
北投區	吉利里	石牌分隊	104-088	AAB-280	石牌-4	第1車	1700	1720	臺北市北投區石牌公園	121.50953	25.11723
北投區	建民里	石牌分隊	104-088	AAB-280	石牌-4	第2車	1820	1824	臺北市北投區文林北路16巷口	121.51908	25.10446
北投區	建民里	石牌分隊	104-088	AAB-280	石牌-4	第2車	1825	1834	臺北市北投區文林北路60巷口	121.51842	25.10497
北投區	建民里	石牌分隊	104-088	AAB-280	石牌-4	第2車	1835	1840	臺北市北投區文林北路94巷口	121.51768	25.1055
北投區	文林里	石牌分隊	104-088	AAB-280	石牌-4	第2車	1841	1849	臺北市北投區文林北路166巷口	121.51613	25.10695
北投區	文林里	石牌分隊	104-088	AAB-280	石牌-4	第2車	1850	1854	臺北市北投區文林北路220號	121.51436	25.10821
北投區	文林里	石牌分隊	104-088	AAB-280	石牌-4	第2車	1855	1904	臺北市北投區文林北路260巷口	121.51343	25.10894
北投區	福興里	石牌分隊	104-088	AAB-280	石牌-4	第2車	1905	1909	臺北市北投區自強街5巷口	121.51201	25.11022
北投區	福興里	石牌分隊	104-088	AAB-280	石牌-4	第2車	1910	1914	臺北市北投區承德路7段32巷口	121.51111	25.11103
北投區	福興里	石牌分隊	104-088	AAB-280	石牌-4	第2車	1915	1920	臺北市北投區承德路7段80號	121.5107	25.11155
北投區	福興里	石牌分隊	104-088	AAB-280	石牌-4	第2車	1923	1930	臺北市北投區承德路7段286號	121.50531	25.11623
北投區	榮光里	石牌分隊	104-088	AAB-280	石牌-4	第3車	2050	2057	臺北市北投區石牌路1段166巷口	121.51351	25.11456
北投區	石牌里	石牌分隊	104-088	AAB-280	石牌-4	第3車	2105	2110	臺北市北投區明德路65號	121.51844	25.10829
北投區	石牌里	石牌分隊	104-088	AAB-280	石牌-4	第3車	2111	2116	臺北市北投區致遠一路1段建民路口旁	121.51717	25.10794
北投區	石牌里	石牌分隊	104-088	AAB-280	石牌-4	第3車	2117	2122	臺北市北投區致遠一路1段46巷口	121.51638	25.10857
北投區	石牌里	石牌分隊	104-088	AAB-280	石牌-4	第3車	2123	2128	臺北市北投區致遠一路1段84巷口	121.51543	25.10926
北投區	石牌里	石牌分隊	104-088	AAB-280	石牌-4	第3車	2129	2135	臺北市北投區致遠一路1段104巷口	121.51519	25.10972
北投區	石牌里	石牌分隊	104-088	AAB-280	石牌-4	第3車	2136	2141	臺北市北投區致遠一路1段124巷口	121.51503	25.11021
北投區	福興里	石牌分隊	104-088	AAB-280	石牌-4	第3車	2142	2147	臺北市北投區自強街61巷口	121.51395	25.11052
北投區	福興里	石牌分隊	104-088	AAB-280	石牌-4	第3車	2148	2155	臺北市北投區自強街31巷口	121.51293	25.11029
中正區	幸褔里	仁愛分隊	104-089	AAB-281	仁愛-1	第1車	1718	1720	臺北市中正區濟南路1段7號前	121.52193	25.04272
中正區	幸褔里	仁愛分隊	104-089	AAB-281	仁愛-1	第1車	1723	1730	臺北市中正區青島東路8號前	121.52213	25.0439
中正區	幸褔里	仁愛分隊	104-089	AAB-281	仁愛-1	第1車	1735	1740	臺北市中正區青島東路21-1號前	121.52396	25.04353
中正區	文祥里	仁愛分隊	104-089	AAB-281	仁愛-1	第1車	1800	1806	臺北市中正區信義路2段15號前	121.52538	25.03517
中正區	文祥里	仁愛分隊	104-089	AAB-281	仁愛-1	第1車	1807	1814	臺北市中正區信義路2段89號前	121.52688	25.03444
中正區	三愛里	仁愛分隊	104-089	AAB-281	仁愛-1	第1車	1815	1822	臺北市中正區信義路2段123號前	121.52784	25.03422
中正區	三愛里	仁愛分隊	104-089	AAB-281	仁愛-1	第1車	1823	1828	臺北市中正區信義路2段161號前	121.52883	25.03393
中正區	三愛里	仁愛分隊	104-089	AAB-281	仁愛-1	第1車	1837	1845	臺北市中正區信義路2段239號前	121.53105	25.03385
中正區	文祥里	仁愛分隊	104-089	AAB-281	仁愛-1	第2車	2000	2011	臺北市中正區金山南路1段127號前	121.52776	25.03561
中正區	文祥里	仁愛分隊	104-089	AAB-281	仁愛-1	第2車	2012	2020	臺北市中正區金山南路1段71號前	121.52819	25.03725
中正區	文祥里	仁愛分隊	104-089	AAB-281	仁愛-1	第2車	2022	2027	臺北市中正區金山南路1段76號前	121.52782	25.03656
中正區	文祥里	仁愛分隊	104-089	AAB-281	仁愛-1	第2車	2028	2035	臺北市中正區金山南路1段108號前	121.52734	25.03549
中正區	文祥里	仁愛分隊	104-089	AAB-281	仁愛-1	第3車	2045	2050	臺北市中正區杭州南路1段141號前	121.52473	25.03626
中正區	文祥里	仁愛分隊	104-089	AAB-281	仁愛-1	第3車	2051	2055	臺北市中正區杭州南路1段109號前	121.52503	25.03731
中正區	東門里	仁愛分隊	104-089	AAB-281	仁愛-1	第3車	2056	2100	臺北市中正區紹興南街36-1號前	121.52298	25.03734
大安區	錦華里	和平分隊	104-091	AAB-283	和平-1	第1車	1750	1758	臺北市大安區和平東路1段39號旁	121.52385	25.02704
大安區	錦華里	和平分隊	104-091	AAB-283	和平-1	第1車	1800	1807	臺北市大安區杭州南路2段91號旁	121.52183	25.02862
大安區	錦華里	和平分隊	104-091	AAB-283	和平-1	第1車	1810	1817	臺北市大安區潮州街58號旁	121.52372	25.02927
大安區	錦華里	和平分隊	104-091	AAB-283	和平-1	第1車	1818	1825	臺北市大安區潮州街102號旁	121.52559	25.0029
大安區	錦安里	和平分隊	104-091	AAB-283	和平-1	第1車	1827	1840	臺北市大安區金山南路2段145號	121.52649	25.02947
大安區	錦泰里	和平分隊	104-091	AAB-283	和平-1	第2車	2000	2005	臺北市大安區杭州南路2段63號旁	121.52218	25.03031
大安區	錦泰里	和平分隊	104-091	AAB-283	和平-1	第2車	2007	2014	臺北市大安區金華街48巷口	121.52327	25.03068
大安區	錦泰里	和平分隊	104-091	AAB-283	和平-1	第2車	2015	2020	臺北市大安區金華街86號前	121.52498	25.03041
大安區	光明里	和平分隊	104-091	AAB-283	和平-1	第2車	2026	2035	臺北市大安區杭州南路2段29號旁	121.52344	25.03391
大安區	光明里	和平分隊	104-091	AAB-283	和平-1	第2車	2037	2040	臺北市大安區信義路2段44巷20弄1號前	121.52553	25.03324
大安區	錦安里	和平分隊	104-091	AAB-283	和平-1	第2車	2046	2050	臺北市大安區金華街146號前	121.52913	25.02977
大安區	錦安里	和平分隊	104-091	AAB-283	和平-1	第3車	2155	2200	臺北市大安區和平東路1段141巷與潮州街口	121.53053	25.02829
大安區	錦安里	和平分隊	104-091	AAB-283	和平-1	第3車	2205	2212	臺北市大安區金山南路2段145號	121.52649	25.02947
大安區	錦泰里	和平分隊	104-091	AAB-283	和平-1	第3車	2216	2220	臺北市大安區杭州南路2段57號	121.52242	25.03159
大安區	光明里	和平分隊	104-091	AAB-283	和平-1	第3車	2223	2233	臺北市大安區信義路2段44巷口	121.52575	25.03459
大安區	光明里	和平分隊	104-091	AAB-283	和平-1	第3車	2235	2245	臺北市大安區金山南路2段12號	121.52712	25.03349
大安區	錦華里	和平分隊	104-091	AAB-283	和平-1	第3車	2248	2255	臺北市大安區金山南路2段154號	121.52622	25.02868
大安區	民輝里	新生分隊	104-092	AAB-285	新生-2	第1車	1832	1842	臺北市大安區仁愛路3段29號前	121.53454	25.03851
大安區	民輝里	新生分隊	104-092	AAB-285	新生-2	第1車	1846	1848	臺北市大安區濟南路3段48號前	121.53573	25.04008
大安區	義村里	新生分隊	104-092	AAB-285	新生-2	第1車	1851	1857	臺北市大安區建國南路1段173號前	121.53773	25.04081
大安區	民輝里	新生分隊	104-092	AAB-285	新生-2	第1車	1900	1906	臺北市大安區建國南路1段42號前	121.53622	25.04402
大安區	民輝里	新生分隊	104-092	AAB-285	新生-2	第1車	1908	1917	臺北市大安區建國南路1段166號	121.53698	25.0409
大安區	民炤里	新生分隊	104-092	AAB-285	新生-2	第1車	1920	1926	臺北市大安區建國南路1段260號前	121.53744	25.03717
大安區	民炤里	新生分隊	104-092	AAB-285	新生-2	第1車	1927	1935	臺北市大安區建國南路1段316號前	121.53754	25.03522
大安區	民炤里	新生分隊	104-092	AAB-285	新生-2	第1車	1936	1940	臺北市大安區建國南路1段336號前	121.53741	25.03465
大安區	和安里	新生分隊	104-092	AAB-285	新生-2	第2車	2050	2105	臺北市大安區建國南路1段299號前	121.53831	25.03546
大安區	和安里	新生分隊	104-092	AAB-285	新生-2	第2車	2106	2116	臺北市大安區建國南路1段283號前	121.53827	25.03623
大安區	民炤里	新生分隊	104-092	AAB-285	新生-2	第2車	2118	2121	臺北市大安區仁愛路3段32號前	121.53682	25.03759
大安區	民炤里	新生分隊	104-092	AAB-285	新生-2	第2車	2122	2126	臺北市大安區仁愛路3段26號前	121.53572	25.03757
大安區	民炤里	新生分隊	104-092	AAB-285	新生-2	第2車	2131	2148	臺北市大安區信義路3段31巷16號（民榮公園旁）	121.53451	25.03519
大安區	民炤里	新生分隊	104-092	AAB-285	新生-2	第2車	2150	2157	臺北市大安區信義路3段29號前	121.53463	25.03378
大安區	民炤里	新生分隊	104-092	AAB-285	新生-2	第2車	2158	2210	臺北市大安區信義路3段75號	121.53714	25.03371
士林區	芝山里	天母分隊	105-G02	AAB-836	天母-3	第1車	1630	1640	臺北市士林區士東路272號	121.537	25.11332
士林區	芝山里	天母分隊	105-G02	AAB-836	天母-3	第1車	1642	1655	臺北市士林區士東路286巷30號(芝山國小)	121.53748	25.11158
士林區	三玉里	天母分隊	105-G02	AAB-836	天母-3	第1車	1658	1715	臺北市士林區天母轉運站	121.53898	25.11626
士林區	天壽里	天母分隊	105-G02	AAB-836	天母-3	第2車	1915	1923	臺北市士林區中山北路6段405巷62號	121.52675	25.11583
士林區	天壽里	天母分隊	105-G02	AAB-836	天母-3	第2車	1925	1933	臺北市士林區中山北路6段405巷80號	121.52611	25.11704
士林區	天玉里	天母分隊	105-G02	AAB-836	天母-3	第2車	1936	1953	臺北市士林區天母北路27號	121.52643	25.11985
士林區	天玉里	天母分隊	105-G02	AAB-836	天母-3	第2車	1955	2003	臺北市士林區天母北路57號	121.5267	25.12123
士林區	天母里	天母分隊	105-G02	AAB-836	天母-3	第2車	2005	2013	臺北市士林區天母北路87巷2弄5號	121.52691	25.12266
士林區	三玉里	天母分隊	105-G02	AAB-836	天母-3	第2車	2030	2050	臺北市士林區天母轉運站	121.53898	25.11622
士林區	天山里	天母分隊	105-G02	AAB-836	天母-3	第3車	2120	2140	臺北市士林區中山北路7段14巷28號	121.53276	25.11897
士林區	天和里	天母分隊	105-G02	AAB-836	天母-3	第3車	2143	2150	臺北市士林區中山北路7段14巷55號	121.53402	25.12076
士林區	天山里	天母分隊	105-G02	AAB-836	天母-3	第3車	2152	2154	臺北市士林區天母東路69巷9號前	121.53422	25.11907
士林區	三玉里	天母分隊	105-G03	AAB-838	天母-4	第1車	1620	1640	臺北市士林區士東路200巷3號對面	121.53358	25.11242
士林區	東山里	天母分隊	105-G03	AAB-838	天母-4	第2車	1730	1800	臺北市士林區天母轉運站天母國中後門	121.53897	25.11619
士林區	三玉里	天母分隊	105-G03	AAB-838	天母-4	第2車	1810	1825	臺北市士林區士東路200巷2號前	121.53396	25.11064
士林區	東山里	天母分隊	105-G03	AAB-838	天母-4	第2車	1830	1835	臺北市士林區天母東路120號(天母國中)對面	121.53877	25.11826
士林區	天和里	天母分隊	105-G03	AAB-838	天母-4	第2車	1836	1847	臺北市士林區天母東路109號前	121.53688	25.11822
士林區	天和里	天母分隊	105-G03	AAB-838	天母-4	第2車	1848	1856	臺北市士林區天母東路79號前	121.5353	25.11817
士林區	天福里	天母分隊	105-G03	AAB-838	天母-4	第2車	1900	1915	臺北市士林區忠誠路2段150號前	121.5327	25.11478
士林區	三玉里	天母分隊	105-G03	AAB-838	天母-4	第3車	2030	2050	臺北市士林區天母轉運站天母國中後門	121.53897	25.11619
士林區	天祿里	天母分隊	105-G03	AAB-838	天母-4	第3車	2105	2115	臺北市士林區中山北路6段350號前	121.52613	25.11194
士林區	天祿里	天母分隊	105-G03	AAB-838	天母-4	第3車	2116	2125	臺北市士林區中山北路6段452號前	121.52743	25.1144
士林區	天祿里	天母分隊	105-G03	AAB-838	天母-4	第3車	2130	2135	臺北市士林區中山北路6段726號前	121.5278	25.11515
士林區	天壽里	天母分隊	105-G03	AAB-838	天母-4	第3車	2145	2200	臺北市士林區中山北路6段429號前	121.52707	25.11397
松山區	新東里	上塔悠分隊	105-G04	AAB-839	上塔悠-2	第1車	1730	1745	臺北市松山區塔悠路298號(接近撫遠街195巷口)	121.56872	25.06021
松山區	新東里	上塔悠分隊	105-G04	AAB-839	上塔悠-2	第1車	1750	1830	臺北市松山區新東街35號	121.56581	25.05983
松山區	新東里	上塔悠分隊	105-G04	AAB-839	上塔悠-2	第2車	2030	2100	臺北市松山區延壽街35號	121.56742	25.05724
松山區	新東里	上塔悠分隊	105-G04	AAB-839	上塔悠-2	第2車	2110	2150	臺北市松山區撫遠街266號(新東公園)	121.56897	25.0585
松山區	新東里	上塔悠分隊	105-G04	AAB-839	上塔悠-2	第2車	2155	2215	臺北市松山區富錦街581巷口	121.5672	25.06281
大安區	仁愛里	敦化分隊	105-G05	AAB-852	敦化-3	第1車	1720	1725	臺北市大安區復興南路1段217號	121.54403	25.03914
大安區	仁愛里	敦化分隊	105-G05	AAB-852	敦化-3	第1車	1728	1733	臺北市大安區復興南路1段179號前	121.54406	25.04072
大安區	仁愛里	敦化分隊	105-G05	AAB-852	敦化-3	第1車	1738	1743	臺北市大安區忠孝東路4段76號前	121.54576	25.04139
大安區	仁愛里	敦化分隊	105-G05	AAB-852	敦化-3	第1車	1748	1753	臺北市大安區忠孝東路4段122號前	121.54732	25.04148
大安區	正聲里	敦化分隊	105-G05	AAB-852	敦化-3	第1車	1805	1815	臺北市大安區光復南路348號前	121.55749	25.03808
大安區	華聲里	敦化分隊	105-G05	AAB-852	敦化-3	第2車	1940	1948	臺北市大安區忠孝東路4段301號前	121.55521	25.04162
大安區	車層里	敦化分隊	105-G05	AAB-852	敦化-3	第2車	1950	1955	臺北市大安區忠孝東路4段285號前	121.55415	25.04167
大安區	建安里	敦化分隊	105-G05	AAB-852	敦化-3	第2車	2002	2007	臺北市大安區敦化南路1段161巷77號前	121.55198	25.04351
大安區	建安里	敦化分隊	105-G05	AAB-852	敦化-3	第2車	2010	2015	臺北市大安區敦化南路1段161巷43號前	121.55116	25.04362
大安區	建安里	敦化分隊	105-G05	AAB-852	敦化-3	第2車	2020	2025	臺北市大安區敦化南路1段161巷7號	121.54975	25.04367
大安區	華聲里	敦化分隊	105-G05	AAB-852	敦化-3	第3車	2140	2145	臺北市大安區延吉街131巷43號對面(第2次收集）	121.55591	25.04291
大安區	建安里	敦化分隊	105-G05	AAB-852	敦化-3	第3車	2150	2155	臺北市大安區忠孝東路4段223巷10弄1-6號	121.55311	25.04223
大安區	建安里	敦化分隊	105-G05	AAB-852	敦化-3	第3車	2158	2202	臺北市大安區敦化南路1段187巷48號	121.55164	25.04246
大安區	建安里	敦化分隊	105-G05	AAB-852	敦化-3	第3車	2205	2208	臺北市大安區敦化南路1段187巷27號	121.55062	25.04269
大安區	建安里	敦化分隊	105-G05	AAB-852	敦化-3	第3車	2210	2212	臺北市大安區敦化南路1段187巷15號	121.55001	25.04267
大同區	保安里	大龍分隊	105-G06	AAB-853	大龍-1	第1車	1654	1658	臺北市大同區承德路3段290號前	121.51958	25.07396
大同區	保安里	大龍分隊	105-G06	AAB-853	大龍-1	第1車	1659	1703	臺北市大同區承德路3段224號前	121.51865	25.07216
大同區	保安里	大龍分隊	105-G06	AAB-853	大龍-1	第1車	1704	1709	臺北市大同區酒泉街103巷口	121.51534	25.07203
大同區	保安里	大龍分隊	105-G06	AAB-853	大龍-1	第1車	1710	1715	臺北市大同區重慶北路3段、哈密街口	121.5139	25.07297
大同區	重慶里	大龍分隊	105-G06	AAB-853	大龍-1	第1車	1717	1721	臺北市大同區重慶北路3段335巷口	121.51391	25.07462
大同區	重慶里	大龍分隊	105-G06	AAB-853	大龍-1	第1車	1722	1725	臺北市大同區重慶北路3段363號	121.51392	25.07543
大同區	重慶里	大龍分隊	105-G06	AAB-853	大龍-1	第2車	1930	1937	臺北市大同區哈密街59巷底敦煌橋旁	121.51572	25.07625
大同區	重慶里	大龍分隊	105-G06	AAB-853	大龍-1	第2車	1938	1948	臺北市大同區哈密街59巷哈密公園	121.51574	25.07494
大同區	保安里	大龍分隊	105-G06	AAB-853	大龍-1	第2車	1950	1953	臺北市大同區庫倫街13巷口	121.51736	25.072
大同區	保安里	大龍分隊	105-G06	AAB-853	大龍-1	第2車	1954	2000	臺北市大同區哈密街45巷、大龍國小東南角	121.5174	25.0734
大同區	重慶里	大龍分隊	105-G06	AAB-853	大龍-1	第2車	2001	2009	臺北市大同區哈密街23巷、大龍國小東北角	121.5173	25.0746
大同區	重慶里	大龍分隊	105-G06	AAB-853	大龍-1	第2車	2010	2013	臺北市大同區敦煌路78號前	121.5182	25.07566
大同區	重慶里	大龍分隊	105-G06	AAB-853	大龍-1	第2車	2014	2017	臺北市大同區敦煌路24巷口	121.51956	25.07529
大同區	保安里	大龍分隊	105-G06	AAB-853	大龍-1	第2車	2018	2021	臺北市大同區敦煌路15號前	121.52026	25.07524
大同區	蓬萊里	大龍分隊	105-G06	AAB-853	大龍-1	第3車	2126	2133	臺北市大同區昌吉街110巷口	121.51475	25.06592
大同區	蓬萊里	大龍分隊	105-G06	AAB-853	大龍-1	第3車	2134	2136	臺北市大同區昌吉街78號前	121.51568	25.0659
大同區	蓬萊里	大龍分隊	105-G06	AAB-853	大龍-1	第3車	2137	2142	臺北市大同區昌吉街50巷口	121.51666	25.06589
大同區	蓬萊里	大龍分隊	105-G06	AAB-853	大龍-1	第3車	2143	2154	臺北市大同區民權西路133巷口	121.51704	25.06303
大同區	蓬萊里	大龍分隊	105-G06	AAB-853	大龍-1	第3車	2155	2156	臺北市大同區民權西路187號前	121.51565	25.06307
大同區	隆和里	大龍分隊	105-G06	AAB-853	大龍-1	第3車	2157	2201	臺北市大同區重慶北路3段9巷口	121.51375	25.06441
大同區	揚雅里	大龍分隊	105-G06	AAB-853	大龍-1	第3車	2202	2204	臺北市大同區重慶北路3段昌吉街口	121.51378	25.06597
大同區	揚雅里	大龍分隊	105-G06	AAB-853	大龍-1	第3車	2205	2208	臺北市大同區重慶北路3段137巷口	121.51383	25.0681
大同區	重慶里	大龍分隊	105-G06	AAB-853	大龍-1	第3車	2209	2214	臺北市大同區重慶北路3段335巷口	121.51391	25.07459
內湖區	蘆洲里	東湖分隊	105-G07	AAB-855	東湖-2	第1車	1610	1700	臺北市內湖區安美街181號前200公尺	121.60283	25.06015
內湖區	蘆洲里	東湖分隊	105-G07	AAB-855	東湖-2	第1車	1725	1730	臺北市內湖區安康路127號前	121.5994	25.06296
內湖區	蘆洲里	東湖分隊	105-G07	AAB-855	東湖-2	第1車	1731	1732	臺北市內湖區潭美街507號旁	121.59744	25.06044
內湖區	蘆洲里	東湖分隊	105-G07	AAB-855	東湖-2	第1車	1733	1734	臺北市內湖區安美街59號前	121.5967	25.06105
內湖區	蘆洲里	東湖分隊	105-G07	AAB-855	東湖-2	第1車	1735	1740	臺北市內湖區安康路58號	121.59707	25.06216
內湖區	蘆洲里	東湖分隊	105-G07	AAB-855	東湖-2	第1車	1742	1750	臺北市內湖區安康路240號前	121.60374	25.06339
內湖區	蘆洲里	東湖分隊	105-G07	AAB-855	東湖-2	第1車	1755	1758	臺北市內湖區潭美街789號前	121.6098	25.06351
內湖區	五分里	東湖分隊	105-G07	AAB-855	東湖-2	第1車	1808	1812	臺北市內湖區康寧路3段269號	121.61111	25.06632
內湖區	樂康里	東湖分隊	105-G07	AAB-855	東湖-2	第2車	1910	1920	臺北市內湖區康樂街12號對面	121.61779	25.06812
內湖區	內溝里	東湖分隊	105-G07	AAB-855	東湖-2	第2車	1925	1930	臺北市內湖區康樂街201巷9號對面	121.62237	25.07555
內湖區	內溝里	東湖分隊	105-G07	AAB-855	東湖-2	第2車	1932	1940	臺北市內湖區康樂街180號	121.62027	25.07564
內湖區	樂康里	東湖分隊	105-G07	AAB-855	東湖-2	第2車	1945	1950	臺北市內湖區康樂街150號	121.61919	25.07244
內湖區	東湖里	東湖分隊	105-G07	AAB-855	東湖-2	第2車	1955	2000	臺北市內湖區東湖路121號	121.61646	25.06828
內湖區	安湖里	東湖分隊	105-G07	AAB-855	東湖-2	第2車	2001	2005	臺北市內湖區東湖路41號	121.61393	25.0689
內湖區	安湖里	東湖分隊	105-G07	AAB-855	東湖-2	第2車	2006	2007	臺北市內湖區東湖路9號(廚餘車不停)	121.6127	25.0689
內湖區	蘆洲里	東湖分隊	105-G07	AAB-855	東湖-2	第3車	2015	2040	臺北市內湖區安美街181號前200公尺	121.60283	25.06015
內湖區	葫洲里	東湖分隊	105-G07	AAB-855	東湖-2	第3車	2110	2113	臺北市內湖區民權東路6段280巷45弄32號	121.606	25.07021
內湖區	康寧里	東湖分隊	105-G07	AAB-855	東湖-2	第3車	2120	2130	臺北市內湖區康寧路3段189巷93弄26號旁	121.61148	25.07299
內湖區	明湖里	東湖分隊	105-G07	AAB-855	東湖-2	第3車	2132	2140	臺北市內湖區康寧路3段103號	121.60993	25.07148
內湖區	金湖里	東湖分隊	105-G07	AAB-855	東湖-2	第3車	2143	2145	臺北市內湖區金湖路268號(垃圾車)	121.60122	25.07554
內湖區	金湖里	東湖分隊	105-G07	AAB-855	東湖-2	第3車	2143	2148	臺北市內湖區金湖路363巷103號	121.59949	25.07298
內湖區	葫洲里	東湖分隊	105-G07	AAB-855	東湖-2	第3車	2150	2200	臺北市內湖區康寧路3段14號	121.60691	25.07274
文山區	景東里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1835	1838	臺北市文山區景興路261號旁	121.54323	24.99059
文山區	景東里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1840	1845	臺北市文山區景興路175號旁	121.54443	24.99298
文山區	景東里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1846	1851	臺北市文山區景興路151號前	121.5447	24.99385
文山區	景東里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1852	1857	臺北市文山區景興路125號前	121.54476	24.99464
文山區	景東里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1900	1910	臺北市文山區景華街124號前	121.54687	24.99567
文山區	興得里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1920	1923	臺北市文山區辛亥路5段75號前	121.55313	24.99805
文山區	興得里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1923	1928	臺北市文山區辛亥路5段19號前	121.55424	24.99963
文山區	興得里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1929	1934	臺北市文山區興隆路3段56號前	121.55532	24.99904
文山區	興得里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1935	1940	臺北市文山區興隆路3段110號前	121.5573	24.99929
文山區	興得里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1941	1943	臺北市文山區興隆路3段154號前	121.55832	24.99846
文山區	興得里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1943	1947	臺北市文山區興隆路3段190號前	121.55878	24.99803
文山區	興得里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1948	1950	臺北市文山區興隆路3段292號前	121.55966	24.9956
文山區	興得里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1951	1953	臺北市文山區興隆路3段304巷3號前	121.55841	24.99321
文山區	興得里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1953	1955	臺北市文山區興隆路3段304巷47號前	121.55735	24.9949
文山區	興得里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1955	1958	臺北市文山區興隆路3段304巷141號旁	121.5554	24.9957
文山區	興得里	興隆分隊	105-G08	AAB-856	興隆-1	第1車	1958	2000	臺北市文山區興隆路3段304巷38號前	121.55783	24.99481
文山區	興泰里	興隆分隊	105-G08	AAB-856	興隆-1	第2車	2130	2131	臺北市文山區辛亥路4段106號前	121.55772	25.00595
文山區	興泰里	興隆分隊	105-G08	AAB-856	興隆-1	第2車	2131	2133	臺北市文山區辛亥路4段128號前	121.5571	25.00548
文山區	興泰里	興隆分隊	105-G08	AAB-856	興隆-1	第2車	2133	2137	臺北市文山區辛亥路4段168號前	121.55622	25.0037
文山區	興泰里	興隆分隊	105-G08	AAB-856	興隆-1	第2車	2137	2142	臺北市文山區辛亥路4段220號前	121.55536	25.00237
文山區	興泰里	興隆分隊	105-G08	AAB-856	興隆-1	第2車	2142	2146	臺北市文山區辛亥路4段250號前	121.55489	25.00152
文山區	興福里	興隆分隊	105-G08	AAB-856	興隆-1	第2車	2157	2202	臺北市文山區景華街95號前	121.54471	24.99514
文山區	興福里	興隆分隊	105-G08	AAB-856	興隆-1	第2車	2203	2205	臺北市文山區景興路93號前	121.54484	24.99562
文山區	興福里	興隆分隊	105-G08	AAB-856	興隆-1	第2車	2206	2210	臺北市文山區景興路51號前	121.54489	24.9969
文山區	興福里	興隆分隊	105-G08	AAB-856	興隆-1	第2車	2210	2212	臺北市文山區景興路15號前	121.54473	24.99807
文山區	興福里	興隆分隊	105-G08	AAB-856	興隆-1	第2車	2212	2216	臺北市文山區興隆路2段2號前	121.5452	24.99874
文山區	興安里	興隆分隊	105-G08	AAB-856	興隆-1	第2車	2217	2221	臺北市文山區興隆路2段48號前	121.54749	24.99925
文山區	興安里	興隆分隊	105-G08	AAB-856	興隆-1	第2車	2221	2224	臺北市文山區興隆路2段78號前	121.54669	24.99921
大安區	住安里	瑞安分隊	105-G09	AAB-857	瑞安-1	第1車	1810	1815	臺北市大安區信義路4段74號前	121.54706	25.03319
大安區	龍雲里	瑞安分隊	105-G09	AAB-857	瑞安-1	第1車	1830	1836	臺北市大安區四維路160巷2號旁	121.54799	25.02874
大安區	龍雲里	瑞安分隊	105-G09	AAB-857	瑞安-1	第1車	1845	1850	臺北市大安區敦化南路2段62號旁	121.54853	25.02994
大安區	龍雲里	瑞安分隊	105-G09	AAB-857	瑞安-1	第1車	1851	1900	臺北市大安區四維路與四維路154巷交叉口前	121.54797	25.03097
大安區	龍圖里	瑞安分隊	105-G09	AAB-857	瑞安-1	第1車	1915	1920	臺北市大安區信義路3段140號旁(美國在台協會)	121.54024	25.03336
大安區	龍圖里	瑞安分隊	105-G09	AAB-857	瑞安-1	第1車	1921	1928	臺北市大安區信義路3段168號	121.54193	25.0333
大安區	龍圖里	瑞安分隊	105-G09	AAB-857	瑞安-1	第1車	1930	1935	臺北市大安區復興南路2段10號	121.5435	25.03277
大安區	龍圖里	瑞安分隊	105-G09	AAB-857	瑞安-1	第1車	1936	1940	臺北市大安區復興南路2段80號前	121.54345	25.03103
大安區	龍雲里	瑞安分隊	105-G09	AAB-857	瑞安-1	第2車	2050	2058	臺北市大安區大安路2段99號	121.54603	25.02935
大安區	住安里	瑞安分隊	105-G09	AAB-857	瑞安-1	第2車	2100	2115	臺北市大安區大安路2段63號前	121.54608	25.03096
大安區	住安里	瑞安分隊	105-G09	AAB-857	瑞安-1	第2車	2116	2123	臺北市大安區復興南路2段45號前	121.54364	25.03133
大安區	住安里	瑞安分隊	105-G09	AAB-857	瑞安-1	第2車	2124	2130	臺北市大安區復興南路2段13號前	121.54367	25.03257
大安區	住安里	瑞安分隊	105-G09	AAB-857	瑞安-1	第2車	2132	2145	臺北市大安區信義路4段60號前(信維市場)	121.54548	25.03322
大安區	德安里	瑞安分隊	105-G09	AAB-857	瑞安-1	第2車	2152	2204	臺北市大安區大安路1段205號前	121.54602	25.03533
大安區	德安里	瑞安分隊	105-G09	AAB-857	瑞安-1	第2車	2205	2215	臺北市大安區大安路1段177號旁（仁愛公園）	121.546	25.03681
北投區	中心里	光明分隊	105-G10	AAB-858	光明-1	第1車	1640	1646	臺北市北投區泉源路12號前	121.50411	25.13682
北投區	中心里	光明分隊	105-G10	AAB-858	光明-1	第1車	1647	1651	臺北市北投區光明路197號前	121.50353	25.13599
北投區	中心里	光明分隊	105-G10	AAB-858	光明-1	第1車	1652	1656	臺北市北投區光明路157巷口	121.50255	25.13536
北投區	長安里	光明分隊	105-G10	AAB-858	光明-1	第1車	1657	1701	臺北市北投區光明路131巷口	121.50161	25.13428
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第1車	1702	1711	臺北市北投區磺港路新市街口	121.50256	25.13312
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第1車	1712	1714	臺北市北投區磺港路清江路25巷口	121.50346	25.13177
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第1車	1714	1717	臺北市北投區磺港路大興街口	121.49955	25.13045
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第1車	1719	1721	臺北市北投區磺港路126號前	121.50318	25.12949
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第1車	1722	1724	臺北市北投區磺港路148號前	121.50305	25.12887
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第1車	1725	1730	臺北市北投區磺港路三合街2段口	121.50328	25.12671
北投區	八仙里	光明分隊	105-G10	AAB-858	光明-1	第1車	1731	1733	臺北市北投區磺港路崇仁路口	121.50295	25.12316
北投區	中心里	光明分隊	105-G10	AAB-858	光明-1	第2車	1803	1806	臺北市北投區中和街40號	121.50276	25.13839
北投區	開明里	光明分隊	105-G10	AAB-858	光明-1	第2車	1809	1811	臺北市北投區復興一路33巷口	121.50235	25.14036
北投區	開明里	光明分隊	105-G10	AAB-858	光明-1	第2車	1812	1814	臺北市北投區永興路2段33巷口	121.50181	25.14007
北投區	開明里	光明分隊	105-G10	AAB-858	光明-1	第2車	1815	1818	臺北市北投區中和街永興路口	121.49916	25.14161
北投區	開明里	光明分隊	105-G10	AAB-858	光明-1	第2車	1819	1824	臺北市北投區中和街292巷口	121.50024	25.14055
北投區	中和里	光明分隊	105-G10	AAB-858	光明-1	第2車	1825	1828	臺北市北投區復興四路大同街口	121.49946	25.14129
北投區	中庸里	光明分隊	105-G10	AAB-858	光明-1	第2車	1829	1831	臺北市北投區大同街228巷口	121.49936	25.13922
北投區	中庸里	光明分隊	105-G10	AAB-858	光明-1	第2車	1832	1834	臺北市北投區大同街永興路口	121.49919	25.13854
北投區	中庸里	光明分隊	105-G10	AAB-858	光明-1	第2車	1835	1836	臺北市北投區永興路1段32巷口	121.5001	25.13917
北投區	中庸里	光明分隊	105-G10	AAB-858	光明-1	第2車	1837	1838	臺北市北投區永興路中和街口	121.50099	25.13975
北投區	中庸里	光明分隊	105-G10	AAB-858	光明-1	第2車	1839	1845	臺北市北投區中和街雙全街口	121.50145	25.13929
北投區	中庸里	光明分隊	105-G10	AAB-858	光明-1	第2車	1846	1850	臺北市北投區中和街57巷口	121.50214	25.13864
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第3車	1930	1933	臺北市北投區清江路中央南路口	121.50131	25.13181
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第3車	1933	1937	臺北市北投區清江路新市街口	121.50179	25.13149
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第3車	1938	1941	臺北市北投區清江路大興街口	121.50199	25.1308
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第3車	1942	1944	臺北市北投區清江路96號前	121.50166	25.1299
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第3車	1945	1948	臺北市北投區清江路113巷口	121.50185	25.12937
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第3車	1949	1950	臺北市北投區清江路151巷口	121.50193	25.12872
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第3車	1951	1952	臺北市北投區清江路177巷口	121.50188	25.12806
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第3車	1953	1954	臺北市北投區清江路206號前	121.50181	25.12739
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第3車	1956	2000	臺北市北投區清江路三合街2段口	121.50212	25.12653
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第3車	2001	2004	臺北市北投區崇仁路1段100巷口	121.50163	25.1258
北投區	清江里	光明分隊	105-G10	AAB-858	光明-1	第3車	2005	2008	臺北市北投區崇仁路1段忠義新村	121.50171	25.12562
北投區	八仙里	光明分隊	105-G10	AAB-858	光明-1	第3車	2009	2011	臺北市北投區崇仁路1段156巷口	121.50217	25.12365
北投區	八仙里	光明分隊	105-G10	AAB-858	光明-1	第3車	2012	2013	臺北市北投區崇仁路1段158巷口	121.50214	25.12339
北投區	八仙里	光明分隊	105-G10	AAB-858	光明-1	第3車	2014	2015	臺北市北投區崇仁路1段公?路口	121.5029	25.12269
北投區	中和里	光明分隊	105-G10	AAB-858	光明-1	第4車	2100	2104	臺北市北投區中和街380號前	121.49916	25.14161
北投區	中和里	光明分隊	105-G10	AAB-858	光明-1	第4車	2105	2109	臺北市北投區中和街390巷口	121.4983	25.1432
北投區	智仁里	光明分隊	105-G10	AAB-858	光明-1	第4車	2110	2113	臺北市北投區中和街441巷1弄1號	121.49758	25.14386
北投區	智仁里	光明分隊	105-G10	AAB-858	光明-1	第4車	2114	2116	臺北市北投區中和街441巷3弄口	121.4974	25.14361
北投區	智仁里	光明分隊	105-G10	AAB-858	光明-1	第4車	2117	2118	臺北市北投區中和街441巷7弄口	121.4974	25.14361
北投區	智仁里	光明分隊	105-G10	AAB-858	光明-1	第4車	2119	2120	臺北市北投區杏林二路口	121.5166	25.138
北投區	智仁里	光明分隊	105-G10	AAB-858	光明-1	第4車	2121	2123	臺北市北投區杏林二路74巷10號前	121.49609	25.14287
北投區	智仁里	光明分隊	105-G10	AAB-858	光明-1	第4車	2124	2125	臺北市北投區中和街455巷7弄口	121.49635	25.14367
北投區	智仁里	光明分隊	105-G10	AAB-858	光明-1	第4車	2126	2127	臺北市北投區中和街455巷1弄口	121.49662	25.14438
北投區	秀山里	光明分隊	105-G10	AAB-858	光明-1	第4車	2128	2130	臺北市北投區中和街458巷口	121.49598	25.14499
北投區	智仁里	光明分隊	105-G10	AAB-858	光明-1	第4車	2136	2145	臺北市北投區中和街474巷口	121.49527	25.14516
北投區	稻香里	光明分隊	105-G10	AAB-858	光明-1	第4車	2148	2155	臺北市北投區秀山路31號前	121.49312	25.14692
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第1車	1650	1658	臺北市中山區長安東路1段35號	121.31295	25.25688
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第1車	1700	1710	臺北市中山區南京東路1段86號	121.52557	25.05182
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第1車	1712	1722	臺北市中山區南京東路1段130號	121.52689	25.05186
中山區	正守里	中山分隊	105-G12	AAB-860	中山-1	第1車	1725	1730	臺北市中山區新生北路1段78號前	121.5301652	25.047427
中山區	正守里	中山分隊	105-G12	AAB-860	中山-1	第1車	1736	1741	臺北市中山區市民大道2段71號	121.52952	25.04669
中山區	正守里	中山分隊	105-G12	AAB-860	中山-1	第1車	1745	1755	臺北市中山區長安東路1段52巷7弄華山公園旁	121.52789	25.04789
中山區	正守里	中山分隊	105-G12	AAB-860	中山-1	第1車	1806	1821	臺北市中山區長安東路1段34號	121.52634	25.04864
中山區	正守里	中山分隊	105-G12	AAB-860	中山-1	第1車	1822	1830	臺北市中山區長安東路1段54號〈正守公園〉	121.52834	25.04814
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第2車	2020	2028	臺北市中山區林森北路109號	121.52514	25.05038
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第2車	2029	2037	臺北市中山區林森北路131號	121.52523	25.051
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第2車	2041	2049	臺北市中山區新生北路1段130號前	121.5277	25.05093
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第2車	2050	2058	臺北市中山區新生北路1段114號	121.52789	25.05056
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第2車	2059	2107	臺北市中山區長安東路1段75-1號	121.52809	25.04849
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第2車	2108	2116	臺北市中山區長安東路1段51-5號	121.31347	25.25574
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第2車	2117	2125	臺北市中山區長安東路1段41-4號	121.5254	25.04911
中山區	正守里	中山分隊	105-G12	AAB-860	中山-1	第2車	2131	2140	臺北市中山區長安東路1段54號〈正守公園〉	121.52834	25.04814
中山區	正守里	中山分隊	105-G12	AAB-860	中山-1	第2車	2141	2150	臺北市中山區新生北路1段78號前	121.53	25.04732
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第2車	2153	2156	臺北市中山區林森北路87號	121.52499	25.04984
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第2車	2157	2200	臺北市中山區林森北路117號	121.52514	25.05063
中山區	正義里	中山分隊	105-G12	AAB-860	中山-1	第2車	2201	2205	臺北市中山區林森北路149號	121.52543	25.05147
中山區	中央里	南京分隊	105-G13	AAB-861	南京-3	第1車	1650	1659	臺北市中山區伊通街94號(四平公園)	121.53478	25.05324
中山區	復華里	南京分隊	105-G13	AAB-861	南京-3	第1車	1700	1708	臺北市中山區長春路256號前	121.53875	25.05471
中山區	復華里	南京分隊	105-G13	AAB-861	南京-3	第1車	1710	1720	臺北市中山區龍江路118號旁	121.54041	25.05338
中山區	復華里	南京分隊	105-G13	AAB-861	南京-3	第1車	1722	1730	臺北市中山區南京東路3段103號前	121.53954	25.05225
中山區	復華里	南京分隊	105-G13	AAB-861	南京-3	第1車	1731	1739	臺北市中山區南京東路3段91號前	121.53925	25.05198
中山區	復華里	南京分隊	105-G13	AAB-861	南京-3	第1車	1740	1745	臺北市中山區建國北路2段1號前	121.53715	25.05238
中山區	復華里	南京分隊	105-G13	AAB-861	南京-3	第1車	1746	1750	臺北市中山區建國北路2段13號前	121.53712	25.05379
中山區	復華里	南京分隊	105-G13	AAB-861	南京-3	第2車	1920	1927	臺北市中山區長春路400號	121.54349	25.05455
中山區	復華里	南京分隊	105-G13	AAB-861	南京-3	第2車	1929	1937	臺北市中山區復興北路152號	121.54382	25.05287
中山區	復華里	南京分隊	105-G13	AAB-861	南京-3	第2車	1940	1953	臺北市中山區龍江路159號前	121.54055	25.05438
中山區	復華里	南京分隊	105-G13	AAB-861	南京-3	第2車	1954	2002	臺北市中山區長春路350號	121.54174	25.05456
中山區	復華里	南京分隊	105-G13	AAB-861	南京-3	第2車	2003	2010	臺北市中山區遼寧街130號前	121.54196	25.05341
中山區	中央里	南京分隊	105-G13	AAB-861	南京-3	第3車	2125	2130	臺北市中山區建國北路2段88號前	121.53668	25.05625
中山區	中央里	南京分隊	105-G13	AAB-861	南京-3	第3車	2131	2138	臺北市中山區建國北路2段66號前	121.53663	25.05453
中山區	中央里	南京分隊	105-G13	AAB-861	南京-3	第3車	2139	2145	臺北市中山區建國北路2段38號前	121.53659	25.05349
中山區	中央里	南京分隊	105-G13	AAB-861	南京-3	第3車	2146	2208	臺北市中山區伊通街94號(四平公園)	121.53478	25.05324
中山區	中央里	南京分隊	105-G13	AAB-861	南京-3	第3車	2209	2214	臺北市中山區松江路173巷旁	121.53323	25.05592
大安區	龍泉里	和平分隊	105-G14	AAB-862	和平-2	第1車	1755	1808	臺北市大安區和平東路1段178號	121.52934	25.02646
大安區	龍坡里	和平分隊	105-G14	AAB-862	和平-2	第1車	1810	1820	臺北市大安區和平東路1段212號	121.53164	25.02625
大安區	龍坡里	和平分隊	105-G14	AAB-862	和平-2	第1車	1822	1830	臺北市大安區和平東路1段266號	121.53367	25.02609
大安區	龍坡里	和平分隊	105-G14	AAB-862	和平-2	第1車	1834	1840	臺北市大安區新生南路3段16-1號	121.53462	25.02448
大安區	龍坡里	和平分隊	105-G14	AAB-862	和平-2	第1車	1845	1905	臺北市大安區泰順街38之1號	121.53437	25.02481
大安區	龍坡里	和平分隊	105-G14	AAB-862	和平-2	第2車	2020	2030	臺北市大安區辛亥路1段137號前	121.53249	25.02247
大安區	古莊里	和平分隊	105-G14	AAB-862	和平-2	第2車	2035	2043	臺北市大安區羅斯福路3段105號	121.52635	25.02243
大安區	古莊里	和平分隊	105-G14	AAB-862	和平-2	第2車	2045	2055	臺北市大安區羅斯福路3段19號	121.52475	25.0238
大安區	古莊里	和平分隊	105-G14	AAB-862	和平-2	第2車	2057	2105	臺北市大安區羅斯福路2段79號前	121.52347	25.02584
大安區	古莊里	和平分隊	105-G14	AAB-862	和平-2	第2車	2108	2113	臺北市大安區和平東路1段14號前	121.52342	25.02694
大安區	古莊里	和平分隊	105-G14	AAB-862	和平-2	第2車	2115	2120	臺北市大安區和平東路1段104巷口	121.52502	25.02681
大安區	古莊里	和平分隊	105-G14	AAB-862	和平-2	第3車	2238	2305	臺北市大安區師大路71號對面	121.52849	25.02365
大安區	敦安里	安和分隊	105-G15	AAB-863	安和-1	第1車	1800	1810	臺北市大安區敦化南路1段303之1號前	121.54905	25.03526
大安區	敦安里	安和分隊	105-G15	AAB-863	安和-1	第1車	1810	1815	臺北市大安區敦化南路1段263號前	121.54915	25.03655
大安區	敦煌里	安和分隊	105-G15	AAB-863	安和-1	第1車	1815	1820	臺北市大安區仁愛路4段232號前	121.55224	25.03757
大安區	光信里	安和分隊	105-G15	AAB-863	安和-1	第1車	1820	1825	臺北市大安區仁愛路4段378號前	121.55587	25.03752
大安區	光信里	安和分隊	105-G15	AAB-863	安和-1	第1車	1825	1830	臺北市大安區仁愛路4段410號前	121.55704	25.03749
大安區	敦安里	安和分隊	105-G15	AAB-863	安和-1	第2車	2000	2005	臺北市大安區信義路4段165號前	121.55065	25.03335
大安區	敦安里	安和分隊	105-G15	AAB-863	安和-1	第2車	2005	2015	臺北市大安區信義路4段203號前	121.55162	25.03332
大安區	敦煌里	安和分隊	105-G15	AAB-863	安和-1	第2車	2015	2020	臺北市大安區信義路4段225號前	121.55256	25.03326
大安區	敦煌里	安和分隊	105-G15	AAB-863	安和-1	第2車	2020	2025	臺北市大安區信義路4段307號前	121.5558	25.03323
大安區	光信里	安和分隊	105-G15	AAB-863	安和-1	第2車	2028	2035	臺北市大安區延吉街256號前	121.5564	25.03417
大安區	光信里	安和分隊	105-G15	AAB-863	安和-1	第2車	2035	2038	臺北市大安區延吉街241巷2弄17號光信公園前	121.55571	25.03566
大安區	光信里	安和分隊	105-G15	AAB-863	安和-1	第2車	2040	2050	臺北市大安區光復南路422號前	121.5574	25.03643
大安區	全安里	安和分隊	105-G15	AAB-863	安和-1	第3車	2215	2220	臺北市大安區安和路2段225號前	121.55018	25.02538
大安區	法治里	安和分隊	105-G15	AAB-863	安和-1	第3車	2230	2245	臺北市大安區通化街167號前	121.55385	25.0283
大安區	通化里	安和分隊	105-G15	AAB-863	安和-1	第3車	2245	2255	臺北市大安區通化街17-5號前	121.55429	25.03183
大同區	永樂里	延平分隊	106-G01	KEA-0290	延平-1	第1車	1616	1619	臺北市大同區南京西路迪化街口	121.51022	25.05382
大同區	永樂里	延平分隊	106-G01	KEA-0290	延平-1	第1車	1620	1623	臺北市大同區迪化街1段42號	121.51006	25.05488
大同區	永樂里	延平分隊	106-G01	KEA-0290	延平-1	第1車	1624	1627	臺北市大同區迪化街1段21號	121.51006	25.05504
大同區	永樂里	延平分隊	106-G01	KEA-0290	延平-1	第1車	1628	1631	臺北市大同區迪化街1段63號第一銀行	121.50998	25.05569
大同區	永樂里	延平分隊	106-G01	KEA-0290	延平-1	第1車	1633	1636	臺北市大同區迪化街、民生西路口	121.50986	25.05681
大同區	永樂里	延平分隊	106-G01	KEA-0290	延平-1	第1車	1637	1639	臺北市大同區民生西路、民樂街口	121.51091	25.05691
大同區	永樂里	延平分隊	106-G01	KEA-0290	延平-1	第1車	1641	1644	臺北市大同區民生西路304號	121.51231	25.05694
大同區	永樂里	延平分隊	106-G01	KEA-0290	延平-1	第1車	1646	1649	臺北市大同區民生西路286號	121.51293	25.05696
大同區	朝陽里	延平分隊	106-G01	KEA-0290	延平-1	第1車	1652	1656	臺北市大同區重慶北路2段64巷口	121.51384	25.0559
大同區	朝陽里	延平分隊	106-G01	KEA-0290	延平-1	第1車	1658	1703	臺北市大同區重慶北路2段46巷口	121.51398	25.05533
大同區	建功里	延平分隊	106-G01	KEA-0290	延平-1	第1車	1706	1709	臺北市大同區天水路27號	121.51314	25.05293
大同區	朝陽里	延平分隊	106-G01	KEA-0290	延平-1	第1車	1710	1713	臺北市大同區天水路53號	121.51265	25.05262
大同區	玉泉里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1855	1858	臺北市大同區南京西路貴德街口	121.50811	25.05355
大同區	玉泉里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1859	1902	臺北市大同區南京西路434巷口	121.50899	25.05334
大同區	玉泉里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1903	1906	臺北市大同區南京西路412巷口	121.50926	25.05332
大同區	玉泉里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1909	1912	臺北市大同區塔城街50巷口	121.51037	25.05243
大同區	玉泉里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1914	1917	臺北市大同區塔城街7號	121.51055	25.05039
大同區	永樂里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1920	1923	臺北市大同區南京西路354號	121.51126	25.05382
大同區	朝陽里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1925	1928	臺北市大同區南京西路344巷口	121.51223	25.05391
大同區	建功里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1929	1932	臺北市大同區南京西路華亭街口	121.51315	25.05397
大同區	建功里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1933	1936	臺北市大同區南京西路302巷口	121.51359	25.054
大同區	建功里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1938	1941	臺北市大同區重慶北路1段62號	121.51388	25.05192
大同區	建功里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1943	1947	臺北市大同區重慶北路1段26巷口	121.51357	25.05061
大同區	建功里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1952	1955	臺北市大同區長安西路298號	121.51253	25.05192
大同區	建功里	延平分隊	106-G01	KEA-0290	延平-1	第2車	1956	1959	臺北市大同區長安西路258號	121.51332	25.05173
大同區	南芳里	延平分隊	106-G01	KEA-0290	延平-1	第3車	2120	2124	臺北市大同區延平北路2段272巷口	121.51124	25.06207
大同區	大有里	延平分隊	106-G01	KEA-0290	延平-1	第3車	2126	2129	臺北市大同區延平北路2段250巷口	121.51136	25.06013
大同區	大有里	延平分隊	106-G01	KEA-0290	延平-1	第3車	2130	2133	臺北市大同區延平北路2段210巷口	121.51141	25.05918
大同區	延平里	延平分隊	106-G01	KEA-0290	延平-1	第3車	2135	2137	臺北市大同區延平北路2段225號	121.51141	25.06014
大同區	南芳里	延平分隊	106-G01	KEA-0290	延平-1	第3車	2141	2144	臺北市大同區民權西路250巷口	121.51274	25.06282
大同區	南芳里	延平分隊	106-G01	KEA-0290	延平-1	第3車	2151	2154	臺北市大同區涼州街安西街口永樂國小	121.50997	25.06062
大同區	南芳里	延平分隊	106-G01	KEA-0290	延平-1	第3車	2156	2158	臺北市大同區環河北路1段365號	121.509	25.0611
大同區	南芳里	延平分隊	106-G01	KEA-0290	延平-1	第3車	2200	2203	臺北市大同區環河北路1段413巷口	121.50872	25.06218
大同區	民權里	建成分隊	106-G02	KEA-0291	建成-2	第1車	1620	1625	臺北市大同區民權西路144巷8號	121.5159	25.06225
大同區	雙連里	建成分隊	106-G02	KEA-0291	建成-2	第1車	1630	1634	臺北市大同區錦西街120之1號、興城街口	121.51695	25.0601
大同區	雙連里	建成分隊	106-G02	KEA-0291	建成-2	第1車	1635	1636	臺北市大同區承德路2段134號（臨停）	121.51809	25.05947
大同區	雙連里	建成分隊	106-G02	KEA-0291	建成-2	第1車	1637	1642	臺北市大同區承德路2段106號萬全街口	121.51806	25.05849
大同區	星明里	建成分隊	106-G02	KEA-0291	建成-2	第1車	1643	1647	臺北市大同區承德路2段30號	121.51806	25.05576
大同區	光能里	建成分隊	106-G02	KEA-0291	建成-2	第1車	1649	1654	臺北市大同區承德路2段3號(建成公園)	121.51799	25.05379
大同區	光能里	建成分隊	106-G02	KEA-0291	建成-2	第1車	1655	1659	臺北市大同區承德路2段39號	121.51831	25.05501
大同區	光能里	建成分隊	106-G02	KEA-0291	建成-2	第1車	1700	1709	臺北市大同區承德路2段91巷口	121.5183	25.05616
大同區	雙連里	建成分隊	106-G02	KEA-0291	建成-2	第1車	1710	1714	臺北市大同區承德路2段173號前	121.51829	25.05877
大同區	雙連里	建成分隊	106-G02	KEA-0291	建成-2	第2車	1910	1915	臺北市大同區民生西路63號	121.52014	25.05767
大同區	雙連里	建成分隊	106-G02	KEA-0291	建成-2	第2車	1916	1920	臺北市大同區萬全街5號	121.52002	25.05935
大同區	雙連里	建成分隊	106-G02	KEA-0291	建成-2	第2車	1921	1923	臺北市大同區萬全街3巷16號之1	121.51994	25.05998
大同區	雙連里	建成分隊	106-G02	KEA-0291	建成-2	第2車	1924	1925	臺北市大同區錦西街52巷13號	121.51991	25.06026
大同區	民權里	建成分隊	106-G02	KEA-0291	建成-2	第2車	1929	1935	臺北市大同區民權西路144巷19弄、雙連國小後	121.51593	25.06164
大同區	民權里	建成分隊	106-G02	KEA-0291	建成-2	第2車	1936	1940	臺北市大同區錦西街53巷口	121.51585	25.05984
大同區	民權里	建成分隊	106-G02	KEA-0291	建成-2	第2車	1941	1945	臺北市大同區保安街1之4號財福大樓	121.51416	25.05934
大同區	民權里	建成分隊	106-G02	KEA-0291	建成-2	第2車	1946	1948	臺北市大同區重慶北路2段189號	121.51368	25.05995
大同區	民權里	建成分隊	106-G02	KEA-0291	建成-2	第2車	1949	1955	臺北市大同區寧夏路161、163號間對面	121.51423	25.0613
大同區	民權里	建成分隊	106-G02	KEA-0291	建成-2	第2車	1956	1958	臺北市大同區民權西路190號、蘭州街44號口	121.51462	25.06264
大同區	民權里	建成分隊	106-G02	KEA-0291	建成-2	第2車	1959	2003	臺北市大同區民權西路120號	121.51694	25.06281
大同區	雙連里	建成分隊	106-G02	KEA-0291	建成-2	第2車	2012	2016	臺北市大同區重慶北路2段民生西路口	121.51388	25.05708
大同區	雙連里	建成分隊	106-G02	KEA-0291	建成-2	第2車	2017	2020	臺北市大同區重慶北路2段歸綏街口	121.51377	25.05826
大同區	建泰里	建成分隊	106-G02	KEA-0291	建成-2	第3車	2135	2140	臺北市大同區南京西路64巷口	121.51896	25.05289
大同區	建泰里	建成分隊	106-G02	KEA-0291	建成-2	第3車	2141	2143	臺北市大同區南京西路32號捷運邊	121.52021	25.05259
大同區	建泰里	建成分隊	106-G02	KEA-0291	建成-2	第3車	2146	2150	臺北市大同區長安西路當代藝術館	121.5195	25.05036
大同區	建泰里	建成分隊	106-G02	KEA-0291	建成-2	第3車	2151	2155	臺北市大同區長安西路53巷口	121.51749	25.05089
大同區	建泰里	建成分隊	106-G02	KEA-0291	建成-2	第3車	2156	2159	臺北市大同區承德路1段41巷口	121.5173	25.05132
大同區	建泰里	建成分隊	106-G02	KEA-0291	建成-2	第3車	2200	2203	臺北市大同區承德路1段77巷口	121.51758	25.05234
大同區	光能里	建成分隊	106-G02	KEA-0291	建成-2	第3車	2204	2207	臺北市大同區承德路2段3號建成公園	121.51798	25.05378
大同區	光能里	建成分隊	106-G02	KEA-0291	建成-2	第3車	2208	2210	臺北市大同區承德路2段39號	121.51833	25.05463
大同區	星明里	建成分隊	106-G02	KEA-0291	建成-2	第3車	2212	2215	臺北市大同區太原路156之6號、平陽街口	121.51644	25.05498
大同區	星明里	建成分隊	106-G02	KEA-0291	建成-2	第3車	2216	2218	臺北市大同區南京西路107巷口	121.51566	25.05384
大同區	星明里	建成分隊	106-G02	KEA-0291	建成-2	第3車	2219	2222	臺北市大同區重慶北路2段59號	121.51417	25.05552
大同區	星明里	建成分隊	106-G02	KEA-0291	建成-2	第3車	2223	2227	臺北市大同區重慶北路2段73巷口	121.51405	25.05603
大同區	南芳里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1630	1632	臺北市大同區重慶北路2段190號	121.51341	25.06244
大同區	延平里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1634	1635	臺北市大同區重慶北路2段保安街口	121.51356	25.05927
大同區	延平里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1637	1639	臺北市大同區民生西路295號	121.51305	25.0571
大同區	延平里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1640	1642	臺北市大同區民生西路335號	121.51141	25.05708
大同區	延平里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1644	1646	臺北市大同區延平北路2段171號	121.51159	25.05852
大同區	延平里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1647	1649	臺北市大同區延平北路2段225號	121.51152	25.06014
大同區	南芳里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1651	1655	臺北市大同區延平北路2段247號	121.51137	25.06244
大同區	國順里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1700	1702	臺北市大同區環河北路2段、昌吉街口	121.50894	25.06584
大同區	國順里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1703	1704	臺北市大同區環河北路2段123巷口	121.50897	25.06671
大同區	國順里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1705	1707	臺北市大同區環河北路2段145巷口	121.509	25.06723
大同區	國順里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1708	1710	臺北市大同區環河北路2段161巷口	121.50906	25.06765
大同區	國順里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1711	1712	臺北市大同區環河北路2段185巷口	121.50912	25.06828
大同區	國順里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1713	1715	臺北市大同區民族西路322號	121.50998	25.06863
大同區	國慶里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1717	1720	臺北市大同區民族西路252巷口	121.5122	25.06859
大同區	國慶里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第1車	1722	1725	臺北市大同區重慶北路3段120巷45號	121.51238	25.06731
大同區	景星里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	1920	1922	臺北市大同區環河北路2段7號	121.50895	25.06368
大同區	景星里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	1923	1925	臺北市大同區環河北路2段47號	121.50886	25.06484
大同區	景星里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	1926	1930	臺北市大同區昌吉街、迪化街口	121.50942	25.06578
大同區	景星里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	1931	1933	臺北市大同區昌吉街230號	121.51048	25.06587
大同區	隆和里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	1935	1939	臺北市大同區昌吉街184號	121.51206	25.06586
大同區	隆和里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	1940	1942	臺北市大同區昌吉街152號	121.51317	25.06583
大同區	老師里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	1950	1953	臺北市大同區延平北路4段155號之1	121.51136	25.07293
大同區	老師里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	1954	1958	臺北市大同區延平北路4段157號	121.51136	25.07308
大同區	老師里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	1959	2004	臺北市大同區延平北路4段191號	121.51161	25.07388
大同區	老師里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	2005	2006	臺北市大同區延平北路4段231號	121.51194	25.07555
大同區	老師里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	2007	2008	臺北市大同區臺北市延平北路4段243號	121.51215	25.07629
大同區	老師里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	2009	2012	臺北市大同區延平北路4段282巷口	121.51198	25.07694
大同區	老師里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	2013	2018	臺北市大同區敦煌路175巷	121.51085	25.07665
大同區	老師里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第2車	2015	2018	臺北市大同區環河北路2段、敦煌路口合昌宮	121.50929	25.07728
大同區	鄰江里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第3車	2148	2155	臺北市大同區酒泉街140號	121.51222	25.07206
大同區	鄰江里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第3車	2157	2203	臺北市大同區民族西路225巷口	121.51211	25.06875
大同區	鄰江里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第3車	2204	2209	臺北市大同區民族西路303巷口	121.51012	25.06872
大同區	鄰江里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第3車	2210	2211	臺北市大同區環河北路2段205巷口	121.50931	25.06923
大同區	鄰江里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第3車	2212	2213	臺北市大同區環河北路2段213巷口	121.5093	25.06973
大同區	鄰江里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第3車	2214	2215	臺北市大同區環河北路2段261號	121.50942	25.07018
大同區	鄰江里	蘭州分隊	106-G04	KEA-0293	蘭州-2	第3車	2216	2218	臺北市大同區延平北路4段102巷75號	121.50934	25.07167
萬華區	福星里	武昌分隊	106-G05	KEA-0295	武昌-1	第1車	1630	1633	臺北市萬華區西寧南路7號	121.50752	25.04833
萬華區	福星里	武昌分隊	106-G05	KEA-0295	武昌-1	第1車	1635	1640	臺北市萬華區洛陽街33號	121.50843	25.04741
萬華區	福星里	武昌分隊	106-G05	KEA-0295	武昌-1	第1車	1642	1647	臺北市萬華區開封街2段二號	121.5089	25.04607
萬華區	福星里	武昌分隊	106-G05	KEA-0295	武昌-1	第1車	1648	1653	臺北市萬華區開封街2段36號	121.50786	25.04629
萬華區	福星里	武昌分隊	106-G05	KEA-0295	武昌-1	第1車	1654	1705	臺北市萬華區開封街2段63號對面	121.50531	25.0471
萬華區	福星里	武昌分隊	106-G05	KEA-0295	武昌-1	第1車	1706	1709	臺北市萬華區環河南路1段224號	121.50329	25.0464
萬華區	萬壽里	武昌分隊	106-G05	KEA-0295	武昌-1	第1車	1711	1715	臺北市萬華區康定路14號	121.50309	25.0455
萬華區	菜園里	武昌分隊	106-G05	KEA-0295	武昌-1	第1車	1716	1722	臺北市萬華區康定路28號	121.50265	25.04424
萬華區	菜園里	武昌分隊	106-G05	KEA-0295	武昌-1	第1車	1723	1730	臺北市萬華區康定路56號	121.50151	25.04276
萬華區	富民里	武昌分隊	106-G05	KEA-0295	武昌-1	第1車	1732	1737	臺北市萬華區康定路188號	121.50184	25.03896
萬華區	菜園里	武昌分隊	106-G05	KEA-0295	武昌-1	第2車	1855	1858	臺北市萬華區環河南路1段81號	121.50111	25.04417
萬華區	萬壽里	武昌分隊	106-G05	KEA-0295	武昌-1	第2車	1859	1903	臺北市萬華區環河南路1段71號前	121.50197	25.04505
萬華區	萬壽里	武昌分隊	106-G05	KEA-0295	武昌-1	第2車	1905	1910	臺北市萬華區漢口街2段90號	121.50437	25.04617
萬華區	福星里	武昌分隊	106-G05	KEA-0295	武昌-1	第2車	1913	1916	臺北市萬華區昆明街34號對面	121.50601	25.04702
萬華區	福星里	武昌分隊	106-G05	KEA-0295	武昌-1	第2車	1917	1927	臺北市萬華區昆明街1號	121.50636	25.04821
萬華區	福星里	武昌分隊	106-G05	KEA-0295	武昌-1	第2車	1930	1935	臺北市萬華區西寧南路71巷口	121.5075	25.04599
萬華區	萬壽里	武昌分隊	106-G05	KEA-0295	武昌-1	第2車	1936	1941	臺北市萬華區西寧南路119號	121.5066	25.04493
萬華區	萬壽里	武昌分隊	106-G05	KEA-0295	武昌-1	第2車	1942	1946	臺北市萬華區西寧南路151號	121.50637	25.04382
萬華區	萬壽里	武昌分隊	106-G05	KEA-0295	武昌-1	第3車	2100	2105	臺北市萬華區漢口街2段54號對面	121.50586	25.04594
萬華區	萬壽里	武昌分隊	106-G05	KEA-0295	武昌-1	第3車	2106	2111	臺北市萬華區漢口街2段17號	121.5081	25.04547
萬華區	萬壽里	武昌分隊	106-G05	KEA-0295	武昌-1	第3車	2113	2118	臺北市萬華區中華路1段100號	121.50844	25.04417
萬華區	西門里	武昌分隊	106-G05	KEA-0295	武昌-1	第3車	2122	2130	臺北市萬華區成都路27號	121.50706	25.04258
萬華區	西門里	武昌分隊	106-G05	KEA-0295	武昌-1	第3車	2132	2138	臺北市萬華區成都路75號前	121.50553	25.04297
萬華區	萬壽里	武昌分隊	106-G05	KEA-0295	武昌-1	第3車	2141	2146	臺北市萬華區峨嵋街115號	121.50368	25.04444
萬華區	萬壽里	武昌分隊	106-G05	KEA-0295	武昌-1	第3車	2147	2152	臺北市萬華區昆明街100號對面	121.50492	25.04432
萬華區	萬壽里	武昌分隊	106-G05	KEA-0295	武昌-1	第3車	2153	2158	臺北市萬華區昆明街90號	121.5054	25.0452
松山區	復建里	中崙分隊	106-G06	KEA-0296	中崙-1	第1車	1715	1725	臺北市松山區光復南路6巷口	121.55774	25.0476
松山區	復建里	中崙分隊	106-G06	KEA-0296	中崙-1	第1車	1725	1740	臺北市松山區光復南路50號	121.55768	25.046
松山區	敦化里	中崙分隊	106-G06	KEA-0296	中崙-1	第1車	1750	1809	臺北市松山區敦化南路1段25號	121.54914	25.04624
松山區	敦化里	中崙分隊	106-G06	KEA-0296	中崙-1	第1車	1815	1830	臺北市松山區八德路3段10號	121.55076	25.04818
松山區	松基里	中崙分隊	106-G06	KEA-0296	中崙-1	第2車	2005	2020	臺北市松山區復興北路207號	121.54424	25.05617
松山區	中正里	中崙分隊	106-G06	KEA-0296	中崙-1	第2車	2025	2040	臺北市松山區慶城街21號	121.54501	25.05329
松山區	松基里	中崙分隊	106-G06	KEA-0296	中崙-1	第2車	2042	2050	臺北市松山區慶城街38號	121.54626	25.05457
松山區	中正里	中崙分隊	106-G06	KEA-0296	中崙-1	第2車	2100	2110	臺北市松山區敦化北路4巷1號	121.54748	25.04989
松山區	福成里	中崙分隊	106-G06	KEA-0296	中崙-1	第2車	2115	2130	臺北市松山區敦化南路1段102號	121.54865	25.04617
松山區	福成里	中崙分隊	106-G06	KEA-0296	中崙-1	第2車	2132	2145	臺北市松山區市民大道4段71號	121.54692	25.04526
松山區	東光里	東社分隊	106-G07	KEA-0297	東社-2	第1車	1725	1730	臺北市松山區三民路3巷口(西松國小)	121.56379	25.05296
松山區	東勢里	東社分隊	106-G07	KEA-0297	東社-2	第1車	1740	1755	臺北市松山區南京東路4段179巷口	121.55635	25.05168
松山區	東勢里	東社分隊	106-G07	KEA-0297	東社-2	第1車	1757	1810	臺北市松山區南京東路4段75巷口	121.55356	25.05177
松山區	中華里	東社分隊	106-G07	KEA-0297	東社-2	第1車	1812	1825	臺北市松山區南京東路4段53巷口	121.55101	25.05184
松山區	東光里	東社分隊	106-G07	KEA-0297	東社-2	第1車	1835	1855	臺北市松山區健康路170號旁(長壽公園)	121.55908	25.05377
松山區	中華里	東社分隊	106-G07	KEA-0297	東社-2	第2車	2025	2045	臺北市松山區敦化北路155巷66弄口	121.55124	25.05429
松山區	中華里	東社分隊	106-G07	KEA-0297	東社-2	第2車	2047	2055	臺北市松山區敦化北路155巷102號	121.55221	25.05426
松山區	龍田里	東社分隊	106-G07	KEA-0297	東社-2	第2車	2100	2115	臺北市松山區健康路45巷口	121.55495	25.05352
松山區	中華里	東社分隊	106-G07	KEA-0297	東社-2	第2車	2120	2135	臺北市松山區健康路44號(中華公園)	121.55261	25.05335
松山區	東勢里	東社分隊	106-G07	KEA-0297	東社-2	第2車	2140	2150	臺北市松山區南京東路4段131號	121.555	25.05171
松山區	龍田里	東社分隊	106-G07	KEA-0297	東社-2	第2車	2200	2210	臺北市松山區延壽街330巷6-2號	121.56024	25.05612
松山區	新聚里	松山分隊	106-G08	KEA-0298	松山-2	第1車	1720	1740	臺北市松山區八德路4段319號	121.56699	25.04914
松山區	復盛里	松山分隊	106-G08	KEA-0298	松山-2	第1車	1750	1807	臺北市松山區八德路4段70號	121.55998	25.04841
松山區	復盛里	松山分隊	106-G08	KEA-0298	松山-2	第1車	1812	1820	臺北市松山區八德路4段196號	121.56389	25.0488
松山區	復盛里	松山分隊	106-G08	KEA-0298	松山-2	第1車	1825	1830	臺北市松山區市民大道5段133號	121.5636	25.04761
松山區	復盛里	松山分隊	106-G08	KEA-0298	松山-2	第1車	1835	1840	臺北市松山區市民大道5段99號	121.56167	25.04684
松山區	復盛里	松山分隊	106-G08	KEA-0298	松山-2	第1車	1845	1905	臺北市松山區光復南路31號	121.55789	25.04665
松山區	吉祥里	松山分隊	106-G08	KEA-0298	松山-2	第2車	2035	2050	臺北市松山區吉祥路29號(中崙高中)	121.56252	25.04982
松山區	吉祥里	松山分隊	106-G08	KEA-0298	松山-2	第2車	2100	2110	臺北市松山區光復北路11巷76號旁	121.56095	25.05021
松山區	新聚里	松山分隊	106-G08	KEA-0298	松山-2	第2車	2130	2140	臺北市松山區東興路14號	121.56545	25.04929
松山區	吉祥里	松山分隊	106-G08	KEA-0298	松山-2	第2車	2145	2155	臺北市松山區八德路4段239號	121.56477	25.04892
信義區	松光里	福德分隊	106-G09	KEA-0299	福德-2	第2車	1830	1900	臺北市信義區林口街68號對面(林口公園)	121.57927	25.03871
信義區	松隆里	福德分隊	106-G09	KEA-0299	福德-2	第3車	2030	2045	臺北市信義區福德街20號對面(松山家商2號門前)	121.58052	25.03661
信義區	中坡里	福德分隊	106-G09	KEA-0299	福德-2	第3車	2047	2118	臺北市信義區福德街189號對面(福德公園)	121.58415	25.03819
信義區	松光里	福德分隊	106-G09	KEA-0299	福德-2	第3車	2120	2130	臺北市信義區林口街68號對面(林口公園)	121.57927	25.03871
信義區	松光里	福德分隊	106-G09	KEA-0299	福德-2	第3車	2131	2135	臺北市信義區林口街6號(松德市場)	121.57937	25.03674
信義區	黎順里	六張犁分隊	106-G10	KEA-0300	六張犁-1	第1車	1800	1815	臺北市信義區崇德街79巷口(黎順里公園)	121.55532	25.02443
信義區	黎忠里	六張犁分隊	106-G10	KEA-0300	六張犁-1	第1車	1825	1840	臺北市信義區和平東路3段391巷8弄1號前	121.55799	25.02006
信義區	黎平里	六張犁分隊	106-G10	KEA-0300	六張犁-1	第2車	1955	2010	臺北市信義區富陽街83號前	121.55653	25.02127
信義區	黎順里	六張犁分隊	106-G10	KEA-0300	六張犁-1	第2車	2015	2025	臺北市信義區崇德街79巷口(黎順里公園)	121.55532	25.02443
信義區	黎忠里	六張犁分隊	106-G10	KEA-0300	六張犁-1	第3車	2135	2145	臺北市信義區和平東路3段391巷8弄1號前	121.55799	25.02006
信義區	黎平里	六張犁分隊	106-G10	KEA-0300	六張犁-1	第3車	2150	2200	臺北市信義區富陽街83號前	121.55653	25.02127
大安區	義安里	安和分隊	106-G12	KEA-0302	安和-2	第1車	1700	1705	臺北市大安區信義路4段186巷與文昌街口	121.55157	25.03265
大安區	通安里	安和分隊	106-G12	KEA-0302	安和-2	第1車	1705	1710	臺北市大安區安和路2段21號前	121.55256	25.03215
大安區	通化里	安和分隊	106-G12	KEA-0302	安和-2	第1車	1710	1715	臺北市大安區信義路4段374號加油站前	121.55547	25.03292
大安區	通化里	安和分隊	106-G12	KEA-0302	安和-2	第1車	1715	1720	臺北市大安區光復南路606號	121.55727	25.03272
大安區	法治里	安和分隊	106-G12	KEA-0302	安和-2	第2車	1900	1905	臺北市大安區樂利路89號前	121.55218	25.02572
大安區	臨江里	安和分隊	106-G12	KEA-0302	安和-2	第2車	1905	1935	臺北市大安區通化街167號前	121.55387	25.02833
大安區	通安里	安和分隊	106-G12	KEA-0302	安和-2	第2車	1945	1950	臺北市安和路2段69巷2號	121.5525	25.03054
大安區	敦安里	安和分隊	106-G12	KEA-0302	安和-2	第3車	2100	2105	臺北市大安區安和路1段104號前	121.55227	25.03416
大安區	義安里	安和分隊	106-G12	KEA-0302	安和-2	第3車	2105	2110	臺北市大安區安和路2段12號前	121.55225	25.03246
大安區	義安里	安和分隊	106-G12	KEA-0302	安和-2	第3車	2110	2115	臺北市大安區安和路2段52號前	121.55221	25.03108
大安區	義安里	安和分隊	106-G12	KEA-0302	安和-2	第3車	2115	2140	臺北市大安區安和路2段92號前	121.55051	25.02905
大安區	全安里	安和分隊	106-G12	KEA-0302	安和-2	第3車	2140	2145	臺北市大安區安和路2段186號前	121.55008	25.02492
大安區	通安里	安和分隊	106-G12	KEA-0302	安和-2	第3車	2150	2155	臺北市安和路2段69巷2號	121.5525	25.03054
大安區	龍陣里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第1車	1700	1705	臺北市大安區瑞安街75號前（安東市場）	121.54116	25.02849
大安區	龍陣里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第1車	1706	1709	臺北市大安區復興南路2段148號前	121.54335	25.02838
大安區	龍雲里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第1車	1711	1716	臺北市大安區復興南路2段111巷1號前	121.54361	25.03036
大安區	龍圖里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第1車	1720	1724	臺北市大安區建國南路2段79巷11號前	121.53849	25.03086
大安區	龍圖里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第1車	1726	1730	臺北市大安區建國南路2段9號前	121.53803	25.03286
大安區	龍生里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第2車	1900	1909	臺北市大安區和平東路2段217號前	121.54263	25.02503
大安區	龍生里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第2車	1910	1922	臺北市大安區和平東路2段181號前	121.54181	25.02515
大安區	龍生里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第2車	1924	1940	臺北市大安區和平東路2段105號前	121.54026	25.02537
大安區	龍生里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第2車	1942	1949	臺北市大安區和平東路2段49之3號	121.53836	25.02561
大安區	龍生里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第2車	1951	1955	臺北市大安區建國南路2段197號前	121.53796	25.02719
大安區	龍生里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第2車	1956	2000	臺北市大安區建國南路2段181號旁	121.53796	25.02774
大安區	龍雲里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第3車	2105	2112	臺北市大安區復興南路2段145號前	121.54358	25.02841
大安區	龍雲里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第3車	2114	2130	臺北市大安區復興南路2段111巷1號前（二次收集）	121.54361	25.0298
大安區	龍圖里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第3車	2132	2140	臺北市大安區瑞安街61巷口(龍陣2號公園旁)	121.54254	25.02956
大安區	龍陣里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第3車	2141	2200	臺北市大安區瑞安街75號前(安東市場）（二次收集）	121.54116	25.02849
大安區	龍陣里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第3車	2202	2210	臺北市大安區復興南路2段160巷口	121.54339	25.02781
大安區	龍陣里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第3車	2211	2215	臺北市大安區復興南路2段208號前	121.54336	25.02652
大安區	龍陣里	瑞安分隊	106-G13	KEA-0303	瑞安-2	第3車	2216	2225	臺北市大安區和平東路2段175巷28號前	121.54177	25.02564
大安區	住安里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第1車	1700	1702	臺北市大安區復興南路2段13之1號前（二次收集）	121.54367	25.03247
大安區	德安里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第1車	1705	1710	臺北市大安區大安路1段231號前	121.54599	25.03431
大安區	德安里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第1車	1712	1718	臺北市大安區大安路1段177號旁（仁愛公園）（二次收集）	121.546	25.0368
大安區	仁慈里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第1車	1722	1726	臺北市大安區東豐街24號旁（東豐公園）	121.54512	25.03602
大安區	德安里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第1車	1728	1729	臺北市大安區敦化南路1段376號前	121.54855	25.03347
大安區	住安里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第1車	1733	1735	臺北市大安區敦化南路2段6號	121.5485608	25.0328293
大安區	仁慈里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第2車	1850	1853	臺北市大安區復興南路1段321號前	121.5437	25.03406
大安區	仁慈里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第2車	1854	1859	臺北市大安區復興南路1段297號前	121.54373	25.03506
大安區	仁慈里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第2車	1900	1907	臺北市大安區復興南路1段251號前	121.54377	25.03684
大安區	仁慈里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第2車	1909	1920	臺北市大安區東豐街24號旁（東豐公園）（二次收集）	121.54511	25.03602
大安區	仁慈里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第2車	1921	1930	臺北市大安區信義路4段55號前	121.54513	25.03347
大安區	德安里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第2車	1937	1950	臺北市大安區四維路66巷2號旁（德安公園）	121.54811	25.03503
大安區	德安里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第2車	1952	1958	臺北市大安區四維路8號前	121.5482	25.03724
大安區	德安里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第2車	1959	2000	臺北市大安區敦化南路1段294號前	121.54861	25.03605
大安區	新龍里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第3車	2110	2124	臺北市大安區建國南路2段117號旁	121.53799	25.02953
大安區	新龍里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第3車	2125	2130	臺北市大安區建國南路2段85號旁	121.53799	25.03084
大安區	新龍里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第3車	2131	2140	臺北市大安區建國南路2段79巷33號對面	121.53936	25.03084
大安區	新龍里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第3車	2141	2154	臺北市大安區建國南路2段151巷38號	121.53939	25.02883
大安區	龍圖里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第3車	2155	2205	臺北市大安區瑞安街208巷50號前	121.54056	25.02962
大安區	龍圖里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第3車	2206	2210	臺北市大安區瑞安街208巷63之1號前	121.54059	25.03072
大安區	龍圖里	瑞安分隊	106-G14	KEA-0305	瑞安-3	第3車	2211	2215	臺北市大安區復興南路2段78巷42弄1號前	121.54188	25.03109
大安區	龍門里	台大分隊	106-G15	KEA-0306	台大-1	第1車	1820	1825	臺北市大安區建國南路2段314號前	121.53705	25.0239
大安區	龍門里	台大分隊	106-G15	KEA-0306	台大-1	第1車	1826	1830	臺北市大安區辛亥路2段35號前	121.53582	25.02269
大安區	龍門里	台大分隊	106-G15	KEA-0306	台大-1	第1車	1831	1837	臺北市大安區新生南路3段23號前	121.53492	25.02471
大安區	龍門里	台大分隊	106-G15	KEA-0306	台大-1	第1車	1838	1846	臺北市大安區和平東路2段20號前	121.53622	25.02562
大安區	龍門里	台大分隊	106-G15	KEA-0306	台大-1	第1車	1847	1852	臺北市大安區和平東路2段38號前	121.5371	25.02549
大安區	龍門里	台大分隊	106-G15	KEA-0306	台大-1	第1車	1855	1858	臺北市大安區和平東路2段48號前	121.53817	25.02546
大安區	龍淵里	台大分隊	106-G15	KEA-0306	台大-1	第1車	1900	1950	臺北市大安區和平東路2段96巷12之2號對面	121.54103	25.02321
大安區	龍門里	台大分隊	106-G15	KEA-0306	台大-1	第2車	2100	2103	臺北市大安區和平東路2段74號前	121.53921	25.02536
大安區	龍淵里	台大分隊	106-G15	KEA-0306	台大-1	第2車	2104	2109	臺北市大安區和平東路2段98號前	121.54145	25.02494
大安區	龍淵里	台大分隊	106-G15	KEA-0306	台大-1	第2車	2110	2118	臺北市大安區和平東路2段120號前	121.54295	25.02472
大安區	龍淵里	台大分隊	106-G15	KEA-0306	台大-1	第2車	2119	2126	臺北市大安區復興南路2段310號前	121.5431	25.02356
大安區	龍淵里	台大分隊	106-G15	KEA-0306	台大-1	第2車	2127	2134	臺北市大安區復興南路2段342號前	121.54308	25.02259
大安區	龍淵里	台大分隊	106-G15	KEA-0306	台大-1	第2車	2135	2142	臺北市大安區辛亥路2段215號前	121.54276	25.02152
大安區	龍淵里	台大分隊	106-G15	KEA-0306	台大-1	第2車	2143	2148	臺北市大安區辛亥路2段169號前	121.54106	25.02158
大安區	龍淵里	台大分隊	106-G15	KEA-0306	台大-1	第2車	2149	2155	臺北市大安區辛亥路2段129號前	121.53951	25.02164
大安區	大學里	台大分隊	106-G15	KEA-0306	台大-1	第2車	2158	2203	臺北市大安區羅斯福路3段333號前	121.53235	25.017
大安區	大學里	台大分隊	106-G15	KEA-0306	台大-1	第2車	2204	2210	臺北市大安區羅斯福路3段281號前	121.53138	25.018
大安區	大學里	台大分隊	106-G15	KEA-0306	台大-1	第2車	2211	2215	臺北市大安區羅斯福路3段273號前	121.53084	25.01852
大安區	芳和里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第1車	1806	1814	臺北市大安區和平東路3段214號	121.55441	25.02254
大安區	黎孝里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第1車	1815	1827	臺北市大安區和平東路3段268號前	121.55574	25.02131
大安區	黎和里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第1車	1829	1834	臺北市大安區和平東路3段348號	121.55753	25.0196
大安區	黎和里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第1車	1836	1845	臺北市大安區臥龍街262號	121.55798	25.01762
大安區	黎和里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第1車	1846	1851	臺北市大安區臥龍街272之1號	121.55847	25.01698
大安區	黎和里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第1車	1852	1855	臺北市大安區臥龍街306號	121.55979	25.01682
大安區	黎和里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第1車	1856	1901	臺北市大安區和平東路3段510號	121.5608	25.01583
大安區	黎和里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第1車	1902	1907	臺北市大安區和平東路3段590號	121.56227	25.0143
大安區	黎和里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第1車	1908	1913	臺北市大安區和平東路3段632巷底	121.56227	25.01262
大安區	臥龍里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2010	2013	臺北市大安區敦南街51號對面	121.54661	25.023
大安區	臥龍里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2014	2017	臺北市大安區臥龍街56巷6之2號旁	121.54694	25.02181
大安區	臥龍里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2018	2021	臺北市大安區基隆路3段4巷1號	121.54795	25.02079
大安區	臥龍里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2022	2025	臺北市大安區基隆路3段20之4號	121.54746	25.02
大安區	虎嘯里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2033	2042	臺北市大安區和平東路3段56號	121.54814	25.02456
大安區	虎嘯里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2046	2051	臺北市大安區樂業街19號	121.54992	25.02372
大安區	虎嘯里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2052	2058	臺北市大安區樂業街50號	121.54984	25.02283
大安區	芳和里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2102	2110	臺北市大安區樂業街118巷1號	121.55207	25.02084
大安區	黎元里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2113	2118	臺北市大安區辛亥路3段157巷12號	121.54993	25.01728
大安區	黎元里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2119	2125	臺北市大安區臥龍街188巷1號	121.55102	25.01825
大安區	黎元里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2126	2132	臺北市大安區臥龍街188巷45號(頂好超市)	121.5505	25.01628
大安區	臥龍里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2137	2144	臺北市大安區復興南路2段381號	121.54343	25.02221
大安區	臥龍里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2145	2150	臺北市大安區復興南路2段339號	121.54344	25.02348
大安區	臥龍里	臥龍分隊	106-G16	KEA-0307	臥龍-3	第2車	2151	2155	臺北市大安區復興南路2段293-3號	121.54347	25.02465
中正區	文北里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第1車	1650	1655	臺北市中正區金山南路1段21號	121.52914	25.04031
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第1車	1700	1705	臺北市中正區忠孝東路2段104號	121.53072	25.04282
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第1車	1707	1712	臺北市中正區忠孝東路2段134巷02號(公園邊)	121.53185	25.04204
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第1車	1713	1720	臺北市中正區忠孝東路2段134巷22號對面	121.53156	25.04048
中正區	幸褔里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第1車	1724	1729	臺北市中正區濟南路2段3之7號	121.52676	25.04144
中正區	幸褔里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第1車	1734	1737	臺北市中正區忠孝東路2段66號	121.52904	25.04328
中正區	文北里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第1車	1742	1745	臺北市中正區金山南路1段70之1號	121.52851	25.03901
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第2車	1930	1935	臺北市中正區濟南路2段40號	121.53026	25.04054
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第2車	1935	1940	臺北市中正區濟南路2段46號	121.53113	25.04034
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第2車	1941	1945	臺北市中正區濟南路2段64號	121.5323	25.04018
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第2車	1947	1952	臺北市中正區新生南路1段100號	121.53264	25.03942
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第2車	1953	1959	臺北市中正區仁愛路2段93號	121.5316	25.03831
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第2車	2000	2005	臺北市中正區仁愛路2段67號	121.53062	25.03833
中正區	文北里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第3車	2110	2115	臺北市中正區金山南路1段43號	121.52884	25.03947
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第3車	2117	2122	臺北市中正區忠孝東路2段106號	121.53075	25.0428
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第3車	2123	2125	臺北市中正區新生南路1段52之3號	121.53282	25.04155
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第3車	2127	2135	臺北市中正區濟南路2段55號	121.53156	25.04029
中正區	幸市里	忠孝分隊	106-G17	KEA-0308	忠孝-1	第3車	2136	2145	臺北市中正區臨沂街23之1號	121.53039	25.04163
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1735	1740	臺北市文山區木柵路4段9巷1號（新光河山）	121.57057	24.99218
文山區	博嘉里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1745	1746	臺北市文山區木柵路4段6號前	121.57202	24.99536
文山區	博嘉里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1747	1748	臺北市文山區木柵路4段36號前	121.57384	24.99723
文山區	博嘉里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1753	1755	臺北市文山區和平東路4段385號(原軍功路31號)	121.57425	24.9992
文山區	博嘉里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1756	1757	臺北市文山區和平東路4段361號(原軍功路53巷口)	121.574	24.9998
文山區	博嘉里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1758	1759	臺北市文山區和平東4段295巷口(原軍功路61巷口)	121.57322	25.00144
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1800	1806	臺北市文山區和平東路4段88巷口(原軍功路150巷口)	121.56684	25.00517
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1808	1810	臺北市文山區萬寧街173~175號前	121.57031	25.00393
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1814	1817	臺北市文山區萬寧街129號前	121.56971	25.00362
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1818	1819	臺北市文山區萬寧街36巷口	121.56552	25.00299
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1820	1821	臺北市文山區萬寧街23巷口	121.56446	25.00387
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1822	1823	臺北市文山區萬寧街1號停車場出入口前	121.56675	25.00345
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1824	1833	臺北市文山區萬美街2段2巷22號旁	121.56237	25.00315
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1835	1837	臺北市文山區萬美街1段123號前	121.56239	25.00129
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1838	1842	臺北市文山區萬美街1段91號前	121.56619	25.00103
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1843	1844	臺北市文山區萬和街7號前	121.56841	25.00084
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1845	1846	臺北市文山區萬芳路13號前	121.5659	24.9988
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1847	1848	臺北市文山區萬芳路19之1號前	121.5657	24.9987
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1849	1852	臺北市文山區萬芳路60之6號前(捷運萬芳社區站)	121.57071	24.99784
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1853	1854	臺北市文山區萬芳路50號前	121.56521	24.99834
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1855	1856	臺北市文山區萬芳路22號前	121.57101	24.99526
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1857	1858	臺北市文山區萬芳路3號旁巷口	121.57131	24.99485
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1859	1900	臺北市文山區木柵路4段35之4號前	121.57152	24.99454
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第1車	1901	1902	臺北市文山區木柵路4段31號前	121.57134	24.99372
文山區	博嘉里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2003	2004	臺北市文山區木柵路5段81號(象頭埔)	121.59047	25.001
文山區	博嘉里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2005	2006	臺北市文山區木柵路5段100號（象頭埔）	121.59321	24.99867
文山區	博嘉里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2017	2018	臺北市文山區木柵路4段111巷口	121.57305	24.99764
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2021	2022	臺北市文山區萬芳路9-1號旁	121.5705	24.99851
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2024	2028	臺北市文山區萬利街2巷口	121.56736	24.99934
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2029	2032	臺北市文山區萬利街30巷8號	121.56507	25.00108
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2033	2037	臺北市文山區萬利街30巷24號前	121.56432	25.00136
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2038	2040	臺北市文山區萬利街57號前	121.56448	25.00078
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2041	2043	臺北市文山區萬利街33號旁	121.56558	25.00044
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2047	2054	臺北市文山區萬美街1段55號旁	121.56798	25.00226
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2055	2102	臺北市文山區萬安街16巷口	121.56955	25.00086
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2103	2109	臺北市文山區萬安街22巷10號旁岔路口	121.56989	25.00053
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2110	2115	臺北市文山區萬安街44巷8號	121.56998	24.9992
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2116	2121	臺北市文山區萬安街53號	121.57118	24.99971
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2122	2126	臺北市文山區萬安街56巷口	121.57251	24.99989
文山區	萬芳里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2127	2132	臺北市文山區萬安街119號	121.57099	25.00152
文山區	博嘉里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2134	2135	臺北市文山區和平東路4段356巷口(原軍功路40巷口)	121.57361	24.99876
文山區	博嘉里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2136	2137	臺北市文山區和平東路4段295巷口	121.57322	25.00144
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2138	2139	臺北市文山區和平東路4段88巷口	121.56684	25.00517
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2142	2143	臺北市文山區萬寧街36巷口	121.56552	25.00299
文山區	萬美里	博嘉分隊	106-G22	KEA-0313	博嘉-1	第2車	2144	2145	臺北市文山區萬寧街1號旁	121.56675	25.00345
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第1車	1630	1633	臺北市文山區木柵路3段37號對面	121.56576	24.9884
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第1車	1634	1640	臺北市文山區木柵路3段94號前	121.56722	24.98858
文山區	木新里	木柵分隊	106-G23	KEA-0315	木柵-2	第1車	1640	1643	臺北市文山區木柵路3段158號	121.56892	24.98906
文山區	木新里	木柵分隊	106-G23	KEA-0315	木柵-2	第1車	1643	1646	臺北市文山區木柵路3段220號	121.56996	24.98956
文山區	木新里	木柵分隊	106-G23	KEA-0315	木柵-2	第2車	1830	1836	臺北市文山區木新路2段12號前	121.5705	24.98717
文山區	木新里	木柵分隊	106-G23	KEA-0315	木柵-2	第2車	1837	1843	臺北市文山區木新路2段98號前	121.57029	24.98495
文山區	木新里	木柵分隊	106-G23	KEA-0315	木柵-2	第2車	1844	1854	臺北市文山區木新路2段134號景文後門	121.56924	24.98459
文山區	木新里	木柵分隊	106-G23	KEA-0315	木柵-2	第2車	1855	1900	臺北市文山區木新路2段109號	121.57007	24.98431
文山區	木新里	木柵分隊	106-G23	KEA-0315	木柵-2	第2車	1900	1905	臺北市文山區木新路2段77號	121.57064	24.98521
文山區	木新里	木柵分隊	106-G23	KEA-0315	木柵-2	第2車	1906	1911	臺北市文山區永安街22巷2號	121.57016	24.98677
文山區	木新里	木柵分隊	106-G23	KEA-0315	木柵-2	第2車	1911	1917	臺北市文山區永安街22巷24號	121.56942	24.98691
文山區	木新里	木柵分隊	106-G23	KEA-0315	木柵-2	第2車	1917	1920	臺北市文山區保儀路73號	121.5686	24.987
文山區	木新里	木柵分隊	106-G23	KEA-0315	木柵-2	第2車	1920	1925	臺北市文山區保儀路11號	121.56866	24.98863
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第3車	2043	2045	臺北市文山區久康街1號	121.5645	24.98865
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第3車	2046	2050	臺北市文山區久康街59號前	121.56518	24.98925
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第3車	2051	2055	臺北市文山區久康街62號前	121.56621	24.98987
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第3車	2056	2100	臺北市文山區久康街98號前	121.56774	24.99062
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第3車	2101	2105	臺北市文山區久康街114號	121.56856	24.99066
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第3車	2106	2110	臺北市文山區木柵路3段155號	121.56901	24.98936
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第3車	2111	2114	臺北市文山區木柵路3段101號	121.56798	24.9889
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第3車	2115	2120	臺北市文山區木柵路3段73號	121.56684	24.98872
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第3車	2120	2124	臺北市文山區木柵路3段47號	121.56606	24.9886
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第3車	2125	2126	臺北市文山區木柵路3段21號	121.56514	24.98858
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第3車	2127	2128	臺北市文山區木柵路3段1號	121.56453	24.9886
文山區	木柵里	木柵分隊	106-G23	KEA-0315	木柵-2	第3車	2129	2133	臺北市文山區木柵路3段48巷1弄1號（三義新村）	121.56545	24.98775
中正區	水源里	公館分隊	106-G24	KEA-0320	公館-2	第1車	1700	1704	臺北市中正區汀州路3段160巷8號	121.53392	25.0131
中正區	水源里	公館分隊	106-G24	KEA-0320	公館-2	第1車	1705	1709	臺北市中正區汀州路3段104巷69號	121.5347	25.01238
中正區	水源里	公館分隊	106-G24	KEA-0320	公館-2	第1車	1710	1730	臺北市中正區汀州路3段253號	121.53509	25.01305
中正區	富水里	公館分隊	106-G24	KEA-0320	公館-2	第2車	1850	1852	臺北市中正區思源街16號	121.53109	25.01442
中正區	富水里	公館分隊	106-G24	KEA-0320	公館-2	第2車	1853	1855	臺北市中正區永春街308號	121.52834	25.01212
中正區	富水里	公館分隊	106-G24	KEA-0320	公館-2	第2車	1856	1857	臺北市中正區水源路3之3號前	121.52727	25.01362
中正區	富水里	公館分隊	106-G24	KEA-0320	公館-2	第2車	1858	1900	臺北市中正區水源路5之4號前(永春街240巷底)	121.5268	25.01433
中正區	富水里	公館分隊	106-G24	KEA-0320	公館-2	第2車	1901	1904	臺北市中正區水源路9之3號前	121.52649	25.015
中正區	林興里	公館分隊	106-G24	KEA-0320	公館-2	第2車	1905	1909	臺北市中正區水源路23號前	121.5252	25.01708
中正區	林興里	公館分隊	106-G24	KEA-0320	公館-2	第2車	1910	1915	臺北市中正區水源路27巷2號	121.52469	25.01753
中正區	林興里	公館分隊	106-G24	KEA-0320	公館-2	第2車	1916	1920	臺北市中正區水源路31巷1號	121.52443	25.01792
中正區	林興里	公館分隊	106-G24	KEA-0320	公館-2	第2車	1921	1925	臺北市中正區水源路37 巷1弄35號	121.52407	25.01868
中正區	林興里	公館分隊	106-G24	KEA-0320	公館-2	第2車	1926	1930	臺北市中正區水源路39之4號	121.52384	25.01868
中正區	林興里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2040	2044	臺北市中正區辛亥路1段23號邊	121.52818	25.01927
中正區	林興里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2045	2049	臺北市中正區辛亥路1段5號	121.52771	25.01889
中正區	林興里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2050	2055	臺北市中正區汀州路3段25號	121.52645	25.01994
中正區	林興里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2056	2059	臺北市中正區羅斯福路3段128巷33號	121.52629	25.02038
中正區	林興里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2100	2105	臺北市中正區師大路169號邊	121.52702	25.02075
中正區	林興里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2106	2108	臺北市中正區辛亥路1段33號	121.52848	25.01932
中正區	文盛里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2111	2115	臺北市中正區羅斯福路3段212號	121.52951	25.01907
中正區	文盛里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2116	2120	臺北市中正區羅斯福路3段238號	121.53041	25.01826
中正區	文盛里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2121	2125	臺北市中正區羅斯福路3段246號	121.53145	25.01725
中正區	文盛里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2126	2130	臺北市中正區羅斯福路3段292-1號	121.53235	25.01638
中正區	文盛里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2131	2134	臺北市中正區羅斯福路4段2號	121.53282	25.01599
中正區	水源里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2135	2140	臺北市中正區羅斯福路4段26號	121.53331	25.01549
中正區	水源里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2141	2144	臺北市中正區羅斯福路4段64號前	121.53425	25.01461
中正區	水源里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2144	2146	臺北市中正區羅斯福路4段92號	121.53501	25.01374
中正區	水源里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2146	2148	臺北市中正區羅斯福路4段138號邊	121.53598	25.01284
中正區	水源里	公館分隊	106-G24	KEA-0320	公館-2	第3車	2148	2150	臺北市中正區羅斯福路4段162號前	121.53628	25.01241
士林區	溪山里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1625	1630	臺北市士林區至善路3段152號	121.57404	25.11634
士林區	溪山里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1631	1634	臺北市士林區至善路3段150巷8號前	121.57437	25.11575
士林區	溪山里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1635	1638	臺北市士林區至善路3段150巷20號前	121.57681	25.11315
士林區	溪山里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1639	1644	臺北市士林區至善路3段150巷36號前	121.57788	25.11523
士林區	溪山里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1645	1650	臺北市士林區至善路3段150巷27號前(週一、週四收運)	121.57696	25.1135
士林區	溪山里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1700	1705	臺北市士林區至善路3段336巷74號(週一、週四收運)	121.59567	25.13542
士林區	溪山里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1706	1711	臺北市士林區至善路3段370巷46號(週一、週四收運)	121.58784	25.13783
士林區	溪山里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1721	1725	臺北市士林區至善路3段71巷10弄6號前	121.56854	25.11554
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1726	1730	臺北市士林區至善路3段71巷30號前	121.56922	25.11835
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1740	1743	臺北市士林區至善路2段445號前	121.55725	25.10891
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1744	1749	臺北市士林區至善路2段423號前	121.55746	25.10771
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1750	1751	臺北市士林區至善路2段393巷2號	121.55705	25.10561
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1752	1753	臺北市士林區至善路2段341號前	121.55416	25.10339
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1754	1757	臺北市士林區至善路2段133號前	121.54743	25.0987
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1758	1759	臺北市士林區至善路2段256號前	121.55053	25.10031
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1800	1805	臺北市士林區至善路2段322巷口	121.55275	25.1019
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1806	1807	臺北市士林區至善路2段342號前	121.55424	25.10322
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1808	1809	臺北市士林區至善路2段392號前	121.55733	25.10532
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第1車	1810	1815	臺北市士林區至善路2段460巷2號	121.55794	25.11027
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1832	1835	臺北市士林區中社路1段36號前	121.55992	25.10968
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1836	1839	臺北市士林區中社路1段60巷口	121.56046	25.10756
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1840	1843	臺北市士林區中社路2段20巷口	121.5622	25.10801
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1844	1847	臺北市士林區中社路2段46巷1號前	121.56309	25.10645
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1848	1851	臺北市士林區中社路2段明溪街37號邊	121.56462	25.10555
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1852	1855	臺北市士林區中社路2段明溪街9號前	121.5657	25.10714
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1857	1900	臺北市士林區中社路2段110號前	121.56666	25.10567
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1901	1904	臺北市士林區中社路2段185巷口	121.57046	25.10719
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1905	1908	臺北市士林區中社路2段125號前	121.56709	25.1066
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1909	1912	臺北市士林區中社路2段翠山街2號左方	121.57042	25.10861
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1913	1916	臺北市士林區中社路2段95號前	121.56752	25.10723
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1917	1920	臺北市士林區中社路2段91巷1號右方	121.56663	25.10751
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1921	1924	臺北市士林區中社路2段79號	121.56496	25.10759
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1925	1928	臺北市士林區中社路2段33號前	121.56265	25.10709
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1929	1932	臺北市士林區中社路2段17巷口	121.56149	25.10862
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1933	1936	臺北市士林區中社路1段61巷口	121.56071	25.10705
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1937	1941	臺北市士林區中社路1段43巷2號斜前方	121.56012	25.10847
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1943	1948	臺北市士林區中社路1段11巷42號前	121.56165	25.11037
士林區	翠山里	文林分隊	106-G27	KEA-0323	文林-3	第2車	1949	1952	臺北市士林區中社路1段9巷〈翠山莊口〉	121.56281	25.11161
士林區	福志里	文林分隊	106-G27	KEA-0323	文林-3	第3車	2110	2112	臺北市士林區忠勇街40巷1弄2號邊	121.53339	25.09833
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第3車	2118	2121	臺北市士林區至善路2段88號前	121.54598	25.0978
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第3車	2122	2123	臺北市士林區故宮路48巷22號斜前方	121.54733	25.09632
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第3車	2124	2125	臺北市士林區故宮路35巷1號前	121.5472	25.09681
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第3車	2126	2127	臺北市士林區故宮路15巷口	121.54696	25.09744
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第3車	2128	2129	臺北市士林區至善路2段132號斜前方	121.54772	25.0985
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第3車	2130	2131	臺北市士林區至善路2段113巷口	121.5466	25.0984
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第3車	2133	2135	臺北市士林區至善路2段59號	121.54537	25.09773
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第3車	2136	2138	臺北市士林區至善路2段25號	121.54409	25.09718
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第3車	2139	2140	臺北市士林區仰德大道1段6巷35號前	121.53832	25.0997
士林區	臨溪里	文林分隊	106-G27	KEA-0323	文林-3	第3車	2141	2142	臺北市士林區至善路2段1巷1-1號	121.5433	25.09772
大安區	學府里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1810	1813	臺北市大安區辛亥路3段300號前	121.55232	25.01467
大安區	學府里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1817	1820	臺北市大安區基隆路3段151號	121.54272	25.01569
大安區	學府里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1821	1823	臺北市大安區基隆路3段121號	121.5435	25.01634
大安區	學府里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1824	1826	臺北市大安區長興街81號對面	121.54713	25.01548
大安區	學府里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1827	1829	臺北市大安區基隆路3段155巷128號之4	121.54782	25.01247
大安區	學府里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1830	1836	臺北市大安區基隆路3段155巷148號芳蘭山莊旁	121.54812	25.01249
大安區	學府里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1837	1842	臺北市大安區基隆路3段155巷109號	121.54512	25.01256
大安區	學府里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1844	1853	臺北市大安區羅斯福路4段119巷68號前	121.5392	25.00975
大安區	學府里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1854	1857	臺北市大安區羅斯福路4段119巷20號前	121.538	25.01049
大安區	大學里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1900	1905	臺北市大安區辛亥路1段28號	121.52978	25.0197
大安區	大學里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1906	1915	臺北市大安區辛亥路1段62號前	121.53075	25.02053
大安區	大學里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1916	1925	臺北市大安區辛亥路1段104號	121.53208	25.02161
大安區	大學里	台大分隊	107-G02	KEA-0855	台大-2	第1車	1926	1930	臺北市大安區辛亥路1段130號前	121.53326	25.02216
大安區	大學里	台大分隊	107-G02	KEA-0855	台大-2	第2車	2040	2044	臺北市大安區新生南路3段54巷口	121.53405	25.02074
大安區	大學里	台大分隊	107-G02	KEA-0855	台大-2	第2車	2045	2052	臺北市大安區新生南路3段62號	121.53388	25.02007
大安區	大學里	台大分隊	107-G02	KEA-0855	台大-2	第2車	2053	2102	臺北市大安區新生南路3段74號	121.53378	25.01962
大安區	大學里	台大分隊	107-G02	KEA-0855	台大-2	第2車	2103	2111	臺北市大安區新生南路3段86號	121.53369	25.01856
大安區	大學里	台大分隊	107-G02	KEA-0855	台大-2	第2車	2112	2120	臺北市大安區新生南路3段96號	121.53336	25.01742
大安區	古風里	台大分隊	107-G02	KEA-0855	台大-2	第2車	2123	2127	臺北市大安區辛亥路1段79號	121.53045	25.02149
大安區	古風里	台大分隊	107-G02	KEA-0855	台大-2	第2車	2128	2138	臺北市大安區師大路115號前	121.52848	25.02231
大安區	古風里	台大分隊	107-G02	KEA-0855	台大-2	第2車	2139	2149	臺北市大安區師大路105巷15號前	121.52931	25.02257
大安區	古風里	台大分隊	107-G02	KEA-0855	台大-2	第2車	2150	2155	臺北市大安區泰順街60巷與62巷交叉口	121.53115	25.02222
大安區	和安里	新生分隊	107-G03	KEA-0856	新生-3	第1車	1820	1825	臺北市大安區信義路3段109號前	121.53916	25.03372
大安區	和安里	新生分隊	107-G03	KEA-0856	新生-3	第1車	1827	1837	臺北市大安區信義路3段147巷11弄1號前	121.54198	25.03483
大安區	和安里	新生分隊	107-G03	KEA-0856	新生-3	第1車	1839	1844	臺北市大安區復興南路1段342號前	121.54333	25.03599
大安區	和安里	新生分隊	107-G03	KEA-0856	新生-3	第1車	1846	1849	臺北市大安區復興南路1段360號前	121.54344	25.03534
大安區	和安里	新生分隊	107-G03	KEA-0856	新生-3	第1車	1851	1854	臺北市大安區信義路3段157巷10弄2號前（安祥公園）	121.54267	25.03429
大安區	和安里	新生分隊	107-G03	KEA-0856	新生-3	第1車	1856	1859	臺北市大安區仁愛路3段144號旁	121.54215	25.03763
大安區	和安里	新生分隊	107-G03	KEA-0856	新生-3	第1車	1900	1907	臺北市大安區仁愛路3段118號前	121.53999	25.0375
大安區	民輝里	新生分隊	107-G03	KEA-0856	新生-3	第1車	1910	1914	臺北市大安區仁愛路3段9號前	121.53351	25.03845
大安區	民輝里	新生分隊	107-G03	KEA-0856	新生-3	第1車	1916	1930	臺北市大安區新生南路1段103-1號	121.5331	25.04056
大安區	民輝里	新生分隊	107-G03	KEA-0856	新生-3	第1車	1935	1945	臺北市大安區濟南路3段17~1號	121.53436	25.04031
大安區	義村里	新生分隊	107-G03	KEA-0856	新生-3	第2車	2055	2103	臺北市大安區忠孝東路3段160號前	121.53822	25.04153
大安區	義村里	新生分隊	107-G03	KEA-0856	新生-3	第2車	2104	2132	臺北市大安區忠孝東路3段214號前	121.53997	25.04145
大安區	義村里	新生分隊	107-G03	KEA-0856	新生-3	第2車	2134	2144	臺北市大安區忠孝東路3段248巷13弄5號前	121.542	25.04063
大安區	義村里	新生分隊	107-G03	KEA-0856	新生-3	第2車	2145	2150	臺北市大安區復興南路1段194號前	121.54342	25.03995
大安區	義村里	新生分隊	107-G03	KEA-0856	新生-3	第2車	2153	2200	臺北市大安區仁愛路3段125號前	121.54209	25.03833
中山區	永安里	大直分隊	107-G05	KEA-0858	大直-3	第1車	1800	1810	臺北市中山區北安路520號前	121.54617	25.07976
中山區	永安里	大直分隊	107-G05	KEA-0858	大直-3	第1車	1815	1835	臺北市中山區北安路458巷41弄16號前(大直市場)	121.54555	25.07848
中山區	永安里	大直分隊	107-G05	KEA-0858	大直-3	第1車	1837	1848	臺北市中山區北安路538巷1弄1號前	121.54806	25.07975
中山區	永安里	大直分隊	107-G05	KEA-0858	大直-3	第1車	1850	1900	臺北市中山區北安路578巷8弄9號前	121.54872	25.08037
中山區	永安里	大直分隊	107-G05	KEA-0858	大直-3	第1車	1903	1920	臺北市中山區北安路554巷8弄3號對面(永安國小東側面)	121.55027	25.07947
中山區	永安里	大直分隊	107-G05	KEA-0858	大直-3	第1車	1921	1927	臺北市中山區明水路397巷7弄25號	121.54877	25.07806
中山區	永安里	大直分隊	107-G05	KEA-0858	大直-3	第1車	1928	1935	臺北市中山區明水路397巷2弄6號前	121.54747	25.07808
中山區	大直里	大直分隊	107-G05	KEA-0858	大直-3	第2車	2100	2130	臺北市中山區大直街2號(大直國小前)	121.54659	25.08049
中山區	大直里	大直分隊	107-G05	KEA-0858	大直-3	第2車	2132	2140	臺北市中山區大直街62巷5弄5號(實踐大學大門口旁)	121.54503	25.08354
中山區	大直里	大直分隊	107-G05	KEA-0858	大直-3	第2車	2141	2156	臺北市中山區大直街65號前	121.54636	25.08357
中山區	大直里	大直分隊	107-G05	KEA-0858	大直-3	第2車	2157	2200	臺北市中山區大直街129號前	121.54884	25.08419
中山區	正得里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1640	1645	臺北市中山區中山北路1段35號	121.5215	25.04886
中山區	正得里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1646	1649	臺北市中山區中山北路1段55號	121.52169	25.04941
中山區	正得里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1650	1655	臺北市中山區中山北路1段93號	121.52229	25.05068
中山區	正得里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1656	1705	臺北市中山區南京東路1段24號	121.52371	25.05203
中山區	正得里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1710	1715	臺北市中山區長安東路1段11號	121.52261	25.04969
中山區	康樂里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1720	1725	臺北市中山區中山北路2段15號	121.52295	25.05286
中山區	康樂里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1726	1730	臺北市中山區中山北路2段43號	121.31222	25.31485
中山區	聚盛里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1732	1739	臺北市中山區民生東路1段48號	121.52477	25.05792
中山區	聚盛里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1740	1748	臺北市中山區民生東路1段72號	121.52259	25.05792
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1750	1756	臺北市中山區新生北路2段76巷2號	121.52706	25.05741
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1800	1805	臺北市中山區新生北路2段66號	121.31379	25.32313
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1807	1816	臺北市中山區新生北路2段58巷4號	121.52712	25.05527
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1817	1822	臺北市中山區長春路59號	121.52622	25.05508
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1824	1830	臺北市中山區長春路21號	121.52413	25.05514
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1836	1841	臺北市中山區中山北路2段59-1號	121.523	25.05593
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第1車	1842	1850	臺北市中山區中山北路2段71號	121.52306	25.05736
中山區	康樂里	中山分隊	107-G06	KEA-0859	中山-3	第2車	2035	2038	臺北市中山區長春路路16號	121.52363	25.0548
中山區	康樂里	中山分隊	107-G06	KEA-0859	中山-3	第2車	2039	2043	臺北市中山區長春路路40號	121.52518	25.05478
中山區	康樂里	中山分隊	107-G06	KEA-0859	中山-3	第2車	2044	2050	臺北市中山區長春路路82-1號	121.52671	25.05482
中山區	康樂里	中山分隊	107-G06	KEA-0859	中山-3	第2車	2053	2100	臺北市中山區南京東路1段29號	121.52439	25.05237
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第2車	2105	2110	臺北市中山區民生東路1段28號	121.52405	25.05789
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第2車	2112	2117	臺北市中山區林森北路362號	121.52542	25.0574
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第2車	2118	2123	臺北市中山區林森北路312號	121.52535	25.05632
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第2車	2124	2130	臺北市中山區林森北路282號	121.52534	25.05549
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第2車	2136	2140	臺北市中山區林森北路291號	121.52559	25.05563
中山區	中山里	中山分隊	107-G06	KEA-0859	中山-3	第2車	2142	2150	臺北市中山區林森北路353號	121.3132	25.32512
中山區	聚盛里	中山分隊	107-G06	KEA-0859	中山-3	第2車	2152	2155	臺北市中山區林森北路381號	121.52567	25.05849
中山區	聚盛里	中山分隊	107-G06	KEA-0859	中山-3	第2車	2156	2200	臺北市中山區林森北路401號	121.52575	25.05928
中山區	行政里	民二分隊	107-G07	KEA-0860	民二-1	第1車	1720	1730	臺北市中山區松江路367號	121.53339	25.06442
中山區	行政里	民二分隊	107-G07	KEA-0860	民二-1	第1車	1732	1737	臺北市中山區松江路441號	121.53341	25.06636
中山區	行政里	民二分隊	107-G07	KEA-0860	民二-1	第1車	1739	1750	臺北市中山區建國北路3段24號前	121.53676	25.06388
中山區	行政里	民二分隊	107-G07	KEA-0860	民二-1	第1車	1752	1807	臺北市中山區民權東路2段133號旁	121.53472	25.06257
中山區	行政里	民二分隊	107-G07	KEA-0860	民二-1	第1車	1809	1830	臺北市中山區農安街182號	121.53483	25.06464
中山區	行政里	民二分隊	107-G07	KEA-0860	民二-1	第1車	1830	1835	臺北市中山區松江路431巷29號	121.53507	25.06565
中山區	行政里	民二分隊	107-G07	KEA-0860	民二-1	第2車	1955	2005	臺北市中山區農安街182號	121.53483	25.06464
中山區	江山里	民二分隊	107-G07	KEA-0860	民二-1	第2車	2010	2040	臺北市中山區錦州街350號	121.53934	25.06022
中山區	下埤里	民二分隊	107-G07	KEA-0860	民二-1	第3車	2045	2100	臺北市中山區民權東路3段73號	121.54355	25.06246
中山區	下埤里	民二分隊	107-G07	KEA-0860	民二-1	第3車	2102	2112	臺北市中山區龍江路459號	121.54104	25.06765
中山區	下埤里	民二分隊	107-G07	KEA-0860	民二-1	第3車	2116	2126	臺北市中山區復興北路514巷53號	121.54189	25.06603
中山區	行政里	民二分隊	107-G08	KEA-0861	民二-2	第1車	1545	1605	臺北市中山區錦州街臨306號	121.53678	25.05976
中山區	行孝里	民二分隊	107-G08	KEA-0861	民二-2	第2車	1732	1740	臺北市中山區民族東路254號前	121.53453	25.06813
中山區	行仁里	民二分隊	107-G08	KEA-0861	民二-2	第2車	1742	1755	臺北市中山區民族東路438號	121.53955	25.06806
中山區	行孝里	民二分隊	107-G08	KEA-0861	民二-2	第2車	1800	1806	臺北市中山區建國北路3段73號	121.53698	25.06525
中山區	行孝里	民二分隊	107-G08	KEA-0861	民二-2	第2車	1810	1820	臺北市中山區民族東路410巷2弄口	121.5383	25.06699
中山區	行仁里	民二分隊	107-G08	KEA-0861	民二-2	第2車	1822	1835	臺北市中山區五常街29號	121.53828	25.06443
中山區	行仁里	民二分隊	107-G08	KEA-0861	民二-2	第2車	1837	1850	臺北市中山區五常街55號對面	121.53964	25.06428
中山區	行孝里	民二分隊	107-G08	KEA-0861	民二-2	第3車	2020	2035	臺北市中山區建國北路3段113巷9號對面	121.53641	25.06684
中山區	下埤里	民二分隊	107-G08	KEA-0861	民二-2	第3車	2038	2043	臺北市中山區民族東路536號	121.54319	25.0672
中山區	行仁里	民二分隊	107-G08	KEA-0861	民二-2	第3車	2128	2142	臺北市中山區龍江路356巷33號	121.53947	25.06603
中山區	晴光里	圓山分隊	107-G09	KEA-0862	圓山-3	第1車	1630	1635	臺北市中山區林森北路594號前	121.52566	25.06568
中山區	恆安里	圓山分隊	107-G09	KEA-0862	圓山-3	第1車	1641	1645	臺北市中山區林森北路530號前	121.52558	25.06351
中山區	恆安里	圓山分隊	107-G09	KEA-0862	圓山-3	第1車	1648	1655	臺北市中山區中山北路3段1號前	121.52248	25.06389
中山區	恆安里	圓山分隊	107-G09	KEA-0862	圓山-3	第1車	1707	1715	臺北市中山區農安街40號	121.52712	25.06489
中山區	聚葉里	圓山分隊	107-G09	KEA-0862	圓山-3	第2車	1855	1905	臺北市中山區新生北路2段122號前	121.52734	25.06145
中山區	聚葉里	圓山分隊	107-G09	KEA-0862	圓山-3	第2車	1907	1915	臺北市中山區林森北路487號前	121.52564	25.06137
中山區	聚葉里	圓山分隊	107-G09	KEA-0862	圓山-3	第2車	1916	1925	臺北市中山區林森北路500號前	121.52555	25.06181
中山區	聚葉里	圓山分隊	107-G09	KEA-0862	圓山-3	第2車	1926	1935	臺北市中山區林森北路438號前	121.52554	25.06049
中山區	聚葉里	圓山分隊	107-G09	KEA-0862	圓山-3	第2車	1936	1945	臺北市中山區錦州街5號前	121.52388	25.06043
中山區	恆安里	圓山分隊	107-G09	KEA-0862	圓山-3	第3車	2105	2110	臺北市中山區林森北路554號前(新光銀行前)	121.52562	25.06411
中山區	聚葉里	圓山分隊	107-G09	KEA-0862	圓山-3	第3車	2120	2130	臺北市中山區民權東路1段70巷28號前	121.52498	25.06159
中山區	聚葉里	圓山分隊	107-G09	KEA-0862	圓山-3	第3車	2131	2135	臺北市中山區中山北路2段145號前	121.52301	25.06196
中山區	聚葉里	圓山分隊	107-G09	KEA-0862	圓山-3	第3車	2138	2145	臺北市中山區民權東路1段56號前	121.52455	25.06262
中山區	新福里	民一分隊	107-G10	KEA-0863	民一-2	第1車	1700	1710	臺北市中山區農安街130號(精漢堂)	121.5315	25.06478
中山區	新福里	民一分隊	107-G10	KEA-0863	民一-2	第1車	1712	1722	臺北市中山區松江路398號前	121.53311	25.06375
中山區	新福里	民一分隊	107-G10	KEA-0863	民一-2	第1車	1725	1735	臺北市中山區民權東路2段69之1號前	121.53157	25.06266
中山區	新庄里	民一分隊	107-G10	KEA-0863	民一-2	第1車	1737	1747	臺北市中山區農安街127號前	121.53002	25.06494
中山區	新庄里	民一分隊	107-G10	KEA-0863	民一-2	第1車	1750	1800	臺北市中山區新生北路3段49號前	121.528	25.06565
中山區	新喜里	民一分隊	107-G10	KEA-0863	民一-2	第2車	1930	1938	臺北市中山區吉林路421號前	121.53047	25.06668
中山區	新喜里	民一分隊	107-G10	KEA-0863	民一-2	第2車	1939	1945	臺北市中山區吉林路463號前	121.53051	25.06784
中山區	新庄里	民一分隊	107-G10	KEA-0863	民一-2	第2車	1946	1950	臺北市中山區吉林路470號前	121.53036	25.06748
中山區	新庄里	民一分隊	107-G10	KEA-0863	民一-2	第2車	1951	2000	臺北市中山區吉林路410號前	121.53031	25.06558
中山區	新福里	民一分隊	107-G10	KEA-0863	民一-2	第2車	2001	2010	臺北市中山區吉林路376號前	121.53028	25.06438
中山區	新福里	民一分隊	107-G10	KEA-0863	民一-2	第2車	2011	2020	臺北市中山區吉林路348號旁(新壽公園旁)	121.53024	25.0635
中山區	新福里	民一分隊	107-G10	KEA-0863	民一-2	第3車	2140	2145	臺北市中山區民權東路2段17號前	121.52881	25.06274
中山區	新福里	民一分隊	107-G10	KEA-0863	民一-2	第3車	2146	2155	臺北市中山區新生北路3段15號旁	121.52793	25.06365
中山區	新庄里	民一分隊	107-G10	KEA-0863	民一-2	第3車	2157	2204	臺北市中山區新生北路3段73號前	121.52802	25.06693
中山區	新庄里	民一分隊	107-G10	KEA-0863	民一-2	第3車	2205	2213	臺北市中山區新生北路3段95號前	121.52803	25.06787
中山區	新喜里	民一分隊	107-G10	KEA-0863	民一-2	第3車	2215	2220	臺北市中山區民族東路230號前	121.53195	25.06821
中正區	南門里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1730	1732	臺北市中正區博愛路185號對面	121.51063	25.03477
中正區	南門里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1733	1735	臺北市中正區博愛路228號前	121.5104	25.03376
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1738	1741	臺北市中正區重慶南路3段2號前	121.51525	25.02962
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1742	1745	臺北市中正區重慶南路3段38號前	121.51548	25.02841
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1746	1748	臺北市中正區重慶南路3段52號前	121.51562	25.02789
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1749	1752	臺北市中正區和平西路1段143號前	121.51552	25.02756
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1753	1756	臺北市中正區和平西路1段165號前	121.51475	25.02781
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1757	1759	臺北市中正區和平西路2段21號前	121.51348	25.02849
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1800	1802	臺北市中正區和平西路2段29號前	121.51315	25.02867
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1803	1804	臺北市中正區寧波西街130號旁	121.51247	25.02908
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1805	1807	臺北市中正區寧波西街120號前	121.5131	25.02924
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1808	1812	臺北市中正區泉州街4號旁	121.51424	25.02931
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1813	1815	臺北市中正區泉州街57號前	121.51454	25.0283
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1818	1820	臺北市中正區泉州街2號旁	121.51371	25.03139
中正區	龍光里	泉州分隊	107-G11	KEA-0865	泉州-2	第1車	1821	1825	臺北市中正區泉州街9號前	121.51411	25.03039
中正區	南門里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	1950	1952	臺北市中正區和平西路2段77號前	121.50749	25.03182
中正區	南門里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	1953	1955	臺北市中正區和平西路2段93號前	121.50701	25.03222
中正區	愛國里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	1956	1957	臺北市中正區和平西路2段131號前	121.5062	25.03301
中正區	愛國里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	1958	2000	臺北市中正區和平西路2段143號前	121.50578	25.03343
中正區	愛國里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2001	2004	臺北市中正區中華路2段91號前	121.50569	25.03391
中正區	愛國里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2005	2010	臺北市中正區中華路2段59號	121.50619	25.03481
中正區	愛國里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2011	2013	臺北市中正區中華路2段41號	121.50642	25.03513
中正區	愛國里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2014	2015	臺北市中正區愛國西路50之5號旁	121.50732	25.03681
中正區	愛國里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2016	2017	臺北市中正區延平南路192巷2號旁	121.5076	25.03611
中正區	南門里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2018	2020	臺北市中正區延平南路169號對面	121.50759	25.03487
中正區	南門里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2021	2023	臺北市中正區延平南路226號前	121.50731	25.03414
中正區	南門里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2024	2027	臺北市中正區中華路2段75巷40號旁	121.50767	25.03344
中正區	南門里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2028	2030	臺北市中正區廣州街8巷17號前	121.50821	25.03406
中正區	南門里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2031	2033	臺北市中正區廣州街8巷9號前	121.50819	25.03486
中正區	南門里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2034	2037	臺北市中正區博愛路185號對面	121.51063	25.03476
中正區	南門里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2038	2040	臺北市中正區博愛路228號前	121.5104	25.03376
中正區	忠勤里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2045	2055	臺北市中正區南海路105號前停車場	121.50734	25.02782
中正區	忠勤里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2056	2100	臺北市中正區惠安街39號	121.50722	25.02915
中正區	忠勤里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2101	2105	臺北市中正區惠安街17號	121.50674	25.02963
中正區	忠勤里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2106	2112	臺北市中正區西藏路39號前	121.50615	25.0303
中正區	忠勤里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2113	2115	臺北市中正區西藏路9號前	121.50715	25.0305
中正區	忠勤里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2116	2119	臺北市中正區三元街8號前	121.50795	25.03028
中正區	忠勤里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2120	2122	臺北市中正區南海路75號前	121.50862	25.02929
中正區	忠勤里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2123	2126	臺北市中正區南海路91號前	121.50826	25.02868
中正區	忠勤里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2127	2130	臺北市中正區中華路2段313巷1號旁	121.50594	25.02817
中正區	忠勤里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2131	2134	臺北市中正區中華路2段307巷1號旁	121.5053	25.02889
中正區	忠勤里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2135	2137	臺北市中正區中華路2段301巷1號旁	121.50471	25.0296
中正區	忠勤里	泉州分隊	107-G11	KEA-0865	泉州-2	第2車	2138	2140	臺北市中正區西藏路69號旁	121.505	25.03002
中正區	三愛里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第1車	1745	1750	臺北市中正區仁愛路2段94號前	121.53138	25.03799
中正區	三愛里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第1車	1751	1800	臺北市中正區仁愛路2段62號前	121.52918	25.03801
中正區	三愛里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第1車	1801	1805	臺北市中正區仁愛路2段34-6號前	121.52727	25.03804
中正區	文北里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第1車	1806	1810	臺北市中正區仁愛路2段18號前	121.52624	25.03808
中正區	東門里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第1車	1812	1818	臺北市中正區仁愛路1段04號前	121.52174	25.03855
中正區	梅花里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第1車	1825	1830	臺北市中正區林森北路11號前	121.52389	25.04614
中正區	梅花里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第1車	1833	1835	臺北市中正區北平東路7-2號前	121.52294	25.04659
中正區	梅花里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第1車	1837	1840	臺北市中正區天津街9號前	121.52233	25.04745
中正區	三愛里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第2車	2005	2012	臺北市中正區新生南路1段134-3號前	121.5325	25.03671
中正區	三愛里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第2車	2012	2019	臺北市中正區新生南路1段140號前	121.53257	25.03622
中正區	三愛里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第2車	2020	2027	臺北市中正區新生南路1段148號前	121.53245	25.03526
中正區	三愛里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第2車	2028	2035	臺北市中正區新生南路1段162號前	121.53245	25.03456
中正區	文北里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第3車	2115	2120	臺北市中正區仁愛路2段25之1號	121.52731	25.03849
中正區	文北里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第3車	2121	2125	臺北市中正區杭州南路1段75號前	121.52572	25.03943
中正區	東門里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第3車	2126	2130	臺北市中正區紹興南街18-15號對面	121.52384	25.03982
中正區	東門里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第3車	2131	2135	臺北市中正區林森南路57號前	121.52211	25.03995
中正區	東門里	仁愛分隊	107-G12	KEA-0866	仁愛-2	第3車	2136	2140	臺北市中正區徐州路20號前	121.52323	25.04063
內湖區	港墘里	內湖分隊	107-G13	KEA-0867	內湖-3	第1車	1620	1650	臺北市內湖區港墘路221巷2號鄰舊宗路	121.57352	25.07397
內湖區	港墘里	內湖分隊	107-G13	KEA-0867	內湖-3	第2車	1730	1900	臺北市內湖區港墘路221巷2號鄰舊宗路	121.57352	25.07397
內湖區	金瑞里	內湖分隊	107-G13	KEA-0867	內湖-3	第2車	2005	2015	臺北市內湖區內湖路3段326巷口	121.58355	25.08968
內湖區	金瑞里	內湖分隊	107-G13	KEA-0867	內湖-3	第2車	2020	2030	臺北市內湖區內湖路3段329巷8號	121.58486	25.08839
內湖區	大湖里	內湖分隊	107-G13	KEA-0867	內湖-3	第3車	2100	2117	臺北市內湖區大湖山莊街25號旁	121.60351	25.08383
內湖區	大湖里	內湖分隊	107-G13	KEA-0867	內湖-3	第3車	2120	2130	臺北市內湖區大湖山莊街65巷1號前	121.60454	25.08655
內湖區	港墘里	內湖分隊	107-G13	KEA-0867	內湖-3	第3車	2145	2155	臺北市內湖區港墘路221巷2號	121.57352	25.07397
松山區	莊敬里	上塔悠分隊	107-G14	KEA-0868	上塔悠-3	第1車	1645	1648	臺北市松山區濱江街863號	121.56223	25.07057
松山區	莊敬里	上塔悠分隊	107-G14	KEA-0868	上塔悠-3	第1車	1657	1700	臺北市松山區撫遠街405巷15號之1	121.56659	25.0678
松山區	新東里	上塔悠分隊	107-G14	KEA-0868	上塔悠-3	第1車	1703	1720	臺北市松山區塔悠路351號(撫遠抽水站)	121.56861	25.06234
松山區	莊敬里	上塔悠分隊	107-G14	KEA-0868	上塔悠-3	第1車	1735	1810	臺北市松山區民權東路4段121號(松指部)	121.55975	25.06253
松山區	富錦里	上塔悠分隊	107-G14	KEA-0868	上塔悠-3	第1車	1820	1835	臺北市松山區三民路168號	121.56321	25.06195
松山區	新益里	上塔悠分隊	107-G14	KEA-0868	上塔悠-3	第1車	1840	1905	臺北市松山區撫遠街259號(三民公園)	121.56686	25.06106
松山區	莊敬里	上塔悠分隊	107-G14	KEA-0868	上塔悠-3	第2車	2040	2110	臺北市松山區撫遠街379巷口	121.56585	25.06439
松山區	富泰里	上塔悠分隊	107-G14	KEA-0868	上塔悠-3	第2車	2120	2140	臺北市松山區民生東路5段186號(圓環邊)	121.56374	25.05866
松山區	東榮里	上塔悠分隊	107-G14	KEA-0868	上塔悠-3	第2車	2145	2155	臺北市松山區民生東路5段27巷9弄口	121.55682	25.06005
松山區	東榮里	上塔悠分隊	107-G14	KEA-0868	上塔悠-3	第2車	2201	2210	臺北市松山區光復北路199號	121.55494	25.06018
文山區	萬年里	景美分隊	107-G15	KEA-0869	景美-1	第1車	1739	1748	臺北市文山區羅斯福路5段192巷22號旁	121.53681	25.00351
文山區	萬和里	景美分隊	107-G15	KEA-0869	景美-1	第1車	1751	1806	臺北市文山區汀州路4段263號旁	121.53634	25.00105
文山區	萬隆里	景美分隊	107-G15	KEA-0869	景美-1	第1車	1808	1816	臺北市文山區羅斯福路5段218巷38弄2號	121.53689	25.00214
文山區	萬隆里	景美分隊	107-G15	KEA-0869	景美-1	第1車	1818	1824	臺北市文山區羅斯福路5段238號旁	121.53905	25.00151
文山區	萬隆里	景美分隊	107-G15	KEA-0869	景美-1	第1車	1825	1830	臺北市文山區萬隆街46號旁	121.53792	25.00042
文山區	萬隆里	景美分隊	107-G15	KEA-0869	景美-1	第1車	1831	1837	臺北市文山區景福街54巷1號前	121.53811	24.99968
文山區	景仁里	景美分隊	107-G15	KEA-0869	景美-1	第1車	1838	1845	臺北市文山區景福街3-1號旁	121.53935	24.99944
文山區	萬盛里	景美分隊	107-G15	KEA-0869	景美-1	第1車	1850	1855	臺北市文山區興隆路1段123號旁	121.54196	25.00231
文山區	萬盛里	景美分隊	107-G15	KEA-0869	景美-1	第1車	1856	1906	臺北市文山區興隆路1段89號前	121.54138	25.00306
文山區	萬祥里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2045	2052	臺北市文山區景隆街12號旁	121.54041	24.99993
文山區	萬祥里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2053	2103	臺北市文山區羅斯福路5段203號前	121.53905	25.00239
文山區	萬祥里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2104	2107	臺北市文山區羅斯福路5段159號前	121.53889	25.00355
文山區	萬祥里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2108	2109	臺北市文山區興隆路1段14號旁	121.53945	25.00419
文山區	萬祥里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2115	2122	臺北市文山區興隆路1段70巷11弄7號前	121.54035	25.00259
文山區	萬祥里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2123	2129	臺北市文山區興隆路1段106號旁	121.54131	25.00278
文山區	萬有里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2130	2137	臺北市文山區興隆路1段140號前	121.54192	25.00175
文山區	萬有里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2138	2143	臺北市文山區興隆路1段204號前	121.54362	25
文山區	萬有里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2145	2152	臺北市文山區景隆街119號前	121.54367	24.99893
文山區	萬有里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2153	2155	臺北市文山區景隆街35號前	121.54197	24.99956
文山區	萬祥里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2156	2200	臺北市文山區景隆街12號旁	121.5403	24.99985
文山區	萬有里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2204	2209	臺北市文山區羅斯福路6段159巷3號前	121.54166	24.99741
文山區	景仁里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2210	2213	臺北市文山區羅斯福路6段142巷20弄2~3號前	121.53967	24.99697
文山區	景仁里	景美分隊	107-G15	KEA-0869	景美-1	第2車	2215	2220	臺北市文山區景福街45巷1號旁	121.53723	24.99825
信義區	六藝里	五分埔分隊	107-G16	KEA-0870	五分埔-1	第1車	1740	1750	臺北市信義區永吉路150巷口	121.57091	25.04501
信義區	六藝里	五分埔分隊	107-G16	KEA-0870	五分埔-1	第1車	1752	1805	臺北市信義區松信路92號(變電所)	121.57195	25.04468
信義區	六藝里	五分埔分隊	107-G16	KEA-0870	五分埔-1	第1車	1807	1820	臺北市信義區松信路與虎林街120巷交叉口	121.57195	25.04226
信義區	富台里	五分埔分隊	107-G16	KEA-0870	五分埔-1	第1車	1823	1835	臺北市信義區忠孝東路5段423巷5弄對面	121.57536	25.04179
信義區	五全里	五分埔分隊	107-G16	KEA-0870	五分埔-1	第1車	1837	1900	臺北市信義區忠孝東路5段423巷66號對面（永吉公園）	121.57552	25.04355
信義區	六藝里	五分埔分隊	107-G16	KEA-0870	五分埔-1	第2車	2040	2055	臺北市信義區松信路92號(變電所)	121.57195	25.04468
信義區	六藝里	五分埔分隊	107-G16	KEA-0870	五分埔-1	第2車	2057	2105	臺北市信義區松信路與虎林街120巷交叉口	121.57195	25.04226
信義區	富台里	五分埔分隊	107-G16	KEA-0870	五分埔-1	第2車	2107	2120	臺北市信義區忠孝東路5段423巷5弄對面	121.57536	25.04179
信義區	五全里	五分埔分隊	107-G16	KEA-0870	五分埔-1	第2車	2122	2135	臺北市信義區忠孝東路5段423巷66號（永吉公園）	121.57552	25.04355
信義區	四維里	五分埔分隊	107-G16	KEA-0870	五分埔-1	第2車	2140	2200	臺北市信義區松山路240巷	121.5776	25.0442
信義區	三張里	吳興分隊	107-G17	KEA-0871	吳興-3	第1車	1830	1839	臺北市信義區松仁路226號(吳興國小門口)	121.56861	25.02576
信義區	六合里	吳興分隊	107-G17	KEA-0871	吳興-3	第1車	1840	1910	臺北市信義區松仁路281巷4號(吳興街公車總站)	121.5702	25.02398
信義區	惠安里	吳興分隊	107-G17	KEA-0871	吳興-3	第1車	1915	1925	臺北市信義區松仁路240巷22號旁	121.56835	25.02439
信義區	三張里	吳興分隊	107-G17	KEA-0871	吳興-3	第2車	2100	2105	臺北市信義區松智路33巷口	121.56532	25.03006
信義區	惠安里	吳興分隊	107-G17	KEA-0871	吳興-3	第2車	2135	2200	臺北市信義區吳興街365巷口	121.56807	25.02612
信義區	三張里	吳興分隊	107-G18	KEA-0872	吳興-2	第1車	1830	1900	臺北市信義區松仁路160號旁	121.56823	25.02838
信義區	三張里	吳興分隊	107-G18	KEA-0872	吳興-2	第1車	1905	1930	臺北市信義區莊敬路341巷口	121.5649	25.02855
信義區	三張里	吳興分隊	107-G18	KEA-0872	吳興-2	第2車	2105	2130	臺北市信義區莊敬路404巷口	121.56573	25.02679
信義區	惠安里	吳興分隊	107-G18	KEA-0872	吳興-2	第2車	2135	2200	臺北市信義區吳興街600巷口	121.57035	25.0198
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第1車	1735	1804	臺北市信義區忠孝東路5段743巷29號前	121.58093	25.04403
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第1車	1805	1810	臺北市信義區忠孝東路5段721巷口	121.58065	25.04271
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第1車	1811	1815	臺北市信義區忠孝東路5段499號	121.57846	25.04144
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第1車	1816	1830	臺北市信義區松山路287巷口	121.5779	25.0429
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第1車	1831	1835	臺北市信義區松山路249巷口	121.5779	25.0442
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第1車	1836	1842	臺北市信義區永吉路444號	121.57836	25.04525
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第1車	1843	1850	臺北市信義區永吉路500號	121.57957	25.04519
信義區	五全里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第2車	2015	2030	臺北市信義區永吉路282號	121.57433	25.04538
信義區	四維里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第2車	2032	2040	臺北市信義區永吉路350號	121.57645	25.04504
信義區	四育里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第2車	2042	2050	臺北市信義區永吉路371號	121.57683	25.04563
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第2車	2100	2109	臺北市信義區忠孝東路5段743巷29號前	121.58093	25.04403
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第2車	2110	2115	臺北市信義區忠孝東路5段721巷口	121.58065	25.04271
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第2車	2117	2129	臺北市信義區松山路287巷口	121.5779	25.0429
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第2車	2130	2134	臺北市信義區松山路249巷口	121.5779	25.0442
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第2車	2135	2142	臺北市信義區永吉路444號	121.57836	25.04525
信義區	永春里	五分埔分隊	107-G19	KEA-0873	五分埔-3	第2車	2143	2150	臺北市信義區永吉路500號	121.57957	25.04519
南港區	中南里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第1車	1751	1756	臺北市南港區忠孝東路7段528號	121.61168	25.05259
南港區	新富里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第1車	1808	1814	臺北市南港區富康街22號前	121.61726	25.05411
南港區	新富里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第1車	1815	1829	臺北市南港區富康街52號前	121.61714	25.05329
南港區	新富里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第1車	1833	1840	臺北市南港區研究院路1段151巷18號	121.61614	25.04998
南港區	中研里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第1車	1842	1845	臺北市南港區研究院路1段臨128號右前	121.61566	25.04925
南港區	中研里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第1車	1847	1851	臺北市南港區研究院路2段86號前	121.61543	25.04514
南港區	舊莊里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第1車	1901	1913	臺北市南港區舊莊街1段3巷18號	121.61826	25.04247
南港區	中研里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第1車	1914	1923	臺北市南港區研究院路2段61巷2弄41號	121.61688	25.04368
南港區	舊莊里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2020	2025	臺北市南港區南深路21巷1號前	121.62131	25.03802
南港區	舊莊里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2026	2030	臺北市南港區舊莊街1段212巷8號前	121.62283	25.0391
南港區	舊莊里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2031	2037	臺北市南港區舊莊街1段145巷6弄55號旁	121.62263	25.03917
南港區	舊莊里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2038	2043	臺北市南港區舊莊街1段197號	121.62208	25.03879
南港區	舊莊里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2044	2048	臺北市南港區舊莊街1段167號	121.62117	25.03942
南港區	舊莊里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2049	2054	臺北市南港區舊莊街1段145巷6弄1號右側	121.62059	25.04031
南港區	舊莊里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2055	2059	臺北市南港區舊莊街1段91巷8號	121.61942	25.04099
南港區	舊莊里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2100	2105	臺北市南港區舊莊街1段3巷旁	121.61755	25.04195
南港區	中研里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2107	2110	臺北市南港區研究院路2段59巷1號左前方	121.61623	25.04415
南港區	中研里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2111	2116	臺北市南港區研究院路2段35-2號	121.61532	25.04559
南港區	新富里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2121	2123	臺北市南港區富康街1巷16弄10號	121.61799	25.05391
南港區	新富里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2124	2130	臺北市南港區富康街53巷9號	121.6178	25.05241
南港區	中研里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2136	2147	臺北市南港區研究院路2段12巷58弄1號對面	121.61384	25.04741
南港區	中研里	舊莊分隊	107-G20	KEA-0875	舊莊-1	第2車	2149	2153	臺北市南港區研究院路2段70巷12號(中研市場旁)	121.61457	25.04561
南港區	玉成里	南港分隊	107-G21	KEA-0876	南港-2	第1車	1750	1758	臺北市南港區南港路3段149巷3弄1號前	121.58516	25.05158
南港區	西新里	南港分隊	107-G21	KEA-0876	南港-2	第1車	1759	1805	臺北市南港區南港路3段67巷4號對面	121.58842	25.05287
南港區	西新里	南港分隊	107-G21	KEA-0876	南港-2	第1車	1805	1811	臺北市南港區南港路3段67巷口	121.58844	25.053
南港區	西新里	南港分隊	107-G21	KEA-0876	南港-2	第1車	1812	1821	臺北市南港區南港路3段106巷13弄口	121.58913	25.05492
南港區	玉成里	南港分隊	107-G21	KEA-0876	南港-2	第1車	1821	1824	臺北市南港區南港路3段130巷5弄口	121.58796	25.05419
南港區	玉成里	南港分隊	107-G21	KEA-0876	南港-2	第1車	1824	1829	臺北市南港區南港路3段130巷1弄1號前	121.5882	25.05342
南港區	玉成里	南港分隊	107-G21	KEA-0876	南港-2	第1車	1830	1837	臺北市南港區南港路3段192號	121.58677	25.05309
南港區	玉成里	南港分隊	107-G21	KEA-0876	南港-2	第1車	1840	1845	臺北市南港區南港路3段312號	121.58157	25.05163
南港區	玉成里	南港分隊	107-G21	KEA-0876	南港-2	第1車	1847	1900	臺北市南港區八德路4段830號	121.58199	25.05128
南港區	重陽里	南港分隊	107-G21	KEA-0876	南港-2	第2車	2008	2015	臺北市南港區重陽路39巷	121.59404	25.05803
南港區	西新里	南港分隊	107-G21	KEA-0876	南港-2	第2車	2030	2037	臺北市南港區昆陽街(南港國中後門)64號對面	121.59305	25.05255
南港區	西新里	南港分隊	107-G21	KEA-0876	南港-2	第2車	2037	2041	臺北市南港區南港路2段215號前	121.59233	25.05423
南港區	西新里	南港分隊	107-G21	KEA-0876	南港-2	第2車	2043	2055	臺北市南港區成功路1段88號	121.59245	25.0575
南港區	西新里	南港分隊	107-G21	KEA-0876	南港-2	第2車	2055	2104	臺北市南港區成功路1段28號	121.59298	25.05536
南港區	西新里	南港分隊	107-G21	KEA-0876	南港-2	第2車	2105	2112	臺北市南港區南港路3段16巷20號	121.59268	25.05438
南港區	西新里	南港分隊	107-G21	KEA-0876	南港-2	第2車	2113	2121	臺北市南港區南港路3段82號	121.59102	25.05389
南港區	玉成里	南港分隊	107-G21	KEA-0876	南港-2	第2車	2122	2127	臺北市南港區南港路3段262號	121.58474	25.05251
南港區	玉成里	南港分隊	107-G21	KEA-0876	南港-2	第2車	2132	2136	臺北市南港區八德路4段830號	121.58198	25.05129
南港區	舊莊里	玉成分隊	107-G22	KEA-0876	南港-2	第1車	1720	1730	臺北市南港區南深路37-1號	121.62411	25.03298
南港區	聯成里	玉成分隊	107-G22	KEA-0877	玉成-2	第1車	1800	1805	臺北市南港區忠孝東路6段190號	121.58666	25.04864
南港區	聯成里	玉成分隊	107-G22	KEA-0877	玉成-2	第1車	1806	1815	臺北市南港區忠孝東路6段252號前	121.58826	25.04899
南港區	聯成里	玉成分隊	107-G22	KEA-0877	玉成-2	第1車	1817	1825	臺北市南港區忠孝東路6段324號	121.59063	25.04956
南港區	新光里	玉成分隊	107-G22	KEA-0877	玉成-2	第1車	1827	1835	臺北市南港區忠孝東路6段372號前	121.59173	25.04978
南港區	新光里	玉成分隊	107-G22	KEA-0877	玉成-2	第1車	1838	1845	臺北市南港區忠孝東路6段430號前	121.59334	25.05019
南港區	新光里	玉成分隊	107-G22	KEA-0877	玉成-2	第1車	1848	1855	臺北市南港區昆陽街157巷13號前	121.59466	25.04986
南港區	新光里	玉成分隊	107-G22	KEA-0877	玉成-2	第1車	1900	1910	臺北市南港區昆陽街152號巷口~154-2號之間	121.59412	25.04889
南港區	新光里	玉成分隊	107-G22	KEA-0877	玉成-2	第1車	1911	1916	臺北市南港區昆陽街171巷3弄1號旁	121.59412	25.04734
南港區	成福里	玉成分隊	107-G22	KEA-0877	玉成-2	第1車	1917	1920	臺北市南港區東新街181號前	121.59353	25.04652
南港區	成福里	玉成分隊	107-G22	KEA-0877	玉成-2	第1車	1922	1927	臺北市南港區東新街170巷21之6號	121.59295	25.04429
南港區	成福里	玉成分隊	107-G22	KEA-0877	玉成-2	第1車	1928	1936	臺北市南港區東新街170巷7弄9號前	121.59298	25.04532
南港區	新光里	玉成分隊	107-G22	KEA-0877	玉成-2	第2車	2040	2045	臺北市南港區昆陽街158號對面公園	121.59404	25.04871
南港區	仁福里	玉成分隊	107-G22	KEA-0877	玉成-2	第2車	2052	2104	臺北市南港區福德街417號中庭	121.5926	25.04004
南港區	聯成里	玉成分隊	107-G22	KEA-0877	玉成-2	第2車	2107	2112	臺北市南港區東新街103號前	121.58976	25.04659
南港區	聯成里	玉成分隊	107-G22	KEA-0877	玉成-2	第2車	2113	2118	臺北市南港區東新街77巷4弄2號對面	121.58838	25.04708
南港區	聯成里	玉成分隊	107-G22	KEA-0877	玉成-2	第2車	2120	2125	臺北市南港區忠孝東路6段188巷13弄2號	121.58697	25.04783
南港區	萬福里	玉成分隊	107-G22	KEA-0877	玉成-2	第2車	2126	2135	臺北市南港區同德路85巷4號前	121.58568	25.04627
南港區	鴻福里	玉成分隊	107-G22	KEA-0877	玉成-2	第2車	2137	2150	臺北市南港區玉成街176巷口	121.5844	25.04438
士林區	公館里	草山分隊	107-G24	KEA-0877	草山-2	第1車	1550	1551	臺北市士林區永公路251號	121.55762	25.1215
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1552	1552	臺北市士林區永公路294號	121.55983	25.12019
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1553	1553	臺北市士林區永公路296巷18號	121.55964	25.1187
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1556	1557	臺北市士林區永公路296巷30弄	121.55862	25.11807
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1558	1600	臺北市士林區永公路296巷89號	121.55872	25.11637
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1601	1602	臺北市士林區永公路310巷巷口	121.56072	25.12001
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1603	1603	臺北市士林區永公路315巷巷口	121.56125	25.11996
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1604	1606	臺北市士林區永公路340巷巷口	121.56338	25.121
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1607	1607	臺北市士林區永公路340巷28號	121.56341	25.11942
士林區	菁山里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1608	1610	臺北市士林區永公路350巷巷口	121.56347	25.12176
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1611	1613	臺北市士林區永公路350巷61號	121.56536	25.1237
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1614	1615	臺北市士林區永公路355巷14號	121.56253	25.12263
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1616	1617	臺北市士林區永公路355巷11號	121.56292	25.12268
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1618	1620	臺北市士林區公?里公車站牌	121.56469	25.12658
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1621	1622	臺北市士林區永公路512號	121.56721	25.138
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1622	1624	臺北市士林區永公路506之1號(菁礐開漳聖王宮)	121.56695	25.13896
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1625	1625	臺北市士林區永公路546號(松竹園停車場入口)	121.56747	25.13977
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1626	1627	臺北市士林區平菁街10巷6號	121.57017	25.14208
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1627	1629	臺北市士林區平菁街10巷底	121.57048	25.14215
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1630	1631	臺北市士林區永公路500巷巷口	121.56926	25.13545
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1632	1634	臺北市士林區永公路500巷公車站牌	121.56891	25.13487
士林區	公館里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1635	1637	臺北市士林區永公路500巷31號	121.57023	25.13533
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1638	1639	臺北市士林區平菁街21號	121.57166	25.13794
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1640	1641	臺北市士林區平菁街陳厝公車站牌	121.57414	25.13505
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1642	1643	臺北市士林區平菁街43巷1號(元山咖啡水蜜桃園)	121.57302	25.13214
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1644	1649	臺北市士林區平菁街42巷巷口(客倌)	121.57279	25.13082
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1650	1653	臺北市士林區平菁街47號	121.57394	25.13085
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1654	1656	臺北市士林區平菁街67巷巷口	121.57497	25.13199
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1657	1659	臺北市士林區平菁街73巷巷口	121.57539	25.13154
士林區	菁山里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1700	1702	臺北市士林區平菁街84巷口(派出所)	121.57643	25.13144
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1703	1704	臺北市士林區平菁街內寮公車站牌	121.5784	25.14295
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1705	1706	臺北市士林區平菁街93巷48號	121.57793	25.14216
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1707	1707	臺北市士林區平菁街93巷二公車站牌	121.5782	25.13908
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1708	1709	臺北市士林區平菁街93巷口	121.5783	25.1379
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1710	1715	臺北市士林區平菁街93巷5號	121.57747	25.13317
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1716	1720	臺北市士林區內厝公車站牌(95巷)	121.57956	25.13297
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1721	1721	臺北市士林區平菁街106巷巷口(大榕樹)	121.57507	25.12897
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1722	1722	臺北市士林區平菁街106巷3號前	121.57604	25.1296
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1723	1727	臺北市士林區平菁街84巷尾(土地公)	121.57569	25.13065
士林區	菁山里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1728	1729	臺北市士林區平菁街106巷(合誠宮公車站牌)	121.57496	25.13027
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1730	1731	臺北市士林區平菁街110號	121.57419	25.12717
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1732	1735	臺北市士林區平菁街112-1號	121.5739	25.12585
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1736	1737	臺北市士林區大坪尾公車站牌(反迴)	121.57197	25.12189
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1738	1744	臺北市士林區平菁街105巷口	121.57526	25.12882
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1745	1746	臺北市士林區菁山里二公車站牌	121.56506	25.14215
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1747	1749	臺北市士林區菁山里一	121.56423	25.14359
士林區	菁山里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1750	1751	臺北市士林區菁山路131巷13號	121.5666	25.14496
士林區	菁山里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1752	1754	臺北市士林區菁山路131巷18號	121.56785	25.1444
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1755	1757	臺北市士林區平菁街131巷27號(福田園)	121.56836	25.14459
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1758	1758	臺北市士林區菁山路衛星電台公車站牌	121.56497	25.14469
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1758	1759	臺北市士林區菁山路117號	121.55939	25.14411
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1800	1800	臺北市士林區菁山路101巷7號	121.55699	25.14359
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1801	1802	臺北市士林區菁山路99巷18號	121.55385	25.14354
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1803	1803	臺北市士林區菁山路99巷37號	121.5523	25.14719
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1804	1805	臺北市士林區菁山路99巷40號	121.55356	25.1474
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1806	1807	臺北市士林區菁山路99巷63號	121.55513	25.14809
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1808	1809	臺北市士林區菁山路101巷49弄口	121.55837	25.14711
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1810	1811	臺北市士林區菁山五公車站牌	121.55915	25.14843
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1812	1813	臺北市士林區菁山路101巷58弄巷口	121.56026	25.14952
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1814	1815	臺北市士林區菁山遊憩區一	121.56113	25.15155
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1816	1817	臺北市士林區菁山路101巷71弄36-2號	121.55664	25.15086
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1818	1819	臺北市士林區101巷32弄口	121.55883	25.14645
士林區	平等里	草山分隊	107-G24	KEA-0879	草山-2	第1車	1820	1822	臺北市士林區平菁街101巷21弄口	121.55758	25.14504
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	1945	1950	臺北市士林區陽明集會所	121.54734	25.13828
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	1951	1956	臺北市士林區格致路與菁山路口	121.54656	25.13787
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	1957	2000	臺北市士林區格致路166巷口	121.5499	25.14128
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2002	2005	臺北市士林區格致路.大亨路口	121.54923	25.14288
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2006	2010	臺北市士林區大亨路6巷口	121.54875	25.14276
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2012	2015	臺北市士林區陽明路1段24巷口	121.5494	25.14896
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2016	2019	臺北市士林區陽明路1段50號	121.54983	24.14991
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2020	2021	臺北市士林區新園街巷底	121.55581	25.1545
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2022	2023	臺北市士林區新園街75巷口	121.55424	25.15207
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2024	2025	臺北市士林區新園街51巷口	121.55363	25.15173
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2026	2027	臺北市士林區新園街40巷口	121.55326	25.15149
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2028	2029	臺北市士林區新園街27號	121.55302	25.15132
士林區	菁山里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2029	2030	臺北市士林區新園街11巷口	121.55268	25.15099
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2032	2035	臺北市士林區格致路251巷口	121.54966	25.14569
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2037	2040	臺北市士林區愛富一街口	121.54654	25.13818
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2042	2045	臺北市士林區華岡路2號	121.54357	25.13851
士林區	陽明里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2050	2100	臺北市士林區華岡路47巷口	121.5418	25.13782
士林區	新安里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2103	2110	臺北市士林區仰德大道3段125巷內	121.5508	25.12191
士林區	新安里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2112	2117	臺北市士林區仰德大道3段105巷內	121.5513	25.11985
士林區	永福里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2118	2120	臺北市士林區永福派出所	121.55247	25.11849
士林區	新安里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2120	2125	臺北市士林區福音山莊	121.55039	25.11416
士林區	新安里	草山分隊	107-G24	KEA-0879	草山-2	第2車	2127	2140	臺北市士林區仰德大道沿線	121.55001	25.11312
士林區	天玉里	天母分隊	107-G25	KEA-0880	天母-5	第1車	1710	1716	臺北市士林區中山北路7段81巷41弄7號	121.52861	25.12182
士林區	天母里	天母分隊	107-G25	KEA-0880	天母-5	第1車	1730	1738	臺北市士林區中山北路7段191巷18號	121.53177	25.12545
士林區	天母里	天母分隊	107-G25	KEA-0880	天母-5	第1車	1739	1744	臺北市士林區中山北路7段227巷8號	121.53275	25.12772
士林區	天母里	天母分隊	107-G25	KEA-0880	天母-5	第1車	1745	1750	臺北市士林區中山北路7段232巷16號	121.53389	25.12703
士林區	天母里	天母分隊	107-G25	KEA-0880	天母-5	第1車	1751	1756	臺北市士林區中山北路7段190巷32號	121.53513	25.12586
士林區	天母里	天母分隊	107-G25	KEA-0880	天母-5	第2車	1850	1858	臺北市士林區中山北路7段190巷27號	121.53504	25.12589
士林區	天母里	天母分隊	107-G25	KEA-0880	天母-5	第2車	1859	1904	臺北市士林區中山北路7段190巷18弄2號	121.53452	25.12556
士林區	天母里	天母分隊	107-G25	KEA-0880	天母-5	第2車	1905	1910	臺北市士林區中山北路7段190巷9號	121.53363	25.12527
士林區	天和里	天母分隊	107-G25	KEA-0880	天母-5	第2車	1911	1914	臺北市士林區中山北路7段190巷12弄5號	121.53394	25.12362
士林區	天和里	天母分隊	107-G25	KEA-0880	天母-5	第2車	1915	1918	臺北市士林區中山北路7段114巷33弄10號	121.53398	25.12351
士林區	天和里	天母分隊	107-G25	KEA-0880	天母-5	第2車	1920	1923	臺北市士林區中山北路7段114巷77號	121.53666	25.12177
士林區	天和里	天母分隊	107-G25	KEA-0880	天母-5	第2車	1924	1927	臺北市士林區中山北路7段114巷69弄1號	121.53598	25.12233
士林區	天和里	天母分隊	107-G25	KEA-0880	天母-5	第2車	1928	1931	臺北市士林區中山北路7段114巷51弄口	121.53499	25.1237
士林區	天和里	天母分隊	107-G25	KEA-0880	天母-5	第2車	1932	1935	臺北市士林區中山北路7段114巷41弄19號	121.53513	25.12474
士林區	天和里	天母分隊	107-G25	KEA-0880	天母-5	第2車	1936	1939	臺北市士林區中山北路7段114巷41弄9號	121.53466	25.12408
士林區	東山里	天母分隊	107-G25	KEA-0880	天母-5	第3車	2050	2054	臺北市士林區東山路142號對面	121.53967	25.11195
士林區	東山里	天母分隊	107-G25	KEA-0880	天母-5	第3車	2055	2100	臺北市士林區士東路336號	121.53921	25.11379
士林區	天和里	天母分隊	107-G25	KEA-0880	天母-5	第3車	2105	2115	臺北市士林區中山北路7段114巷40號	121.53405	25.12294
士林區	東山里	天母分隊	107-G25	KEA-0880	天母-5	第3車	2125	2128	臺北市士林區東山路25巷81弄8號	121.5419	25.12135
士林區	東山里	天母分隊	107-G25	KEA-0880	天母-5	第3車	2129	2131	臺北市士林區東山路25巷99弄2號	121.54408	25.12099
士林區	東山里	天母分隊	107-G25	KEA-0880	天母-5	第3車	2132	2135	臺北市士林區東山路25巷88弄8號	121.54343	25.11842
士林區	東山里	天母分隊	107-G25	KEA-0880	天母-5	第3車	2136	2140	臺北市士林區東山路25巷50號	121.54192	25.11852
大同區	永樂里	延平分隊	108-G01	KEA-1675	延平-2	第1車	1600	1603	臺北市大同區西寧北路民生西路口	121.50898	25.05676
大同區	永樂里	延平分隊	108-G01	KEA-1675	延平-2	第1車	1604	1608	臺北市大同區西寧北路86巷口	121.50888	25.05516
大同區	永樂里	延平分隊	108-G01	KEA-1675	延平-2	第1車	1609	1612	臺北市大同區西寧北路78號	121.5088	25.05441
大同區	永樂里	延平分隊	108-G01	KEA-1675	延平-2	第1車	1613	1616	臺北市大同區西寧北路68號	121.50869	25.05366
大同區	玉泉里	延平分隊	108-G01	KEA-1675	延平-2	第1車	1617	1620	臺北市大同區南京西路434巷口	121.50899	25.05334
大同區	玉泉里	延平分隊	108-G01	KEA-1675	延平-2	第1車	1624	1628	臺北市大同區延平北路1段66巷口	121.51186	25.05151
大同區	玉泉里	延平分隊	108-G01	KEA-1675	延平-2	第1車	1629	1632	臺北市大同區延平北路1段22號	121.51195	25.05056
大同區	玉泉里	延平分隊	108-G01	KEA-1675	延平-2	第1車	1636	1638	臺北市大同區忠孝西路2段13號	121.50945	25.04833
大同區	玉泉里	延平分隊	108-G01	KEA-1675	延平-2	第1車	1643	1646	臺北市大同區西寧北路3巷口	121.508	25.04978
大同區	朝陽里	延平分隊	108-G01	KEA-1675	延平-2	第1車	1649	1653	臺北市大同區延平北路2段61巷口	121.51169	25.05552
大同區	朝陽里	延平分隊	108-G01	KEA-1675	延平-2	第1車	1654	1657	臺北市大同區延平北路2段97號	121.51163	25.05656
大同區	南芳里	延平分隊	108-G01	KEA-1675	延平-2	第1車	1700	1705	臺北市大同區涼州街安西街口	121.50997	25.06062
大同區	大有里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1850	1853	臺北市大同區民生西路民樂街口	121.51072	25.05697
大同區	大有里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1854	1857	臺北市大同區民生西路迪化街口	121.50967	25.05692
大同區	大有里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1900	1903	臺北市大同區歸綏街忠和公園	121.5088	25.05809
大同區	大有里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1905	1909	臺北市大同區歸綏街民樂街口	121.5105	25.05824
大同區	大有里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1911	1914	臺北市大同區延平北路2段144巷口	121.51153	25.05754
大同區	永樂里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1916	1919	臺北市大同區延平北路2段60巷口	121.51163	25.0554
大同區	永樂里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1920	1923	臺北市大同區延平北路2段36巷口	121.51166	25.05487
大同區	永樂里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1925	1928	臺北市大同區延平北路甘谷街口	121.51181	25.05271
大同區	玉泉里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1930	1933	臺北市大同區長安西路253號	121.51167	25.05209
大同區	玉泉里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1934	1937	臺北市大同區長安西路285號	121.50966	25.05205
大同區	玉泉里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1939	1942	臺北市大同區長安西路289號	121.50946	25.05205
大同區	玉泉里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1944	1946	臺北市大同區長安西路貴德街口	121.50792	25.05222
大同區	玉泉里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1947	1949	臺北市大同區環河北路1段83號	121.50741	25.05297
大同區	永樂里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1950	1952	臺北市大同區環河北路1段141號	121.50768	25.05439
大同區	大有里	延平分隊	108-G01	KEA-1675	延平-2	第2車	1954	1957	臺北市大同區環河北路1段迪化街224巷底	121.50849	25.05953
大同區	建功里	延平分隊	108-G01	KEA-1675	延平-2	第3車	2136	2139	臺北市大同區延平北路1段17號	121.512	25.05017
大同區	建功里	延平分隊	108-G01	KEA-1675	延平-2	第3車	2140	2143	臺北市大同區延平北路1段69巷口	121.51194	25.05147
大同區	朝陽里	延平分隊	108-G01	KEA-1675	延平-2	第3車	2147	2150	臺北市大同區延平北路2段61巷口	121.51169	25.05552
大同區	延平里	延平分隊	108-G01	KEA-1675	延平-2	第3車	2153	2156	臺北市大同區保安街78巷口	121.51207	25.05904
大同區	延平里	延平分隊	108-G01	KEA-1675	延平-2	第3車	2157	2159	臺北市大同區保安街甘州街口	121.51277	25.05912
大同區	延平里	延平分隊	108-G01	KEA-1675	延平-2	第3車	2203	2205	臺北市大同區甘州街1號前	121.51299	25.05833
大同區	延平里	延平分隊	108-G01	KEA-1675	延平-2	第3車	2206	2209	臺北市大同區歸綏街209號	121.512	25.05817
大安區	龍安里	和平分隊	108-G02	KEA-1676	和平-3	第1車	1800	1806	臺北市大安區和平東路1段185號	121.53333	25.02625
大安區	龍安里	和平分隊	108-G02	KEA-1676	和平-3	第1車	1807	1815	臺北市大安區和平東路1段163號	121.53193	25.02638
大安區	錦安里	和平分隊	108-G02	KEA-1676	和平-3	第1車	1820	1830	臺北市大安區永康街75巷14號旁	121.53057	25.02883
大安區	龍安里	和平分隊	108-G02	KEA-1676	和平-3	第1車	1832	1840	臺北市大安區青田街1巷口	121.53192	25.02902
大安區	龍安里	和平分隊	108-G02	KEA-1676	和平-3	第1車	1845	1855	臺北市大安區新生南路2段72號旁	121.53454	25.02771
大安區	錦安里	和平分隊	108-G02	KEA-1676	和平-3	第2車	2015	2020	臺北市大安區金山南路2段239號前	121.52599	25.0269
大安區	永康里	和平分隊	108-G02	KEA-1676	和平-3	第2車	2024	2029	臺北市大安區信義路2段116號旁	121.52787	25.03389
大安區	永康里	和平分隊	108-G02	KEA-1676	和平-3	第2車	2032	2040	臺北市大安區金山南路2段31巷口	121.52904	25.03269
大安區	永康里	和平分隊	108-G02	KEA-1676	和平-3	第2車	2042	2050	臺北市大安區金華街 199 巷3弄8號旁	121.52861	25.03058
大安區	福住里	和平分隊	108-G02	KEA-1676	和平-3	第2車	2052	2100	臺北市大安區金華街243巷口	121.53062	25.02977
大安區	福住里	和平分隊	108-G02	KEA-1676	和平-3	第3車	2210	2215	臺北市大安區新生南路2段26號前	121.53299	25.03211
大安區	福住里	和平分隊	108-G02	KEA-1676	和平-3	第3車	2220	2229	臺北市大安區永康街12巷口	121.52954	25.0315
大安區	福住里	和平分隊	108-G02	KEA-1676	和平-3	第3車	2231	2240	臺北市大安區信義路2段200號旁	121.5303	25.03356
大安區	福住里	和平分隊	108-G02	KEA-1676	和平-3	第3車	2242	2250	臺北市大安區信義路2段230號旁	121.53167	25.03352
大安區	全安里	安和分隊	108-G03	KEA-1677	安和-3	第1車	1700	1705	臺北市大安區安和路2段225號前	121.55018	25.02538
大安區	全安里	安和分隊	108-G03	KEA-1677	安和-3	第1車	1705	1715	臺北市大安區安和路2段187號前	121.55026	25.02648
大安區	通安里	安和分隊	108-G03	KEA-1677	安和-3	第1車	1715	1725	臺北市大安區安和路2段123號前	121.55139	25.02929
大安區	敦煌里	安和分隊	108-G03	KEA-1677	安和-3	第1車	1730	1745	臺北市大安區安和路1段129號前	121.55262	25.03463
大安區	敦煌里	安和分隊	108-G03	KEA-1677	安和-3	第1車	1745	1750	臺北市大安區安和路1段91號前	121.55274	25.03616
大安區	全安里	安和分隊	108-G03	KEA-1677	安和-3	第2車	1915	1920	臺北市大安區敦化南路2段263號前	121.54902	25.02546
大安區	義安里	安和分隊	108-G03	KEA-1677	安和-3	第2車	1920	1925	臺北市大安區敦化南路2段71號前	121.54923	25.03059
大安區	義安里	安和分隊	108-G03	KEA-1677	安和-3	第2車	1925	1930	臺北市大安區敦化南路2段37巷口	121.54908	25.03213
大安區	義安里	安和分隊	108-G03	KEA-1677	安和-3	第2車	1930	1935	臺北市大安區信義路4段188號前	121.55166	25.03308
大安區	通安里	安和分隊	108-G03	KEA-1677	安和-3	第2車	1935	1940	臺北市大安區信義路4段222號前	121.53657	25.01114
大安區	通化里	安和分隊	108-G03	KEA-1677	安和-3	第2車	1940	1945	臺北市大安區信義路4段374號加油站前	121.55547	25.03292
大安區	通化里	安和分隊	108-G03	KEA-1677	安和-3	第2車	1945	1950	臺北市大安區光復南路606號	121.55727	25.03272
大安區	通化里	安和分隊	108-G03	KEA-1677	安和-3	第2車	1953	2005	臺北市大安區光復南路676號前	121.55728	25.03031
大安區	臨江里	安和分隊	108-G03	KEA-1677	安和-3	第3車	2130	2140	臺北市大安區基隆路2段140號前	121.55671	25.02837
大安區	法治里	安和分隊	108-G03	KEA-1677	安和-3	第3車	2140	2148	臺北市大安區基隆路2段184巷口	121.55324	25.02507
大安區	全安里	安和分隊	108-G03	KEA-1677	安和-3	第3車	2148	2200	臺北市大安區和平東路3段129號前	121.55216	25.02459
大安區	群賢里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第1車	1750	1800	臺北市大安區復興南路2段237號	121.54354	25.02574
大安區	群賢里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第1車	1802	1807	臺北市大安區復興南路2段175號	121.54356	25.02738
大安區	群英里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第1車	1810	1825	臺北市大安區復興南路2段151巷30弄1號	121.54534	25.02823
大安區	群英里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第1車	1835	1920	臺北市大安區和平東路2段311巷50號前	121.54519	25.02637
大安區	群賢里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第2車	2035	2050	臺北市大安區四維路170巷20號	121.54703	25.02821
大安區	群賢里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第2車	2051	2100	臺北市大安區敦化南路2段126號(鳳雛公園)	121.54848	25.02626
大安區	群賢里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第2車	2101	2104	臺北市大安區敦化南路2段148號	121.54848	25.02545
大安區	群賢里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第2車	2107	2120	臺北市大安區和平東路2段365號(新增)	121.54664	25.02473
大安區	群賢里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第2車	2121	2133	臺北市大安區和平東路2段315號(新增)	121.54517	25.02488
大安區	虎嘯里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第2車	2143	2150	臺北市大安區和平東路3段22號	121.54726	25.02459
大安區	虎嘯里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第2車	2152	2155	臺北市大安區和平東路3段66號	121.55014	25.02441
大安區	虎嘯里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第2車	2157	2207	臺北市大安區和平東路3段78號	121.55076	25.02438
大安區	虎嘯里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第2車	2210	2215	臺北市大安區基隆路2段192號	121.55201	25.02393
大安區	虎嘯里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第2車	2215	2220	臺北市大安區基隆路2段228號(新增)	121.55117	25.0232
大安區	虎嘯里	臥龍分隊	108-G04	KEA-1678	臥龍-2	第2車	2221	2223	臺北市大安區基隆路2段272號	121.54979	25.02202
中山區	新喜里	民一分隊	108-G05	KEA-1679	民一-3	第1車	1658	1718	臺北市中山區松江路526號前	121.53311	25.06662
中山區	新生里	民一分隊	108-G05	KEA-1679	民一-3	第1車	1725	1730	臺北市中山區松江路350號前	121.53305	25.06168
中山區	新生里	民一分隊	108-G05	KEA-1679	民一-3	第1車	1732	1740	臺北市中山區松江路328號前	121.53303	25.06103
中山區	中庄里	民一分隊	108-G05	KEA-1679	民一-3	第1車	1742	1750	臺北市中山區松江路266號前	121.533	25.05948
中山區	中庄里	民一分隊	108-G05	KEA-1679	民一-3	第2車	1925	1933	臺北市中山區民生東路2段25號前	121.52861	25.05814
中山區	中庄里	民一分隊	108-G05	KEA-1679	民一-3	第2車	1935	1943	臺北市中山區新生北路2段121號前	121.52786	25.05905
中山區	中庄里	民一分隊	108-G05	KEA-1679	民一-3	第2車	1945	1953	臺北市中山區新生北路2段125號前	121.52787	25.05959
中山區	新生里	民一分隊	108-G05	KEA-1679	民一-3	第2車	1955	2003	臺北市中山區新生北路2段135號前	121.52788	25.06096
中山區	新生里	民一分隊	108-G05	KEA-1679	民一-3	第2車	2005	2013	臺北市中山區新生北路2段143號前	121.5279	25.06172
中山區	新生里	民一分隊	108-G05	KEA-1679	民一-3	第2車	2015	2023	臺北市中山區民權東路2段24號前	121.52875	25.0625
中山區	新生里	民一分隊	108-G05	KEA-1679	民一-3	第2車	2025	2032	臺北市中山區吉林路312號前	121.53021	25.06192
中山區	新生里	民一分隊	108-G05	KEA-1679	民一-3	第2車	2035	2040	臺北市中山區吉林路288號	121.53032	25.06099
中山區	中庄里	民一分隊	108-G05	KEA-1679	民一-3	第2車	2041	2045	臺北市中山區吉林路246號	121.53023	25.0596
中山區	中庄里	民一分隊	108-G05	KEA-1679	民一-3	第2車	2046	2050	臺北市中山區吉林路210號	121.53025	25.05876
中山區	中庄里	民一分隊	108-G05	KEA-1679	民一-3	第3車	2150	2203	臺北市中山區錦州街222號前(松江市場)	121.53219	25.06033
中山區	新生里	民一分隊	108-G05	KEA-1679	民一-3	第3車	2205	2220	臺北市中山區錦州街140號前(錦州公園)	121.5291	25.06035
中正區	龍福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1700	1705	臺北市中正區牯嶺街5巷口斜對面	121.51533	25.03173
中正區	龍福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1706	1711	臺北市中正區牯嶺街24號前	121.51607	25.03049
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1712	1715	臺北市中正區牯嶺街38號前	121.5166	25.02976
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1716	1720	臺北市中正區牯嶺街58之1號前	121.51713	25.02901
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1721	1725	臺北市中正區和平西路1段71號前	121.51867	25.02664
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1728	1732	臺北市中正區重慶南路3段23號前	121.51583	25.0286
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1733	1737	臺北市中正區重慶南路3段1之4號前	121.51553	25.02961
中正區	龍福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1739	1743	臺北市中正區重慶南路2段73號前	121.51539	25.03004
中正區	龍福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1743	1747	臺北市中正區重慶南路2段59號前	121.51508	25.0308
中正區	龍福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1748	1752	臺北市中正區重慶南路2段15號前	121.51427	25.03257
中正區	板溪里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1802	1807	臺北市中正區南昌路2段96號前	121.52176	25.02616
中正區	頂東里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1808	1812	臺北市中正區南昌路2段140號前	121.52283	25.02525
中正區	頂東里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1813	1818	臺北市中正區南昌路2段206號前	121.52432	25.02404
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1840	1844	臺北市中正區南昌路2段69號前	121.52059	25.02742
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1845	1849	臺北市中正區南昌路2段31號前	121.51984	25.02802
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1850	1854	臺北市中正區南昌路1段141號前	121.51859	25.02959
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1855	1859	臺北市中正區南昌路1段105號前	121.51814	25.03019
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第1車	1900	1907	臺北市中正區南昌路1段45號前	121.51736	25.03128
中正區	螢雪里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2030	2034	臺北市中正區汀州路2段8號旁	121.5159	25.02577
中正區	螢圃里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2035	2039	臺北市中正區汀州路2段30號	121.51722	25.02533
中正區	螢圃里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2040	2044	臺北市中正區汀州路2段70號	121.51855	25.02508
中正區	螢圃里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2045	2050	臺北市中正區汀州路2段118號	121.52029	25.02464
中正區	螢圃里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2051	2055	臺北市中正區汀州路2段150號	121.52135	25.02419
中正區	新營里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2105	2109	臺北市中正區羅斯福路2段7之5號	121.52127	25.02913
中正區	新營里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2110	2114	臺北市中正區羅斯福路1段121號	121.52003	25.03075
中正區	新營里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2115	2119	臺北市中正區羅斯福路1段79號前	121.51963	25.03127
中正區	新營里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2122	2125	臺北市中正區愛國東路60號前	121.51896	25.0339
中正區	龍福里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2135	2139	臺北市中正區牯嶺街7號對面	121.51531	25.0315
中正區	龍福里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2140	2146	臺北市中正區牯嶺街24號前	121.51592	25.03041
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2147	2151	臺北市中正區南昌路1段106號旁	121.51775	25.03034
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2152	2156	臺北市中正區南昌路1段130號前	121.51832	25.02957
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2157	2201	臺北市中正區南昌路2段4之1號前	121.51938	25.0282
中正區	南福里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2202	2206	臺北市中正區南昌路2段42號旁	121.52017	25.0275
中正區	板溪里	南昌分隊	108-G06	KEA-1680	南昌-2	第2車	2207	2210	臺北市中正區南昌路2段96號前	121.52176	25.02616
內湖區	週美里	文德分隊	108-G08	KEA-1682	文德-3	第1車	1630	1643	臺北市內湖區民權東路6段46巷與行忠路交叉路口	121.58301	25.06725
內湖區	寶湖里	文德分隊	108-G08	KEA-1682	文德-3	第1車	1657	1700	臺北市內湖區民權東路6段234號	121.60042	25.06683
內湖區	寶湖里	文德分隊	108-G08	KEA-1682	文德-3	第1車	1703	1705	臺北市內湖區民權東路6段205號	121.59916	25.06718
內湖區	寶湖里	文德分隊	108-G08	KEA-1682	文德-3	第1車	1707	1711	臺北市內湖區民權東路6段131號	121.59398	25.06899
內湖區	湖興里	文德分隊	108-G08	KEA-1682	文德-3	第1車	1715	1720	臺北市內湖區民權東路6段99號前	121.58909	25.06915
內湖區	湖興里	文德分隊	108-G08	KEA-1682	文德-3	第1車	1725	1730	臺北市內湖區民權東路6段45號	121.58604	25.06925
內湖區	寶湖里	文德分隊	108-G08	KEA-1682	文德-3	第1車	1735	1743	臺北市內湖區成功路2段217號旁	121.59091	25.06727
內湖區	寶湖里	文德分隊	108-G08	KEA-1682	文德-3	第1車	1745	1750	臺北市內湖區成功路2段309號	121.3527	25.4107
內湖區	紫陽里	文德分隊	108-G08	KEA-1682	文德-3	第1車	1757	1801	臺北市內湖區文德路155號前	121.58485	25.0788
內湖區	瑞陽里	文德分隊	108-G08	KEA-1682	文德-3	第1車	1806	1815	臺北市內湖區文德路22巷9弄2號	121.57956	25.0773
內湖區	湖元里	文德分隊	108-G08	KEA-1682	文德-3	第2車	1930	1940	臺北市內湖區民權東路6段90巷14號	121.58591	25.06804
內湖區	湖元里	文德分隊	108-G08	KEA-1682	文德-3	第2車	1945	1955	臺北市內湖區民權東路6段136巷30號	121.58762	25.06786
內湖區	瑞光里	文德分隊	108-G08	KEA-1682	文德-3	第2車	2005	2015	臺北市內湖區江南街71巷75弄22號	121.57957	25.07562
內湖區	湖興里	文德分隊	108-G08	KEA-1682	文德-3	第3車	2130	2140	臺北市內湖區成功路2段320巷32號	121.58903	25.06747
內湖區	瑞陽里	文德分隊	108-G08	KEA-1682	文德-3	第3車	2150	2158	臺北市內湖區文德路22巷74弄10號	121.58117	25.07552
內湖區	湖興里	文德分隊	108-G08	KEA-1682	文德-3	第3車	2205	2212	臺北市內湖區成功路2段496號	121.58963	25.0735
內湖區	湖興里	文德分隊	108-G08	KEA-1682	文德-3	第3車	2215	2220	臺北市內湖區成功路2段432號	121.58965	25.07148
內湖區	湖興里	文德分隊	108-G08	KEA-1682	文德-3	第3車	2225	2230	臺北市內湖區成功路2段252號	121.59037	25.06612
文山區	順興里	復興分隊	108-G09	KEA-1683	復興-2	第1車	1750	1753	臺北市文山區保儀路129號旁	121.56704	24.98506
文山區	順興里	復興分隊	108-G09	KEA-1683	復興-2	第1車	1800	1804	臺北市文山區木新路2段160號前	121.56865	24.98407
文山區	順興里	復興分隊	108-G09	KEA-1683	復興-2	第1車	1804	1808	臺北市文山區木新路2段220號前	121.56733	24.98364
文山區	順興里	復興分隊	108-G09	KEA-1683	復興-2	第1車	1809	1814	臺北市文山區木新路2段234號旁	121.56689	24.98344
文山區	順興里	復興分隊	108-G09	KEA-1683	復興-2	第1車	1815	1818	臺北市文山區保儀路152號旁	121.56558	24.98321
文山區	順興里	復興分隊	108-G09	KEA-1683	復興-2	第1車	1819	1825	臺北市文山區木新路3段54號前	121.56406	24.98261
文山區	明興里	復興分隊	108-G09	KEA-1683	復興-2	第1車	1828	1835	臺北市文山區興隆路4段55號前	121.55987	24.98967
文山區	明興里	復興分隊	108-G09	KEA-1683	復興-2	第1車	1836	1841	臺北市文山區興隆路4段27號前	121.55948	24.99051
文山區	明興里	復興分隊	108-G09	KEA-1683	復興-2	第1車	1842	1844	臺北市文山區興隆路4段1巷3號旁	121.55931	24.99127
文山區	明義里	復興分隊	108-G09	KEA-1683	復興-2	第1車	1845	1851	臺北市文山區興隆路4段12號前	121.55995	24.98902
文山區	順興里	復興分隊	108-G09	KEA-1683	復興-2	第2車	1945	1949	臺北市文山區興隆路4段215號前	121.56248	24.98261
文山區	順興里	復興分隊	108-G09	KEA-1683	復興-2	第2車	1949	1953	臺北市文山區興隆路4段177-1號前	121.56213	24.98373
文山區	順興里	復興分隊	108-G09	KEA-1683	復興-2	第2車	1954	1958	臺北市文山區興隆路4段165巷20號前	121.56301	24.98415
文山區	順興里	復興分隊	108-G09	KEA-1683	復興-2	第2車	1959	2003	臺北市文山區忠順街2段90巷7號前	121.56491	24.98451
文山區	順興里	復興分隊	108-G09	KEA-1683	復興-2	第2車	2004	2008	臺北市文山區忠順街2段90巷1號旁	121.56582	24.98488
文山區	忠順里	復興分隊	108-G09	KEA-1683	復興-2	第2車	2009	2014	臺北市文山區忠順街2段55號前	121.56419	24.98503
文山區	忠順里	復興分隊	108-G09	KEA-1683	復興-2	第2車	2015	2020	臺北市文山區忠順街2段21號前	121.56274	24.98479
文山區	忠順里	復興分隊	108-G09	KEA-1683	復興-2	第2車	2021	2025	臺北市文山區興隆路4段143號前	121.56165	24.98513
文山區	忠順里	復興分隊	108-G09	KEA-1683	復興-2	第2車	2027	2031	臺北市文山區興隆路4段109巷38號前	121.56314	24.98678
文山區	樟腳里	復興分隊	108-G09	KEA-1683	復興-2	第3車	2130	2132	臺北市文山區興隆路4段109巷94號對面(明道國小後門)	121.56362	24.98689
文山區	樟腳里	復興分隊	108-G09	KEA-1683	復興-2	第3車	2142	2145	臺北市文山區木新路3段97號旁	121.56278	24.98206
文山區	樟腳里	復興分隊	108-G09	KEA-1683	復興-2	第3車	2145	2149	臺北市文山區木新路3段41號前	121.56432	24.98239
文山區	樟腳里	復興分隊	108-G09	KEA-1683	復興-2	第3車	2150	2153	臺北市文山區木新路2段295號前	121.56546	24.98271
文山區	樟腳里	復興分隊	108-G09	KEA-1683	復興-2	第3車	2154	2158	臺北市文山區木新路2段251號前	121.56695	24.98318
文山區	樟腳里	復興分隊	108-G09	KEA-1683	復興-2	第3車	2159	2202	臺北市文山區木新路2段199號前	121.56793	24.98348
文山區	木新里	復興分隊	108-G09	KEA-1683	復興-2	第3車	2203	2205	臺北市文山區木新路2段161巷8號前	121.56898	24.98326
文山區	樟腳里	復興分隊	108-G09	KEA-1683	復興-2	第3車	2206	2210	臺北市文山區木新路2段211巷10弄15號前	121.56791	24.98242
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1710	1715	臺北市文山區景後街145號前	121.54236	24.9909
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1716	1721	臺北市文山區景後街103號前	121.54207	24.99031
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1723	1730	臺北市文山區景興路206號前	121.54366	24.99151
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1731	1739	臺北市文山區景興路276號旁	121.54247	24.98967
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1740	1745	臺北市文山區景美街148號旁	121.54177	24.98839
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1747	1752	臺北市文山區景文街165號前	121.54091	24.98901
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1753	1758	臺北市文山區景文街123號前	121.54114	24.99037
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1759	1808	臺北市文山區景文街75號前	121.54134	24.99123
文山區	景華里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1810	1813	臺北市文山區羅斯福路6段299號前	121.5414	24.99428
文山區	景美里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1819	1827	臺北市文山區羅斯福路6段234號前	121.54053	24.99239
文山區	景美里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1828	1837	臺北市文山區羅斯福路6段308號前	121.53962	24.9906
文山區	景美里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1841	1850	臺北市文山區萬慶街37巷9號旁	121.53874	24.99278
文山區	景美里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1851	1858	臺北市文山區育英街30號旁	121.53832	24.99169
文山區	景美里	景美分隊	108-G10	KEA-1685	景美-2	第1車	1900	1910	臺北市文山區育英街31巷36弄2號旁	121.53762	24.99008
文山區	景華里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2046	2051	臺北市文山區景中街27號旁	121.54238	24.9929
文山區	景美里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2052	2057	臺北市文山區羅斯福路6段234號前	121.54053	24.99239
文山區	景美里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2058	2103	臺北市文山區羅斯福路6段308號前	121.53962	24.9906
文山區	景慶里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2105	2108	臺北市文山區景福街283號前	121.54024	24.99349
文山區	景慶里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2109	2115	臺北市文山區景福街251巷2號旁	121.53957	24.99375
文山區	景慶里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2116	2121	臺北市文山區景福街221號旁	121.53836	24.99426
文山區	景慶里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2122	2129	臺北市文山區景福街177號旁	121.53737	24.99492
文山區	景慶里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2130	2134	臺北市文山區景福街133巷2號旁	121.53737	24.9956
文山區	景慶里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2135	2140	臺北市文山區溪口街127號旁	121.53686	24.99657
文山區	景慶里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2140	2145	臺北市文山區溪口街101號	121.53767	24.9961
文山區	景慶里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2147	2158	臺北市文山區溪口街85巷旁	121.53871	24.99552
文山區	景慶里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2159	2206	臺北市文山區溪口街53號前	121.53964	24.99498
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2212	2217	臺北市文山區景興路206號旁	121.54369	24.99159
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2218	2221	臺北市文山區景興路276號旁	121.54247	24.98967
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2222	2226	臺北市文山區景美街148號旁	121.54177	24.98839
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2227	2228	臺北市文山區景文街165號前	121.54091	24.98901
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2229	2230	臺北市文山區景文街123號前	121.54114	24.99037
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2231	2232	臺北市文山區景文街75號前	121.54134	24.99123
文山區	景行里	景美分隊	108-G10	KEA-1685	景美-2	第2車	2233	2234	臺北市文山區景文街41號前	121.54137	24.99147
北投區	中庸里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1615	1620	臺北市北投區珠海路雙全街口	121.50114	25.13766
北投區	中庸里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1621	1631	臺北市北投區珠海路1號	121.50153	25.1377
北投區	中庸里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1633	1635	臺北市北投區臺北市大業路松林飯店	121.50274	25.13743
北投區	中庸里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1636	1639	臺北市北投區大業路雙全街口	121.50102	25.1371
北投區	中庸里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1640	1642	臺北市北投區大業路大同街口	121.49912	25.13696
北投區	豐年里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1643	1645	臺北市北投區大業路中央北路口	121.49718	25.13618
北投區	豐年里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1646	1647	臺北市北投區大業路525巷口	121.49567	25.13429
北投區	大同里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1648	1649	臺北市北投區大業路大興街口	121.49955	25.13045
北投區	大同里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1650	1651	臺北市北投區大業路432號前	121.49671	25.13062
北投區	大同里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1652	1654	臺北市北投區大業路472巷口	121.49604	25.13205
北投區	大同里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1655	1656	臺北市北投區大業路526號	121.49666	25.13477
北投區	大同里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1657	1658	臺北市北投區大業路572號	121.49709	25.13556
北投區	大同里	光明分隊	108-G13	KEA-1689	光明-2	第1車	1659	1700	臺北市北投區大業路大同街口	121.49912	25.13696
北投區	秀山里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1743	1749	臺北市北投區中和街474巷口	121.49527	25.14524
北投區	秀山里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1750	1751	臺北市北投區中和街512號前	121.49402	25.14541
北投區	秀山里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1752	1753	臺北市北投區中和街530號旁	121.49357	25.14546
北投區	稻香里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1754	1755	臺北市北投區秀山橋上	121.4925	25.14501
北投區	稻香里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1757	1759	臺北市北投區秀山路30號前	121.49312	25.14692
北投區	稻香里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1802	1803	臺北市北投區稻香路185號	121.48854	25.1434
北投區	稻香里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1804	1805	臺北市北投區稻香路石仙路口	121.48598	25.14313
北投區	稻香里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1808	1809	臺北市北投區新興路石仙路口	121.48956	25.14113
北投區	稻香里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1811	1812	臺北市北投區新興路70巷口	121.48842	25.14105
北投區	稻香里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1813	1815	臺北市北投區新興路重三路口	121.48801	25.14017
北投區	稻香里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1816	1817	臺北市北投區新興路崗山路口	121.48705	25.14003
北投區	豐年里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1821	1822	臺北市北投區中央北路2段381、371、343號	121.48693	25.13813
北投區	豐年里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1823	1825	臺北市北投區中央北路2段309、307號、273巷前	121.48962	25.13847
北投區	豐年里	光明分隊	108-G13	KEA-1689	光明-2	第2車	1826	1830	臺北市北投區稻香橋上	121.49116	25.13853
北投區	溫泉里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1910	1912	臺北市北投區公館路85巷口	121.50455	25.13132
北投區	溫泉里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1913	1918	臺北市北投區公館路63巷口	121.50386	25.13252
北投區	溫泉里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1919	1923	臺北市北投區公館路31號前	121.50317	25.13302
北投區	溫泉里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1925	1928	臺北市北投區光明路溫泉路口	121.50226	25.13399
北投區	長安里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1929	1931	臺北市北投區光明路150號前	121.50248	25.1347
北投區	長安里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1933	1934	臺北市北投區光明路188號前	121.50329	25.13574
北投區	長安里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1935	1936	臺北市北投區光明路218號前	121.50443	25.13642
北投區	長安里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1939	1940	臺北市北投區光明路228號前	121.50583	25.13601
北投區	溫泉里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1941	1943	臺北市北投區光明路238號前	121.50726	25.13622
北投區	溫泉里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1944	1946	臺北市北投區光明路270號前	121.51008	25.13668
北投區	林泉里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1947	1948	臺北市北投區中山路地熱谷	121.50571	25.1361
北投區	林泉里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1950	1953	臺北市北投區中山路5號前	121.50806	25.13701
北投區	林泉里	光明分隊	108-G13	KEA-1689	光明-2	第3車	1955	2000	臺北市北投區中山路1號前	121.50477	25.13708
北投區	中心里	光明分隊	108-G13	KEA-1689	光明-2	第3車	2001	2005	臺北市北投區中和街20巷口	121.50315	25.13775
北投區	中庸里	光明分隊	108-G13	KEA-1689	光明-2	第3車	2006	2008	臺北市北投區大業路雙全街口	121.50104	25.13708
北投區	中庸里	光明分隊	108-G13	KEA-1689	光明-2	第3車	2009	2010	臺北市北投區大業路大同街口	121.49912	25.13696
北投區	文化里	光明分隊	108-G13	KEA-1689	光明-2	第3車	2011	2013	臺北市北投區大業路中央北路口	121.49717	25.13629
北投區	豐年里	光明分隊	108-G13	KEA-1689	光明-2	第3車	2014	2015	臺北市北投區大業路525巷口	121.49567	25.13429
北投區	文化里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2050	2103	臺北市北投區文化三路杏林一路口	121.49915	25.1407
北投區	文化里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2104	2106	臺北市北投區文化三路區里公園旁	121.49811	25.13899
北投區	文化里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2107	2109	臺北市北投區文化三路12號	121.49783	25.13759
北投區	文化里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2110	2112	臺北市北投區文化三路2號	121.49722	25.13712
北投區	文化里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2113	2116	臺北市北投區中央北路2段42巷口	121.49533	25.13697
北投區	文化里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2117	2119	臺北市北投區中央北路2段66巷口	121.49257	25.13812
北投區	文化里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2120	2122	臺北市北投區中央北路2段130號	121.49162	25.13857
北投區	稻香里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2123	2124	臺北市北投區中央北路2段320巷口	121.48969	25.13854
北投區	豐年里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2125	2126	臺北市北投區中央北路2段275號	121.49059	25.13838
北投區	豐年里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2127	2128	臺北市北投區中央北路2段豐年路口	121.49265	25.13732
北投區	豐年里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2129	2131	臺北市北投區中央北路2段131巷口	121.49426	25.13743
北投區	豐年里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2132	2133	臺北市北投區中央北路2段95巷口	121.49537	25.1369
北投區	豐年里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2134	2136	臺北市北投區豐年公園	121.49672	25.13628
北投區	大同里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2137	2140	臺北市北投區大業路大興街口	121.49709	25.12975
北投區	大同里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2141	2144	臺北市北投區大業路432號前	121.49664	25.13079
北投區	大同里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2145	2150	臺北市北投區大業路472巷口	121.49604	25.13204
北投區	大同里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2151	2152	臺北市北投區大業路526號	121.49666	25.13477
北投區	大同里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2153	2154	臺北市北投區大業路572號	121.49709	25.13556
北投區	長安里	光明分隊	108-G13	KEA-1689	光明-2	第4車	2155	2200	臺北市北投區大業路大同街口	121.49912	25.13696
松山區	吉仁里	中崙分隊	108-G14	KEA-1690	中崙-2	第1車	1645	1653	臺北市松山區市民大道4段215號	121.55316	25.04453
松山區	復勢里	中崙分隊	108-G14	KEA-1690	中崙-2	第1車	1715	1740	臺北市松山區南京東路4段118號	121.55509	25.05149
松山區	復勢里	中崙分隊	108-G14	KEA-1690	中崙-2	第1車	1755	1805	臺北市松山區八德路3段241號(頂好超市)	121.55712	25.04849
松山區	美仁里	中崙分隊	108-G14	KEA-1690	中崙-2	第1車	1808	1816	臺北市松山區北寧路58號(台北體院斜對面)	121.55268	25.04991
松山區	美仁里	中崙分隊	108-G14	KEA-1690	中崙-2	第1車	1818	1825	臺北市松山區南京東路4段56號	121.55363	25.05157
松山區	中崙里	中崙分隊	108-G14	KEA-1690	中崙-2	第2車	2000	2020	臺北市松山區八德路2段374號	121.54572	25.04814
松山區	中正里	中崙分隊	108-G14	KEA-1690	中崙-2	第2車	2022	2030	臺北市松山區八德路2段449號(臺安醫院對面)	121.54743	25.04831
松山區	復勢里	中崙分隊	108-G14	KEA-1690	中崙-2	第2車	2035	2050	臺北市松山區光復北路78號	121.5578	25.05008
松山區	復建里	中崙分隊	108-G14	KEA-1690	中崙-2	第2車	2052	2057	臺北市松山區光復南路34號	121.55772	25.04662
松山區	復源里	中崙分隊	108-G14	KEA-1690	中崙-2	第2車	2100	2110	臺北市松山區市民大道4段269號	121.55536	25.04478
松山區	敦化里	中崙分隊	108-G14	KEA-1690	中崙-2	第2車	2115	2125	臺北市松山區市民大道4段141號	121.55054	25.04481
松山區	精忠里	東社分隊	108-G15	KEA-1691	東社-3	第1車	1730	1745	臺北市松山區光復北路與富錦街口	121.55483	25.0603
松山區	精忠里	東社分隊	108-G15	KEA-1691	東社-3	第1車	1750	1815	臺北市松山區民生東路4段131巷3號斜對面	121.55394	25.05886
松山區	精忠里	東社分隊	108-G15	KEA-1691	東社-3	第1車	1820	1830	臺北市松山區富錦街12巷8號	121.55123	25.06015
松山區	中華里	東社分隊	108-G15	KEA-1691	東社-3	第1車	1835	1845	臺北市松山區敦化北路199巷19號	121.55212	25.05659
松山區	龍田里	東社分隊	108-G15	KEA-1691	東社-3	第1車	1850	1900	臺北市松山區光復北路161巷口	121.55575	25.0558
松山區	民福里	東社分隊	108-G15	KEA-1691	東社-3	第2車	2030	2040	臺北市松山區民權東路3段193號	121.54844	25.06207
松山區	民福里	東社分隊	108-G15	KEA-1691	東社-3	第2車	2045	2105	臺北市松山區民權東路3段107號	121.54514	25.06222
松山區	民福里	東社分隊	108-G15	KEA-1691	東社-3	第2車	2110	2130	臺北市松山區五常街370號	121.54541	25.06435
松山區	東光里	東社分隊	108-G15	KEA-1691	東社-3	第2車	2145	2210	臺北市松山區健康路170號旁(長壽公園)	121.55908	25.05377
松山區	安平里	松山分隊	108-G16	KEA-1692	松山-3	第1車	1700	1735	臺北市松山區健康路303號	121.56517	25.05438
松山區	安平里	松山分隊	108-G16	KEA-1692	松山-3	第2車	1915	1935	臺北市松山區健康路290號	121.5653	25.05416
松山區	安平里	松山分隊	108-G16	KEA-1692	松山-3	第2車	1940	2000	臺北市松山區寶清街79號對面(寶清公園旁)	121.568	25.05228
松山區	安平里	松山分隊	108-G16	KEA-1692	松山-3	第2車	2005	2025	臺北市松山區南京東路5段269號	121.56549	25.05146
松山區	吉祥里	松山分隊	108-G16	KEA-1692	松山-3	第2車	2035	2050	臺北市松山區八德路4段21號	121.55894	25.04833
松山區	鵬程里	松山分隊	108-G16	KEA-1692	松山-3	第2車	2125	2135	臺北市松山區塔悠路112號	121.56961	25.05519
松山區	安平里	松山分隊	108-G16	KEA-1692	松山-3	第2車	2140	2200	臺北市松山區寶清街123號	121.56757	25.05439
松山區	中正里	中崙分隊	108-G17	KEA-1693	中崙-3	第1車	1740	1750	臺北市松山區復興北路35號	121.54414	25.05011
松山區	中正里	中崙分隊	108-G17	KEA-1693	中崙-3	第1車	1805	1810	臺北市松山區敦化北路118號(中國信託旁)	121.54868	25.05378
松山區	中正里	中崙分隊	108-G17	KEA-1693	中崙-3	第1車	1813	1825	臺北市松山區南京東路3段301號	121.54681	25.05187
松山區	松基里	中崙分隊	108-G17	KEA-1693	中崙-3	第1車	1830	1840	臺北市松山區復興北路229號	121.54425	25.05707
松山區	中崙里	中崙分隊	108-G17	KEA-1693	中崙-3	第2車	2015	2024	臺北市松山區復興南路1段45號	121.54399	25.04553
松山區	中正里	中崙分隊	108-G17	KEA-1693	中崙-3	第2車	2025	2030	臺北市松山區復興北路15號(加油站前)	121.54413	25.04934
松山區	中正里	中崙分隊	108-G17	KEA-1693	中崙-3	第2車	2032	2040	臺北市松山區南京東路3段280號	121.54575	25.05172
松山區	吉仁里	中崙分隊	108-G17	KEA-1693	中崙-3	第2車	2100	2200	臺北市松山區八德路3段106巷口	121.5537	25.04818
信義區	敦厚里	三張犁分隊	108-G18	KEA-1695	三張犁-1	第1車	1800	1810	臺北市信義區基隆路1段101巷2號	121.56743	25.04499
信義區	興雅里	三張犁分隊	108-G18	KEA-1695	三張犁-1	第1車	1815	1845	臺北市信義區松隆路36號全聯社前	121.56741	25.04348
信義區	敦厚里	三張犁分隊	108-G18	KEA-1695	三張犁-1	第2車	2040	2050	臺北市信義區永吉路120巷22弄口	121.5696	25.04489
信義區	興雅里	三張犁分隊	108-G18	KEA-1695	三張犁-1	第2車	2055	2105	臺北市信義區忠孝東路5段207號(慶豐幼稚園)前	121.57015	25.0411
信義區	興雅里	三張犁分隊	108-G18	KEA-1695	三張犁-1	第3車	2115	2150	臺北市信義區永吉路30巷151弄口	121.5689	25.0425
萬華區	西門里	昆明分隊	108-G19	KEA-1696	昆明-2	第1車	1600	1605	臺北市萬華區西寧南路84號	121.50583	25.04231
萬華區	新起里	昆明分隊	108-G19	KEA-1696	昆明-2	第1車	1608	1615	臺北市萬華區西寧南路146號	121.50597	25.04043
萬華區	仁德里	昆明分隊	108-G19	KEA-1696	昆明-2	第1車	1618	1622	臺北市萬華區西寧南路186號	121.50611	25.03933
萬華區	仁德里	昆明分隊	108-G19	KEA-1696	昆明-2	第1車	1625	1630	臺北市萬華區西寧南路198號前	121.5062	25.03872
萬華區	西門里	昆明分隊	108-G19	KEA-1696	昆明-2	第1車	1635	1640	臺北市萬華區內江街67號前	121.50485	25.04165
萬華區	新起里	昆明分隊	108-G19	KEA-1696	昆明-2	第1車	1642	1650	臺北市萬華區漢中街145號	121.50725	25.04169
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1820	1824	臺北市萬華區艋舺大道71號前	121.50348	25.03377
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1826	1828	臺北市萬華區康定路275號	121.50125	25.03435
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1829	1833	臺北市萬華區和平西路3段86號	121.50207	25.0351
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1833	1837	臺北市萬華區和平西路3段64號前	121.50321	25.03498
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1835	1837	臺北市萬華區和平西路3段30巷	121.5041	25.03431
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1837	1841	臺北市萬華區和平西路3段15號前	121.50419	25.0346
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1842	1846	臺北市萬華區三水街47號前	121.50402	25.03556
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1847	1851	臺北市萬華區南寧路41號之2前	121.50409	25.03608
萬華區	福音里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1852	1854	臺北市萬華區昆明街322號前	121.5032	25.03534
萬華區	福音里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1854	1856	臺北市萬華區和平西路3段57號	121.50233	25.03535
萬華區	福音里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1857	1902	臺北市萬華區康定路221號前	121.50147	25.0356
萬華區	仁德里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1905	1909	臺北市萬華區昆明街255號前	121.50387	25.03751
萬華區	仁德里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1910	1914	臺北市萬華區柳州街82號前	121.50493	25.03713
萬華區	仁德里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1915	1918	臺北市萬華區廣州街32號前	121.50441	25.03645
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第2車	1920	1922	臺北市萬華區中華路2段10號前	121.50544	25.0339
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2040	2044	臺北市萬華區康定路360號前	121.50096	25.03445
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2045	2046	臺北市萬華區大理街34號之9	121.50063	25.03449
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2047	2048	臺北市萬華區大理街42號之6前	121.49993	25.03448
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2049	2052	臺北市萬華區西園路1段282巷25號前	121.49869	25.03377
萬華區	富福里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2052	2055	臺北市萬華區大理街58號前	121.49899	25.03424
萬華區	富民里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2057	2059	臺北市萬華區西園路1段139號前	121.49972	25.03757
萬華區	富民里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2100	2105	臺北市萬華區桂林路90號(西昌街口)	121.50035	25.03833
萬華區	富民里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2106	2110	臺北市萬華區康定路248號	121.50154	25.03759
萬華區	富民里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2111	2116	臺北市萬華區康定路280號	121.50138	25.03694
萬華區	富民里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2120	2123	臺北市萬華區康定路338號前	121.5011	25.03543
萬華區	富民里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2123	2125	臺北市萬華區和平西路3段89巷	121.501	25.03531
萬華區	富民里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2124	2127	臺北市萬華區和平西路3段107號	121.5005	25.03539
萬華區	青山里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2130	2135	臺北市萬華區和平西路3段157號	121.49852	25.03548
萬華區	青山里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2135	2140	臺北市萬華區和平西路3段187號	121.49779	25.03549
萬華區	青山里	昆明分隊	108-G19	KEA-1696	昆明-2	第3車	2140	2145	臺北市萬華區和平西路3段與211號前	121.49692	25.03551
萬華區	保德里	東園分隊	108-G23	KEA-1700	東園-2	第1車	1640	1642	臺北市萬華區東園街122號前	121.49744	25.02374
萬華區	保德里	東園分隊	108-G23	KEA-1700	東園-2	第1車	1643	1646	臺北市萬華區東園街152號前(衛生所)	121.49782	25.02295
萬華區	保德里	東園分隊	108-G23	KEA-1700	東園-2	第1車	1647	1650	臺北市萬華區東園街198號前(頂好超市)	121.49841	25.02157
萬華區	華中里	東園分隊	108-G23	KEA-1700	東園-2	第1車	1651	1655	臺北市萬華區萬大路426號	121.49822	25.02094
萬華區	華中里	東園分隊	108-G23	KEA-1700	東園-2	第1車	1656	1701	臺北市萬華區萬大路472號	121.49756	25.01991
萬華區	華中里	東園分隊	108-G23	KEA-1700	東園-2	第1車	1702	1706	臺北市萬華區萬大路524號(郵局)	121.49678	25.01887
萬華區	華中里	東園分隊	108-G23	KEA-1700	東園-2	第1車	1707	1712	臺北市萬華區萬大路614號	121.49551	25.01678
萬華區	華中里	東園分隊	108-G23	KEA-1700	東園-2	第1車	1713	1716	臺北市萬華區環河南路3段345號(民本電臺)	121.49451	25.01743
萬華區	榮德里	東園分隊	108-G23	KEA-1700	東園-2	第1車	1717	1721	臺北市萬華區環河南路3段283號前	121.4935	25.01897
萬華區	銘德里	東園分隊	108-G23	KEA-1700	東園-2	第1車	1722	1726	臺北市萬華區環河南路3段243號前	121.49273	25.02037
萬華區	銘德里	東園分隊	108-G23	KEA-1700	東園-2	第1車	1727	1730	臺北市萬華區環河南路3段203號(巖清寺)	121.49221	25.02147
萬華區	錦德里	東園分隊	108-G23	KEA-1700	東園-2	第1車	1731	1733	臺北市萬華區環河南路3段123號前	121.49108	25.02399
萬華區	榮德里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1900	1903	臺北市萬華區萬大路424巷159號	121.49387	25.02065
萬華區	銘德里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1904	1909	臺北市萬華區萬大路424巷112-6號對面三角公園	121.49502	25.02102
萬華區	保德里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1910	1913	臺北市萬華區長泰街201號	121.49599	25.02178
萬華區	保德里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1913	1914	臺北市萬華區長泰街161號	121.49686	25.02197
萬華區	保德里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1914	1919	臺北市萬華區長泰街139巷2號之1前	121.49743	25.02173
萬華區	日善里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1920	1923	臺北市萬華區東園街65號(公路警察)	121.4962	25.02649
萬華區	日善里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1924	1928	臺北市萬華區東園街19號	121.49573	25.02749
萬華區	日善里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1930	1933	臺北市萬華區西藏路197號前	121.49979	25.02929
萬華區	日善里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1934	1937	臺北市萬華區萬大路156號前	121.50038	25.02865
萬華區	日善里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1938	1942	臺北市萬華區萬大路188號前	121.50039	25.0277
萬華區	日善里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1943	1946	臺北市萬華區萬大路220號前	121.5004	25.02695
萬華區	全德里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1947	1951	臺北市萬華區萬大路282號	121.50028	25.02552
萬華區	全德里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1952	1956	臺北市萬華區萬大路326號	121.50014	25.02418
萬華區	全德里	東園分隊	108-G23	KEA-1700	東園-2	第2車	1957	2000	臺北市萬華區萬大路344巷22號前	121.49859	25.02403
萬華區	全德里	東園分隊	108-G23	KEA-1700	東園-2	第3車	2125	2128	臺北市萬華區民和街50號前	121.49871	25.02586
萬華區	日善里	東園分隊	108-G23	KEA-1700	東園-2	第3車	2129	2132	臺北市萬華區民和街104號	121.49744	25.02545
萬華區	忠德里	東園分隊	108-G23	KEA-1700	東園-2	第3車	2133	2137	臺北市萬華區德昌街152號(國際電台)	121.49617	25.02407
萬華區	孝德里	東園分隊	108-G23	KEA-1700	東園-2	第3車	2138	2142	臺北市萬華區德昌街198號	121.49505	25.02367
萬華區	孝德里	東園分隊	108-G23	KEA-1700	東園-2	第3車	2143	2147	臺北市萬華區德昌街230號前	121.49428	25.02359
萬華區	孝德里	東園分隊	108-G23	KEA-1700	東園-2	第3車	2148	2152	臺北市萬華區西園路2段281巷31號	121.49276	25.02333
萬華區	錦德里	東園分隊	108-G23	KEA-1700	東園-2	第3車	2153	2156	臺北市萬華區德昌街274號(東隆宮)	121.49215	25.02302
萬華區	錦德里	東園分隊	108-G23	KEA-1700	東園-2	第3車	2158	2204	臺北市萬華區寶興街92號	121.4943	25.02588
萬華區	錦德里	東園分隊	108-G23	KEA-1700	東園-2	第3車	2205	2208	臺北市萬華區寶興街144號	121.49488	25.02461
士林區	葫東里	社子分隊	108-G24	KEA-1701	社子-3	第1車	1600	1605	臺北市士林區通河西街1段91號	121.51244	25.08454
士林區	福順里	社子分隊	108-G24	KEA-1701	社子-3	第1車	1606	1611	臺北市士林區重慶北路4段146號後面	121.51241	25.08358
士林區	福順里	社子分隊	108-G24	KEA-1701	社子-3	第1車	1612	1617	臺北市士林區重慶北路4段96號後面	121.51304	25.08215
士林區	富光里	社子分隊	108-G24	KEA-1701	社子-3	第1車	1623	1633	臺北市士林區葫蘆街32號	121.5098	25.08006
士林區	富光里	社子分隊	108-G24	KEA-1701	社子-3	第1車	1634	1644	臺北市士林區葫蘆街80號	121.50844	25.0816
士林區	富光里	社子分隊	108-G24	KEA-1701	社子-3	第1車	1645	1650	臺北市士林區葫蘆街108號	121.50816	25.08254
士林區	葫蘆里	社子分隊	108-G24	KEA-1701	社子-3	第2車	1830	1839	臺北市士林區葫蘆街137號	121.50847	25.08372
士林區	葫蘆里	社子分隊	108-G24	KEA-1701	社子-3	第2車	1840	1845	臺北市士林區葫蘆街126號對面	121.50769	25.08342
士林區	葫蘆里	社子分隊	108-G24	KEA-1701	社子-3	第2車	1850	1855	臺北市士林區葫蘆街110號對面	121.50796	25.08263
士林區	富光里	社子分隊	108-G24	KEA-1701	社子-3	第2車	1856	1904	臺北市士林區葫蘆街60號對面	121.50847	25.08111
士林區	富光里	社子分隊	108-G24	KEA-1701	社子-3	第2車	1905	1910	臺北市士林區葫蘆街27號	121.50991	25.07997
士林區	葫蘆里	社子分隊	108-G24	KEA-1701	社子-3	第2車	1912	1917	臺北市士林區環河北路3段99號	121.50669	25.08437
士林區	福順里	社子分隊	108-G24	KEA-1701	社子-3	第3車	2038	2041	臺北市士林區重慶北路4段1巷3弄1號	121.51294	25.07991
士林區	福順里	社子分隊	108-G24	KEA-1701	社子-3	第3車	2049	2051	臺北市士林區延平北路5段3號	121.51115	25.07917
士林區	富光里	社子分隊	108-G24	KEA-1701	社子-3	第3車	2100	2105	臺北市士林區重慶北路4段58號	121.5134	25.08129
士林區	福順里	社子分隊	108-G24	KEA-1701	社子-3	第3車	2106	2111	臺北市士林區重慶北路4段90號	121.51291	25.08225
士林區	福順里	社子分隊	108-G24	KEA-1701	社子-3	第3車	2112	2117	臺北市士林區重慶北路4段152號	121.51206	25.08428
士林區	福順里	社子分隊	108-G24	KEA-1701	社子-3	第3車	2118	2123	臺北市士林區重慶北路4段188號	121.51196	25.08465
士林區	葫東里	社子分隊	108-G24	KEA-1701	社子-3	第3車	2124	2129	臺北市士林區重慶北路4段222號	121.51154	25.08568
士林區	葫東里	社子分隊	108-G24	KEA-1701	社子-3	第3車	2131	2132	臺北市士林區重慶北路4段260號	121.51147	25.08691
士林區	葫東里	社子分隊	108-G24	KEA-1701	社子-3	第3車	2133	2136	臺北市士林區重慶北路4段129號	121.5122093	25.0829556
士林區	葫東里	社子分隊	108-G24	KEA-1701	社子-3	第3車	2137	2141	臺北市士林區通河西街1段111號	121.51226	25.08582
士林區	葫東里	社子分隊	108-G24	KEA-1701	社子-3	第3車	2142	2144	臺北市士林區通河西街1段97號	121.51239	25.08491
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1700	1710	臺北市中正區牯嶺街128號旁	121.519	25.02284
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1711	1715	臺北市中正區牯嶺街132號旁	121.51901	25.02268
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1716	1720	臺北市中正區牯嶺街144號前	121.519	25.02163
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1721	1725	臺北市中正區水源路97號前	121.51871	25.02131
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1726	1730	臺北市中正區廈門街133之4號前	121.51745	25.0223
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1731	1735	臺北市中正區廈門街123號前	121.51745	25.02304
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1736	1740	臺北市中正區廈門街109號前	121.51745	25.02359
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1741	1745	臺北市中正區廈門街81之1號	121.51756	25.02443
中正區	螢圃里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1746	1750	臺北市中正區廈門街27號前	121.51788	25.02629
中正區	螢雪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1801	1805	臺北市中正區和平西路1段156號前	121.51512	25.02733
中正區	螢圃里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1806	1810	臺北市中正區和平西路1段110號	121.51749	25.02678
中正區	螢圃里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1811	1815	臺北市中正區和平西路1段88號	121.51846	25.02645
中正區	板溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1816	1820	臺北市中正區和平西路1段56號	121.51963	25.02637
中正區	板溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1821	1825	臺北市中正區和平西路1段34號前	121.52044	25.02653
中正區	板溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1826	1830	臺北市中正區同安街22之1號前	121.52233	25.02498
中正區	板溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1831	1835	臺北市中正區同安街30號前	121.5219	25.02442
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1836	1840	臺北市中正區同安街66號前	121.52097	25.02313
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1841	1845	臺北市中正區同安街74號旁	121.5205	25.02239
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1846	1850	臺北市中正區同安街90號前	121.52014	25.02162
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第1車	1851	1855	臺北市中正區水源路83號前	121.51965	25.02111
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2020	2027	臺北市中正區廈門街113巷17號前	121.51902	25.02339
中正區	板溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2028	2034	臺北市中正區牯嶺街95巷4號旁	121.51939	25.02602
中正區	板溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2035	2039	臺北市中正區牯嶺街95巷57號(強恕中學後面)	121.52044	25.02561
中正區	螢雪里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2050	2054	臺北市中正區福州街56號前	121.51514	25.02683
中正區	螢雪里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2055	2059	臺北市中正區重慶南路3段84號前	121.51607	25.0261
中正區	螢雪里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2100	2104	臺北市中正區重慶南路3段116號前	121.51644	25.02481
中正區	螢雪里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2105	2109	臺北市中正區重慶南路3段134號前	121.51658	25.02416
中正區	螢雪里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2110	2114	臺北市中正區重慶南路3段148號前	121.51655	25.02385
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2115	2119	臺北市中正區重慶南路3段149號前	121.51707	25.0232
中正區	網溪里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2120	2124	臺北市中正區重慶南路3段125號	121.517	25.02394
中正區	螢圃里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2125	2129	臺北市中正區重慶南路3段89號	121.51676	25.02507
中正區	螢圃里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2130	2134	臺北市中正區重慶南路3段67號前	121.51641	25.02626
中正區	南福里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2135	2139	臺北市中正區寧波西街64號前	121.51708	25.0304
中正區	新營里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2140	2144	臺北市中正區寧波東街4號	121.51976	25.032
中正區	新營里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2145	2151	臺北市中正區金華街47號前	121.52008	25.03199
中正區	新營里	南昌分隊	108-G25	KEA-1702	南昌-3	第2車	2152	2157	臺北市中正區金華街32號前	121.52175	25.03111
中正區	黎明里	博愛分隊	108-G26	KEA-1703	博愛-2	第1車	1658	1705	臺北市中正區館前路18號	121.51494	25.04536
中正區	黎明里	博愛分隊	108-G26	KEA-1703	博愛-2	第1車	1708	1715	臺北市中正區開封街1段3號	121.51445	25.04605
中正區	黎明里	博愛分隊	108-G26	KEA-1703	博愛-2	第1車	1717	1724	臺北市中正區懷寧街32號對面	121.51421	25.04531
中正區	黎明里	博愛分隊	108-G26	KEA-1703	博愛-2	第1車	1725	1730	臺北市中正區懷寧街74號對面	121.51411	25.04366
中正區	黎明里	博愛分隊	108-G26	KEA-1703	博愛-2	第1車	1732	1737	臺北市中正區懷寧街96號對面	121.51405	25.04217
中正區	黎明里	博愛分隊	108-G26	KEA-1703	博愛-2	第1車	1740	1747	臺北市中正區重慶南路1段141號	121.51316	25.04166
中正區	黎明里	博愛分隊	108-G26	KEA-1703	博愛-2	第1車	1749	1756	臺北市中正區重慶南路1段119號	121.51324	25.04246
中正區	光復里	博愛分隊	108-G26	KEA-1703	博愛-2	第1車	1801	1808	臺北市中正區武昌街1段64號	121.51075	25.0441
中正區	光復里	博愛分隊	108-G26	KEA-1703	博愛-2	第1車	1814	1820	臺北市中正區博愛路69號	121.51156	25.04384
中正區	光復里	博愛分隊	108-G26	KEA-1703	博愛-2	第1車	1821	1827	臺北市中正區博愛路31號	121.51144	25.04531
中正區	建國里	博愛分隊	108-G26	KEA-1703	博愛-2	第2車	2012	2017	臺北市中正區重慶南路1段142巷17號	121.51247	25.03577
中正區	建國里	博愛分隊	108-G26	KEA-1703	博愛-2	第2車	2022	2026	臺北市中正區衡陽路47號	121.5123	25.04236
中正區	建國里	博愛分隊	108-G26	KEA-1703	博愛-2	第2車	2028	2033	臺北市中正區衡陽路85號	121.51082	25.04229
中正區	建國里	博愛分隊	108-G26	KEA-1703	博愛-2	第2車	2035	2042	臺北市中正區寶慶路27號	121.51056	25.04134
中正區	光復里	博愛分隊	108-G26	KEA-1703	博愛-2	第2車	2043	2045	臺北市中正區博愛路119號	121.51154	25.04175
中正區	光復里	博愛分隊	108-G26	KEA-1703	博愛-2	第2車	2047	2054	臺北市中正區博愛路99號	121.51155	25.043
中正區	黎明里	博愛分隊	108-G26	KEA-1703	博愛-2	第2車	2059	2104	臺北市中正區忠孝西路1段33號前	121.51871	25.04603
中正區	光復里	博愛分隊	108-G26	KEA-1703	博愛-2	第2車	2109	2111	臺北市中正區北平西路56號	121.51325	25.04796
中正區	光復里	博愛分隊	108-G26	KEA-1703	博愛-2	第2車	2112	2114	臺北市中正區忠孝西路1段259號	121.51206	25.04775
中正區	黎明里	博愛分隊	108-G26	KEA-1703	博愛-2	第2車	2116	2123	臺北市中正區重慶南路1段7號	121.51329	25.04638
中正區	建國里	博愛分隊	108-G26	KEA-1703	博愛-2	第2車	2126	2130	臺北市中正區博愛路5號	121.51135	25.04614
萬華區	忠德里	東園分隊	108-G27	KEA-1705	東園-1	第1車	1700	1704	臺北市萬華區東園街66巷25號前	121.49583	25.02548
萬華區	忠德里	東園分隊	108-G27	KEA-1705	東園-1	第1車	1705	1710	臺北市萬華區東園街66巷55號前	121.49529	25.02508
萬華區	孝德里	東園分隊	108-G27	KEA-1705	東園-1	第1車	1711	1717	臺北市萬華區寶興街140巷17弄1號之4	121.49427	25.0243
萬華區	孝德里	東園分隊	108-G27	KEA-1705	東園-1	第1車	1718	1723	臺北市萬華區寶興街140巷26號前	121.49377	25.02396
萬華區	錦德里	東園分隊	108-G27	KEA-1705	東園-1	第1車	1725	1730	臺北市萬華區西園路2段279號前	121.49163	25.02493
萬華區	錦德里	東園分隊	108-G27	KEA-1705	東園-1	第1車	1731	1736	臺北市萬華區西園路2段251號前	121.49281	25.02602
萬華區	忠德里	東園分隊	108-G27	KEA-1705	東園-1	第1車	1737	1745	臺北市萬華區西園路2段205號(土地銀行)	121.49453	25.02736
萬華區	日善里	東園分隊	108-G27	KEA-1705	東園-1	第2車	1915	1919	臺北市萬華區東園街73巷104號(西園國小圍牆旁)	121.49964	25.02638
萬華區	日善里	東園分隊	108-G27	KEA-1705	東園-1	第2車	1920	1924	臺北市萬華區東園街73巷60號前	121.49815	25.02659
萬華區	日善里	東園分隊	108-G27	KEA-1705	東園-1	第2車	1925	1929	臺北市萬華區東園街73巷25號前	121.49699	25.02612
萬華區	忠德里	東園分隊	108-G27	KEA-1705	東園-1	第2車	1930	1935	臺北市萬華區東園街88號	121.49695	25.02472
萬華區	銘德里	東園分隊	108-G27	KEA-1705	東園-1	第2車	1936	1941	臺北市萬華區寶興街210巷2號	121.49557	25.0228
萬華區	銘德里	東園分隊	108-G27	KEA-1705	東園-1	第2車	1942	1947	臺北市萬華區德昌街185巷34號前	121.49457	25.02256
萬華區	孝德里	東園分隊	108-G27	KEA-1705	東園-1	第2車	1948	1953	臺北市萬華區德昌街185巷64號前	121.49343	25.02248
萬華區	孝德里	東園分隊	108-G27	KEA-1705	東園-1	第2車	1954	1959	臺北市萬華區德昌街185巷86號前	121.49243	25.02205
萬華區	錦德里	東園分隊	108-G27	KEA-1705	東園-1	第2車	2000	2005	臺北市萬華區西園路2段281巷15號前	121.49246	25.02416
萬華區	全德里	東園分隊	108-G27	KEA-1705	東園-1	第3車	2106	2112	臺北市萬華區德昌街11號前(守望相助亭)	121.49969	25.02532
萬華區	全德里	東園分隊	108-G27	KEA-1705	東園-1	第3車	2113	2118	臺北市萬華區德昌街42號前(慈安宮)	121.4988	25.02509
萬華區	全德里	東園分隊	108-G27	KEA-1705	東園-1	第3車	2119	2123	臺北市萬華區德昌街76號前	121.49809	25.02482
萬華區	榮德里	東園分隊	108-G27	KEA-1705	東園-1	第3車	2126	2133	臺北市萬華區萬大路486巷61號(東興市場)	121.4958	25.02052
萬華區	華中里	東園分隊	108-G27	KEA-1705	東園-1	第3車	2135	2140	臺北市萬華區武成街56巷27號前	121.495	25.01913
萬華區	榮德里	東園分隊	108-G27	KEA-1705	東園-1	第3車	2141	2146	臺北市萬華區武成街61號	121.49487	25.01879
士林區	社新里	社子分隊	109-G01	KEG-1110	社子-5	第1車	1630	1637	臺北市士林區環河北路3段151號	121.5053	25.08647
士林區	社新里	社子分隊	109-G01	KEG-1110	社子-5	第1車	1638	1644	臺北市士林區環河北路3段215號	121.50374	25.08814
士林區	永倫里	社子分隊	109-G01	KEG-1110	社子-5	第1車	1645	1651	臺北市士林區社中街460號斜對面	121.50185	25.09115
士林區	永倫里	社子分隊	109-G01	KEG-1110	社子-5	第1車	1652	1658	臺北市士林區社中街393號	121.50301	25.09196
士林區	永倫里	社子分隊	109-G01	KEG-1110	社子-5	第1車	1700	1707	臺北市士林區社中街324號斜對面	121.50523	25.09219
士林區	社園里	社子分隊	109-G01	KEG-1110	社子-5	第1車	1709	1715	臺北市士林區社中街279號	121.5064	25.09185
士林區	社園里	社子分隊	109-G01	KEG-1110	社子-5	第1車	1716	1724	臺北市士林區社中街253號	121.5073	25.09155
士林區	社園里	社子分隊	109-G01	KEG-1110	社子-5	第1車	1725	1732	臺北市士林區社中街229號	121.50793	25.0913
士林區	社園里	社子分隊	109-G01	KEG-1110	社子-5	第1車	1733	1739	臺北市士林區社中街209號	121.50851	25.09102
士林區	社子里	社子分隊	109-G01	KEG-1110	社子-5	第1車	1740	1750	臺北市士林區社中街141號	121.5095	25.09049
士林區	社子里	社子分隊	109-G01	KEG-1110	社子-5	第1車	1751	1800	臺北市士林區社正路37號	121.50949	25.08887
士林區	社子里	社子分隊	109-G01	KEG-1110	社子-5	第1車	1801	1806	臺北市士林區延平北路6段62號	121.50873	25.08827
士林區	社子里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2015	2020	臺北市士林區社正路28號	121.50963	25.08874
士林區	社子里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2021	2027	臺北市士林區社正路85號	121.51102	25.08904
士林區	社子里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2028	2035	臺北市士林區社中街95號對面	121.51039	25.08943
士林區	社子里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2036	2046	臺北市士林區社中街141號對面	121.50962	25.09055
士林區	社園里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2047	2056	臺北市士林區社中街212號	121.50855	25.09113
士林區	社園里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2057	2104	臺北市士林區社中街252號	121.50741	25.09165
士林區	社園里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2105	2112	臺北市士林區社中街266號	121.50686	25.09189
士林區	社園里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2113	2120	臺北市士林區社中街281號對面	121.5063	25.09203
士林區	社園里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2121	2128	臺北市士林區社中街300號	121.50565	25.09224
士林區	永倫里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2129	2136	臺北市士林區社中街348號	121.50445	25.09249
士林區	永倫里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2137	2143	臺北市士林區社中街386號	121.50345	25.09228
士林區	永倫里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2144	2147	臺北市士林區社中街428號	121.50242	25.09184
士林區	永倫里	社子分隊	109-G01	KEG-1110	社子-5	第2車	2148	2152	臺北市士林區社中街460號	121.50173	25.09114
大安區	車層里	敦化分隊	109-G04	KEG-1115	敦化-1	第1車	1720	1735	臺北市大安區忠孝東路4段216巷39號前	121.55303	25.03924
大安區	車層里	敦化分隊	109-G04	KEG-1115	敦化-1	第1車	1738	1743	臺北市大安區忠孝東路4段216巷29號	121.55308	25.0398
大安區	建安里	敦化分隊	109-G04	KEG-1115	敦化-1	第1車	1750	1755	臺北市大安區忠孝東路4段209號	121.55204	25.04156
大安區	建安里	敦化分隊	109-G04	KEG-1115	敦化-1	第1車	1758	1808	臺北市大安區忠孝東路4段151號	121.54976	25.04162
大安區	正聲里	敦化分隊	109-G04	KEG-1115	敦化-1	第2車	1935	1940	臺北市大安區光復南路348號（第2次收集）	121.55749	25.03808
大安區	仁愛里	敦化分隊	109-G04	KEG-1115	敦化-1	第2車	1950	1955	臺北市大安區仁愛路4段27巷11號	121.5453	25.03954
大安區	仁愛里	敦化分隊	109-G04	KEG-1115	敦化-1	第2車	1957	2000	臺北市大安區仁愛路4段27巷1號	121.54524	25.03865
大安區	建倫里	敦化分隊	109-G04	KEG-1115	敦化-1	第2車	2010	2025	臺北市大安區忠孝東路4段170巷5弄20號	121.55146	25.04073
大安區	仁愛里	敦化分隊	109-G04	KEG-1115	敦化-1	第3車	2145	2150	臺北市大安區敦化南路1段252巷13號前	121.54747	25.03988
大安區	仁愛里	敦化分隊	109-G04	KEG-1115	敦化-1	第3車	2155	2200	臺北市大安區仁愛路4段99號前	121.54813	25.03863
大安區	仁愛里	敦化分隊	109-G04	KEG-1115	敦化-1	第3車	2203	2207	臺北市大安區仁愛路4段69號前	121.54723	25.03812
大安區	仁愛里	敦化分隊	109-G04	KEG-1115	敦化-1	第3車	2210	2220	臺北市大安區大安路1段146號	121.54602	25.03858
中山區	大佳里	大直分隊	109-G05	KEG-1116	大直-1	第1車	1645	1653	臺北市中山區民族東路125號前	121.53907	25.06826
中山區	大佳里	大直分隊	109-G05	KEG-1116	大直-1	第1車	1654	1700	臺北市中山區民族東路95號前	121.53637	25.06828
中山區	大佳里	大直分隊	109-G05	KEG-1116	大直-1	第1車	1702	1704	臺北市中山區松江路579號前	121.53367	25.06995
中山區	大佳里	大直分隊	109-G05	KEG-1116	大直-1	第1車	1705	1714	臺北市中山區濱江街152號前	121.53684	25.07251
中山區	大佳里	大直分隊	109-G05	KEG-1116	大直-1	第1車	1715	1718	臺北市中山區濱江街228號前	121.54071	25.0723
中山區	大佳里	大直分隊	109-G05	KEG-1116	大直-1	第1車	1720	1724	臺北市中山區濱江街262號前	121.54298	25.07222
中山區	大佳里	大直分隊	109-G05	KEG-1116	大直-1	第1車	1725	1728	臺北市中山區濱江街358號前	121.54972	25.07199
中山區	劍潭里	大直分隊	109-G05	KEG-1116	大直-1	第2車	1950	1953	臺北市中山區北安路85號前(碧海山莊)	121.53004	25.07811
中山區	劍潭里	大直分隊	109-G05	KEG-1116	大直-1	第2車	1955	2005	臺北市中山區北安路55號前(中央電台)	121.52884	25.07784
中山區	劍潭里	大直分隊	109-G05	KEG-1116	大直-1	第2車	2011	2020	臺北市中山區北安路400巷1弄2號前	121.54107	25.07919
中山區	劍潭里	大直分隊	109-G05	KEG-1116	大直-1	第2車	2032	2052	臺北市中山區通北街65巷2弄2號前	121.53976	25.0831
中山區	劍潭里	大直分隊	109-G05	KEG-1116	大直-1	第2車	2054	2110	臺北市中山區通北街89號旁(118巷對面)	121.53817	25.08303
中山區	劍潭里	大直分隊	109-G05	KEG-1116	大直-1	第2車	2111	2140	臺北市中山區通北街144號前	121.53773	25.08517
中山區	松江里	民一分隊	109-G06	KEG-1117	民一-1	第1車	1700	1708	臺北市中山區民生東路2段161號前	121.53612	25.05801
中山區	松江里	民一分隊	109-G06	KEG-1117	民一-1	第1車	1709	1713	臺北市中山區民生東路2段149號前	121.53593	25.05812
中山區	松江里	民一分隊	109-G06	KEG-1117	民一-1	第1車	1716	1723	臺北市中山區松江路261號前	121.53329	25.05966
中山區	松江里	民一分隊	109-G06	KEG-1117	民一-1	第1車	1725	1735	臺北市中山區松江路303號前	121.5333	25.06125
中山區	中庄里	民一分隊	109-G06	KEG-1117	民一-1	第2車	1935	1945	臺北市中山區民生東路2段125號前	121.53209	25.05802
中山區	中庄里	民一分隊	109-G06	KEG-1117	民一-1	第2車	1946	1950	臺北市中山區民生東路2段87號前	121.5308	25.05808
中山區	中庄里	民一分隊	109-G06	KEG-1117	民一-1	第2車	1951	2000	臺北市中山區吉林路163號前	121.53028	25.05908
中山區	中庄里	民一分隊	109-G06	KEG-1117	民一-1	第2車	2001	2010	臺北市中山區吉林路201號前	121.53032	25.06
中山區	新生里	民一分隊	109-G06	KEG-1117	民一-1	第2車	2011	2019	臺北市中山區吉林路245號	121.53034	25.0613
中山區	新生里	民一分隊	109-G06	KEG-1117	民一-1	第2車	2023	2028	臺北市中山區民權東路2段94號	121.53184	25.06242
中山區	松江里	民一分隊	109-G06	KEG-1117	民一-1	第2車	2032	2040	臺北市中山區民權東路2段150號前	121.53471	25.06236
中山區	松江里	民一分隊	109-G06	KEG-1117	民一-1	第3車	2150	2155	臺北市中山區建國北路2段238號	121.53669	25.06115
中山區	松江里	民一分隊	109-G06	KEG-1117	民一-1	第3車	2157	2203	臺北市中山區錦州街298號前(錦北公園)	121.53585	25.06029
中山區	松江里	民一分隊	109-G06	KEG-1117	民一-1	第3車	2205	2213	臺北市中山區錦州街261號前	121.53474	25.06037
中山區	松江里	民一分隊	109-G06	KEG-1117	民一-1	第3車	2215	2220	臺北市中山區錦州街243號前	121.53383	25.06037
內湖區	港墘里	西湖分隊	109-G08	KEG-1120	西湖-3	第1車	1635	1700	臺北市內湖區港墘路221巷2號	121.57386	25.07438
內湖區	港墘里	西湖分隊	109-G08	KEG-1120	西湖-3	第1車	1710	1720	臺北市內湖區江南街65巷16號	121.57864	25.07697
內湖區	西安里	西湖分隊	109-G08	KEG-1120	西湖-3	第2車	1910	1920	臺北市內湖區環山路1段134號	121.5689	25.08646
內湖區	西安里	西湖分隊	109-G08	KEG-1120	西湖-3	第2車	1920	1930	臺北市內湖區環山路1段98號前	121.56788	25.08643
內湖區	港華里	西湖分隊	109-G08	KEG-1120	西湖-3	第2車	2000	2020	臺北市內湖區環山路2段81號	121.57452	25.08497
內湖區	麗山里	西湖分隊	109-G08	KEG-1120	西湖-3	第2車	2025	2050	臺北市內湖區環山路2段29巷1號	121.57273	25.08571
內湖區	港富里	西湖分隊	109-G08	KEG-1120	西湖-3	第3車	2200	2240	臺北市內湖區港墘路83號	121.57798	25.0808
內湖區	西康里	西湖分隊	109-G09	KEG-1121	西湖-1	第1車	1720	1745	臺北市內湖區環山路1段28巷17號對面	121.56385	25.08543
內湖區	港富里	西湖分隊	109-G09	KEG-1121	西湖-1	第1車	1800	1815	臺北市內湖區港墘路1巷和內湖路1段737巷口	121.57912	25.08391
內湖區	港華里	西湖分隊	109-G09	KEG-1121	西湖-1	第1車	1820	1835	臺北市內湖區環山路2段111號對面	121.57614	25.08447
內湖區	麗山里	西湖分隊	109-G09	KEG-1121	西湖-1	第2車	1950	2010	臺北市內湖區內湖路1段411巷12號	121.57131	25.08267
內湖區	西安里	西湖分隊	109-G09	KEG-1121	西湖-1	第2車	2015	2030	臺北市內湖區環山路1段62號	121.56659	25.08651
內湖區	西湖里	西湖分隊	109-G09	KEG-1121	西湖-1	第3車	2140	2220	臺北市內湖區內湖路1段285巷19號	121.5667	25.0829
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1650	1652	臺北市北投區復興三路355巷56號前(回收車收運)	121.49859	25.15504
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1653	1654	臺北市北投區復興三路521巷240號百姓公廟前(回收車收運)	121.49462	25.16087
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1655	1656	臺北市北投區復興三路521巷34號前(回收車收運)	121.49981	25.16052
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1700	1705	臺北市北投區復興三路526號前清天宮旁(回收車收運)	121.50056	25.15999
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1706	1707	臺北市北投區復興三路488號前(回收車收運)	121.50164	25.15931
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1708	1709	臺北市北投區復興三路355巷口(回收車收運)	121.50187	25.1554
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1710	1711	臺北市北投區復興三路吳氏宗祠前(回收車收運)	121.50258	25.15512
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1712	1714	臺北市北投區復興三路大屯國小前(回收車收運)	121.50405	25.15478
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1715	1716	臺北市北投區復興三路310巷口(回收車收運)	121.50415	25.15438
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1717	1719	臺北市北投區復興三路300巷37號前(回收車收運)	121.5068	25.15457
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1720	1721	臺北市北投區復興三路300巷13號前(回收車收運)	121.5051	25.15473
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1722	1723	臺北市北投區復興三路上清宮前(回收車收運)	121.5053	25.15327
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1724	1728	臺北市北投區復興三路201巷46號白宮山莊(回收車收運)	121.50448	25.14894
北投區	大屯里	光明分隊	109-G12	KEG-1127	光明-5	第1車	1729	1730	臺北市北投區復興三路152巷30弄1號前(回收車收運)	121.50624	25.14852
北投區	大同里	光明分隊	109-G12	KEG-1127	光明-5	第2車	1800	1803	臺北市北投區中央北路光明路口	121.50154	25.1334
北投區	大同里	光明分隊	109-G12	KEG-1127	光明-5	第2車	1804	1807	臺北市北投區光明路73巷口前	121.50031	25.13298
北投區	大同里	光明分隊	109-G12	KEG-1127	光明-5	第2車	1808	1813	臺北市北投區光明路中正街口	121.49949	25.13265
北投區	大同里	光明分隊	109-G12	KEG-1127	光明-5	第2車	1814	1818	臺北市北投區育仁路14號前	121.49837	25.13297
北投區	大同里	光明分隊	109-G12	KEG-1127	光明-5	第2車	1819	1828	臺北市北投區育仁路大同街口	121.49842	25.13379
北投區	大同里	光明分隊	109-G12	KEG-1127	光明-5	第2車	1829	1834	臺北市北投區育仁路薇閣國小前	121.5005	25.13625
北投區	大同里	光明分隊	109-G12	KEG-1127	光明-5	第2車	1837	1842	臺北市北投區大業路中央北路口	121.49779	25.13577
北投區	長安里	光明分隊	109-G12	KEG-1127	光明-5	第2車	1843	1845	臺北市北投區中央北路70號前	121.50027	25.13436
北投區	長安里	光明分隊	109-G12	KEG-1127	光明-5	第2車	1846	1848	臺北市北投區中央北路大同街口	121.49882	25.13527
北投區	長安里	光明分隊	109-G12	KEG-1127	光明-5	第2車	1849	1854	臺北市北投區中央北路育仁路口	121.49958	25.13476
北投區	長安里	光明分隊	109-G12	KEG-1127	光明-5	第2車	1855	1859	臺北市北投區中央北路1段186號前	121.49774	25.1359
北投區	八仙里	光明分隊	109-G12	KEG-1127	光明-5	第3車	1935	1937	臺北市北投區大業路154號前	121.49896	25.12482
北投區	八仙里	光明分隊	109-G12	KEG-1127	光明-5	第3車	1938	1940	臺北市北投區大業路280巷口	121.49811	25.12723
北投區	中央里	光明分隊	109-G12	KEG-1127	光明-5	第3車	1941	1943	臺北市北投區大業路280巷9弄口	121.49878	25.12742
北投區	中央里	光明分隊	109-G12	KEG-1127	光明-5	第3車	1944	1947	臺北市北投區大業路280巷21弄口	121.49938	25.12747
北投區	中央里	光明分隊	109-G12	KEG-1127	光明-5	第3車	1948	1949	臺北市北投區大業路300巷19號前	121.49899	25.12832
北投區	中央里	光明分隊	109-G12	KEG-1127	光明-5	第3車	1950	1951	臺北市北投區大業路300巷9弄12號前	121.49896	25.12864
北投區	中央里	光明分隊	109-G12	KEG-1127	光明-5	第3車	1952	1953	臺北市北投區大興街24巷7弄口	121.49942	25.12889
北投區	中央里	光明分隊	109-G12	KEG-1127	光明-5	第3車	1954	1955	臺北市北投區大興街24巷5弄口	121.4988	25.12907
北投區	中央里	光明分隊	109-G12	KEG-1127	光明-5	第3車	1956	1957	臺北市北投區大興街24巷3弄口	121.49873	25.12934
北投區	中央里	光明分隊	109-G12	KEG-1127	光明-5	第3車	1958	1959	臺北市北投區大興街24巷1弄口	121.49863	25.12962
北投區	中央里	光明分隊	109-G12	KEG-1127	光明-5	第3車	2000	2002	臺北市北投區大興街24巷	121.49851	25.12999
北投區	大同里	光明分隊	109-G12	KEG-1127	光明-5	第3車	2003	2008	臺北市北投區大興街23巷31號	121.49772	25.13075
北投區	大同里	光明分隊	109-G12	KEG-1127	光明-5	第3車	2010	2012	臺北市北投區大興街9巷34弄	121.49727	25.13098
北投區	大同里	光明分隊	109-G12	KEG-1127	光明-5	第3車	2013	2014	臺北市北投區大業路452巷大興街9巷口	121.49698	25.13159
北投區	大同里	光明分隊	109-G12	KEG-1127	光明-5	第3車	2015	2016	臺北市北投區大業路516巷口	121.49751	25.1325
北投區	大同里	光明分隊	109-G12	KEG-1127	光明-5	第3車	2018	2022	臺北市北投區北投路2段1號	121.49944	25.13027
北投區	中央里	光明分隊	109-G12	KEG-1127	光明-5	第3車	2023	2025	臺北市北投區大興街50號前	121.50071	25.13054
北投區	中央里	光明分隊	109-G12	KEG-1127	光明-5	第3車	2026	2028	臺北市北投區中正街49巷底	121.49956	25.13141
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2100	2104	臺北市北投區公館路89巷口	121.50507	25.13076
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2105	2107	臺北市北投區公館路130巷口	121.50525	25.12956
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2108	2109	臺北市北投區公館路144號前	121.50565	25.12936
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2110	2111	臺北市北投區公館路166巷口	121.50617	25.12914
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2113	2115	臺北市北投區公館路187號對面	121.50722	25.12834
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2116	2125	臺北市北投區公館路三合街2段口	121.5076	25.12741
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2126	2131	臺北市北投區公館路228巷口	121.50794	25.12654
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2132	2140	臺北市北投區公館路255巷口	121.50951	25.12573
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2141	2143	臺北市北投區公館路292巷口	121.50704	25.12488
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2144	2145	臺北市北投區公館路306巷口	121.50642	25.12481
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2146	2149	臺北市北投區公館路308巷口	121.50628	25.12442
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2150	2151	臺北市北投區公館路334巷口	121.50528	25.12382
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2152	2154	臺北市北投區公館路340巷口	121.50503	25.12354
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2155	2156	臺北市北投區公館路350巷口	121.5048	25.12327
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2157	2158	臺北市北投區公館路358巷口	121.50452	25.12301
北投區	奇岩里	光明分隊	109-G12	KEG-1127	光明-5	第4車	2159	2200	臺北市北投區公館路376巷口	121.5038	25.12287
信義區	中興里	三張犁分隊	109-G13	KEG-1129	三張犁-4	第1車	1800	1810	臺北市信義區光復南路487號	121.55751	25.0326
信義區	正和里	三張犁分隊	109-G13	KEG-1129	三張犁-4	第1車	1815	1830	臺北市信義區光復南路417號之8	121.5577	25.03691
信義區	正和里	三張犁分隊	109-G13	KEG-1129	三張犁-4	第1車	1835	1900	臺北市信義區仁愛路4段452巷3號(正和里里民活動中心)	121.5591	25.037
信義區	西村里	三張犁分隊	109-G13	KEG-1129	三張犁-4	第2車	2100	2120	臺北市信義區光復南路459號	121.55768	25.03421
信義區	西村里	三張犁分隊	109-G13	KEG-1129	三張犁-4	第2車	2125	2130	臺北市信義區光復南路477之36號對面	121.55765	25.03882
信義區	西村里	三張犁分隊	109-G13	KEG-1129	三張犁-4	第2車	2135	2150	臺北市信義區基隆路1段364巷6號	121.56019	25.03516
南港區	萬福里	玉成分隊	109-G14	KEG-1131	玉成-1	第1車	1748	1800	臺北市南港區同德路45號前	121.58464	25.04549
南港區	鴻福里	玉成分隊	109-G14	KEG-1131	玉成-1	第1車	1810	1820	臺北市南港區玉成街235巷1號對面	121.58535	25.04317
南港區	成福里	玉成分隊	109-G14	KEG-1131	玉成-1	第1車	1822	1832	臺北市南港區成福路17號前	121.58649	25.045
南港區	成福里	玉成分隊	109-G14	KEG-1131	玉成-1	第1車	1833	1840	臺北市南港區東新街82號前	121.58705	25.04636
南港區	聯成里	玉成分隊	109-G14	KEG-1131	玉成-1	第1車	1845	1853	臺北市南港區忠孝東路6段278巷22弄36號前	121.58857	25.04804
南港區	聯成里	玉成分隊	109-G14	KEG-1131	玉成-1	第1車	1854	1900	臺北市南港區忠孝東路6段278巷21號前	121.58956	25.04846
南港區	聯成里	玉成分隊	109-G14	KEG-1131	玉成-1	第1車	1907	1917	臺北市南港區忠孝東路6段280號前	121.58916	25.04921
南港區	新光里	玉成分隊	109-G14	KEG-1131	玉成-1	第1車	1919	1930	臺北市南港區忠孝東路6段400號前	121.59253	25.05
南港區	新光里	玉成分隊	109-G14	KEG-1131	玉成-1	第1車	1932	1940	臺北市南港區忠孝東路6段464號前	121.59449	25.05046
南港區	新光里	玉成分隊	109-G14	KEG-1131	玉成-1	第1車	1941	1945	臺北市南港區忠孝東路7段124巷17弄40號前	121.60024	25.05082
南港區	成福里	玉成分隊	109-G14	KEG-1131	玉成-1	第2車	2033	2041	臺北市南港區成福路165號前	121.58822	25.04111
南港區	成福里	玉成分隊	109-G14	KEG-1131	玉成-1	第2車	2042	2057	臺北市南港區成福路121巷口	121.58732	25.04211
南港區	成福里	玉成分隊	109-G14	KEG-1131	玉成-1	第2車	2059	2109	臺北市南港區成福路81號對面公園旁	121.58678	25.04315
南港區	百福里	玉成分隊	109-G14	KEG-1131	玉成-1	第2車	2110	2120	臺北市南港區成福路176號前	121.58779	25.04147
南港區	百福里	玉成分隊	109-G14	KEG-1131	玉成-1	第2車	2121	2131	臺北市南港區成福路206巷2號前	121.58884	25.04016
南港區	百福里	玉成分隊	109-G14	KEG-1131	玉成-1	第2車	2132	2142	臺北市南港區成福路253號對面	121.59015	25.03884
南港區	百福里	玉成分隊	109-G14	KEG-1131	玉成-1	第2車	2143	2150	臺北市南港區成福路266號旁	121.59056	25.03773
南港區	東新里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1758	1803	臺北市南港區重陽路166巷口	121.60093	25.05727
南港區	東新里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1812	1815	臺北市南港區東明街123巷24號對面	121.601	25.05525
南港區	東明里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1817	1822	臺北市南港區南港路2段86巷9弄口對面	121.60424	25.055
南港區	東明里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1824	1829	臺北市南港區南港路2段86巷口	121.60329	25.05382
南港區	東明里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1833	1838	臺北市南港區東明街16號	121.60432	25.05593
南港區	東新里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1840	1849	臺北市南港區興華路84號	121.60579	25.05593
南港區	東明里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1851	1900	臺北市南港區興華路32號	121.60593	25.05521
南港區	東新里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1904	1906	臺北市南港區興南街60巷口	121.60304	25.05663
南港區	東新里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1908	1911	臺北市南港區重陽路166巷16弄口	121.60141	25.0565
南港區	重陽里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1914	1917	臺北市南港區重陽路235巷口	121.60235	25.05769
南港區	三重里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1920	1925	臺北市南港區重陽路421號	121.60886	25.05875
南港區	南港里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1927	1930	臺北市南港區重陽路383巷2號	121.60776	25.05841
南港區	南港里	南港分隊	109-G15	KEG-1132	南港-1	第1車	1932	1937	臺北市南港區重陽路335號	121.60627	25.05809
南港區	三重里	南港分隊	109-G15	KEG-1132	南港-1	第2車	2038	2042	臺北市南港區南港路1段54-60號	121.61515	25.05533
南港區	南港里	南港分隊	109-G15	KEG-1132	南港-1	第2車	2045	2050	臺北市南港區新民街99號	121.61062	25.0556
南港區	三重里	南港分隊	109-G15	KEG-1132	南港-1	第2車	2052	2100	臺北市南港區新民街29號	121.61308	25.0562
南港區	三重里	南港分隊	109-G15	KEG-1132	南港-1	第2車	2102	2115	臺北市南港區園區街14號	121.61122	25.05903
南港區	三重里	南港分隊	109-G15	KEG-1132	南港-1	第2車	2117	2125	臺北市南港區三重路32巷口	121.61402	25.05612
南港區	三重里	南港分隊	109-G15	KEG-1132	南港-1	第2車	2127	2131	臺北市南港區新民街58號	121.61182	25.05596
南港區	南港里	南港分隊	109-G15	KEG-1132	南港-1	第2車	2133	2138	臺北市南港區南港路1段123號前	121.61434	25.05512
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第1車	1610	1619	臺北市中山區松江路200號前	121.53305	25.05766
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第1車	1620	1624	臺北市中山區松江路168號前	121.53296	25.0559
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第1車	1625	1630	臺北市中山區松江路148號前	121.53276	25.05376
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第1車	1633	1642	臺北市中山區南京東路2段81號前	121.53166	25.05229
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第1車	1643	1648	臺北市中山區南京東路2段53號前	121.52974	25.05252
中山區	中原里	南京分隊	109-GA01	KEG-1532	南京-2	第1車	1649	1653	臺北市中山區南京東路2段23號前	121.52885	25.05221
中山區	中原里	南京分隊	109-GA01	KEG-1532	南京-2	第1車	1655	1700	臺北市中山區新生北路2段17號前	121.5278	25.0538
中山區	中原里	南京分隊	109-GA01	KEG-1532	南京-2	第2車	1825	1830	臺北市中山區長春路93號前	121.52897	25.05496
中山區	中原里	南京分隊	109-GA01	KEG-1532	南京-2	第2車	1831	1843	臺北市中山區中原街17號(中原公園)	121.52894	25.05585
中山區	中原里	南京分隊	109-GA01	KEG-1532	南京-2	第2車	1844	1855	臺北市中山區新生北路2段75號前	121.5278	25.05679
中山區	中原里	南京分隊	109-GA01	KEG-1532	南京-2	第2車	1856	1903	臺北市中山區民生東路2段36號前	121.52897	25.05787
中山區	中原里	南京分隊	109-GA01	KEG-1532	南京-2	第2車	1904	1908	臺北市中山區吉林路176號前	121.53015	25.05727
中山區	中原里	南京分隊	109-GA01	KEG-1532	南京-2	第2車	1909	1913	臺北市中山區吉林路158號前	121.53014	25.0566
中山區	中原里	南京分隊	109-GA01	KEG-1532	南京-2	第2車	1915	1920	臺北市中山區南京東路2段39號	121.52926	25.05227
中山區	中原里	南京分隊	109-GA01	KEG-1532	南京-2	第2車	1921	1926	臺北市中山區新生北路2段31之1號前	121.52785	25.05421
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第3車	2040	2050	臺北市中山區松江路170巷20號對面(中吉公園)	121.53202	25.05606
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第3車	2051	2059	臺北市中山區長春路137巷6號前	121.53147	25.05553
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第3車	2100	2119	臺北市中山區一江街42號	121.5314	25.05392
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第3車	2121	2125	臺北市中山區吉林路69號前	121.5302	25.05386
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第3車	2126	2130	臺北市中山區吉林路79號	121.53017	25.05522
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第3車	2131	2140	臺北市中山區吉林路121號前	121.53015	25.05703
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第3車	2141	2145	臺北市中山區民生東路2段92號	121.53073	25.05783
中山區	中吉里	南京分隊	109-GA01	KEG-1532	南京-2	第3車	2146	2150	臺北市中山區民生東路2段132號	121.53195	25.05764
中山區	民安里	中山分隊	109-GA02	KEG-1533	中山-2	第1車	1630	1640	臺北市中山區中山北路2段74號	121.5225	25.0572
中山區	民安里	中山分隊	109-GA02	KEG-1533	中山-2	第1車	1641	1650	臺北市中山區中山北路2段22號	121.52236	25.05359
中山區	民安里	中山分隊	109-GA02	KEG-1533	中山-2	第1車	1655	1700	臺北市中山區民生西路54號	121.52125	25.0577
中山區	民安里	中山分隊	109-GA02	KEG-1533	中山-2	第1車	1700	1704	臺北市中山區民生西路20號	121.52166	25.05773
中山區	聚盛里	中山分隊	109-GA02	KEG-1533	中山-2	第1車	1706	1711	臺北市中山區民生東路1段59號	121.52652	25.05818
中山區	聚盛里	中山分隊	109-GA02	KEG-1533	中山-2	第1車	1712	1722	臺北市中山區民生東路1段13號	121.52383	25.05819
中山區	聚盛里	中山分隊	109-GA02	KEG-1533	中山-2	第1車	1723	1729	臺北市中山區中山北路2段91號	121.52308	25.05934
中山區	聚盛里	中山分隊	109-GA02	KEG-1533	中山-2	第1車	1730	1735	臺北市中山區錦州街6號	121.52367	25.06025
中山區	聚盛里	中山分隊	109-GA02	KEG-1533	中山-2	第1車	1736	1740	臺北市中山區錦州街28號	121.52456	25.0602
中山區	聚盛里	中山分隊	109-GA02	KEG-1533	中山-2	第1車	1742	1744	臺北市中山區錦州街50號	121.52627	25.06026
中山區	聚盛里	中山分隊	109-GA02	KEG-1533	中山-2	第1車	1746	1750	臺北市中山區新生北路2段96號	121.52733	25.05913
中山區	民安里	中山分隊	109-GA02	KEG-1533	中山-2	第2車	1920	1925	臺北市中山區南京西路3號	121.52164	25.0526
中山區	民安里	中山分隊	109-GA02	KEG-1533	中山-2	第2車	1930	1933	臺北市中山區中山北路2段52號	121.5226	25.05636
中山區	民安里	中山分隊	109-GA02	KEG-1533	中山-2	第2車	1934	1940	臺北市中山區中山北路2段42巷18號前	121.3118	25.31823
中山區	民安里	中山分隊	109-GA02	KEG-1533	中山-2	第2車	1942	1950	臺北市中山區中山北路1段124號	121.52189	25.05094
中山區	民安里	中山分隊	109-GA02	KEG-1533	中山-2	第2車	1951	1953	臺北市中山區中山北路1段94號	121.52115	25.04938
中山區	民安里	中山分隊	109-GA02	KEG-1533	中山-2	第2車	1954	1959	臺北市中山區華陰街16號	121.52032	25.04899
中山區	民安里	中山分隊	109-GA02	KEG-1533	中山-2	第2車	2004	2010	臺北市中山區長安西路50號	121.52017	25.05001
中山區	正得里	中山分隊	109-GA02	KEG-1533	中山-2	第2車	2011	2015	臺北市中山區長安東路1段8-2號前	121.52268	25.04965
中山區	正得里	中山分隊	109-GA02	KEG-1533	中山-2	第3車	2125	2130	臺北市中山區林森北路140號	121.5251	25.05156
中山區	正得里	中山分隊	109-GA02	KEG-1533	中山-2	第3車	2131	2135	臺北市中山區林森北路102號	121.5248	25.05056
中山區	正得里	中山分隊	109-GA02	KEG-1533	中山-2	第3車	2136	2140	臺北市中山區林森北路72號	121.52464	25.04974
中山區	正得里	中山分隊	109-GA02	KEG-1533	中山-2	第3車	2141	2145	臺北市中山區林森北路56號	121.52427	25.04864
中山區	正得里	中山分隊	109-GA02	KEG-1533	中山-2	第3車	2146	2150	臺北市中山區天津街21號(市民大道上)	121.52236	25.048
中山區	正得里	中山分隊	109-GA02	KEG-1533	中山-2	第3車	2151	2154	臺北市中山區中山北路1段35號	121.5215	25.04886
中山區	正得里	中山分隊	109-GA02	KEG-1533	中山-2	第3車	2155	2200	臺北市中山區中山北路1段93號	121.52229	25.05068
中山區	正得里	中山分隊	109-GA02	KEG-1533	中山-2	第3車	2201	2205	臺北市中山區中山北路1段133號	121.52265	25.0516
中山區	江寧里	民二分隊	109-GA03	KEG-1535	民二-3	第1車	1650	1710	臺北市中山區民權東路3段8號	121.53936	25.06225
中山區	江寧里	民二分隊	109-GA03	KEG-1535	民二-3	第1車	1712	1730	臺北市中山區民權東路3段58號	121.54225	25.06223
中山區	江山里	民二分隊	109-GA03	KEG-1535	民二-3	第1車	1735	1745	臺北市中山區民生東路3段31號	121.53897	25.05797
中山區	下埤里	民二分隊	109-GA03	KEG-1535	民二-3	第1車	1755	1840	臺北市中山區五常街16號前(五常國小前右側10公尺處)	121.54258	25.06428
中山區	江寧里	民二分隊	109-GA03	KEG-1535	民二-3	第2車	2010	2030	臺北市中山區龍江路297號	121.54081	25.06061
中山區	下埤里	民二分隊	109-GA03	KEG-1535	民二-3	第2車	2032	2045	臺北市中山區龍江路335號旁(345巷口)	121.54096	25.0635
中山區	江山里	民二分隊	109-GA03	KEG-1535	民二-3	第2車	2050	2107	臺北市中山區復興北路356號	121.54406	25.06031
中山區	江山里	民二分隊	109-GA03	KEG-1535	民二-3	第2車	2109	2116	臺北市中山區復興北路278號	121.54405	25.05862
中山區	江山里	民二分隊	109-GA03	KEG-1535	民二-3	第2車	2119	2126	臺北市中山區民生東路3段51號	121.54038	25.05793
中山區	江山里	民二分隊	109-GA03	KEG-1535	民二-3	第2車	2128	2138	臺北市中山區民生東路3段7號	121.53787	25.05801
中山區	江寧里	民二分隊	109-GA03	KEG-1535	民二-3	第2車	2140	2145	臺北市中山區建國北路2段135號	121.53725	25.06043
文山區	興家里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1720	1723	臺北市文山區興隆路3段263號前	121.55887	24.99215
文山區	興家里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1723	1726	臺北市文山區興隆路3段257號前	121.55883	24.99253
文山區	興家里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1726	1729	臺北市文山區興隆路3段227號前	121.55929	24.99352
文山區	興家里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1729	1731	臺北市文山區興隆路3段219號前	121.55968	24.99429
文山區	興家里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1731	1734	臺北市文山區興隆路3段205號前	121.55995	24.99545
文山區	興光里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1734	1737	臺北市文山區興隆路3段177號前	121.56023	24.99634
文山區	興光里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1738	1743	臺北市文山區興隆路3段123號前	121.5583	24.99887
文山區	興泰里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1747	1750	臺北市文山區興隆路2段283號前	121.55286	25.00162
文山區	興邦里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1752	1800	臺北市文山區興隆路2段231號前	121.55054	25.0014
文山區	興邦里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1800	1806	臺北市文山區興隆路2段193號	121.54931	25.00073
文山區	興豐里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1806	1811	臺北市文山區興隆路2段125號前	121.54776	24.99995
文山區	興豐里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1812	1817	臺北市文山區興隆路2段69號前	121.54636	24.99916
文山區	興豐里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1817	1822	臺北市文山區興隆路1段281號	121.54446	24.9988
文山區	興豐里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1823	1826	臺北市文山區興隆路1段227號前	121.54381	25.00012
文山區	興豐里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1828	1829	臺北市文山區景豐街48巷11弄50號前	121.54664	25.00034
文山區	興邦里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1830	1835	臺北市文山區興隆路2段203巷54號前	121.54758	25.0025
文山區	興邦里	興隆分隊	109-GA04	KEG-1536	興隆-2	第1車	1836	1845	臺北市文山區興隆路2段203巷16號前	121.54876	25.00217
文山區	興光里	興隆分隊	109-GA04	KEG-1536	興隆-2	第2車	2012	2015	臺北市文山區興隆路3段75號前	121.55655	25.00003
文山區	興光里	興隆分隊	109-GA04	KEG-1536	興隆-2	第2車	2015	2020	臺北市文山區興隆路3段17號前	121.55515	25.0009
文山區	興旺里	興隆分隊	109-GA04	KEG-1536	興隆-2	第2車	2025	2037	臺北市文山區福興路82巷1弄1號前（山下）	121.55037	25.0061
文山區	興旺里	興隆分隊	109-GA04	KEG-1536	興隆-2	第2車	2038	2048	臺北市文山區福興路65號前	121.54999	25.00368
文山區	興旺里	興隆分隊	109-GA04	KEG-1536	興隆-2	第2車	2049	2055	臺北市文山區福興路17號前	121.5515	25.00265
文山區	興安里	興隆分隊	109-GA04	KEG-1536	興隆-2	第2車	2057	2100	臺北市文山區仙岩路33號前	121.54896	24.99908
文山區	興安里	興隆分隊	109-GA04	KEG-1536	興隆-2	第2車	2101	2106	臺北市文山區仙岩路11巷2號前	121.5482	24.9989
文山區	興安里	興隆分隊	109-GA04	KEG-1536	興隆-2	第2車	2108	2113	臺北市文山區興隆路2段116號前	121.55	25.00084
文山區	興業里	興隆分隊	109-GA04	KEG-1536	興隆-2	第2車	2115	2118	臺北市文山區興隆路2段218號旁	121.55243	25.00127
文山區	興業里	興隆分隊	109-GA04	KEG-1536	興隆-2	第2車	2119	2124	臺北市文山區興隆路2段244巷20號前	121.55317	25.00018
文山區	興業里	興隆分隊	109-GA04	KEG-1536	興隆-2	第2車	2125	2130	臺北市文山區辛亥路5段90號前	121.55304	24.99857
文山區	興業里	興隆分隊	109-GA04	KEG-1536	興隆-2	第2車	2130	2135	臺北市文山區辛亥路5段118巷2號旁	121.55207	24.99747
文山區	景仁里	景美分隊	109-GA05	KEG-1537	景美-3	第1車	1700	1705	臺北市文山區溪口街28巷1號前	121.54037	24.99527
文山區	景仁里	景美分隊	109-GA05	KEG-1537	景美-3	第1車	1706	1711	臺北市文山區溪口街70號旁	121.53859	24.99558
文山區	景仁里	景美分隊	109-GA05	KEG-1537	景美-3	第1車	1714	1719	臺北市文山區景福街45巷1號旁	121.53723	24.99825
文山區	景仁里	景美分隊	109-GA05	KEG-1537	景美-3	第1車	1720	1725	臺北市文山區景仁街78巷1號前	121.53851	24.99814
文山區	景仁里	景美分隊	109-GA05	KEG-1537	景美-3	第1車	1726	1730	臺北市文山區景仁街32號前	121.53865	24.99772
文山區	景仁里	景美分隊	109-GA05	KEG-1537	景美-3	第1車	1731	1738	臺北市文山區羅斯福路6段142巷20弄2~3號前	121.5403	24.99693
文山區	萬年里	景美分隊	109-GA05	KEG-1537	景美-3	第1車	1746	1751	臺北市文山區汀州路4段105巷1號旁	121.5368	25.00661
文山區	萬年里	景美分隊	109-GA05	KEG-1537	景美-3	第1車	1752	1800	臺北市文山區汀州路4段85巷3號旁	121.53756	25.00712
文山區	萬年里	景美分隊	109-GA05	KEG-1537	景美-3	第1車	1801	1806	臺北市文山區羅斯福路5段90-3號旁	121.53828	25.00741
文山區	萬年里	景美分隊	109-GA05	KEG-1537	景美-3	第1車	1807	1814	臺北市文山區羅斯福路5段166-2號前	121.53866	25.00468
文山區	萬隆里	景美分隊	109-GA05	KEG-1537	景美-3	第1車	1815	1820	臺北市文山區羅斯福路5段206-3號前	121.53864	25.00287
文山區	興豐里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2000	2005	臺北市文山區興隆路1段177號旁	121.54293	25.00116
文山區	萬盛里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2007	2013	臺北市文山區羅斯福路5段125號前	121.53919	25.00485
文山區	萬盛里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2014	2018	臺北市文山區羅斯福路5段87號前	121.53924	25.00598
文山區	萬盛里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2019	2024	臺北市文山區羅斯福路5段51號旁	121.53901	25.00685
文山區	萬盛里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2025	2030	臺北市文山區羅斯福路5段15號前	121.53846	25.00803
文山區	萬年里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2033	2038	臺北市文山區羅斯福路5段2號前	121.53722	25.00962
文山區	萬和里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2039	2046	臺北市文山區溪洲街10號旁	121.53517	25.00613
文山區	萬和里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2047	2052	臺北市文山區汀州路4段150號旁	121.53539	25.00492
文山區	萬和里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2053	2101	臺北市文山區汀州路4段251號前	121.53576	25.00416
文山區	萬年里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2102	2112	臺北市文山區羅斯福路5段170巷32號旁	121.53675	25.00474
文山區	景華里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2122	2124	臺北市文山區景興路10巷1號旁	121.5439	24.99803
文山區	萬有里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2125	2127	臺北市文山區三福街9巷1號對面	121.54219	24.99794
文山區	景華里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2129	2136	臺北市文山區景興路42巷8弄2號旁	121.54278	24.99699
文山區	景華里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2137	2143	臺北市文山區景興路42巷4弄2號旁	121.54406	24.99752
文山區	景華里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2145	2150	臺北市文山區景興路、景華街64號旁	121.5446	24.99506
文山區	景華里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2152	2158	臺北市文山區景興路172號前	121.54422	24.99292
文山區	景華里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2200	2206	臺北市文山區景華街52巷13號前	121.54378	24.99378
文山區	景華里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2208	2216	臺北市文山區景華街47號旁	121.54284	24.99505
文山區	景華里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2217	2223	臺北市文山區羅斯福路6段257號旁	121.5414	24.99525
文山區	景華里	景美分隊	109-GA05	KEG-1537	景美-3	第2車	2224	2230	臺北市文山區三福街2-1號旁	121.54149	24.99597
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第1車	1730	1735	臺北市文山區新光路1段161號旁	121.57395	24.99268
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第1車	1736	1739	臺北市文山區新光路1段130號前	121.57342	24.9921
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第1車	1740	1745	臺北市文山區秀明路2段22號	121.57468	24.99168
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第1車	1746	1750	臺北市文山區秀明路2段88號	121.57622	24.9914
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第1車	1751	1754	臺北市文山區秀明路2段112巷11號旁	121.57575	24.99035
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第1車	1755	1800	臺北市文山區新光路1段65巷20號前	121.57454	24.99048
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第1車	1801	1805	臺北市文山區指南路2段45巷10弄1號旁	121.57528	24.98912
文山區	指南里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	1925	1930	臺北市文山區指南路3段24巷2號旁	121.57974	24.98357
文山區	指南里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	1931	1933	臺北市文山區指南路3段21號前	121.5802	24.985
文山區	政大里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	1934	1936	臺北市文山區指南路2段229號	121.58003	24.98548
文山區	政大里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	1937	1940	臺北市文山區指南路2段207號前	121.57872	24.98692
文山區	政大里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	1941	1945	臺北市文山區指南路2段145號前	121.57713	24.98742
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	1946	1950	臺北市文山區萬壽路2號前	121.57578	24.98776
文山區	政大里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	1952	1953	臺北市文山區政大一街388號(雅敘苑)	121.58766	24.98794
文山區	指南里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	1955	2000	臺北市文山區萬壽路65號旁（指南宮）	121.58845	24.98398
文山區	政大里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	2002	2003	臺北市文山區萬壽路75巷1號政大御花園前	121.58738	24.9858
文山區	政大里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	2004	2008	臺北市文山區萬壽路61巷1號旁(綠野山莊前)	121.58823	24.98693
文山區	政大里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	2010	2013	臺北市文山區萬壽路43號前	121.57787	24.98892
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	2014	2017	臺北市文山區秀明路2段175號(大誠高中)	121.57687	24.99057
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第2車	2019	2022	臺北市文山區新光路1段143號	121.57388	24.99196
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第3車	2125	2130	臺北市文山區指南路2段71號	121.57495	24.9879
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第3車	2131	2135	臺北市文山區指南路2段31號	121.57388	24.98816
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第3車	2136	2140	臺北市文山區新光路1段15號旁	121.57381	24.98865
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第3車	2141	2145	臺北市文山區新光路1段35號	121.57383	24.98949
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第3車	2146	2150	臺北市文山區新光路1段67號	121.57386	24.99027
文山區	萬興里	木柵分隊	109-GA06	KEG-1538	木柵-3	第3車	2151	2155	臺北市文山區新光路1段97號	121.57382	24.99093
南港區	東明里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1750	1755	臺北市南港區向陽路100號	121.59516	25.05338
南港區	東明里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1756	1800	臺北市南港區南港路2段135號	121.59629	25.05433
南港區	東新里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1801	1810	臺北市南港區南港路2段238巷2號	121.59732	25.05446
南港區	東新里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1811	1815	臺北市南港區向陽路120巷2弄37號	121.59771	25.05473
南港區	東明里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1817	1822	臺北市南港區東明街120號	121.60062	25.05453
南港區	東新里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1823	1827	臺北市南港區東明街90號	121.60183	25.05464
南港區	東新里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1828	1832	臺北市南港區東明街72號	121.60257	25.05487
南港區	東新里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1833	1839	臺北市南港區東明街60號	121.60319	25.05521
南港區	東新里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1841	1848	臺北市南港區重陽路280號	121.60458	25.05771
南港區	東新里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1849	1856	臺北市南港區興華路138號	121.60544	25.05731
南港區	南港里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1857	1904	臺北市南港區興中路66號	121.60692	25.05691
南港區	南港里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1911	1917	臺北市南港區興中路34號	121.60709	25.05579
南港區	南港里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1918	1922	臺北市南港區南港路1段295號	121.60792	25.05455
南港區	三重里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1927	1935	臺北市南港區重陽路514號	121.61213	25.06098
南港區	三重里	南港分隊	109-GA08	KEG-1550	南港-3	第1車	1936	1940	臺北市南港區經貿二路235巷20號前	121.61502	25.06104
南港區	南港里	南港分隊	109-GA08	KEG-1550	南港-3	第2車	2056	2100	臺北市南港區南港路1段152之6號	121.61236	25.05538
南港區	南港里	南港分隊	109-GA08	KEG-1550	南港-3	第2車	2101	2105	臺北市南港區南港路1段188號	121.61132	25.05518
南港區	東明里	南港分隊	109-GA08	KEG-1550	南港-3	第2車	2110	2115	臺北市南港區南港路2段126號	121.60166	25.05346
南港區	東明里	南港分隊	109-GA08	KEG-1550	南港-3	第2車	2116	2120	臺北市南港區南港路2段218號	121.5988	25.05369
南港區	東新里	南港分隊	109-GA08	KEG-1550	南港-3	第2車	2122	2130	臺北市南港區興南街55號	121.60085	25.05593
南港區	南港里	南港分隊	109-GA08	KEG-1550	南港-3	第2車	2135	2140	臺北市南港區南港路1段287巷2弄1號	121.60832	25.05407
南港區	南港里	南港分隊	109-GA08	KEG-1550	南港-3	第2車	2140	2144	臺北市南港區南港路1段231號	121.61065	25.05501
南港區	南港里	南港分隊	109-GA08	KEG-1550	南港-3	第2車	2145	2150	臺北市南港區南港路1段185號	121.61246	25.05523
南港區	南港里	南港分隊	109-GA08	KEG-1550	南港-3	第2車	2151	2159	臺北市南港區南港路1段167號	121.61332	25.05526
南港區	南港里	南港分隊	109-GA08	KEG-1550	南港-3	第2車	2200	2208	臺北市南港區南港路1段143號	121.61391	25.05523
南港區	舊莊里	玉成分隊	109-GA09	KEG-1550	南港-3	第1車	1700	1715	臺北市南港區南深路37-1號	121.62267	25.03387
南港區	合成里	玉成分隊	109-GA09	KEG-1551	玉成-3	第1車	1755	1759	臺北市南港區忠孝東路6段81巷口	121.58461	25.04778
南港區	合成里	玉成分隊	109-GA09	KEG-1551	玉成-3	第1車	1800	1808	臺北市南港區永吉路601號	121.58225	25.0454
南港區	合成里	玉成分隊	109-GA09	KEG-1551	玉成-3	第1車	1810	1820	臺北市南港區中坡北路40巷口	121.58074	25.04613
南港區	合成里	玉成分隊	109-GA09	KEG-1551	玉成-3	第1車	1821	1826	臺北市南港區中坡北路60巷口	121.58074	25.04687
南港區	萬福里	玉成分隊	109-GA09	KEG-1551	玉成-3	第1車	1831	1840	臺北市南港區玉成街138號前	121.58322	25.04511
南港區	萬福里	玉成分隊	109-GA09	KEG-1551	玉成-3	第1車	1841	1850	臺北市南港區同德路54號前	121.58474	25.0455
南港區	成福里	玉成分隊	109-GA09	KEG-1551	玉成-3	第1車	1853	1905	臺北市南港區東新街108巷10號前	121.58792	25.04589
南港區	仁福里	玉成分隊	109-GA09	KEG-1551	玉成-3	第1車	1910	1917	臺北市南港區福德街461號(B6棟前)	121.59263	25.04007
南港區	仁福里	玉成分隊	109-GA09	KEG-1551	玉成-3	第1車	1918	1923	臺北市南港區福德街373巷41~47號(A11~A12棟之間)	121.59201	25.03877
南港區	仁福里	玉成分隊	109-GA09	KEG-1551	玉成-3	第1車	1924	1932	臺北市南港區福德街373巷21號(A16~A17棟之間)	121.59137	25.03928
南港區	仁福里	玉成分隊	109-GA09	KEG-1551	玉成-3	第1車	1933	1938	臺北市南港區福德街383號(A2棟前)	121.59075	25.04078
南港區	合成里	玉成分隊	109-GA09	KEG-1551	玉成-3	第2車	2020	2030	臺北市南港區忠孝東路6段405號前	121.59272	25.05023
南港區	合成里	玉成分隊	109-GA09	KEG-1551	玉成-3	第2車	2031	2043	臺北市南港區忠孝東路6段271號前	121.58978	25.04955
南港區	合成里	玉成分隊	109-GA09	KEG-1551	玉成-3	第2車	2044	2056	臺北市南港區忠孝東路6段227號前	121.5885	25.04924
南港區	合成里	玉成分隊	109-GA09	KEG-1551	玉成-3	第2車	2057	2110	臺北市南港區忠孝東路6段187號前	121.58736	25.04898
南港區	合成里	玉成分隊	109-GA09	KEG-1551	玉成-3	第2車	2112	2117	臺北市南港區忠孝東路6段17號前	121.58313	25.04605
南港區	合成里	玉成分隊	109-GA09	KEG-1131	玉成-3	第2車	2120	2125	臺北市南港區中坡北路72號	121.5807	25.04733
南港區	合成里	玉成分隊	109-GA09	KEG-1131	玉成-3	第2車	2126	2134	臺北市南港區玉成街42巷口	121.58146	25.04853
南港區	合成里	玉成分隊	109-GA09	KEG-1131	玉成-3	第2車	2135	2140	臺北市南港區玉成街56號前	121.58159	25.04746
南港區	合成里	玉成分隊	109-GA09	KEG-1131	玉成-3	第2車	2144	2150	臺北市南港區忠孝東路5段815號前	121.5824	25.04504
內湖區	西湖里	西湖分隊	109-GA12	KEG-1131	玉成-3	第1車	1800	1810	臺北市內湖區環山路1段61號	121.56816	25.08639
內湖區	港都里	西湖分隊	109-GA12	KEG-1591	西湖-2	第1車	1820	1850	臺北市內湖區內湖路1段629巷42號	121.57605	25.08139
內湖區	港墘里	西湖分隊	109-GA12	KEG-1591	西湖-2	第1車	1905	1935	臺北市內湖區港墘路127巷16弄2號	121.57704	25.07778
內湖區	港墘里	西湖分隊	109-GA12	KEG-1591	西湖-2	第2車	2040	2055	臺北市內湖區港墘路151號	121.57571	25.07725
內湖區	港富里	西湖分隊	109-GA12	KEG-1591	西湖-2	第2車	2100	2115	臺北市內湖區內湖路2段11號	121.57926	25.07882
內湖區	麗山里	西湖分隊	109-GA12	KEG-1591	西湖-2	第2車	2120	2150	臺北市內湖區內湖路1段441號	121.5723	25.0812
內湖區	西湖里	西湖分隊	109-GA12	KEG-1591	西湖-2	第2車	2155	2230	臺北市內湖區內湖路1段285巷65弄2號	121.56681	25.08458
內湖區	西康里	西湖分隊	109-GA12	KEG-1591	西湖-2	第2車	2235	2240	臺北市內湖區內湖路1段31號	121.55892	25.08523
大同區	民權里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1620	1625	臺北市大同區承德路2段188號前	121.51814	25.06163
大同區	雙連里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1627	1629	臺北市大同區寧夏路102號	121.51496	25.05883
大同區	雙連里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1630	1634	臺北市大同區寧夏路、歸綏街口	121.51511	25.05835
大同區	建功里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1640	1644	臺北市大同區太原路118號	121.51588	25.05292
大同區	建功里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1645	1648	臺北市大同區太原路76巷	121.51558	25.05188
大同區	建明里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1649	1654	臺北市大同區長安西路174號	121.51615	25.05107
大同區	建明里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1655	1657	臺北市大同區承德路1段32號	121.51684	25.05079
大同區	建明里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1657	1658	臺北市大同區承德路、華陰街口北站邊	121.51666	25.05016
大同區	建明里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1703	1705	臺北市大同區承德路1段21號	121.51708	25.0505
大同區	建明里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1707	1715	臺北市大同區長安西路78巷口	121.51935	25.05034
大同區	建明里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1718	1721	臺北市大同區華陰街47號	121.51902	25.04942
大同區	建明里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1721	1723	臺北市大同區華陰街73號	121.51802	25.04966
大同區	建明里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1723	1725	臺北市大同區華陰街95號	121.51754	25.04974
大同區	星明里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1732	1734	臺北市大同區寧夏路11號	121.51494	25.05476
大同區	星明里	建成分隊	109-GA14	KEG-1593	建成-1	第1車	1735	1737	臺北市大同區平陽街46號	121.51526	25.05545
大同區	雙連里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	1915	1919	臺北市大同區民生西路95號、雙連街口	121.51929	25.05756
大同區	雙連里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	1920	1924	臺北市大同區民生西路171號	121.51717	25.0573
大同區	星明里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	1925	1929	臺北市大同區太原路、五原路口	121.51706	25.05658
大同區	星明里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	1930	1932	臺北市大同區民生西路178巷	121.51749	25.05719
大同區	雙連里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	1936	1938	臺北市大同區錦西街、雙連街口	121.51882	25.06019
大同區	雙連里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	1939	1939	臺北市大同區停錦西街70號(臨停)	121.51925	25.06022
大同區	雙連里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	1940	1943	臺北市大同區錦西街50號	121.51995	25.06027
大同區	建泰里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	1948	1954	臺北市大同區承德路1段72號	121.51727	25.05232
大同區	建明里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	1956	1959	臺北市大同區太原路48巷口	121.51527	25.0508
大同區	建明里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	2000	2005	臺北市大同區太原路、華陰街口	121.51512	25.05026
大同區	建明里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	2007	2012	臺北市大同區重慶北路1段33號華陰街口	121.51378	25.05073
大同區	建功里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	2013	2018	臺北市大同區重慶北路1段85號	121.51422	25.05276
大同區	建功里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	2020	2023	臺北市大同區南京西路262巷口	121.51524	25.05374
大同區	雙連里	建成分隊	109-GA14	KEG-1593	建成-1	第2車	2031	2035	臺北市大同區承德路2段、萬全街口	121.51827	25.05843
信義區	黎順里	六張犁分隊	109-GA16	KEG-1586	六張犁-2	第1車	1800	1805	臺北市信義區基隆路2段155號前	121.55497	25.02571
信義區	嘉興里	六張犁分隊	109-GA16	KEG-1586	六張犁-2	第1車	1807	1815	臺北市信義區基隆路2段131號前	121.55691	25.02824
信義區	景聯里	六張犁分隊	109-GA16	KEG-1586	六張犁-2	第1車	1820	1830	臺北市信義區基隆路2段39巷口(玉山銀行前)	121.55951	25.03059
信義區	雙和里	六張犁分隊	109-GA16	KEG-1586	六張犁-2	第2車	1942	1950	臺北市信義區吳興街284巷24弄84號	121.56117	25.0227
信義區	雙和里	六張犁分隊	109-GA16	KEG-1586	六張犁-2	第2車	1952	2000	臺北市信義區吳興街284巷59弄口	121.56341	25.0221
信義區	雙和里	六張犁分隊	109-GA16	KEG-1586	六張犁-2	第2車	2002	2010	臺北市信義區吳興街284巷30弄47號前	121.56328	25.02318
信義區	雙和里	六張犁分隊	109-GA16	KEG-1586	六張犁-2	第2車	2012	2020	臺北市信義區吳興街284巷24弄2號旁	121.56357	25.02423
信義區	雙和里	六張犁分隊	109-GA16	KEG-1586	六張犁-2	第2車	2022	2030	臺北市信義區吳興街284巷3號前	121.56409	25.02577
信義區	黎順里	六張犁分隊	109-GA16	KEG-1586	六張犁-2	第3車	2130	2135	臺北市信義區基隆路2段155號前	121.55497	25.02571
信義區	嘉興里	六張犁分隊	109-GA16	KEG-1586	六張犁-2	第3車	2137	2145	臺北市信義區基隆路2段131號前	121.55691	25.02824
信義區	景聯里	六張犁分隊	109-GA16	KEG-1586	六張犁-2	第3車	2148	2200	臺北市信義區基隆路2段39巷口	121.55862	25.03133
萬華區	菜園里	漢中分隊	110-G01	KEJ-0038	漢中-1	第1車	1600	1604	臺北市萬華區環河南路1段183號前	121.49844	25.04046
萬華區	菜園里	漢中分隊	110-G01	KEJ-0038	漢中-1	第1車	1605	1610	臺北市萬華區西園路1段36號前	121.49981	25.04065
萬華區	青山里	漢中分隊	110-G01	KEJ-0038	漢中-1	第1車	1612	1618	臺北市萬華區西園路1段74號前	121.49975	25.03932
萬華區	富民里	漢中分隊	110-G01	KEJ-0038	漢中-1	第1車	1620	1630	臺北市萬華區西昌街155號前	121.50078	25.03938
萬華區	菜園里	漢中分隊	110-G01	KEJ-0038	漢中-1	第1車	1631	1635	臺北市萬華區西昌街97號前	121.50081	25.04111
萬華區	菜園里	漢中分隊	110-G01	KEJ-0038	漢中-1	第1車	1636	1640	臺北市萬華區內江街178號	121.50099	25.04176
萬華區	菜園里	漢中分隊	110-G01	KEJ-0038	漢中-1	第1車	1641	1647	臺北市萬華區內江街148號之3號前	121.50163	25.04171
萬華區	新起里	漢中分隊	110-G01	KEJ-0038	漢中-1	第1車	1648	1655	臺北市萬華區長沙街2段136之11號前	121.50299	25.04034
萬華區	新起里	漢中分隊	110-G01	KEJ-0038	漢中-1	第1車	1656	1700	臺北市萬華區長沙街2段114號對面	121.5039	25.04032
萬華區	青山里	漢中分隊	110-G01	KEJ-0038	漢中-1	第2車	1830	1834	臺北市萬華區貴陽街2段254號前	121.4983	25.03994
萬華區	青山里	漢中分隊	110-G01	KEJ-0038	漢中-1	第2車	1835	1840	臺北市萬華區貴陽街2段230號之1	121.4992	25.03998
萬華區	富民里	漢中分隊	110-G01	KEJ-0038	漢中-1	第2車	1841	1845	臺北市萬華區貴陽街2段196號	121.50023	25.04008
萬華區	富民里	漢中分隊	110-G01	KEJ-0038	漢中-1	第2車	1846	1850	臺北市萬華區貴陽街2段166號前	121.50126	25.04019
萬華區	福音里	漢中分隊	110-G01	KEJ-0038	漢中-1	第2車	1852	1900	臺北市萬華區貴陽街2段94號前	121.50332	25.03986
萬華區	仁德里	漢中分隊	110-G01	KEJ-0038	漢中-1	第2車	1901	1905	臺北市萬華區昆明街175號前	121.5042	25.03964
萬華區	仁德里	漢中分隊	110-G01	KEJ-0038	漢中-1	第2車	1906	1912	臺北市萬華區貴陽街2段28號前	121.50541	25.03951
萬華區	仁德里	漢中分隊	110-G01	KEJ-0038	漢中-1	第2車	1913	1920	臺北市萬華區柳州街60號前	121.5052	25.03818
萬華區	福音里	漢中分隊	110-G01	KEJ-0038	漢中-1	第2車	1921	1928	臺北市萬華區昆明街284號前	121.50392	25.03858
萬華區	新起里	漢中分隊	110-G01	KEJ-0038	漢中-1	第2車	1930	1935	臺北市萬華區昆明街161號前	121.50435	25.04027
萬華區	新起里	漢中分隊	110-G01	KEJ-0038	漢中-1	第3車	2105	2110	臺北市萬華區長沙街2段7號前	121.50719	25.04065
萬華區	福音里	漢中分隊	110-G01	KEJ-0038	漢中-1	第3車	2122	2126	臺北市萬華區桂林路65巷2之1號旁	121.50256	25.03834
萬華區	福音里	漢中分隊	110-G01	KEJ-0038	漢中-1	第3車	2127	2134	臺北市萬華區康定路89號前	121.50204	25.03994
萬華區	新起里	漢中分隊	110-G01	KEJ-0038	漢中-1	第3車	2135	2140	臺北市萬華區內江街142之1號前	121.50257	25.04165
萬華區	新起里	漢中分隊	110-G01	KEJ-0038	漢中-1	第3車	2141	2145	臺北市萬華區內江街110號前	121.50343	25.04158
萬華區	新起里	漢中分隊	110-G01	KEJ-0038	漢中-1	第3車	2146	2150	臺北市萬華區內江街74之1號前	121.50419	25.04149
萬華區	西門里	漢中分隊	110-G01	KEJ-0038	漢中-1	第3車	2151	2155	臺北市萬華區昆明街160號前	121.50461	25.04212
萬華區	西門里	漢中分隊	110-G01	KEJ-0038	漢中-1	第3車	2156	2200	臺北市萬華區昆明街134之2號前	121.50472	25.04272
萬華區	西門里	漢中分隊	110-G01	KEJ-0038	漢中-1	第3車	2201	2205	臺北市萬華區成都路105號前	121.50421	25.04324
大同區	蓬萊里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1600	1610	臺北市大同區蘭州街89巷口、蘭州公園	121.51557	25.06427
大同區	斯文里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1615	1620	臺北市大同區大龍街85巷口	121.516	25.06649
大同區	揚雅里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1622	1628	臺北市大同區重慶北路3段113巷28號	121.51494	25.06727
大同區	揚雅里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1630	1635	臺北市大同區民族西路162巷口	121.51544	25.0686
大同區	斯文里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1636	1640	臺北市大同區民族西路78號前	121.51767	25.06855
大同區	斯文里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1642	1653	臺北市大同區承德路3段122巷口	121.5183	25.06727
大同區	蓬萊里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1654	1657	臺北市大同區承德路3段60號前	121.51826	25.06537
大同區	蓬萊里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1658	1701	臺北市大同區承德路3段24巷口	121.51822	25.0642
大同區	蓬萊里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1702	1705	臺北市大同區承德路3段43號前	121.51842	25.06464
大同區	斯文里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1706	1709	臺北市大同區承德路3段85巷口	121.51845	25.06605
大同區	斯文里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1710	1714	臺北市大同區承德路3段129巷口	121.51846	25.0673
大同區	斯文里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1715	1718	臺北市大同區承德路3段159巷口	121.51848	25.06805
大同區	斯文里	大龍分隊	110-G02	KEJ-0039	大龍-2	第1車	1719	1723	臺北市大同區民族西路50號前	121.5191	25.06852
大同區	斯文里	大龍分隊	110-G02	KEJ-0039	大龍-2	第2車	1920	1930	臺北市大同區大龍街91巷11號前	121.5166	25.06731
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第2車	1935	1938	臺北市大同區承德路3段177巷口	121.5185	25.06912
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第2車	1939	1943	臺北市大同區承德路3段225巷口	121.51851	25.07016
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第2車	1944	1946	臺北市大同區承德路3段247巷口	121.51856	25.07114
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第2車	1948	1950	臺北市大同區承德路3段176巷口	121.51836	25.06912
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第2車	1951	1953	臺北市大同區民族西路133號前	121.51663	25.06858
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第2車	1954	2005	臺北市大同區民族西路169巷口	121.51541	25.06862
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第2車	2006	2010	臺北市大同區重慶北路3段191巷口	121.51386	25.06945
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第2車	2011	2015	臺北市大同區重慶北路3段223巷口	121.51389	25.07164
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第2車	2016	2020	臺北市大同區重慶北路3段259巷口	121.51389	25.07164
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第3車	2130	2134	臺北市大同區酒泉街37號前	121.51895	25.0706
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第3車	2135	2138	臺北市大同區承德路3段214巷口	121.51846	25.07148
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第3車	2139	2142	臺北市大同區承德路3段208巷17號前	121.51781	25.07048
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第3車	2143	2153	臺北市大同區大龍街215巷口大龍公園	121.51591	25.07053
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第3車	2154	2158	臺北市大同區大龍街187巷口	121.51592	25.06919
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第3車	2159	2205	臺北市大同區酒泉街78號前	121.51487	25.07203
大同區	至聖里	大龍分隊	110-G02	KEJ-0039	大龍-2	第3車	2206	2208	臺北市大同區酒泉街50巷口	121.51666	25.07196
信義區	五常里	五分埔分隊	110-G04	KEJ-0051	五分埔-2	第1車	1800	1815	臺北市信義區永吉路225巷52弄23號前(五常公園)	121.57337	25.04725
信義區	五常里	五分埔分隊	110-G04	KEJ-0051	五分埔-2	第1車	1818	1838	臺北市信義區永吉路321巷口	121.57553	25.04611
信義區	五常里	五分埔分隊	110-G04	KEJ-0051	五分埔-2	第1車	1840	1850	臺北市信義區永吉路189號	121.57282	25.04578
信義區	五常里	五分埔分隊	110-G04	KEJ-0051	五分埔-2	第2車	2030	2045	臺北市信義區永吉路225巷52弄23號前(五常公園)	121.57337	25.04725
信義區	四育里	五分埔分隊	110-G04	KEJ-0051	五分埔-2	第2車	2046	2055	臺北市信義區松隆路290號	121.57629	25.04809
信義區	四育里	五分埔分隊	110-G04	KEJ-0051	五分埔-2	第2車	2057	2105	臺北市信義區松山路146號	121.57759	25.04697
信義區	永吉里	五分埔分隊	110-G04	KEJ-0051	五分埔-2	第2車	2107	2120	臺北市信義區松隆路333號對面(中坡公園)	121.57928	25.04808
信義區	永吉里	五分埔分隊	110-G04	KEJ-0051	五分埔-2	第3車	2240	2250	臺北市信義區永吉路517號	121.58026	25.04557
信義區	永吉里	五分埔分隊	110-G04	KEJ-0051	五分埔-2	第3車	2252	2300	臺北市信義區永吉路443巷口	121.57839	25.04668
信義區	永吉里	五分埔分隊	110-G04	KEJ-0051	五分埔-2	第3車	2302	2317	臺北市信義區松隆路333號對面(中坡公園)	121.57928	25.04808
信義區	永吉里	五分埔分隊	110-G04	KEJ-0051	五分埔-2	第3車	2318	2323	臺北市信義區中坡公園地下停車場前	121.57928	25.04808
信義區	永吉里	五分埔分隊	110-G04	KEJ-0051	五分埔-2	第3車	2325	2330	臺北市信義區松山路161巷口	121.57816	25.04631
內湖區	麗山里	西湖分隊	110-G06	KEJ-0055	西湖-4	第1車	1810	1820	臺北市內湖區內湖路1段625號	121.57444	25.08049
內湖區	港富里	西湖分隊	110-G06	KEJ-0055	西湖-4	第1車	1830	1900	臺北市內湖區內湖路2段82號	121.58158	25.07944
內湖區	西康里	西湖分隊	110-G06	KEJ-0055	西湖-4	第1車	1925	1935	臺北市內湖區文湖街21巷98弄1號	121.55965	25.09055
內湖區	西康里	西湖分隊	110-G06	KEJ-0055	西湖-4	第1車	1940	1950	臺北市內湖區內湖路1段47巷22弄15號	121.55987	25.08839
內湖區	西康里	西湖分隊	110-G06	KEJ-0055	西湖-4	第1車	1955	2010	臺北市內湖區內湖路1段47巷7號	121.55908	25.08668
內湖區	西康里	西湖分隊	110-G06	KEJ-0055	西湖-4	第1車	2020	2035	臺北市內湖區內湖路1段215號	121.56449	25.08289
內湖區	西湖里	西湖分隊	110-G06	KEJ-0055	西湖-4	第2車	2140	2150	臺北市內湖區內湖路1段337號	121.56865	25.08223
內湖區	港墘里	西湖分隊	110-G06	KEJ-0055	西湖-4	第2車	2200	2230	臺北市內湖區瑞光路309號	121.57579	25.07578
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1601	1605	臺北市士林區延平北路9段255號	121.47033	25.10869
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1606	1611	臺北市士林區延平北路9段129號	121.47292	25.10627
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1612	1617	臺北市士林區延平北路9段35號	121.47642	25.10575
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1618	1623	臺北市士林區延平北路8段257號	121.47889	25.10586
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1624	1629	臺北市士林區延平北路8段185號	121.48132	25.10591
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1630	1635	臺北市士林區延平北路8段131號	121.48288	25.10591
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1636	1641	臺北市士林區延平北路8段55巷1號	121.48509	25.10509
士林區	福安里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1642	1645	臺北市士林區延平北路7段149號	121.4932	25.09821
士林區	福安里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1646	1649	臺北市士林區延平北路7段83號	121.49516	25.09648
士林區	社子里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1700	1706	臺北市士林區延平北路6段28號	121.50909	25.08746
士林區	社子里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1707	1714	臺北市士林區社正路28號	121.50963	25.08874
士林區	社子里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1715	1726	臺北市士林區社正路50號	121.51046	25.08883
士林區	社子里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1723	1726	臺北市士林區社正路62號	121.51083	25.08891
士林區	社子里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1729	1732	臺北市士林區中正路580號	121.51023	25.0872
士林區	社新里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1734	1737	臺北市士林區中正路622號	121.50865	25.08676
士林區	社新里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1738	1747	臺北市士林區中正路688號	121.50663	25.08619
士林區	永倫里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1757	1805	臺北市士林區永平街90號對面	121.50509	25.09196
士林區	永倫里	社子分隊	110-G07	KEJ-0056	社子-6	第1車	1807	1820	臺北市士林區永平街23號	121.50511	25.09026
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2015	2020	臺北市士林區延平北路9段255號	121.47037	25.10867
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2021	2026	臺北市士林區延平北路9段193號	121.47169	25.10744
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2027	2032	臺北市士林區延平北路9段129號	121.47299	25.10627
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2033	2038	臺北市士林區延平北路9段80號	121.47479	25.10611
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2039	2044	臺北市士林區延平北路9段35號	121.47641	25.10584
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2045	2050	臺北市士林區延平北路9段1號	121.47793	25.10591
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2051	2056	臺北市士林區延平北路8段257號	121.4789	25.10585
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2057	2102	臺北市士林區延平北路8段245之1號	121.47923	25.10587
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2103	2108	臺北市士林區延平北路8段185號	121.48132	25.106
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2109	2114	臺北市士林區延平北路8段131號	121.48287	25.10587
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2115	2120	臺北市士林區延平北路8段76號	121.48464	25.10552
士林區	富洲里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2121	2126	臺北市士林區延平北路8段55巷1號	121.48506	25.10504
士林區	福安里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2127	2134	臺北市士林區延平北路7段261號	121.48728	25.1032
士林區	福安里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2135	2138	臺北市士林區延平北路7段149號	121.49324	25.09819
士林區	福安里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2139	2142	臺北市士林區延平北路7段125號	121.49427	25.09733
士林區	福安里	社子分隊	110-G07	KEJ-0056	社子-6	第2車	2143	2146	臺北市士林區延平北路7段85號	121.4952	25.09652
士林區	福佳里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1721	1723	臺北市士林區基河路140號前	121.52243	25.08843
士林區	福德里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1724	1728	臺北市士林區承德路4段235號前	121.52208	25.08849
士林區	福德里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1731	1736	臺北市士林區福德路60巷2號後面	121.52244	25.09238
士林區	福林里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1800	1805	臺北市士林區福林路220號前	121.53295	25.09691
士林區	福林里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1806	1811	臺北市士林區福林路252號前	121.53445	25.0979
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1813	1818	臺北市士林區福林路253號前	121.53511	25.09842
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1819	1824	臺北市士林區雨農路2巷2號前	121.53221	25.09706
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1825	1830	臺北市士林區雨農路30-3號前	121.53253	25.09906
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1831	1836	臺北市士林區福志路12號前	121.53164	25.09845
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1837	1842	臺北市士林區福志路50號前	121.53034	25.09906
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1843	1848	臺北市士林區福志路80巷2號邊	121.52925	25.09889
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1849	1854	臺北市士林區福志路101號對面	121.52854	25.09851
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第1車	1855	1900	臺北市士林區中山北路5段722號前	121.52739	25.09834
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2010	2015	臺北市士林區中山北路5段463號前	121.52751	25.09212
士林區	福林里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2020	2025	臺北市士林區中山北路5段86號前	121.52576	25.08408
士林區	福林里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2029	2032	臺北市士林區中山北路5段282巷口	121.52719	25.08766
士林區	福林里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2036	2041	臺北市士林區福林路82號前	121.53079	25.09547
士林區	福林里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2043	2048	臺北市士林區至善路1段138巷2號前	121.53992	25.09718
士林區	福林里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2049	2054	臺北市士林區至善路1段138巷17號	121.54118	25.09643
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2058	2103	臺北市士林區臨溪路72號	121.54611	25.09451
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2107	2112	臺北市士林區福林路329號	121.53581	25.09884
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2113	2118	臺北市士林區福林路197號前	121.5329	25.09699
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2119	2124	臺北市士林區雨農路19號前	121.53227	25.09802
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2125	2130	臺北市士林區雨農路9號前	121.53214	25.09734
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2131	2136	臺北市士林區志成街口	121.53025	25.09628
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2137	2142	臺北市士林區中正路116號前	121.52913	25.09623
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2143	2148	臺北市士林區中山北路5段620號前	121.52781	25.09667
士林區	福志里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2149	2154	臺北市士林區中山北路5段702號前	121.52749	25.0978
士林區	福林里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2155	2200	臺北市士林區中山北路5段754號前	121.52698	25.09959
士林區	福林里	文林分隊	110-G08	KEJ-0057	文林-1	第2車	2202	2208	臺北市士林區中山北路5段511號前	121.52784	25.09374
士林區	福佳里	文林分隊	110-G08	KEJ-0057	文林-1	第3車	2305	2308	臺北市士林區文林路大北路口	121.52695	25.0896
士林區	仁勇里	文林分隊	110-G08	KEJ-0057	文林-1	第3車	2309	2312	臺北市士林區文林路大南路口	121.52654	25.08887
士林區	仁勇里	文林分隊	110-G08	KEJ-0057	文林-1	第3車	2313	2315	臺北市士林區文林路101巷口	121.52621	25.08806
士林區	仁勇里	文林分隊	110-G08	KEJ-0057	文林-1	第3車	2316	2318	臺北市士林區文林路67號	121.5256	25.08702
士林區	仁勇里	文林分隊	110-G08	KEJ-0057	文林-1	第3車	2319	2322	臺北市士林區文林路.大東路口(基河路與文林路交接端附近)	121.52543	25.08653
北投區	中心里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1735	1740	臺北市北投區珠海路219號	121.51415	25.14293
北投區	中心里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1750	1755	臺北市北投區珠海路180號至192號(路口橋頭)	121.51214	25.14261
北投區	泉源里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1756	1758	臺北市北投區登山路與珠海路口(郵政訓練所前)	121.5102	25.14189
北投區	林泉里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1805	1808	臺北市北投區中山路、中心街口	121.51115	25.13837
北投區	林泉里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1809	1811	臺北市北投區中心街10巷前	121.50979	25.13846
北投區	中心里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1814	1828	臺北市北投區泉源路32號	121.50664	25.14012
北投區	中心里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1829	1831	臺北市北投區泉源路36號	121.50654	25.14027
北投區	中心里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1832	1836	臺北市北投區泉源路39號	121.50703	25.14142
北投區	中心里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1837	1838	臺北市北投區泉源路50號(掬水軒大樓)	121.5092	25.14112
北投區	林泉里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1839	1841	臺北市北投區泉源路49號對面	121.51096	25.14125
北投區	林泉里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1842	1843	臺北市北投區泉源路64號	121.51301	25.14144
北投區	林泉里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1845	1846	臺北市北投區天寶聖道宮杏林巷5-1號(回收車)	121.51898	25.1386
北投區	林泉里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1846	1847	臺北市北投區杏林巷25號(回收車)	121.51533	25.13929
北投區	林泉里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1849	1859	臺北市北投區杏林巷3-2號鐘鼓山洞	121.51626	25.13803
北投區	林泉里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1900	1902	臺北市北投區新民路107號	121.51404	25.14169
北投區	林泉里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1903	1908	臺北市北投區新民路71巷口	121.51212	25.1407
北投區	林泉里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1909	1911	臺北市北投區新民路57巷口	121.51131	25.14031
北投區	林泉里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1912	1914	臺北市北投區新民路3巷口	121.50852	25.13971
北投區	林泉里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1915	1921	臺北市北投區新民路、中心街口	121.5073	25.13939
北投區	中心里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1922	1924	臺北市北投區泉源路21巷口	121.50492	25.13848
北投區	中心里	陽明分隊	110-G09	KEJ-0059	陽明-1	第1車	1925	1926	臺北市北投區泉源路1巷口	121.50418	25.13767
北投區	泉源里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2035	2036	臺北市北投區第一公墓	121.52708	25.14253
北投區	中心里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2040	2042	臺北市北投區泉源路39之39號(回收車)	121.50638	25.14085
北投區	中心里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2044	2045	臺北市北投區東昇路3號青濂橋(回收車)	121.52127	25.14373
北投區	泉源里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2054	2055	臺北市北投區泉源路242號龍鳳谷	121.53075	25.14816
北投區	湖山里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2057	2059	臺北市北投區紗帽路14號	121.53371	25.1486
北投區	湖山里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2101	2102	臺北市北投區紗帽路111號	121.54859	25.14839
北投區	湖山里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2103	2104	臺北市北投區紗帽路117號	121.54836	25.14923
北投區	湖山里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2105	2106	臺北市北投區紗帽路140號(養老院)	121.54738	25.15064
北投區	湖山里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2107	2108	臺北市北投區勝利街口	121.5465	25.15176
北投區	湖山里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2109	2110	臺北市北投區湖山路1段11巷口	121.5473	25.15238
北投區	湖山里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2111	2112	臺北市北投區陽明路1段67號(回收車)	121.5495	25.14966
北投區	湖山里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2112	2113	臺北市北投區陽明路1段15之1號(回收車)	121.54913	25.1468
北投區	湖山里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2114	2115	臺北市北投區湖山路1段17號	121.54734	25.1524
北投區	泉源里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2116	2117	臺北市北投區東昇路201號	121.53276	25.16064
北投區	泉源里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2118	2120	臺北市北投區東昇路80-89號	121.5302	25.1563
北投區	泉源里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2121	2122	臺北市北投區東昇路47號	121.5254	25.15051
北投區	泉源里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2122	2123	臺北市北投區東昇路41號	121.52455	25.14938
北投區	泉源里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2123	2124	臺北市北投區東昇路33號	121.52296	25.15045
北投區	中心里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2125	2127	臺北市北投區大同之家	121.52292	25.14585
北投區	永和里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2155	2156	臺北市北投區行義路301巷口	121.5279	25.13825
北投區	永和里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2157	2159	臺北市北投區行義路170巷口	121.5282	25.13147
北投區	永和里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2200	2201	臺北市北投區行義路137巷口	121.52633	25.12947
北投區	永和里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2202	2204	臺北市北投區行義路117巷口(明山宮)	121.52923	25.12817
北投區	永和里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2205	2206	臺北市北投區行義路55巷口	121.5278	25.12607
北投區	永和里	陽明分隊	110-G09	KEJ-0059	陽明-1	第2車	2207	2208	臺北市北投區行義路5巷口	121.52594	25.12419
中山區	興亞里	長安分隊	110-G10	KEJ-6172	長安-2	第1車	1630	1638	臺北市中山區新生北路1段51號	121.52972	25.04833
中山區	興亞里	長安分隊	110-G10	KEJ-6172	長安-2	第1車	1640	1648	臺北市中山區吉林路31號前	121.5301	25.05086
中山區	興亞里	長安分隊	110-G10	KEJ-6172	長安-2	第1車	1650	1658	臺北市中山區一江街3號對面	121.53146	25.05085
中山區	興亞里	長安分隊	110-G10	KEJ-6172	長安-2	第1車	1700	1710	臺北市中山區松江路68號	121.53287	25.04928
中山區	興亞里	長安分隊	110-G10	KEJ-6172	長安-2	第2車	1840	1847	臺北市中山區新生北路1段11-7號	121.53235	25.04639
中山區	興亞里	長安分隊	110-G10	KEJ-6172	長安-2	第2車	1848	1856	臺北市中山區新生北路1段25之1號前	121.53139	25.04694
中山區	興亞里	長安分隊	110-G10	KEJ-6172	長安-2	第2車	1858	1904	臺北市中山區新生北路1段83號前	121.52831	25.05085
中山區	興亞里	長安分隊	110-G10	KEJ-6172	長安-2	第2車	1905	1912	臺北市中山區南京東路2段26號前	121.52889	25.05194
中山區	興亞里	長安分隊	110-G10	KEJ-6172	長安-2	第2車	1914	1922	臺北市中山區吉林路24號	121.52997	25.05126
中山區	興亞里	長安分隊	110-G10	KEJ-6172	長安-2	第2車	1924	1930	臺北市中山區長安東路2段38號前	121.53157	25.04845
中山區	埤頭里	長安分隊	110-G10	KEJ-6172	長安-2	第3車	2050	2054	臺北市中山區八德路2段158號(進安公園旁)	121.5376	25.04622
中山區	埤頭里	長安分隊	110-G10	KEJ-6172	長安-2	第3車	2056	2101	臺北市中山區安東街2號前	121.54161	25.04686
中山區	埤頭里	長安分隊	110-G10	KEJ-6172	長安-2	第3車	2102	2107	臺北市中山區安東街17號前	121.54221	25.04538
中山區	埤頭里	長安分隊	110-G10	KEJ-6172	長安-2	第3車	2108	2114	臺北市中山區安東街16巷7號前	121.54143	25.04538
中山區	埤頭里	長安分隊	110-G10	KEJ-6172	長安-2	第3車	2115	2120	臺北市中山區安東街16巷32號前	121.54026	25.04532
中山區	埤頭里	長安分隊	110-G10	KEJ-6172	長安-2	第3車	2121	2130	臺北市中山區八德路2段210巷10號前	121.53932	25.04549
中山區	埤頭里	長安分隊	110-G10	KEJ-6172	長安-2	第3車	2131	2139	臺北市中山區八德路2段308號	121.54242	25.04716
中山區	埤頭里	長安分隊	110-G10	KEJ-6172	長安-2	第3車	2140	2146	臺北市中山區復興南路1段26號	121.54375	25.04639
中山區	埤頭里	長安分隊	110-G10	KEJ-6172	長安-2	第3車	2147	2153	臺北市中山區八德路2段300巷80號旁	121.54283	25.04498
中山區	埤頭里	長安分隊	110-G10	KEJ-6172	長安-2	第3車	2155	2200	臺北市中山區八德路2段174巷16號前	121.53843	25.04538
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1625	1630	臺北市士林區仰德大道2段32號	121.54183	25.10342
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1630	1632	臺北市士林區仰德大道2段70巷口	121.54354	25.10482
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1632	1634	臺北市士林區仰德大道2段110號	121.54512	25.1062
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1634	1637	臺北市士林區仰德大道2段132號	121.54555	25.10744
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1637	1638	臺北市士林區仰德大道2段與莊頂路口	121.54724	25.10947
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1638	1640	臺北市士林區仰德大道3段10號	121.54871	25.11057
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1640	1641	臺北市士林區仰德大道3段14號(隨招)	121.55231	25.11813
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1641	1647	臺北市士林區仰德大道3段34巷口旁公車站	121.55463	25.12029
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1647	1648	臺北市士林區新安路8巷口	121.55477	25.12079
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1648	1649	臺北市士林區新安路30巷2號	121.55293	25.12277
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1649	1651	臺北市士林區新安路30巷18號(迴轉)	121.55492	25.12088
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1651	1652	臺北市士林區新安路106巷10號	121.55689	25.12427
士林區	陽明里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1652	1653	臺北市士林區新安路106巷底(迴轉)	121.55288	25.12093
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1653	1657	臺北市士林區新安路106巷口(鼎興橋)	121.54692	25.13117
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1657	1705	臺北市士林區新安路120號	121.54586	25.13416
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1705	1706	臺北市士林區新安路129號	121.54931	25.13431
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1706	1708	臺北市士林區新安路129號至219號(隨招)	121.55011	25.12869
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1708	1710	臺北市士林區新安路280號	121.54789	25.13539
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1710	1712	臺北市士林區新安路276號至218號(隨招)	121.5486	25.13603
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1712	1714	臺北市士林區新安路175之1號	121.55082	25.1371
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1714	1716	臺北市士林區新安路石頭公園至單行道出口(隨招)	121.54618	25.13695
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1716	1721	臺北市士林區永公路245巷43弄38之1號	121.54548	25.13731
士林區	陽明里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1721	1723	臺北市士林區新安路115之1號至83號(隨招)	121.54521	25.13777
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1723	1726	臺北市士林區仰德大道3段90號	121.54247	25.13693
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1726	1727	臺北市士林區仰德大道3段122號至仁民路(隨招)	121.54369	25.13576
士林區	陽明里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1727	1733	臺北市士林區仰德大道4段仁民路口(消防局對面)	121.55279	25.11935
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1733	1736	臺北市士林區仰德大道3段250巷(進)	121.54634	25.13085
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1736	1738	臺北市士林區仰德大道3段250巷22之2號	121.55091	25.1397
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1738	1740	臺北市士林區仰德大道3段250巷27號(前空地)	121.55858	25.14149
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1740	1742	臺北市士林區仰德大道3段250巷38號	121.55374	25.14005
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1742	1744	臺北市士林區仰德大道3段250巷口(出)	121.55977	25.1382
士林區	陽明里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1744	1749	臺北市士林區中庸一路35巷口(美通橋)	121.56111	25.13436
士林區	新安里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1749	1751	臺北市士林區建業路與中庸一路口	121.56079	25.13314
士林區	陽明里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1751	1756	臺北市士林區建業路26號	121.55315	25.10902
士林區	陽明里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1756	1758	臺北市士林區建業路68巷1號	121.55408	25.11085
士林區	陽明里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1758	1802	臺北市士林區格致路與凱旋路口(垃圾車)	121.54584	25.10901
士林區	陽明里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1802	1818	臺北市士林區光華路與格致路55巷口	121.54087	25.10172
士林區	陽明里	草山分隊	110-G15	KEJ-6182	草山-1	第1車	1818	1824	臺北市士林區國泰街與光華路26巷口	121.53739	25.10719
士林區	菁山里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	1953	1955	臺北市士林區菁山路110巷(大厝地)	121.53708	25.10308
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	1955	1958	臺北市士林區永公路245巷34弄273號	121.56116	25.13424
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	1958	1959	臺北市士林區永公路245巷34弄145號	121.56079	25.1302
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	1959	2000	臺北市士林區永公路245巷34弄144號	121.56113	25.12944
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2000	2003	臺北市士林區永公路245巷34弄121號至16號(隨招)	121.56213	25.12839
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2003	2005	臺北市士林區永公路245巷34弄4號	121.56005	25.12479
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2005	2008	臺北市士林區永公路245巷52號(對面郵筒)	121.55995	25.12583
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2008	2011	臺北市士林區永公路245巷109號	121.56113	25.1263
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2011	2014	臺北市士林區永公路245巷88號	121.56112	25.12595
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2014	2015	臺北市士林區永公路245巷56號	121.56053	25.12586
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2015	2017	臺北市士林區永公路245巷33號至19號(隨招)	121.55845	25.12281
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2017	2019	臺北市士林區永公路245巷19號至永公路105號(隨招)	121.5553	25.11732
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2019	2021	臺北市士林區永公路103號至永公路5巷口(隨招)	121.55219	25.11405
士林區	公館里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2021	2024	臺北市士林區永公路3巷口	121.55086	25.11375
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2024	2028	臺北市士林區莊頂路80巷36弄口	121.55293	25.10887
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2028	2033	臺北市士林區莊頂路119號	121.55314	25.11033
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2033	2037	臺北市士林區莊頂路168號(柏園山莊)	121.55388	25.11066
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2037	2041	臺北市士林區仰德大道2段131巷	121.54548	25.10891
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2041	2045	臺北市士林區仰德大道2段2巷	121.54226	25.1023
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2045	2051	臺北市士林區仰德大道1段91巷口(芝蘭新村)	121.5373	25.10718
士林區	永福里	草山分隊	110-G15	KEJ-6182	草山-1	第2車	2051	2100	臺北市士林區仰德大道1段15號	121.53697	25.10357
士林區	溪山里	文林分隊	110-G16	KEJ-6183	文林-4	第1車	1652	1655	臺北市士林區至善路3段316號	121.58702	25.12311
士林區	溪山里	文林分隊	110-G16	KEJ-6183	文林-4	第1車	1656	1659	臺北市士林區至善路3段336巷4號	121.58767	25.12466
士林區	溪山里	文林分隊	110-G16	KEJ-6183	文林-4	第1車	1701	1704	臺北市士林區至善路3段370巷土地公廟	121.58676	25.13208
士林區	溪山里	文林分隊	110-G16	KEJ-6183	文林-4	第1車	1708	1710	臺北市士林區至善路3段267號前	121.5846	25.1198
士林區	溪山里	文林分隊	110-G16	KEJ-6183	文林-4	第1車	1711	1713	臺北市士林區至善路3段239號前	121.58314	25.11931
士林區	溪山里	文林分隊	110-G16	KEJ-6183	文林-4	第1車	1714	1715	臺北市士林區至善路3段185號	121.57851	25.11976
士林區	溪山里	文林分隊	110-G16	KEJ-6183	文林-4	第1車	1716	1717	臺北市士林區至善路3段129號	121.57199	25.11521
士林區	溪山里	文林分隊	110-G16	KEJ-6183	文林-4	第1車	1718	1720	臺北市士林區至善路3段22號 對面	121.56298	25.11217
士林區	福林里	文林分隊	110-G16	KEJ-6183	文林-4	第1車	1730	1732	臺北市士林區中山北路5段378巷30號	121.53057	25.09071
士林區	福林里	文林分隊	110-G16	KEJ-6183	文林-4	第1車	1733	1734	臺北市士林區中山北路5段378巷4號對面	121.52926	25.09002
士林區	福林里	文林分隊	110-G16	KEJ-6183	文林-4	第1車	1734	1736	臺北市士林區中山北路5段376號消防隊	121.52776	25.08967
士林區	舊佳里	文林分隊	110-G16	KEJ-6183	文林-4	第2車	1820	1825	臺北市士林區中山北路5段735號前	121.5269	25.09851
士林區	舊佳里	文林分隊	110-G16	KEJ-6183	文林-4	第2車	1829	1834	臺北市士林區中山北路5段685號	121.52731	25.09706
士林區	舊佳里	文林分隊	110-G16	KEJ-6183	文林-4	第2車	1836	1841	臺北市士林區中正路188號前	121.52728	25.09581
士林區	舊佳里	文林分隊	110-G16	KEJ-6183	文林-4	第2車	1842	1857	臺北市士林區中正路214號前	121.52627	25.09552
士林區	舊佳里	文林分隊	110-G16	KEJ-6183	文林-4	第2車	1858	1905	臺北市士林區中正路236號左前方	121.52538	25.09536
士林區	舊佳里	文林分隊	110-G16	KEJ-6183	文林-4	第2車	1907	1912	臺北市士林區中正路249號	121.52513	25.09504
士林區	福林里	文林分隊	110-G16	KEJ-6183	文林-4	第2車	1913	1918	臺北市士林區中正路219號	121.52639	25.09533
士林區	舊佳里	文林分隊	110-G16	KEJ-6183	文林-4	第2車	1925	1930	臺北市士林區前街9號對面（捷運橋下）	121.52497	25.09752
士林區	福德里	文林分隊	110-G16	KEJ-6183	文林-4	第2車	1935	1940	臺北市士林區文林路594巷2號	121.52406	25.09854
士林區	福佳里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2050	2055	臺北市士林區美崙街60號前	121.52236	25.09713
士林區	義信里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2100	2113	臺北市士林區基河路175號前	121.52315	25.08941
士林區	福德里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2116	2120	臺北市士林區中正路411號前	121.52092	25.09364
士林區	福德里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2121	2130	臺北市士林區中正路397號前	121.52129	25.09395
士林區	福德里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2131	2135	臺北市士林區中正路363號前	121.52203	25.09431
士林區	福德里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2136	2142	臺北市士林區中正路303號前	121.52374	25.0947
士林區	福德里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2143	2145	臺北市士林區中正路279號前	121.52432	25.09482
士林區	福德里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2146	2148	臺北市士林區文林路423號前	121.52477	25.09439
士林區	福德里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2149	2156	臺北市士林區文林路406號前	121.52503	25.09395
士林區	福佳里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2158	2203	臺北市士林區中正路288號	121.52349	25.09489
士林區	福佳里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2204	2208	臺北市士林區中正路316號前	121.52277	25.09473
士林區	福佳里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2209	2213	臺北市士林區中正路338號前	121.5221	25.09458
士林區	福佳里	文林分隊	110-G16	KEJ-6183	文林-4	第3車	2214	2216	臺北市士林區文昌路40號前	121.52159	25.09554
北投區	永和里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1615	1618	臺北市北投區宏盛天母公園(每週二、五回收車)	121.53041	25.13249
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1700	1702	臺北市北投區登山路40、35、30號	121.51169	25.14584
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1703	1705	臺北市北投區登山路25之1號(每週二,五回收車)	121.50875	25.14815
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1706	1707	臺北市北投區登山路69之2號(回收車)	121.51489	25.149
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1707	1708	臺北市北投區登山路61號(回收車)	121.51459	25.14833
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1708	1709	臺北市北投區公車站小7(回收車)	121.51429	25.14788
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1710	1714	臺北市北投區登山路98號	121.51596	25.1494
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1715	1716	臺北市北投區登山路128號	121.51806	25.15001
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1717	1718	臺北市北投區登山路114號	121.52002	25.15003
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1719	1724	臺北市北投區登山路108之5－＞120號(法雨寺)	121.51806	25.1472
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1725	1726	臺北市北投區登山路143號	121.52116	25.15007
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1727	1728	臺北市北投區登山路149號(回收車)	121.5219	25.15314
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1728	1729	臺北市北投區登山路159號(回收車)	121.52192	25.15288
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1729	1730	臺北市北投區登山路171號(回收車)	121.52164	25.1521
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1730	1732	臺北市北投區登山路161號(回收車)	121.5219	25.15241
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1733	1734	臺北市北投區東昇路47之2號(回收車)	121.52581	25.15053
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1734	1735	臺北市北投區東昇路47之5號(回收車)	121.52664	25.15037
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1735	1736	臺北市北投區東昇路38號(回收車)	121.52789	25.1505
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1736	1737	臺北市北投區東昇路38之18號(回收車)	121.52909	25.14821
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1737	1738	臺北市北投區東昇路38之12號(回收車)	121.52859	25.14757
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1739	1740	臺北市北投區東昇路38之16號(每週二,五回收車)	121.52893	25.15083
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1741	1742	臺北市北投區東昇路61巷口(涼亭)	121.52801	25.15291
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1743	1746	臺北市北投區東昇路86號	121.52877	25.15581
北投區	泉源里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1747	1755	臺北市北投區東昇路108號(頂湖)	121.53002	25.15649
北投區	湖山里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1756	1758	臺北市北投區湖山路2段46－50號	121.53873	25.15785
北投區	湖山里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1800	1802	臺北市北投區觀雲樓(回收車)	121.5404	25.15427
北投區	湖山里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1802	1805	臺北市北投區湖山路1段31號	121.54024	25.15421
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1815	1816	臺北市北投區竹子湖路64號(游園)	121.54165	25.17568
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1817	1818	臺北市北投區竹子湖路20號	121.54043	25.16886
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1818	1819	臺北市北投區竹子湖路17號	121.54023	25.16845
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1820	1821	臺北市北投區梅荷研習中心	121.53885	25.16826
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1823	1824	臺北市北投區竹子湖路29之1號(湖田橋餐廳)前	121.53863	25.17046
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1825	1826	臺北市北投區竹子湖路67之68號前	121.53872	25.17077
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1826	1827	臺北市北投區竹子湖路56之57號前	121.55705	25.17759
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1827	1828	臺北市北投區竹子湖路55之6號前	121.53834	25.17399
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1828	1829	臺北市北投區竹子湖路51號	121.53333	25.17662
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1829	1830	臺北市北投區竹子湖路49號	121.53304	25.17393
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1831	1832	臺北市北投區竹子湖路33號	121.5332	25.17279
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1832	1833	臺北市北投區竹子湖路29號	121.53659	25.16906
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1833	1834	臺北市北投區竹子湖路9之1號(回收車)	121.53834	25.16683
北投區	湖田里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1835	1836	臺北市北投區竹子湖路16號(派出所)	121.5401	25.16747
北投區	湖山里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1837	1840	臺北市北投區湖山路1段25之1至43號	121.54089	25.15173
北投區	湖山里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1841	1843	臺北市北投區湖底路56號(湖山亭餐廳)(回收車)	121.53698	25.1508
北投區	湖山里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1844	1845	臺北市北投區湖底路76號	121.53767	25.14803
北投區	湖山里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1845	1846	臺北市北投區湖底路70號	121.53746	25.14653
北投區	湖山里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1847	1850	臺北市北投區湖底路18之14號(回收車)	121.53687	25.14779
北投區	湖山里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1853	1855	臺北市北投區紗帽路66之5號(大埔)(回收車)	121.53658	25.14276
北投區	湖山里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1857	1902	臺北市北投區跑馬場	121.53257	25.14027
北投區	湖山里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1902	1903	臺北市北投區紗帽路9號(回收車)	121.53481	25.14902
北投區	湖山里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1903	1905	臺北市北投區紗帽路11號(回收車)	121.5354	25.14967
北投區	林泉里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1909	1912	臺北市北投區第一公墓（轉運）	121.52671	25.14395
北投區	永和里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1913	1914	臺北市北投區行義路明山宮	121.52919	25.12809
北投區	永和里	陽明分隊	110-G17	KEJ-6185	陽明-2	第1車	1915	1920	臺北市北投區行義路五福宮	121.52595	25.12422
北投區	永和里	陽明分隊	110-G17	KEJ-6185	陽明-2	第2車	2048	2055	臺北市北投區行義路186巷26弄口	121.52972	25.13259
北投區	永和里	陽明分隊	110-G17	KEJ-6185	陽明-2	第2車	2056	2057	臺北市北投區行義路186巷	121.52864	25.13272
北投區	永和里	陽明分隊	110-G17	KEJ-6185	陽明-2	第2車	2059	2101	臺北市北投區行義路154巷口	121.52822	25.13061
北投區	永和里	陽明分隊	110-G17	KEJ-6185	陽明-2	第2車	2105	2108	臺北市北投區行義路154巷19弄口	121.52968	25.13038
北投區	永和里	陽明分隊	110-G17	KEJ-6185	陽明-2	第2車	2109	2111	臺北市北投區行義路140巷口	121.52841	25.12977
北投區	永和里	陽明分隊	110-G17	KEJ-6185	陽明-2	第2車	2113	2120	臺北市北投區行義路130巷口	121.52829	25.12895
北投區	永和里	陽明分隊	110-G17	KEJ-6185	陽明-2	第2車	2121	2124	臺北市北投區行義路55巷口	121.52771	25.12597
北投區	永和里	陽明分隊	110-G17	KEJ-6185	陽明-2	第2車	2125	2127	臺北市北投區行義路37號	121.5274	25.12568
北投區	永欣里	陽明分隊	110-G17	KEJ-6185	陽明-2	第2車	2128	2130	臺北市北投區行義路10巷口	121.52617	25.12455
北投區	永和里	陽明分隊	110-G17	KEJ-6185	陽明-2	第2車	2132	2150	臺北市北投區同德街30號	121.52871	25.12534
中正區	梅花里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第1車	1735	1742	臺北市中正區北平東路與杭州北路交口處	121.52729	25.04553
中正區	梅花里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第1車	1745	1752	臺北市中正區紹興北街6號	121.5253	25.04513
中正區	幸褔里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第1車	1755	1802	臺北市中正區紹興南街5號	121.52497	25.04383
中正區	幸褔里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第2車	1915	1920	臺北市中正區青島東路19號	121.52391	25.04342
中正區	文北里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第2車	1925	1930	臺北市中正區濟南路2段6之1號	121.527	25.04133
中正區	文北里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第2車	1932	1935	臺北市中正區濟南路2段20號	121.52838	25.04101
中正區	文北里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第2車	1936	1939	臺北市中正區金山南路1段62號	121.5288	25.03983
中正區	文北里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第2車	1940	1944	臺北市中正區金山南路1段70之1號	121.52851	25.03901
中正區	文北里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第2車	1945	1952	臺北市中正區杭州南路1段69號	121.52575	25.04016
中正區	幸褔里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第2車	1954	1957	臺北市中正區杭州南路1段25號	121.52631	25.04198
中正區	幸褔里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第2車	1958	2001	臺北市中正區杭州南路1段19號	121.52652	25.04279
中正區	梅花里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第3車	2100	2105	臺北市中正區忠孝東路2段37號	121.52802	25.04374
中正區	幸褔里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第3車	2108	2111	臺北市中正區忠孝東路1段148號	121.52555	25.0442
中正區	幸褔里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第3車	2112	2116	臺北市中正區忠孝東路2段28號	121.52768	25.04366
中正區	幸褔里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第3車	2117	2119	臺北市中正區忠孝東路2段66號	121.52904	25.04328
中正區	幸褔里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第3車	2120	2123	臺北市中正區金山南路1段8號	121.52962	25.04276
中正區	幸褔里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第3車	2124	2126	臺北市中正區金山南路1段52號	121.52929	25.04142
中正區	幸褔里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第3車	2127	2129	臺北市中正區濟南路2段25號對面	121.52851	25.04097
中正區	梅花里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第3車	2135	2140	臺北市中正區忠孝東路2段93號(臨沂街口)	121.53087	25.0433
中正區	梅花里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第3車	2142	2147	臺北市中正區八德路1段84號	121.53186	25.04411
中正區	梅花里	忠孝分隊	111-G01	KEJ-0383	忠孝-2	第3車	2150	2155	臺北市中正區新生南路1段14號	121.5328	25.04382
內湖區	湖濱里	內湖分隊	111-G03	KEJ-0565	內湖-2	第1車	1800	1810	臺北市內湖區內湖路2段179巷3弄1號	121.58746	25.08155
內湖區	湖濱里	內湖分隊	111-G03	KEJ-0565	內湖-2	第1車	1815	1830	臺北市內湖區內湖路2段263巷4號	121.59027	25.08244
內湖區	碧山里	內湖分隊	111-G03	KEJ-0565	內湖-2	第2車	1950	2000	臺北市內湖區內湖路3段60巷12弄1號	121.59231	25.08791
內湖區	金龍里	內湖分隊	111-G03	KEJ-0565	內湖-2	第2車	2005	2020	臺北市內湖區金龍路91號前	121.59159	25.08539
內湖區	湖濱里	內湖分隊	111-G03	KEJ-0565	內湖-2	第2車	2025	2040	臺北市內湖區內湖路2段179巷48弄16號	121.58542	25.08348
內湖區	金龍里	內湖分隊	111-G03	KEJ-0565	內湖-2	第3車	2150	2200	臺北市內湖區金龍路33號旁	121.59415	25.08473
內湖區	內湖里	內湖分隊	111-G03	KEJ-0565	內湖-2	第3車	2205	2215	臺北市內湖區內湖路3段7號前	121.59256	25.08433
內湖區	內湖里	內湖分隊	111-G03	KEJ-0565	內湖-2	第3車	2220	2230	臺北市內湖區成功路4段182巷6弄1號前	121.59375	25.08401
文山區	木新里	木柵分隊	111-G04	KEJ-0570	木柵-4	第1車	1725	1727	臺北市文山區保儀路111號	121.56793	24.98609
文山區	木新里	木柵分隊	111-G04	KEJ-0570	木柵-4	第1車	1728	1730	臺北市文山區指南路1段2號旁	121.56875	24.98761
文山區	木新里	木柵分隊	111-G04	KEJ-0570	木柵-4	第1車	1731	1733	臺北市文山區指南路1段28號	121.5695	24.98756
文山區	木新里	木柵分隊	111-G04	KEJ-0570	木柵-4	第1車	1734	1736	臺北市文山區指南路1段35號前	121.56988	24.98779
文山區	木新里	木柵分隊	111-G04	KEJ-0570	木柵-4	第1車	1737	1745	臺北市文山區木新路2段43巷12號	121.57137	24.98597
文山區	木新里	木柵分隊	111-G04	KEJ-0570	木柵-4	第1車	1746	1748	臺北市文山區木新路2段111巷13號前	121.57045	24.9837
文山區	木新里	木柵分隊	111-G04	KEJ-0570	木柵-4	第1車	1749	1751	臺北市文山區木新路2段111巷12弄10號	121.56994	24.98351
文山區	木新里	木柵分隊	111-G04	KEJ-0570	木柵-4	第1車	1752	1754	臺北市文山區木新路2段161巷19弄3號旁	121.56958	24.98275
文山區	木新里	木柵分隊	111-G04	KEJ-0570	木柵-4	第1車	1756	1800	臺北市文山區保儀路109巷18弄1號旁	121.56921	24.98538
文山區	指南里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1914	1916	臺北市文山區指南路3段75巷1號旁	121.58029	24.98285
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1917	1919	臺北市文山區政大一街211號	121.5838	24.98564
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1920	1922	臺北市文山區政大一街210巷47號	121.58513	24.98483
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1925	1927	臺北市文山區政大一街320巷1號旁	121.58562	24.98668
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1928	1930	臺北市文山區政大二街2號	121.58413	24.98831
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1931	1933	臺北市文山區政大二街48號	121.58381	24.98707
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1933	1934	臺北市文山區政大二街166號	121.58449	24.98931
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1934	1936	臺北市文山區政大二街215巷11號	121.58694	24.98911
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1937	1939	臺北市文山區政大二街175號	121.58594	24.98906
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1940	1943	臺北市文山區政大二街131號	121.58443	24.98933
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1943	1944	臺北市文山區政大二街101號	121.58393	24.98774
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1944	1947	臺北市文山區政大三街33號夏木漱石	121.58173	24.98599
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1948	1950	臺北市文山區政大一街89號	121.58152	24.9851
文山區	政大里	木柵分隊	111-G04	KEJ-0570	木柵-4	第2車	1951	1953	臺北市文山區政大一街57號	121.58114	24.98508
文山區	木柵里	木柵分隊	111-G04	KEJ-0570	木柵-4	第3車	2056	2059	臺北市文山區秀明路1段201號	121.56991	24.99198
文山區	木柵里	木柵分隊	111-G04	KEJ-0570	木柵-4	第3車	2100	2102	臺北市文山區秀明路1段185巷1號旁	121.56819	24.99152
文山區	木柵里	木柵分隊	111-G04	KEJ-0570	木柵-4	第3車	2103	2105	臺北市文山區秀明路1段127號	121.56688	24.99112
文山區	木柵里	木柵分隊	111-G04	KEJ-0570	木柵-4	第3車	2106	2110	臺北市文山區秀明路1段103巷4弄1號旁	121.56614	24.99122
文山區	木柵里	木柵分隊	111-G04	KEJ-0570	木柵-4	第3車	2111	2114	臺北市文山區秀明路1段79巷5弄1號前	121.56556	24.99082
文山區	木柵里	木柵分隊	111-G04	KEJ-0570	木柵-4	第3車	2115	2117	臺北市文山區秀明路1段77號	121.56576	24.99041
文山區	木柵里	木柵分隊	111-G04	KEJ-0570	木柵-4	第3車	2118	2120	臺北市文山區秀明路1段49號前	121.56495	24.98991
文山區	木柵里	木柵分隊	111-G04	KEJ-0570	木柵-4	第3車	2121	2123	臺北市文山區秀明路1段88號前	121.56648	24.99047
文山區	木柵里	木柵分隊	111-G04	KEJ-0570	木柵-4	第3車	2125	2127	臺北市文山區保儀路13巷22號	121.5693	24.98834
文山區	木新里	木柵分隊	111-G04	KEJ-0570	木柵-4	第3車	2128	2130	臺北市文山區木柵路3段102巷9號	121.56767	24.98824
文山區	木柵里	木柵分隊	111-G04	KEJ-0570	木柵-4	第3車	2132	2135	臺北市文山區木柵路3段85巷23弄14號唐莊	121.56823	24.98961
北投區	永欣里	石牌分隊	111-G05	KEJ-0571	石牌-3	第1車	1730	1735	臺北市北投區榮總東院1號門	121.52267	25.11974
北投區	永欣里	石牌分隊	111-G05	KEJ-0571	石牌-3	第1車	1736	1745	臺北市北投區榮總東院對面6號門	121.52227	25.12091
北投區	永欣里	石牌分隊	111-G05	KEJ-0571	石牌-3	第1車	1750	1809	臺北市北投區石牌路2段324巷口	121.52384	25.122
北投區	永欣里	石牌分隊	111-G05	KEJ-0571	石牌-3	第1車	1810	1817	臺北市北投區石牌路2段348巷口	121.52486	25.12311
北投區	永欣里	石牌分隊	111-G05	KEJ-0571	石牌-3	第1車	1818	1827	臺北市北投區石牌路2段357號口	121.52543	25.12368
北投區	永欣里	石牌分隊	111-G05	KEJ-0571	石牌-3	第1車	1831	1850	臺北市北投區石牌路2段315巷口	121.5233	25.12174
北投區	裕民里	石牌分隊	111-G05	KEJ-0571	石牌-3	第2車	1955	1959	臺北市北投區東華街1段378號	121.51888	25.11022
北投區	裕民里	石牌分隊	111-G05	KEJ-0571	石牌-3	第2車	2000	2003	臺北市北投區東華街1段440巷口旁前	121.51786	25.11177
北投區	裕民里	石牌分隊	111-G05	KEJ-0571	石牌-3	第2車	2004	2007	臺北市北投區東華街1段488號	121.51738	25.11254
北投區	裕民里	石牌分隊	111-G05	KEJ-0571	石牌-3	第2車	2008	2013	臺北市北投區裕民六路114巷口	121.51752	25.1145
北投區	振華里	石牌分隊	111-G05	KEJ-0571	石牌-3	第2車	2014	2017	臺北市北投區裕民一路40巷19號前	121.51777	25.11595
北投區	振華里	石牌分隊	111-G05	KEJ-0571	石牌-3	第2車	2018	2021	臺北市北投區振華公園	121.519	25.11574
北投區	振華里	石牌分隊	111-G05	KEJ-0571	石牌-3	第2車	2022	2025	臺北市北投區懷德街與榮華三路口旁	121.51977	25.11429
北投區	裕民里	石牌分隊	111-G05	KEJ-0571	石牌-3	第2車	2026	2031	臺北市北投區懷德街與東陽街口旁	121.51942	25.11238
北投區	榮華里	石牌分隊	111-G05	KEJ-0571	石牌-3	第2車	2034	2039	臺北市北投區榮華三路與榮華一路旁	121.52466	25.11368
北投區	立賢里	石牌分隊	111-G05	KEJ-0571	石牌-3	第3車	2132	2150	臺北市北投區承德路7段292號	121.50513	25.11653
北投區	立賢里	石牌分隊	111-G05	KEJ-0571	石牌-3	第3車	2151	2200	臺北市北投區承德路7段342巷口旁	121.50428	25.1172
北投區	八仙里	石牌分隊	111-G05	KEJ-0571	石牌-3	第3車	2201	2205	臺北市北投區承德路7段立農街1段口	121.50267	25.11869
北投區	八仙里	石牌分隊	111-G05	KEJ-0571	石牌-3	第3車	2207	2215	臺北市北投區公?路423巷口	121.50294	25.12063
南港區	中南里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第1車	1740	1746	臺北市南港區忠孝東路7段525號前	121.6125	25.0528
南港區	新富里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第1車	1800	1804	臺北市南港區研究院路1段16號	121.61636	25.05416
南港區	中南里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第1車	1806	1811	臺北市南港區研究院路1段120號(中南街尾)	121.61556	25.05105
南港區	中研里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第1車	1813	1818	臺北市南港區研究院路2段2巷10弄10號	121.61489	25.04782
南港區	中研里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第1車	1819	1829	臺北市南港區研究院路2段12巷58弄19號對面	121.61382	25.04749
南港區	中研里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第1車	1830	1835	臺北市南港區研究院路2段54巷24號	121.61381	25.04633
南港區	中研里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第1車	1836	1841	臺北市南港區研究院路2段70巷15號	121.61461	25.04567
南港區	中研里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第1車	1842	1847	臺北市南港區研究院路2段12巷14弄24號	121.61456	25.04666
南港區	中研里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第1車	1848	1851	臺北市南港區研究院路2段13巷14號前	121.6156	25.04764
南港區	中研里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第1車	1852	1855	臺北市南港區研究院路2段38號	121.61531	25.04686
南港區	九如里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	1945	1950	臺北市南港區研究院路2段178號前	121.61697	25.03766
南港區	九如里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	1951	2000	臺北市南港區研究院路3段2巷16號對面	121.61592	25.03656
南港區	九如里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2001	2006	臺北市南港區研究院路3段2巷10號對面	121.61521	25.03583
南港區	九如里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2007	2012	臺北市南港區研究院路3段2巷68巷9號	121.61427	25.03502
南港區	九如里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2013	2018	臺北市南港區研究院路3段86巷13號對面	121.61318	25.03463
南港區	九如里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2019	2024	臺北市南港區研究院路3段245號右側	121.60987	25.03368
南港區	九如里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2025	2027	臺北市南港區研究院路3段203號	121.61191	25.03327
南港區	九如里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2028	2031	臺北市南港區研究院路3段151號	121.61364	25.03413
南港區	九如里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2032	2036	臺北市南港區研究院路3段27號前	121.61633	25.03499
南港區	新富里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2042	2047	臺北市南港區研究院路1段165號	121.61567	25.05015
南港區	新富里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2049	2052	臺北市南港區研究院路1段119號	121.61596	25.05158
南港區	中南里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2055	2100	臺北市南港區忠孝東路7段623號前	121.61556	25.0532
南港區	中南里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2101	2106	臺北市南港區忠孝東路7段575號	121.61422	25.05304
南港區	中南里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2107	2112	臺北市南港區忠孝東路7段529號前	121.6127	25.05285
南港區	中南里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2112	2115	臺北市南港區忠孝東路7段487巷1號	121.61154	25.05279
南港區	中南里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2116	2119	臺北市南港區忠孝東路7段478巷1-1號	121.60972	25.05237
南港區	中南里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2121	2131	臺北市南港區忠孝東路7段596號	121.61364	25.05281
南港區	中南里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2132	2134	臺北市南港區忠孝東路7段616號	121.61575	25.05306
南港區	新富里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2135	2137	臺北市南港區研究院路1段96號	121.61605	25.05241
南港區	中南里	舊莊分隊	111-G07	KEJ-0573	舊莊-2	第2車	2138	2145	臺北市南港區中南街130號前	121.61523	25.05212
萬華區	興德里	青年分隊	111-G08	KEJ-0387	青年-2	第1車	1627	1632	臺北市萬華區萬大路489號	121.49785	25.02016
萬華區	興德里	青年分隊	111-G08	KEJ-0387	青年-2	第1車	1632	1635	臺北市萬華區萬大路447號	121.49847	25.02094
萬華區	壽德里	青年分隊	111-G08	KEJ-0387	青年-2	第1車	1637	1643	臺北市萬華區萬大路327號	121.50023	25.02423
萬華區	壽德里	青年分隊	111-G08	KEJ-0387	青年-2	第1車	1643	1647	臺北市萬華區萬大路281號	121.50063	25.02528
萬華區	壽德里	青年分隊	111-G08	KEJ-0387	青年-2	第1車	1648	1653	臺北市萬華區萬大路277巷14弄1號	121.50112	25.02536
萬華區	壽德里	青年分隊	111-G08	KEJ-0387	青年-2	第1車	1653	1657	臺北市萬華區萬大路277巷33弄2號	121.50179	25.02543
萬華區	忠貞里	青年分隊	111-G08	KEJ-0387	青年-2	第1車	1657	1705	臺北市萬華區萬大路277巷46號	121.50257	25.02524
萬華區	新和里	青年分隊	111-G08	KEJ-0387	青年-2	第1車	1707	1712	臺北市萬華區西藏路125巷20號	121.50322	25.02512
萬華區	新和里	青年分隊	111-G08	KEJ-0387	青年-2	第1車	1713	1718	臺北市萬華區中華路2段364巷15號	121.50406	25.02862
萬華區	新和里	青年分隊	111-G08	KEJ-0387	青年-2	第1車	1720	1724	臺北市萬華區中華路2段384號	121.50517	25.02863
萬華區	新和里	青年分隊	111-G08	KEJ-0387	青年-2	第1車	1725	1730	臺北市萬華區中華路2段430號	121.50634	25.02746
萬華區	凌霄里	青年分隊	111-G08	KEJ-0387	青年-2	第2車	1907	1916	臺北市萬華區國興路46號	121.50744	25.02507
萬華區	新和里	青年分隊	111-G08	KEJ-0387	青年-2	第2車	1918	1927	臺北市萬華區國興路86號	121.50607	25.02677
萬華區	新和里	青年分隊	111-G08	KEJ-0387	青年-2	第2車	1929	1935	臺北市萬華區西藏路125巷31號	121.50307	25.02653
萬華區	忠貞里	青年分隊	111-G08	KEJ-0387	青年-2	第2車	1935	1940	臺北市萬華區青年路54號	121.50322	25.02512
萬華區	忠貞里	青年分隊	111-G08	KEJ-0387	青年-2	第2車	1940	1945	臺北市萬華區青年路58號	121.50281	25.02462
萬華區	壽德里	青年分隊	111-G08	KEJ-0387	青年-2	第2車	1946	1951	臺北市萬華區萬青街168號	121.50154	25.02351
萬華區	壽德里	青年分隊	111-G08	KEJ-0387	青年-2	第2車	1952	2000	臺北市萬華區萬大路423巷61號	121.50084	25.02151
萬華區	騰雲里	青年分隊	111-G08	KEJ-0387	青年-2	第3車	2116	2126	臺北市萬華區國興路1巷13號	121.50846	25.02346
萬華區	新和里	青年分隊	111-G08	KEJ-0387	青年-2	第3車	2128	2133	臺北市萬華區青年路18號	121.50572	25.02601
萬華區	新和里	青年分隊	111-G08	KEJ-0387	青年-2	第3車	2134	2141	臺北市萬華區青年路32號	121.50459	25.02565
萬華區	凌霄里	青年分隊	111-G08	KEJ-0387	青年-2	第3車	2143	2146	臺北市萬華區中華路2段496號	121.50743	25.02631
萬華區	凌霄里	青年分隊	111-G08	KEJ-0387	青年-2	第3車	2146	2151	臺北市萬華區中華路2段522號	121.50829	25.02545
萬華區	騰雲里	青年分隊	111-G08	KEJ-0387	青年-2	第3車	2152	2200	臺北市萬華區中華路2段598號	121.50941	25.02481
萬華區	興德里	青年分隊	111-G09	KEJ-0575	青年-1	第1車	1625	1630	臺北市萬華區萬大路423巷12號	121.49922	25.02131
萬華區	日祥里	青年分隊	111-G09	KEJ-0575	青年-1	第1車	1630	1635	臺北市萬華區萬大路423巷30弄口	121.50038	25.02113
萬華區	日祥里	青年分隊	111-G09	KEJ-0575	青年-1	第1車	1636	1640	臺北市萬華區萬大路423巷48號	121.50144	25.02171
萬華區	忠貞里	青年分隊	111-G09	KEJ-0575	青年-1	第1車	1641	1645	臺北市萬華區萬青街199號	121.50156	25.02226
萬華區	壽德里	青年分隊	111-G09	KEJ-0575	青年-1	第1車	1646	1650	臺北市萬華區長泰街2號	121.50144	25.02315
萬華區	壽德里	青年分隊	111-G09	KEJ-0575	青年-1	第1車	1651	1655	臺北市萬華區長泰街37號	121.50056	25.0232
萬華區	壽德里	青年分隊	111-G09	KEJ-0575	青年-1	第1車	1656	1700	臺北市萬華區長泰街75號(天橋下)	121.49981	25.02269
萬華區	新安里	青年分隊	111-G09	KEJ-0575	青年-1	第1車	1705	1715	臺北市萬華區萬大路139號	121.50072	25.02945
萬華區	新忠里	青年分隊	111-G09	KEJ-0575	青年-1	第1車	1719	1724	臺北市萬華區西藏路113號	121.50305	25.0298
萬華區	新忠里	青年分隊	111-G09	KEJ-0575	青年-1	第1車	1725	1729	臺北市萬華區中華路2段334號	121.50445	25.02952
萬華區	興德里	青年分隊	111-G09	KEJ-0575	青年-1	第2車	1903	1908	臺北市萬華區富民路93號	121.49893	25.01854
萬華區	興德里	青年分隊	111-G09	KEJ-0575	青年-1	第2車	1910	1912	臺北市萬華區富民路147號	121.50005	25.01818
萬華區	日祥里	青年分隊	111-G09	KEJ-0575	青年-1	第2車	1921	1925	臺北市萬華區水源路203號	121.50313	25.01951
萬華區	興德里	青年分隊	111-G09	KEJ-0575	青年-1	第2車	1925	1930	臺北市萬華區水源路209之1號	121.50213	25.01909
萬華區	日祥里	青年分隊	111-G09	KEJ-0575	青年-1	第2車	1933	1940	臺北市萬華區青年路152巷1號	121.50219	25.02096
萬華區	日祥里	青年分隊	111-G09	KEJ-0575	青年-1	第2車	1940	1945	臺北市萬華區青年路152巷29號	121.50167	25.02058
萬華區	日祥里	青年分隊	111-G09	KEJ-0575	青年-1	第2車	1945	1950	臺北市萬華區青年路152巷57號	121.50108	25.01972
萬華區	興德里	青年分隊	111-G09	KEJ-0575	青年-1	第2車	1950	1954	臺北市萬華區萬大路493巷58弄10號	121.50034	25.02008
萬華區	壽德里	青年分隊	111-G09	KEJ-0575	青年-1	第2車	1955	2000	臺北市萬華區萬大路423巷29號	121.49993	25.02119
萬華區	新和里	青年分隊	111-G09	KEJ-0575	青年-1	第3車	2115	2120	臺北市萬華區中華路2段364巷17弄5號	121.50438	25.02835
萬華區	新和里	青年分隊	111-G09	KEJ-0575	青年-1	第3車	2120	2125	臺北市萬華區中華路2段416巷3號	121.5049	25.02737
萬華區	新和里	青年分隊	111-G09	KEJ-0575	青年-1	第3車	2126	2130	臺北市萬華區中華路2段416巷17號	121.50358	25.02692
萬華區	新安里	青年分隊	111-G09	KEJ-0575	青年-1	第3車	2132	2137	臺北市萬華區中華路2段416巷118號	121.50161	25.02664
萬華區	新安里	青年分隊	111-G09	KEJ-0575	青年-1	第3車	2139	2144	臺北市萬華區西藏路163號	121.50117	25.02933
萬華區	新忠里	青年分隊	111-G09	KEJ-0575	青年-1	第3車	2145	2148	臺北市萬華區西藏路125巷5號	121.50228	25.02892
萬華區	新忠里	青年分隊	111-G09	KEJ-0575	青年-1	第3車	2148	2152	臺北市萬華區西藏路125巷11號	121.50239	25.02849
萬華區	新安里	青年分隊	111-G09	KEJ-0575	青年-1	第3車	2152	2200	臺北市萬華區雙和街5號(市場)	121.50265	25.028
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1610	1613	臺北市萬華區艋舺大道170號	121.50083	25.0329
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1614	1617	臺北市萬華區艋舺大道142號	121.50162	25.03303
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1618	1620	臺北市萬華區艋舺大道118號	121.50237	25.03319
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1621	1623	臺北市萬華區艋舺大道66號	121.50365	25.03366
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1624	1626	臺北市萬華區汀州路1段2號前	121.50417	25.03328
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1627	1629	臺北市萬華區中華路2段64號前	121.50467	25.03232
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1630	1634	臺北市萬華區莒光路114號	121.50369	25.03131
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1635	1639	臺北市萬華區莒光路164號	121.50218	25.03126
萬華區	雙園里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1640	1644	臺北市萬華區莒光路258號	121.499	25.03118
萬華區	雙園里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1644	1648	臺北市萬華區莒光路322巷口	121.49763	25.03114
萬華區	和平里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1649	1653	臺北市萬華區西園路2段88號	121.49668	25.03102
萬華區	和平里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1653	1657	臺北市萬華區西園路2段144號	121.4962	25.03004
萬華區	和平里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1657	1700	臺北市萬華區西園路2段194號	121.49578	25.02919
萬華區	和德里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1701	1704	臺北市萬華區西園路2段256號	121.49473	25.02786
萬華區	和德里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1705	1708	臺北市萬華區西園路2段290-5號	121.49378	25.02701
萬華區	和德里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1709	1712	臺北市萬華區西園路2段296號	121.49342	25.02672
萬華區	和德里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1712	1715	臺北市萬華區西園路2段328號	121.49258	25.02601
萬華區	和德里	大理分隊	111-G12	KEP-0133	大理-1	第1車	1716	1720	臺北市萬華區環河南路3段99號前	121.49058	25.02512
萬華區	雙園里	大理分隊	111-G12	KEP-0133	大理-1	第2車	1850	1853	臺北市萬華區萬大路20號	121.5005	25.03217
萬華區	雙園里	大理分隊	111-G12	KEP-0133	大理-1	第2車	1854	1858	臺北市萬華區萬大路88號	121.50047	25.03023
萬華區	雙園里	大理分隊	111-G12	KEP-0133	大理-1	第2車	1859	1902	臺北市萬華區西藏路332號	121.49997	25.02946
萬華區	雙園里	大理分隊	111-G12	KEP-0133	大理-1	第2車	1903	1906	臺北市萬華區西藏路436號	121.4971	25.02931
萬華區	雙園里	大理分隊	111-G12	KEP-0133	大理-1	第2車	1907	1910	臺北市萬華區西藏路450號	121.49655	25.02919
萬華區	和平里	大理分隊	111-G12	KEP-0133	大理-1	第2車	1912	1916	臺北市萬華區西藏路484號	121.49425	25.02879
萬華區	和平里	大理分隊	111-G12	KEP-0133	大理-1	第2車	1916	1920	臺北市萬華區西藏路514號	121.49329	25.02865
萬華區	和平里	大理分隊	111-G12	KEP-0133	大理-1	第2車	1920	1924	臺北市萬華區西藏路538號	121.49239	25.02858
萬華區	和平里	大理分隊	111-G12	KEP-0133	大理-1	第2車	1925	1928	臺北市萬華區雙園街60巷46弄15號	121.49278	25.02971
萬華區	和平里	大理分隊	111-G12	KEP-0133	大理-1	第2車	1929	1932	臺北市萬華區艋舺大道390巷2號	121.49403	25.0308
萬華區	和德里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2057	2101	臺北市萬華區興義街2號	121.49288	25.02766
萬華區	和德里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2102	2106	臺北市萬華區興義街35號	121.49181	25.0267
萬華區	和德里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2107	2110	臺北市萬華區興義街56號	121.49077	25.02585
萬華區	和德里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2111	2114	臺北市萬華區環河南路3段55號前	121.4901	25.0262
萬華區	和德里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2115	2118	臺北市萬華區環河南路3段1號前	121.48995	25.02763
萬華區	和德里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2119	2122	臺北市萬華區西園路2段320巷70號	121.49029	25.02779
萬華區	雙園里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2123	2126	臺北市萬華區西園路2段107號	121.49641	25.03011
萬華區	雙園里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2127	2130	臺北市萬華區莒光路327號	121.49717	25.031
萬華區	雙園里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2131	2136	臺北市萬華區莒光路287號	121.49945	25.03107
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2137	2141	臺北市萬華區莒光路195號	121.50188	25.03113
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2142	2147	臺北市萬華區莒光路171號	121.50267	25.03115
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2148	2152	臺北市萬華區中華路2段138號前	121.50411	25.0307
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2153	2158	臺北市萬華區西藏路194號	121.50294	25.02988
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2158	2202	臺北市萬華區西藏路234號	121.50193	25.0297
萬華區	頂碩里	大理分隊	111-G12	KEP-0133	大理-1	第3車	2203	2206	臺北市萬華區萬大路87號	121.50061	25.03034
北投區	八仙里	光明分隊	111-G13	KEP-0131	光明-4	第1車	1730	1733	臺北市北投區中央南路2段131號前	121.50011	25.12131
北投區	八仙里	光明分隊	111-G13	KEP-0131	光明-4	第1車	1734	1736	臺北市北投區中央南路2段101號前	121.50018	25.12218
北投區	八仙里	光明分隊	111-G13	KEP-0131	光明-4	第1車	1737	1740	臺北市北投區中央南路2段91巷口	121.49968	25.12904
北投區	八仙里	光明分隊	111-G13	KEP-0131	光明-4	第1車	1741	1745	臺北市北投區中央南路2段63巷口	121.50016	25.12297
北投區	八仙里	光明分隊	111-G13	KEP-0131	光明-4	第1車	1746	1750	臺北市北投區中央南路2段39巷口	121.50024	25.12391
北投區	八仙里	光明分隊	111-G13	KEP-0131	光明-4	第1車	1751	1755	臺北市北投區中央南路2段31號前	121.50039	25.12515
北投區	豐年里	光明分隊	111-G13	KEP-0131	光明-4	第1車	1800	1806	臺北市北投區豐年路2段36號	121.49636	25.1356
北投區	豐年里	光明分隊	111-G13	KEP-0131	光明-4	第1車	1808	1813	臺北市北投區豐年路2段98號	121.49503	25.13617
北投區	豐年里	光明分隊	111-G13	KEP-0131	光明-4	第1車	1815	1820	臺北市北投區豐年路2段132號	121.4938	25.13678
北投區	豐年里	光明分隊	111-G13	KEP-0131	光明-4	第1車	1823	1825	臺北市北投區大業路545號	121.49656	25.13554
北投區	溫泉里	光明分隊	111-G13	KEP-0131	光明-4	第2車	1900	1902	臺北市北投區溫泉路銀光巷21號	121.51573	25.13636
北投區	溫泉里	光明分隊	111-G13	KEP-0131	光明-4	第2車	1903	1905	臺北市北投區溫泉路銀光巷4弄口	121.51344	25.13623
北投區	溫泉里	光明分隊	111-G13	KEP-0131	光明-4	第2車	1911	1913	臺北市北投區溫泉路68巷14-1號	121.50602	25.13461
北投區	溫泉里	光明分隊	111-G13	KEP-0131	光明-4	第2車	1914	1915	臺北市北投區民族路43巷22號	121.50621	25.13397
北投區	溫泉里	光明分隊	111-G13	KEP-0131	光明-4	第2車	1916	1918	臺北市北投區民族路48巷口	121.50631	25.1333
北投區	溫泉里	光明分隊	111-G13	KEP-0131	光明-4	第2車	1920	1921	臺北市北投區民族路19巷口	121.50543	25.13271
北投區	溫泉里	光明分隊	111-G13	KEP-0131	光明-4	第2車	1922	1924	臺北市北投區公館路63巷21弄口	121.50477	25.13287
北投區	溫泉里	光明分隊	111-G13	KEP-0131	光明-4	第2車	1925	1929	臺北市北投區溫泉路58巷11號	121.50528	25.13375
北投區	奇岩里	光明分隊	111-G13	KEP-0131	光明-4	第3車	1950	1958	臺北市北投區威靈頓山莊(一,五收代清業者垃圾)	121.5127	25.12685
北投區	溫泉里	光明分隊	111-G13	KEP-0131	光明-4	第3車	2000	2025	臺北市北投區奇岩路258號至溫泉路68巷24號全線沿線打鈴隨招隨停	121.51087	25.12793
北投區	中和里	光明分隊	111-G13	KEP-0131	光明-4	第4車	2115	2117	臺北市北投區中和街錫安巷110號	121.50035	25.14737
北投區	中和里	光明分隊	111-G13	KEP-0131	光明-4	第4車	2118	2120	臺北市北投區中和街錫安巷112-8號	121.50038	25.14764
北投區	開明里	光明分隊	111-G13	KEP-0131	光明-4	第4車	2125	2128	臺北市北投區中和街292巷、義方街口	121.50021	25.14056
北投區	開明里	光明分隊	111-G13	KEP-0131	光明-4	第4車	2129	2133	臺北市北投區義方街２７號	121.50146	25.14107
北投區	開明里	光明分隊	111-G13	KEP-0131	光明-4	第4車	2134	2138	臺北市北投區義方街15號	121.50209	25.14084
北投區	開明里	光明分隊	111-G13	KEP-0131	光明-4	第4車	2139	2143	臺北市北投區義方街1號	121.5015	25.14737
北投區	開明里	光明分隊	111-G13	KEP-0131	光明-4	第4車	2144	2146	臺北市北投區開明街21號	121.50096	25.14193
北投區	開明里	光明分隊	111-G13	KEP-0131	光明-4	第4車	2147	2148	臺北市北投區開明街2號	121.50026	25.14215
北投區	中和里	光明分隊	111-G13	KEP-0131	光明-4	第4車	2149	2151	臺北市北投區大屯路11巷口	121.49969	25.14339
北投區	中和里	光明分隊	111-G13	KEP-0131	光明-4	第4車	2152	2154	臺北市北投區大屯路23號	121.50026	25.14323
北投區	中和里	光明分隊	111-G13	KEP-0131	光明-4	第4車	2155	2156	臺北市北投區大屯路47號	121.50076	25.1437
北投區	中和里	光明分隊	111-G13	KEP-0131	光明-4	第4車	2157	2210	臺北市北投區大屯路68號	121.50129	25.14424
內湖區	行善里	文德分隊	111-G15	KEL-6565	文德-4	第1車	1800	1810	臺北市內湖區新明路460巷18弄14號	121.57852	25.05405
內湖區	週美里	文德分隊	111-G15	KEL-6565	文德-4	第1車	1813	1818	臺北市內湖區潭美街217號	121.58513	25.05599
內湖區	石潭里	文德分隊	111-G15	KEL-6565	文德-4	第1車	1820	1822	臺北市內湖區潭美街359號	121.60086	25.06087
內湖區	週美里	文德分隊	111-G15	KEL-6565	文德-4	第2車	1945	2000	臺北市內湖區潭美街129號對面	121.34489	25.03139
內湖區	石潭里	文德分隊	111-G15	KEL-6565	文德-4	第2車	2006	2009	臺北市內湖區民權東路6段206巷143弄27號	121.59648	25.06452
內湖區	行善里	文德分隊	111-G15	KEL-6565	文德-4	第3車	2125	2140	臺北市內湖區新明路460巷18弄3號	121.57837	25.05425
內湖區	行善里	文德分隊	111-G15	KEL-6565	文德-4	第3車	2143	2149	臺北市內湖區潭美街27號	121.57646	25.05299
內湖區	週美里	文德分隊	111-G15	KEL-6565	文德-4	第3車	2151	2156	臺北市內湖區潭美街129號對面	121.34489	25.03139
內湖區	週美里	文德分隊	111-G15	KEL-6565	文德-4	第3車	2200	2205	臺北市內湖區南京東路6段192號	121.5804	25.05614
北投區	八仙里	關渡分隊	111-G16	KEL-6571	關渡-2	第1車	1600	1610	臺北市北投區承德路7段401巷88弄與413巷交叉口	121.49997	25.11789
北投區	福興里	關渡分隊	111-G16	KEL-6571	關渡-2	第1車	1627	1628	臺北市北投區承德路7段119巷口	121.50926	25.11198
北投區	建民里	關渡分隊	111-G16	KEL-6571	關渡-2	第1車	1630	1635	臺北市北投區承德路6段331巷	121.50975	25.10388
北投區	八仙里	關渡分隊	111-G16	KEL-6571	關渡-2	第1車	1702	1703	臺北市北投區承德路7段401巷120號	121.50026	25.11704
北投區	八仙里	關渡分隊	111-G16	KEL-6571	關渡-2	第1車	1704	1705	臺北市北投區承德路7段401巷177-2號	121.49937	25.11465
北投區	八仙里	關渡分隊	111-G16	KEL-6571	關渡-2	第1車	1706	1708	臺北市北投區承德路7段401巷318號	121.49681	25.11547
北投區	八仙里	關渡分隊	111-G16	KEL-6571	關渡-2	第1車	1709	1712	臺北市北投區承德路7段401巷350弄口	121.49585	25.1153
北投區	八仙里	關渡分隊	111-G16	KEL-6571	關渡-2	第1車	1714	1715	臺北市北投區承德路7段401巷572號	121.48995	25.11688
北投區	八仙里	關渡分隊	111-G16	KEL-6571	關渡-2	第1車	1719	1722	臺北市北投區承德路7段401巷989弄75號	121.48386	25.11516
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第2車	1730	1733	臺北市北投區聖景路,貴族山莊101號(星期二.星期五)	121.46461	25.12181
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第2車	1800	1802	臺北市北投區大度路3段301巷28弄口	121.46578	25.12218
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第2車	1803	1805	臺北市北投區大度路3段301巷63弄口	121.4666	25.1209
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第2車	1806	1808	臺北市北投區大度路3段301巷86號	121.46561	25.12097
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第2車	1809	1814	臺北市北投區大度路3段301巷128弄口	121.4652	25.1198
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第2車	1815	1818	臺北市北投區關渡宮	121.46395	25.1177
北投區	八仙里	關渡分隊	111-G16	KEL-6571	關渡-2	第2車	1835	1845	臺北市北投區大業路65巷2弄口	121.49699	25.12334
北投區	八仙里	關渡分隊	111-G16	KEL-6571	關渡-2	第2車	1853	1858	臺北市北投區大度路1段怡和巷	121.49581	25.12161
北投區	桃源里	關渡分隊	111-G16	KEL-6571	關渡-2	第3車	1945	1948	臺北市北投區中央北路3段41號前	121.48561	25.13808
北投區	桃源里	關渡分隊	111-G16	KEL-6571	關渡-2	第3車	1949	1951	臺北市北投區中央北路3段3號	121.48658	25.13816
北投區	桃源里	關渡分隊	111-G16	KEL-6571	關渡-2	第3車	1952	1954	臺北市北投區中央北路3段16巷口	121.48619	25.13849
北投區	桃源里	關渡分隊	111-G16	KEL-6571	關渡-2	第3車	1955	1956	臺北市北投區中央北路3段40巷20弄口	121.48555	25.13902
北投區	桃源里	關渡分隊	111-G16	KEL-6571	關渡-2	第3車	1957	2004	臺北市北投區中央北路3段40巷頂（桃源國小門口）	121.48456	25.13968
北投區	桃源里	關渡分隊	111-G16	KEL-6571	關渡-2	第3車	2005	2008	臺北市北投區崗山路11巷口	121.48592	25.14054
北投區	桃源里	關渡分隊	111-G16	KEL-6571	關渡-2	第3車	2009	2010	臺北市北投區崗山路9巷口	121.48587	25.14034
北投區	桃源里	關渡分隊	111-G16	KEL-6571	關渡-2	第3車	2011	2012	臺北市北投區崗山路5巷口	121.48629	25.14006
北投區	桃源里	關渡分隊	111-G16	KEL-6571	關渡-2	第3車	2013	2015	臺北市北投區新興路140號	121.48692	25.13978
北投區	桃源里	關渡分隊	111-G16	KEL-6571	關渡-2	第3車	2016	2018	臺北市北投區新興路158巷口	121.486	25.13905
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第4車	2106	2108	臺北市北投區302公車站	121.46512	25.11793
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第4車	2109	2110	臺北市北投區知行路6號	121.46571	25.11793
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第4車	2111	2112	臺北市北投區知行路12號	121.46585	25.11801
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第4車	2113	2114	臺北市北投區知行路24號	121.46637	25.11808
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第4車	2115	2116	臺北市北投區知行路36號	121.46691	25.11806
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第4車	2117	2118	臺北市北投區知行路52號	121.46735	25.11822
北投區	關渡里	關渡分隊	111-G16	KEL-6571	關渡-2	第4車	2119	2120	臺北市北投區知行路76號	121.46811	25.11833
北投區	永明里	石牌分隊	111-G17	KEA-0309	石牌-5	第1車	1730	1743	臺北市北投區立農街2段202巷口旁	121.51415	25.11887
北投區	永明里	石牌分隊	111-G17	KEA-0309	石牌-5	第1車	1745	1800	臺北市北投區永明派出所前旁	121.51649	25.11767
北投區	永明里	石牌分隊	111-G17	KEA-0309	石牌-5	第1車	1801	1805	臺北市北投區義理街49巷口旁	121.5156345	25.1169205
北投區	永明里	石牌分隊	111-G17	KEA-0309	石牌-5	第1車	1806	1810	臺北市北投區義理街7-1號前	121.51523	25.11645
北投區	永明里	石牌分隊	111-G17	KEA-0309	石牌-5	第2車	1915	1925	臺北市北投區東華街2段60號前	121.5141	25.11704
北投區	東華里	石牌分隊	111-G17	KEA-0309	石牌-5	第2車	1926	1930	臺北市北投區東華街2段114號礦務局旁	121.51172	25.11983
北投區	東華里	石牌分隊	111-G17	KEA-0309	石牌-5	第2車	1931	1936	臺北市北投區東華街2段174巷	121.51006	25.12037
北投區	東華里	石牌分隊	111-G17	KEA-0309	石牌-5	第2車	1937	1942	臺北市北投區致遠三路55巷96號旁	121.50896	25.12062
北投區	東華里	石牌分隊	111-G17	KEA-0309	石牌-5	第2車	1943	1948	臺北市北投區致遠三路149巷2弄48號	121.50822	25.12106
北投區	東華里	石牌分隊	111-G17	KEA-0309	石牌-5	第2車	1949	1954	臺北市北投區致遠三路147巷口	121.50936	25.12173
北投區	東華里	石牌分隊	111-G17	KEA-0309	石牌-5	第2車	1955	1959	臺北市北投區致遠三路119巷口	121.51011	25.12175
北投區	東華里	石牌分隊	111-G17	KEA-0309	石牌-5	第2車	2000	2005	臺北市北投區致遠三路101巷	121.51087	25.12168
北投區	東華里	石牌分隊	111-G17	KEA-0309	石牌-5	第2車	2006	2010	臺北市北投區致遠三路55巷口	121.51176	25.12111
北投區	東華里	石牌分隊	111-G17	KEA-0309	石牌-5	第2車	2012	2015	臺北市北投區東華街2段300巷頭	121.50684	25.121
北投區	東華里	石牌分隊	111-G17	KEA-0309	石牌-5	第2車	2016	2020	臺北市北投區東華街2段340巷	121.5056	25.12123
北投區	東華里	石牌分隊	111-G17	KEA-0309	石牌-5	第2車	2021	2025	臺北市北投區東華街2段300巷尾	121.5043	25.12148
北投區	福興里	石牌分隊	111-G17	KEA-0309	石牌-5	第3車	2121	2124	臺北市北投區致遠一路2段125巷口	121.51254	25.11357
北投區	福興里	石牌分隊	111-G17	KEA-0309	石牌-5	第3車	2125	2129	臺北市北投區致遠一路2段111巷口	121.51274	25.11329
北投區	福興里	石牌分隊	111-G17	KEA-0309	石牌-5	第3車	2130	2135	臺北市北投區致遠一路2段71巷口	121.51316	25.11274
北投區	福興里	石牌分隊	111-G17	KEA-0309	石牌-5	第3車	2136	2139	臺北市北投區致遠一路2段57巷口	121.51352	25.11225
北投區	福興里	石牌分隊	111-G17	KEA-0309	石牌-5	第3車	2140	2145	臺北市北投區致遠一路2段35巷口	121.51397	25.11158
北投區	福興里	石牌分隊	111-G17	KEA-0309	石牌-5	第3車	2146	2148	臺北市北投區致遠一路2段11巷口	121.51437	25.11105
北投區	石牌里	石牌分隊	111-G17	KEA-0309	石牌-5	第3車	2150	2155	臺北市北投區自強街120巷口	121.51569	25.11091
南港區	中研里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第1車	1800	1805	臺北市南港區福山街44巷15弄12號	121.61773	25.04534
南港區	中研里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第1車	1807	1816	臺北市南港區福山街4號	121.616	25.04569
南港區	中研里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第1車	1820	1824	臺北市南港區研究院路2段35巷23弄2號	121.61639	25.04632
南港區	中研里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第1車	1825	1830	臺北市南港區研究院路2段25號	121.61528	25.04638
南港區	中研里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第1車	1832	1838	臺北市南港區研究院路2段5巷2號前	121.61571	25.04729
南港區	新富里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第1車	1842	1845	臺北市南港區研究院路1段69號前	121.61633	25.05278
南港區	中南里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第1車	1846	1850	臺北市南港區研究院路1段29號	121.6165	25.05377
南港區	中南里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第1車	1856	1859	臺北市南港區市民大道8段575號	121.61517	25.05445
南港區	中南里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第1車	1900	1903	臺北市南港區市民大道8段530號前	121.61342	25.05394
南港區	中南里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第1車	1904	1907	臺北市南港區市民大道8段588巷口	121.61508	25.05422
南港區	中南里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第1車	1910	1915	臺北市南港區中南街74巷18號	121.61447	25.05344
南港區	中研里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2012	2016	臺北市南港區研究院路2段136號右側	121.61711	25.03871
南港區	九如里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2018	2022	臺北市南港區研究院路2段199號前	121.61733	25.03664
南港區	九如里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2022	2027	臺北市南港區研究院路2段225號	121.61702	25.03606
南港區	九如里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2030	2032	臺北市南港區研究院路2段182巷29弄2號後	121.61585	25.03721
南港區	九如里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2035	2040	臺北市南港區研究院路2段182巷109號前	121.61295	25.03598
南港區	九如里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2041	2051	臺北市南港區研究院路2段182巷58弄23號	121.6141	25.03618
南港區	舊莊里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2054	2057	臺北市南港區合順街8巷7弄口	121.61889	25.04152
南港區	舊莊里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2058	2100	臺北市南港區舊莊街1段92號前	121.61918	25.04065
南港區	舊莊里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2102	2104	臺北市南港區舊莊街1段170號	121.62129	25.03925
南港區	舊莊里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2105	2107	臺北市南港區舊莊街1段264號	121.62358	25.03734
南港區	舊莊里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2108	2110	臺北市南港區舊莊街1段290巷1弄1號前	121.62396	25.03678
南港區	舊莊里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2111	2113	臺北市南港區舊莊街2段3號對面	121.62454	25.03749
南港區	舊莊里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2115	2117	臺北市南港區舊莊街2段100號前30公尺	121.62973	25.03592
南港區	舊莊里	舊莊分隊	111-G19	KEL-6575	舊莊-3	第2車	2118	2145	臺北市南港區舊莊街2段128-324號前(週一、週四、週六收運，採沿途沿線播放音樂方式收運)	121.63048	25.035
中正區	河堤里	公館分隊	111-G20	KEP-3619	公館-1	第1車	1725	1728	臺北市中正區師大路188號	121.52445	25.02117
中正區	河堤里	公館分隊	111-G20	KEP-3619	公館-1	第1車	1729	1730	臺北市中正區師大路206號	121.5234	25.02075
中正區	河堤里	公館分隊	111-G20	KEP-3619	公館-1	第1車	1731	1734	臺北市中正區水源路51號前	121.52205	25.02062
中正區	河堤里	公館分隊	111-G20	KEP-3619	公館-1	第1車	1735	1739	臺北市中正區同安街99號	121.52053	25.02186
中正區	河堤里	公館分隊	111-G20	KEP-3619	公館-1	第1車	1740	1744	臺北市中正區汀州路2段180號旁	121.52266	25.02329
中正區	河堤里	公館分隊	111-G20	KEP-3619	公館-1	第1車	1745	1749	臺北市中正區臺北市汀州路2段218號前(金門街口)	121.52397	25.02218
中正區	河堤里	公館分隊	111-G20	KEP-3619	公館-1	第1車	1750	1755	臺北市中正區汀州路2段258號	121.52484	25.02141
中正區	富水里	公館分隊	111-G20	KEP-3619	公館-1	第2車	1854	1855	臺北市中正區汀州路3段24巷3號	121.52773	25.01681
中正區	富水里	公館分隊	111-G20	KEP-3619	公館-1	第2車	1856	1857	臺北市中正區永春街204號	121.52664	25.0156
中正區	富水里	公館分隊	111-G20	KEP-3619	公館-1	第2車	1901	1905	臺北市中正區羅斯福路3段316巷11號	121.5322	25.01561
中正區	富水里	公館分隊	111-G20	KEP-3619	公館-1	第2車	1906	1910	臺北市中正區汀州路3段153號	121.5314	25.01584
中正區	富水里	公館分隊	111-G20	KEP-3619	公館-1	第2車	1911	1915	臺北市中正區汀州路3段123號	121.53038	25.01657
中正區	富水里	公館分隊	111-G20	KEP-3619	公館-1	第2車	1916	1920	臺北市中正區汀州路3段97號	121.5293	25.01728
中正區	富水里	公館分隊	111-G20	KEP-3619	公館-1	第2車	1921	1925	臺北市中正區汀州路3段65號	121.52821	25.01806
中正區	河堤里	公館分隊	111-G20	KEP-3619	公館-1	第2車	1927	1930	臺北市中正區金門街14-1號	121.52335	25.02186
中正區	河堤里	公館分隊	111-G20	KEP-3619	公館-1	第2車	1931	1934	臺北市中正區金門街32號	121.52271	25.0213
中正區	河堤里	公館分隊	111-G20	KEP-3619	公館-1	第2車	1935	1938	臺北市中正區金門街34巷14號旁	121.5217	25.02195
中正區	河堤里	公館分隊	111-G20	KEP-3619	公館-1	第2車	1939	1942	臺北市中正區金門街24巷11-1號邊	121.52219	25.02229
中正區	水源里	公館分隊	111-G20	KEP-3619	公館-1	第3車	2100	2104	臺北市中正區汀州路3段291號前	121.53569	25.01206
中正區	水源里	公館分隊	111-G20	KEP-3619	公館-1	第3車	2105	2109	臺北市中正區汀州路3段249號	121.53435	25.01367
中正區	水源里	公館分隊	111-G20	KEP-3619	公館-1	第3車	2110	2114	臺北市中正區汀州路3段199之1號	121.53328	25.01452
中正區	文盛里	公館分隊	111-G20	KEP-3619	公館-1	第3車	2115	2120	臺北市中正區汀州路3段173號	121.53253	25.0151
中正區	水源里	公館分隊	111-G20	KEP-3619	公館-1	第3車	2121	2123	臺北市中正區汀州路3段162號	121.53452	25.01337
中正區	水源里	公館分隊	111-G20	KEP-3619	公館-1	第3車	2124	2126	臺北市中正區汀州路3段194號前	121.53522	25.01247
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1414	1415	臺北市文山區新光路2段74巷24號(週二、週六收運)	121.59624	24.98628
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1444	1445	臺北市文山區萬壽路61巷66號(週一、週五收運))	121.59012	24.98636
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1446	1447	臺北市文山區新光路2段74巷23號(週二、週六收運)	121.59761	24.99115
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1446	1447	臺北市文山區萬壽路61巷56號(週一、週五收運)	121.59012	24.98636
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1448	1449	臺北市文山區新光路2段74巷22號(週二、週六收運)	121.58627	24.99983
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1448	1449	臺北市文山區萬壽路61巷46號(週一、週五收運)	121.58977	24.98671
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1448	1449	臺北市文山區新光路2段74巷20號(週二、週六收運)	121.59812	24.98961
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1450	1451	臺北市文山區新光路2段74巷17號(週二、週六收運)	121.59704	24.98773
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1450	1451	臺北市文山區萬壽路61巷37號(週一、週五收運)	121.58978	24.98681
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1450	1451	臺北市文山區萬壽路61巷39號(週一、週五收運)	121.58984	24.98656
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1452	1453	臺北市文山區新光路2段74巷11號(週二、週六收運)	121.59624	24.98628
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1452	1453	臺北市文山區萬壽路61巷40號(週一、週五收運)	121.5899	24.98644
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1452	1453	臺北市文山區新光路2段74巷13號(週一、週五收運)	121.59456	24.97686
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1452	1453	臺北市文山區萬壽路61巷42號(週一、週五收運)	121.59008	24.98629
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1454	1455	臺北市文山區新光路2段74巷16號(週二、週六收運)	121.59624	24.98628
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1454	1455	臺北市文山區萬壽路61巷36號(週一、週五收運)	121.58978	24.98681
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1456	1457	臺北市文山區萬壽路61巷30號(週一、週五收運)	121.5894	24.98672
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1456	1457	臺北市文山區萬壽路61巷34號(週一、週五收運)	121.58942	24.98672
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1456	1457	臺北市文山區萬壽路71號(週二、週六收運)	121.58542	24.98164
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1457	1458	臺北市文山區萬壽路61巷19號(週一、週五收運)	121.58934	24.98649
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1457	1458	臺北市文山區萬壽路61巷26號(週一、週五收運)	121.58937	24.98649
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1458	1459	臺北市文山區萬壽路61巷16號(週一、週五收運)	121.58907	24.98635
文山區	政大里	木柵分隊	111-G22	KEP-3617	木柵-1	第1車	1458	1459	臺北市文山區萬壽路69號(週二、週六收運)	121.58934	24.98302
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1530	1532	臺北市文山區指南路3段38巷33號（紅瓦屋）	121.5907	24.96705
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1533	1534	臺北市文山區指南路3段38巷33之6號（雙橡園）	121.59103	24.96713
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1535	1536	臺北市文山區指南路3段38巷37之1號（大茶壺）	121.59177	24.96869
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1537	1538	臺北市文山區指南路3段38巷37之2號（天恩宮）	121.59216	24.97041
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1539	1540	臺北市文山區指南路3段40巷8之2號（茶藝推廣中心）	121.5944	24.9691
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1541	1542	臺北市文山區指南路3段40巷18之1號（金盆茶園公車迴轉處）	121.5958	24.9677
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1543	1547	臺北市文山區指南路3段40巷20之3號（煎茶院）	121.59629	24.96721
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1548	1551	臺北市文山區指南路3段40巷20之3號（八月桂花香）	121.59629	24.96721
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1553	1554	臺北市文山區指南路3段40巷32之1號（茗華園）	121.6017	24.9705
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1555	1557	臺北市文山區指南路3段187號（第十鄰長）	121.6068	24.9705
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1558	1559	臺北市文山區指南路3段167巷8號〈因緣〉	121.6002	24.9733
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1600	1601	臺北市文山區指南路3段157巷（峰園茶行）	121.59226	24.97677
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1602	1604	臺北市文山區指南路3段150號（指南宮後山停車場）	121.58322	24.9777
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1605	1606	臺北市文山區指南路3段42號（明園茶園）	121.58006	24.98302
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1607	1608	臺北市文山區指南路3段38巷11之2號（有緣茶藝）	121.58602	24.97526
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1609	1610	臺北市文山區指南路3段115之7號	121.58248	24.9789
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1611	1612	臺北市文山區指南路3段58之72號（水綱琴）	121.57999	24.98331
文山區	萬興里	木柵分隊	111-G22	KEP-3617	木柵-1	第2車	1617	1620	臺北市文山區秀明路2段115巷(翡翠城堡)	121.5764	24.9917
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1805	1807	臺北市文山區指南路3段34巷5之2號〈指南國小〉	121.58363	24.97644
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1808	1809	臺北市文山區指南路3段34巷9之3號	121.58224	24.97674
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1810	1811	臺北市文山區指南路3段34巷11號	121.58028	24.9788
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1812	1813	臺北市文山區指南路3段34巷12號〈世外桃源〉	121.58006	24.97456
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1814	1815	臺北市文山區指南路3段34巷13至19號〈滿庭香〉	121.58126	24.97314
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1816	1817	臺北市文山區指南路3段34巷21至37號〈松清園〉	121.5824	24.971
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1818	1819	臺北市文山區指南路3段34巷29至33號〈第八鄰長〉	121.58154	24.96956
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1820	1821	臺北市文山區老泉街45巷29號〈樟山寺〉	121.5796	24.97302
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1822	1823	臺北市文山區指南路3段34巷36至33之5號〈順天宮〉	121.58045	24.96929
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1824	1825	臺北市文山區指南路3段34巷65號〈瓦厝〉	121.5798	24.968
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1826	1827	臺北市文山區指南路3段34巷47之1號〈原味〉	121.58067	24.96895
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1828	1829	臺北市文山區指南路3段34巷53之2號〈迺妙〉	121.58301	24.96575
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1830	1831	臺北市文山區指南路3段38巷30號〈春茶香〉	121.58641	24.96643
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1832	1833	臺北市文山區指南路3段38巷22至26號〈大觀園〉	121.58687	24.96708
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1834	1835	臺北市文山區指南路3段38巷16之4號〈三玄宮〉	121.58791	24.96823
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1836	1837	臺北市文山區指南路3段38巷16之2號〈緣續緣〉	121.58759	24.96897
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1838	1839	臺北市文山區指南路3段38巷19之1號〈美加〉	121.58778	24.97112
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1840	1841	臺北市文山區指南路3段38巷14號〈三姊妹〉	121.58672	24.97005
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1842	1843	臺北市文山區指南路3段38巷14之3號〈談天園〉	121.58515	24.96859
文山區	指南里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1844	1845	臺北市文山區指南路3段34巷24號	121.58313	24.97028
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1855	1856	臺北市文山區老泉街45巷27號〈明德宮〉	121.57668	24.96842
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1857	1858	臺北市文山區老泉街45巷27之2號、30號	121.57678	24.96903
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1859	1900	臺北市文山區老泉街45巷20之1號、21之1號、23號、25之1號	121.57372	24.97355
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1901	1902	臺北市文山區老泉街45巷5之3號、4號	121.56956	24.97215
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1903	1904	臺北市文山區老泉街45巷6號、9號、10之1號	121.57119	24.97426
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1905	1906	臺北市文山區老泉街45巷8之3號	121.57109	24.9754
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1907	1908	臺北市文山區老泉街45巷1之1號〈混元宮〉	121.56908	24.97767
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1910	1912	臺北市文山區老泉街41號、42號	121.56263	24.97836
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1913	1914	臺北市文山區老泉街13號、15號、16之1號、23之3號	121.55928	24.97643
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1915	1916	臺北市文山區老泉街6號、22之1號	121.55677	24.97601
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1917	1919	臺北市文山區老泉街24之1號、24之5號〈里長〉	121.56055	24.97491
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1920	1921	臺北市文山區老泉街26巷2號	121.56211	24.97399
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1922	1923	臺北市文山區老泉街26巷4號、8號	121.56471	24.97196
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1924	1926	臺北市文山區老泉街26巷7號	121.56618	24.96956
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1927	1928	臺北市文山區老泉街26巷14號	121.56677	24.96896
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1929	1931	臺北市文山區老泉街9號、9之1號、11號	121.55686	24.97606
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1932	1933	臺北市文山區老泉街15之3號	121.55928	24.97643
文山區	老泉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1934	1935	臺北市文山區老泉街15之9號	121.55928	24.97643
文山區	博嘉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1947	1952	臺北市文山區木柵路4段159巷2號	121.57549	25.00048
文山區	博嘉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1953	1955	臺北市文山區木柵路4段159巷168號	121.57791	25.0034
文山區	博嘉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1956	1958	臺北市文山區木柵路4段159巷170弄1號	121.57789	25.00364
文山區	博嘉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	1959	2000	臺北市文山區木柵路4段159巷170弄4號	121.57772	25.00378
文山區	博嘉里	木柵分隊	111-G22	KEP-3617	木柵-1	第3車	2014	2015	臺北市文山區木柵路5段38號	121.55124	24.98675
北投區	榮光里	石牌分隊	112-G03	KES-7395	石牌-2	第1車	1815	1827	臺北市北投區西安街1段與自強街141號	121.5171	25.11158
北投區	石牌里	石牌分隊	112-G03	KES-7395	石牌-2	第1車	1828	1831	臺北市北投區西安街1段與建民路交叉口	121.5182	25.11
北投區	裕民里	石牌分隊	112-G03	KES-7395	石牌-2	第1車	1832	1842	臺北市北投區懷德街與明德路交叉口	121.52015	25.11021
北投區	裕民里	石牌分隊	112-G03	KES-7395	石牌-2	第1車	1843	1848	臺北市北投區懷德街14巷口旁	121.5194	25.11161
北投區	振華里	石牌分隊	112-G03	KES-7395	石牌-2	第1車	1849	1854	臺北市北投區懷德街56巷旁	121.51962	25.11291
北投區	振華里	石牌分隊	112-G03	KES-7395	石牌-2	第1車	1855	1900	臺北市北投區懷德街與榮華三路口旁	121.51986	25.11425
北投區	建民里	石牌分隊	112-G03	KES-7395	石牌-2	第2車	2000	2005	臺北市北投區明德路20號前	121.51756	25.10699
北投區	建民里	石牌分隊	112-G03	KES-7395	石牌-2	第2車	2006	2009	臺北市北投區文林北路94巷99號旁	121.51985	25.10783
北投區	榮華里	石牌分隊	112-G03	KES-7395	石牌-2	第2車	2010	2012	臺北市北投區東華街1段46號	121.52007	25.10856
北投區	振華里	石牌分隊	112-G03	KES-7395	石牌-2	第2車	2016	2021	臺北市北投區明德路305號	121.52091	25.11537
北投區	榮華里	石牌分隊	112-G03	KES-7395	石牌-2	第2車	2022	2028	臺北市北投區明德路265號	121.5222	25.11438
北投區	振華里	石牌分隊	112-G03	KES-7395	石牌-2	第2車	2029	2033	臺北市北投區明德路213號	121.52154	25.11252
北投區	振華里	石牌分隊	112-G03	KES-7395	石牌-2	第2車	2034	2038	臺北市北投區明德路201號	121.52112	25.11173
北投區	裕民里	石牌分隊	112-G03	KES-7395	石牌-2	第2車	2039	2043	臺北市北投區明德路151號前	121.52077	25.11074
北投區	裕民里	石牌分隊	112-G03	KES-7395	石牌-2	第2車	2044	2047	臺北市北投區明德路119號前	121.5201	25.10996
北投區	石牌里	石牌分隊	112-G03	KES-7395	石牌-2	第2車	2055	2100	臺北市北投區西安街1段179巷口	121.51832	25.11005
北投區	石牌里	石牌分隊	112-G03	KES-7395	石牌-2	第2車	2101	2104	臺北市北投區西安街1段165巷口	121.51863	25.10962
北投區	振華里	石牌分隊	112-G03	KES-7395	石牌-2	第3車	2147	2149	臺北市北投區石牌路2段90巷天主教門口	121.51752	25.11715
北投區	振華里	石牌分隊	112-G03	KES-7395	石牌-2	第3車	2150	2152	臺北市北投區石牌路2段90巷34號旁	121.51866	25.11701
北投區	振華里	石牌分隊	112-G03	KES-7395	石牌-2	第3車	2153	2155	臺北市北投區明德路337號巷口	121.52028	25.11682
北投區	榮華里	石牌分隊	112-G03	KES-7395	石牌-2	第3車	2156	2158	臺北市北投區振興街21號	121.5222	25.11821
北投區	永欣里	石牌分隊	112-G03	KES-7395	石牌-2	第3車	2200	2205	臺北市北投區天母西路117巷口	121.52318	25.11896
北投區	永欣里	石牌分隊	112-G03	KES-7395	石牌-2	第3車	2207	2220	臺北市北投區石牌路2段324巷口	121.52385	25.12203
北投區	永欣里	石牌分隊	112-G03	KES-7395	石牌-2	第3車	2221	2225	臺北市北投區石牌路2段348巷口	121.52489	25.12308
北投區	永明里	石牌分隊	112-G03	KES-7395	石牌-2	第3車	2230	2232	臺北市北投區石牌路2段31號	121.51553	25.116
南港區	南港里	南港分隊	112-G09	447-BN	南港-4	第1車	1650	1700	臺北市南港區興華路12巷17號(週一、二、四、五收運)	121.60653	25.05488
南港區	重陽里	南港分隊	112-G09	447-BN	南港-4	第1車	1753	1756	臺北市南港區向陽路258巷100號	121.59685	25.0585
南港區	東新里	南港分隊	112-G09	447-BN	南港-4	第1車	1800	1808	臺北市南港區向陽路120巷1號	121.59534	25.0546
南港區	東新里	南港分隊	112-G09	447-BN	南港-4	第1車	1812	1817	臺北市南港區東明街1巷23號	121.6043	25.05665
南港區	東新里	南港分隊	112-G09	447-BN	南港-4	第1車	1818	1822	臺北市南港區興華路114巷18號	121.60477	25.05664
南港區	重陽里	南港分隊	112-G09	447-BN	南港-4	第1車	1905	1915	臺北市南港區重陽路187巷1號	121.59902	25.05669
南港區	玉成里	南港分隊	112-G09	447-BN	南港-4	第1車	1922	1929	臺北市南港區東新街8號	121.58308	25.05053
南港區	玉成里	南港分隊	112-G09	447-BN	南港-4	第1車	1930	1936	臺北市南港區東新街、市民大道口	121.58376	25.0497
南港區	東新里	南港分隊	112-G09	447-BN	南港-4	第1車	1944	1949	臺北市南港區重陽路20號	121.59604	25.05532
南港區	三重里	南港分隊	112-G09	447-BN	南港-4	第2車	2037	2041	臺北市南港區南港路1段16號	121.6194	25.05484
南港區	三重里	南港分隊	112-G09	447-BN	南港-4	第2車	2042	2046	臺北市南港區南港路1段30巷24號	121.61926	25.05538
南港區	三重里	南港分隊	112-G09	447-BN	南港-4	第2車	2049	2053	臺北市南港區經園街66號	121.6165	25.06233
南港區	三重里	南港分隊	112-G09	447-BN	南港-4	第2車	2057	2102	臺北市南港區三重路79巷8弄16號	121.61425	25.05588
南港區	三重里	南港分隊	112-G09	447-BN	南港-4	第2車	2103	2108	臺北市南港區三重路39號	121.61421	25.05957
南港區	南港里	南港分隊	112-G09	447-BN	南港-4	第2車	2115	2125	臺北市南港區東南街28號	121.61225	25.05467
南港區	重陽里	南港分隊	112-G09	447-BN	南港-4	第2車	2133	2140	臺北市南港區重陽路187巷1號	121.59901	25.05668
北投區	八仙里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1630	1633	臺北市北投區中央南路2段131號前	121.50015	25.12129
北投區	八仙里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1634	1636	臺北市北投區中央南路2段101號前	121.50045	25.12225
北投區	八仙里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1637	1638	臺北市北投區中央南路2段91巷口	121.49968	25.12905
北投區	八仙里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1639	1640	臺北市北投區中央南路2段63號前	121.50017	25.12299
北投區	八仙里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1641	1642	臺北市北投區中央南路2段39巷口	121.50025	25.12391
北投區	八仙里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1643	1645	臺北市北投區中央南路2段31號前	121.5004	25.12514
北投區	清江里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1646	1650	臺北市北投區崇仁路1段74號	121.50144	25.12634
北投區	清江里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1651	1655	臺北市北投區崇仁路1段34巷口	121.50095	25.1273
北投區	清江里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1656	1700	臺北市北投區中央南路1段佑民醫院前	121.50129	25.12819
北投區	清江里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1701	1706	臺北市北投區中央南路1段民權街口	121.5011	25.12912
北投區	清江里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1707	1710	臺北市北投區中央南路1段大興街口	121.50112	25.1307
北投區	清江里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1711	1715	臺北市北投區中央南路1段清江路口	121.50132	25.13179
北投區	中央里	光明分隊	112-G17	KEJ-0961	光明-3	第1車	1716	1720	臺北市北投區中央南路1段光明路口	121.50152	25.13324
北投區	秀山里	光明分隊	112-G17	KEJ-0961	光明-3	第2車	1800	1808	臺北市北投區中和街458巷33弄口	121.4961	25.14589
北投區	秀山里	光明分隊	112-G17	KEJ-0961	光明-3	第2車	1809	1813	臺北市北投區中和街474巷4弄	121.49535	25.14574
北投區	秀山里	光明分隊	112-G17	KEJ-0961	光明-3	第2車	1815	1818	臺北市北投區中和街502巷7弄	121.49366	25.14656
北投區	秀山里	光明分隊	112-G17	KEJ-0961	光明-3	第2車	1819	1822	臺北市北投區中和街502巷14弄	121.49521	25.14738
北投區	秀山里	光明分隊	112-G17	KEJ-0961	光明-3	第2車	1825	1828	臺北市北投區秀山路85巷口(由回收車收運)	121.4914	25.15069
北投區	秀山里	光明分隊	112-G17	KEJ-0961	光明-3	第2車	1829	1830	臺北市北投區秀山路129巷口	121.49387	25.14894
北投區	稻香里	光明分隊	112-G17	KEJ-0961	光明-3	第2車	1832	1837	臺北市北投區秀山路致遠新村	121.49312	25.14692
北投區	稻香里	光明分隊	112-G17	KEJ-0961	光明-3	第2車	1838	1841	臺北市北投區稻香路37巷口	121.48988	25.13958
北投區	稻香里	光明分隊	112-G17	KEJ-0961	光明-3	第2車	1842	1845	臺北市北投區稻香路29號前	121.48598	25.14313
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1930	1931	臺北市北投區珠海路進賢路口	121.50496	25.1408
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1932	1933	臺北市北投區珠海路113巷	121.50447	25.14209
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1934	1935	臺北市北投區珠海路長壽路口	121.50593	25.14205
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1936	1937	臺北市北投區珠海路翠嶺路口	121.5073	25.14234
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1938	1940	臺北市北投區翠宜路宜山路口	121.50463	25.14347
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1941	1942	臺北市北投區翠宜路奉賢路口	121.50534	25.14336
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1943	1944	臺北市北投區西園街翠雲街口	121.50593	25.14448
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1945	1946	臺北市北投區西園街翠華街口	121.50582	25.14548
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1947	1948	臺北市北投區復興三路100號旁	121.50513	25.14734
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1949	1951	臺北市北投區復興三路64號前	121.5035	25.14505
北投區	中和里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1952	1953	臺北市北投區復興四路93號前	121.50142	25.14351
北投區	中和里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1954	1955	臺北市北投區復興四路53號前	121.5012	25.14319
北投區	中和里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1956	1957	臺北市北投區復興四路47號前	121.50085	25.14287
北投區	中和里	光明分隊	112-G17	KEJ-0961	光明-3	第3車	1958	2000	臺北市北投區復興四路開明街口	121.50021	25.14222
北投區	林泉里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2040	2042	臺北市北投區幽雅路市議會招待所(由回收車收運)	121.51446	25.13761
北投區	林泉里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2043	2045	臺北市北投區幽雅路華南對面(由回收車收運)	121.51564	25.13755
北投區	溫泉里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2100	2101	臺北市北投區溫泉路32號前	121.5089	25.1362
北投區	溫泉里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2102	2104	臺北市北投區溫泉路58巷口	121.50531	25.13365
北投區	溫泉里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2105	2107	臺北市北投區溫泉路68巷口	121.50575	25.13479
北投區	溫泉里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2108	2111	臺北市北投區溫泉路71號前	121.50489	25.13551
北投區	溫泉里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2112	2113	臺北市北投區溫泉路96號前	121.50879	25.13613
北投區	溫泉里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2114	2116	臺北市北投區溫泉路幽雅路口	121.51184	25.137
北投區	林泉里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2117	2119	臺北市北投區溫泉路147號前	121.51296	25.14042
北投區	林泉里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2121	2123	臺北市北投區溫泉路中心街口	121.51122	25.13839
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2127	2129	臺北市北投區長壽路翠嶺路口	121.50539	25.1423
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2131	2133	臺北市北投區長壽路27號前	121.50458	25.14252
北投區	開明里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2134	2140	臺北市北投區復興三路47號前	121.50303	25.14451
北投區	清江里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2155	2158	臺北市北投區中央南路1段大興街口	121.50114	25.1306
北投區	清江里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2159	2202	臺北市北投區中央南路1段民權街口	121.50113	25.12913
北投區	清江里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2203	2206	臺北市北投區中央南路1段佑民醫院前	121.50125	25.12842
北投區	清江里	光明分隊	112-G17	KEJ-0961	光明-3	第4車	2207	2210	臺北市北投區崇仁路1段34巷口	121.50095	25.1273
文山區	試院里	復興分隊	112-G15	KEJ-0957	復興-4	第1車	1748	1750	臺北市文山區木柵路1段59巷35號前	121.54747	24.98824
文山區	試院里	復興分隊	112-G15	KEJ-0957	復興-4	第1車	1751	1753	臺北市文山區木柵路1段59巷11弄1號旁	121.54633	24.98786
文山區	試院里	復興分隊	112-G15	KEJ-0957	復興-4	第1車	1754	1756	臺北市文山區和興路8號前	121.5462	24.98616
文山區	試院里	復興分隊	112-G15	KEJ-0957	復興-4	第1車	1757	1759	臺北市文山區和興路26巷1號旁	121.54631	24.98544
文山區	試院里	復興分隊	112-G15	KEJ-0957	復興-4	第1車	1800	1802	臺北市文山區和興路46號前	121.54733	24.98503
文山區	試院里	復興分隊	112-G15	KEJ-0957	復興-4	第1車	1803	1805	臺北市文山區和興路76巷1號旁	121.54813	24.985
文山區	試院里	復興分隊	112-G15	KEJ-0957	復興-4	第1車	1806	1808	臺北市文山區和興路90號	121.54926	24.98522
文山區	樟樹里	復興分隊	112-G15	KEJ-0957	復興-4	第1車	1816	1820	臺北市文山區興隆路4段74巷21弄2-10號	121.5607	24.98367
文山區	華興里	復興分隊	112-G15	KEJ-0957	復興-4	第2車	1920	1925	臺北市文山區辛亥路6段61號前	121.55248	24.98913
文山區	華興里	復興分隊	112-G15	KEJ-0957	復興-4	第2車	1928	1930	臺北市文山區辛亥路6段11號前	121.55207	24.99078
文山區	華興里	復興分隊	112-G15	KEJ-0957	復興-4	第2車	1935	1937	臺北市文山區辛亥路6段88號前	121.55235	24.98883
文山區	華興里	復興分隊	112-G15	KEJ-0957	復興-4	第2車	1938	1940	臺北市文山區木柵路1段191巷41號	121.55097	24.98891
文山區	華興里	復興分隊	112-G15	KEJ-0957	復興-4	第2車	1941	1943	臺北市文山區試院路4巷9號	121.55014	24.98868
文山區	華興里	復興分隊	112-G15	KEJ-0957	復興-4	第2車	1944	1947	臺北市文山區試院路6號前	121.54928	24.98913
文山區	華興里	復興分隊	112-G15	KEJ-0957	復興-4	第2車	1948	1950	臺北市文山區試院路62號前	121.54898	24.98975
文山區	華興里	復興分隊	112-G15	KEJ-0957	復興-4	第2車	1951	1952	臺北市文山區試院路86號	121.54826	24.98991
文山區	華興里	復興分隊	112-G15	KEJ-0957	復興-4	第2車	1953	1957	臺北市文山區試院路144巷1弄1號	121.54712	24.99042
文山區	華興里	復興分隊	112-G15	KEJ-0957	復興-4	第2車	1958	2001	臺北市文山區試院路146號前	121.54737	24.99005
文山區	華興里	復興分隊	112-G15	KEJ-0957	復興-4	第2車	2005	2008	臺北市文山區木柵路1段378巷12號前	121.55718	24.98808
文山區	明興里	復興分隊	112-G15	KEJ-0957	復興-4	第3車	2105	2115	臺北市文山區木柵路2段109巷25弄2號前	121.56295	24.99003
文山區	明興里	復興分隊	112-G15	KEJ-0957	復興-4	第3車	2125	2129	臺北市文山區木柵路2段109巷25弄58號前	121.56219	24.9915
文山區	明興里	復興分隊	112-G15	KEJ-0957	復興-4	第3車	2135	2139	臺北市文山區木柵路2段109巷100弄1號旁	121.56302	24.99145
文山區	明興里	復興分隊	112-G15	KEJ-0957	復興-4	第3車	2139	2143	臺北市文山區木柵路2段109巷25弄38號前	121.56236	24.99062
文山區	樟腳里	復興分隊	112-G15	KEJ-0957	復興-4	第3車	2150	2153	臺北市文山區恆光街30巷20號	121.5662	24.98194
文山區	樟腳里	復興分隊	112-G15	KEJ-0957	復興-4	第3車	2155	2157	臺北市文山區木新路3段45巷底(新大樓)	121.5641	24.9821
文山區	樟腳里	復興分隊	112-G15	KEJ-0957	復興-4	第3車	2158	2200	臺北市文山區木新路3段95巷30號	121.56305	24.9811
信義區	國業里	福德分隊	112-G18	KEJ-0962	福德-3	第1車	1700	1710	臺北市信義區松德路85號對面	121.57623	25.03808
信義區	國業里	福德分隊	112-G18	KEJ-0962	福德-3	第2車	1845	1855	臺北市信義區松德路61號前	121.57675	25.03863
信義區	松隆里	福德分隊	112-G18	KEJ-0962	福德-3	第2車	1900	1910	臺北市信義區松山路669號前	121.5812	25.033
信義區	松隆里	福德分隊	112-G18	KEJ-0962	福德-3	第2車	1915	1920	臺北市信義區松山路650巷15弄18之11號	121.57926	25.03141
信義區	松隆里	福德分隊	112-G18	KEJ-0962	福德-3	第2車	1922	1925	臺北市信義區松山路650巷15弄2號前	121.57893	25.03248
信義區	松隆里	福德分隊	112-G18	KEJ-0962	福德-3	第2車	1927	1930	臺北市信義區松山路650巷19~21弄1號旁	121.57878	25.03002
信義區	松隆里	福德分隊	112-G18	KEJ-0962	福德-3	第2車	1932	1935	臺北市信義區松山路656巷1號旁(福德社區發展協會)	121.57808	25.03166
信義區	松友里	福德分隊	112-G18	KEJ-0962	福德-3	第3車	2050	2053	臺北市信義區松德路307巷3號	121.57781	25.03933
信義區	松友里	福德分隊	112-G18	KEJ-0962	福德-3	第3車	2054	2100	臺北市信義區松德路269巷口	121.57554	25.03294
信義區	大道里	福德分隊	112-G18	KEJ-0962	福德-3	第3車	2105	2120	臺北市信義區大道路85號前	121.58269	25.04053
信義區	大道里	福德分隊	112-G18	KEJ-0962	福德-3	第3車	2120	2125	臺北市信義區忠孝東路5段790巷23弄1號	121.58252	25.04285
信義區	中行里	福德分隊	112-G18	KEJ-0962	福德-3	第3車	2130	2135	臺北市信義區福德街300巷27號前	121.58667	25.0404
文山區	明義里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1710	1715	臺北市文山區興隆路4段101巷62號前	121.55987	25.9878
文山區	明義里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1720	1724	臺北市文山區興隆路4段109巷94號對面(明道國小後門)	121.56362	24.98689
文山區	明義里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1725	1727	臺北市文山區興隆路4段105巷口	121.56205	24.98779
文山區	明義里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1728	1732	臺北市文山區興隆路4段46巷14號前	121.55918	24.98775
文山區	明義里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1732	1735	臺北市文山區木柵路2段2巷50號	121.55837	24.98791
文山區	華興里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1736	1740	臺北市文山區木柵路1段333號旁	121.55741	24.98878
文山區	華興里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1742	1747	臺北市文山區木柵路1段283號前	121.55373	24.98813
文山區	華興里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1749	1752	臺北市文山區木柵路1段233號前	121.55212	24.98789
文山區	華興里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1753	1757	臺北市文山區木柵路1段197號前	121.55141	24.98778
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1758	1801	臺北市文山區木柵路1段119號前	121.54844	24.98734
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1802	1805	臺北市文山區木柵路1段91號前	121.54739	24.98715
文山區	華興里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1808	1812	臺北市文山區木柵路1段140號	121.5516	24.98753
文山區	華興里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1814	1817	臺北市文山區木柵路1段184號	121.55263	24.9877
文山區	華興里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1818	1822	臺北市文山區木柵路1段240號前	121.55383	24.98785
文山區	華興里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1823	1826	臺北市文山區木柵路1段290-1號前	121.55533	24.9881
文山區	華興里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1827	1830	臺北市文山區木柵路1段294號旁	121.55673	24.98835
文山區	明義里	復興分隊	112-G14	KEJ-0956	復興-3	第1車	1831	1835	臺北市文山區木柵路2段84號前	121.5598	24.98868
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2004	2007	臺北市文山區興隆路4段58巷18號前	121.56054	24.9854
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2007	2010	臺北市文山區忠順街1段121巷7弄1號前	121.55983	24.98479
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2011	2013	臺北市文山區忠順街1段41巷3弄1號旁	121.55859	24.98433
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2014	2017	臺北市文山區光輝路132號前	121.55811	24.98532
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2017	2021	臺北市文山區光輝路104號	121.55677	24.98488
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2022	2027	臺北市文山區光輝路64號前	121.55548	24.98459
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2028	2030	臺北市文山區光輝路50巷3弄22號前	121.55509	24.98449
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2030	2032	臺北市文山區辛亥路7段58號前	121.55444	24.9843
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2033	2037	臺北市文山區光輝路47巷2號旁	121.55558	24.98521
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2038	2040	臺北市文山區光輝路71巷7號前	121.55634	24.98575
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2041	2043	臺北市文山區下崙路25~2號前	121.55885	24.98634
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2044	2046	臺北市文山區下崙路10號前	121.55989	24.98654
文山區	明義里	復興分隊	112-G14	KEJ-0956	復興-3	第2車	2050	2052	臺北市文山區木柵路2段2巷50號	121.55837	24.98791
文山區	樟林里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2135	2138	臺北市文山區光輝路32號旁	121.5549	24.98615
文山區	華興里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2139	2141	臺北市文山區辛亥路7段19號前	121.55318	24.98677
文山區	華興里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2142	2146	臺北市文山區辛亥路7段4號旁	121.55259	24.98736
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2149	2151	臺北市文山區試院路5巷1號前	121.54804	24.98882
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2154	2156	臺北市文山區木柵路1段74號旁(國家考場邊）	121.54999	24.9874
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2156	2158	臺北市文山區和興路100號	121.54971	24.98523
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2158	2200	臺北市文山區和興路84巷18號前	121.5498	24.98493
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2201	2203	臺北市文山區和興路52巷15號	121.54766	24.98425
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2203	2205	臺北市文山區和興路44巷16號前	121.54741	24.984
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2205	2210	臺北市文山區和興路44巷46號前	121.54563	24.98416
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2210	2213	臺北市文山區和興路26巷12弄1號旁	121.5457	24.98543
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2215	2217	臺北市文山區木柵路1段51號前	121.54527	24.98723
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2217	2220	臺北市文山區木柵路1段5號前	121.54268	24.9886
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2224	2227	臺北市文山區木柵路1段34號前	121.54655	24.98672
文山區	試院里	復興分隊	112-G14	KEJ-0956	復興-3	第3車	2230	2232	臺北市文山區木柵路1段56號前	121.54724	24.9868
文山區	興泰里	興隆分隊	111-G23	KEP-3621	興隆-4	第1車	1800	1803	臺北市文山區興隆路2段301巷6~2號前	121.55349	25.00165
文山區	興旺里	興隆分隊	111-G23	KEP-3621	興隆-4	第1車	1806	1809	臺北市文山區福興路4巷6弄28號	121.55239	25.00419
文山區	興旺里	興隆分隊	111-G23	KEP-3621	興隆-4	第1車	1809	1813	臺北市文山區福興路4巷15弄2號前	121.55157	25.00398
文山區	興旺里	興隆分隊	111-G23	KEP-3621	興隆-4	第1車	1814	1818	臺北市文山區福興路78巷1弄2號前	121.55097	25.00512
文山區	興旺里	興隆分隊	111-G23	KEP-3621	興隆-4	第1車	1819	1822	臺北市文山區福興路108-8號前	121.54974	25.00476
文山區	興旺里	興隆分隊	111-G23	KEP-3621	興隆-4	第1車	1823	1824	臺北市文山區福興路95巷21號	121.54664	25.00542
文山區	興旺里	興隆分隊	111-G23	KEP-3621	興隆-4	第1車	1824	1828	臺北市文山區福興路95巷47號	121.54693	25.00584
文山區	興旺里	興隆分隊	111-G23	KEP-3621	興隆-4	第1車	1828	1830	臺北市文山區福興路95巷14號前	121.54779	25.00553
文山區	興豐里	興隆分隊	111-G23	KEP-3621	興隆-4	第1車	1832	1840	臺北市文山區景豐街48巷1號旁	121.54613	25.00018
文山區	興得里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	1946	1948	臺北市文山區興隆路3段263號前	121.55887	24.99215
文山區	興家里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	1950	1952	臺北市文山區興隆路3段227號前	121.55929	24.99352
文山區	興家里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	1955	1958	臺北市文山區興隆路3段207巷17弄1號旁	121.56253	24.99485
文山區	興家里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	1958	2000	臺北市文山區興隆路3段207巷15弄1號旁	121.56212	24.9949
文山區	興家里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	2000	2002	臺北市文山區興隆路3段207巷13弄1號旁	121.56182	24.99491
文山區	興家里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	2002	2004	臺北市文山區興隆路3段207巷9弄1號旁	121.56103	24.99495
文山區	興家里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	2004	2006	臺北市文山區興隆路3段207巷5弄1號旁	121.56026	24.99543
文山區	興得里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	2010	2013	臺北市文山區興隆路3段192巷8弄34號前	121.55757	24.99795
文山區	興得里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	2014	2016	臺北市文山區興隆路3段112巷13號旁	121.55697	24.99826
文山區	興得里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	2017	2020	臺北市文山區興隆路3段36巷17弄1號前	121.55522	24.99961
文山區	興安里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	2023	2025	臺北市文山區興隆路2段96巷96號前	121.55113	24.99772
文山區	興安里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	2025	2028	臺北市文山區興隆路2段96巷59號前	121.5509	24.99845
文山區	興安里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	2028	2030	臺北市文山區興隆路2段96巷24號旁	121.55072	24.99928
文山區	興業里	興隆分隊	111-G23	KEP-3621	興隆-4	第2車	2031	2033	臺北市文山區興隆路2段220巷53號旁	121.55213	24.99903
文山區	興豐里	興隆分隊	111-G23	KEP-3621	興隆-4	第3車	2130	2140	臺北市文山區興順街80巷2號前	121.54496	25.00112
文山區	興安里	興隆分隊	111-G23	KEP-3621	興隆-4	第3車	2140	2145	臺北市文山區景華街176巷19弄1號旁	121.54898	24.99714
文山區	興安里	興隆分隊	111-G23	KEP-3621	興隆-4	第3車	2150	2152	臺北市文山區仙岩路16巷75號前	121.55046	24.99581
文山區	興安里	興隆分隊	111-G23	KEP-3621	興隆-4	第3車	2152	2154	臺北市文山區仙岩路16巷55號前	121.55029	24.99707
文山區	興安里	興隆分隊	111-G23	KEP-3621	興隆-4	第3車	2154	2156	臺北市文山區仙岩路16巷43號前	121.55001	24.99758
文山區	興福里	興隆分隊	111-G23	KEP-3621	興隆-4	第3車	2157	2202	臺北市文山區景華街149號前	121.54471	24.99514
文山區	興福里	興隆分隊	111-G23	KEP-3621	興隆-4	第3車	2203	2208	臺北市文山區景華街121巷15弄1號前	121.54678	24.99636
文山區	興福里	興隆分隊	111-G23	KEP-3621	興隆-4	第3車	2209	2212	臺北市文山區景華街73號旁	121.54471	24.99514
文山區	萬祥里	景美分隊	112-G06 	KES-7386	景美-4	第1車	1700	1705	臺北市文山區景隆街12號	121.5403	24.9998
文山區	萬祥里	景美分隊	112-G06 	KES-7386	景美-4	第1車	1711	1716	臺北市文山區羅斯福路5段269巷11號旁	121.54003	25.00134
文山區	萬祥里	景美分隊	112-G06 	KES-7386	景美-4	第1車	1717	1721	臺北市文山區興隆路1段70巷5號旁	121.54005	25.00187
文山區	萬祥里	景美分隊	112-G06 	KES-7386	景美-4	第1車	1722	1725	臺北市文山區興隆路1段102巷15號前	121.54127	25.0023
文山區	萬祥里	景美分隊	112-G06 	KES-7386	景美-4	第1車	1726	1728	臺北市文山區景明街14巷4號旁	121.54139	25.00204
文山區	萬祥里	景美分隊	112-G06 	KES-7386	景美-4	第1車	1729	1734	臺北市文山區羅斯福路5段269巷30號前	121.54082	25.00147
文山區	萬有里	景美分隊	112-G06 	KES-7386	景美-4	第1車	1735	1739	臺北市文山區景明街11巷6弄14號對面	121.54147	25.00076
文山區	萬有里	景美分隊	112-G06 	KES-7386	景美-4	第1車	1740	1745	臺北市文山區興隆路1段184巷11號旁	121.54246	25.00055
文山區	興昌里	景美分隊	112-G06 	KES-7386	景美-4	第2車	1925	1930	臺北市文山區興德路66巷2號旁	121.55751	25.00355
文山區	興光里	景美分隊	112-G06 	KES-7386	景美-4	第2車	1931	1936	臺北市文山區興德路53巷2號旁	121.55648	25.00181
文山區	興光里	景美分隊	112-G06 	KES-7386	景美-4	第2車	1937	1940	臺北市文山區興德路19號旁	121.55572	25.00109
文山區	萬盛里	景美分隊	112-G06 	KES-7386	景美-4	第2車	1950	1953	臺北市文山區興隆路1段55巷11號前	121.54164	25.00362
文山區	萬盛里	景美分隊	112-G06 	KES-7386	景美-4	第2車	1954	1959	臺北市文山區興隆路1段55巷27弄39號前	121.54105	25.0044
文山區	萬盛里	景美分隊	112-G06 	KES-7386	景美-4	第2車	2000	2005	臺北市文山區羅斯福路5段97巷2號旁	121.53911	25.00554
文山區	萬盛里	景美分隊	112-G06 	KES-7386	景美-4	第3車	2120	2123	臺北市文山區興隆路1段55巷27弄13號前	121.5419	25.00451
文山區	萬盛里	景美分隊	112-G06 	KES-7386	景美-4	第3車	2124	2128	臺北市文山區萬盛街156巷22~1號前	121.54254	25.00465
文山區	萬盛里	景美分隊	112-G06 	KES-7386	景美-4	第3車	2129	2134	臺北市文山區萬盛街113號前	121.54233	25.00554
文山區	萬盛里	景美分隊	112-G06 	KES-7386	景美-4	第3車	2135	2138	臺北市文山區萬盛街59號前	121.5423	25.00564
文山區	萬盛里	景美分隊	112-G06 	KES-7386	景美-4	第3車	2139	2143	臺北市文山區萬盛街25號旁	121.54155	25.00556
文山區	萬盛里	景美分隊	112-G06 	KES-7386	景美-4	第3車	2146	2149	臺北市文山區萬盛街38號前	121.53924	25.0074
文山區	萬盛里	景美分隊	112-G06 	KES-7386	景美-4	第3車	2150	2154	臺北市文山區萬盛街62號前	121.53998	25.00672
文山區	萬盛里	景美分隊	112-G06 	KES-7386	景美-4	第3車	2155	2200	臺北市文山區萬盛街80號前	121.54052	25.00617
文山區	萬盛里	景美分隊	112-G06 	KES-7386	景美-4	第3車	2202	2205	臺北市文山區興隆路1段83巷8號旁	121.54171	25.00351
文山區	萬有里	景美分隊	112-G06 	KES-7386	景美-4	第3車	2206	2209	臺北市文山區景明街11巷6弄14號對面	121.54147	25.00091
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1740	1743	臺北市文山區興隆路3段185巷15弄1號旁	121.56306	24.99547
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1744	1746	臺北市文山區興隆路3段185巷13弄1號旁	121.56268	24.99547
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1747	1749	臺北市文山區興隆路3段185巷9弄1號旁	121.56187	24.99554
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1750	1752	臺北市文山區興隆路3段185巷5弄1號旁	121.56108	24.99564
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1753	1755	臺北市文山區興隆路3段185巷1弄1號旁	121.56053	24.99583
文山區	興光里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1800	1804	臺北市文山區辛亥路4段223號	121.55542	25.00195
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1807	1811	臺北市文山區辛亥路4段101巷4號旁	121.55921	25.00682
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1812	1817	臺北市文山區辛亥路4段101巷131號前	121.56192	25.00623
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1818	1820	臺北市文山區辛亥路4段101巷93弄24號前	121.56147	25.0065
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1821	1823	臺北市文山區辛亥路4段101巷93弄13號前	121.56066	25.00677
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1823	1826	臺北市文山區辛亥路4段101巷93弄1號前	121.56023	25.00657
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1828	1830	臺北市文山區萬美街2段82號前	121.56191	25.00448
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1833	1834	臺北市文山區萬美街2段65號前	121.56358	25.00457
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第1車	1834	1835	臺北市文山區萬美街2段45號前	121.56443	25.00544
文山區	明興里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	1948	1950	臺北市文山區興隆路4段3號前	121.55901	24.99107
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	1954	1957	臺北市文山區興隆路3段255巷56號前	121.56013	24.99211
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	1957	1958	臺北市文山區興隆路3段255巷31號前	121.5604	24.99249
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	1958	2001	臺北市文山區興隆路3段255巷19號前	121.56031	24.99323
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	2001	2002	臺北市文山區興隆路3段255巷5號前	121.55968	24.99269
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	2004	2009	臺北市文山區興隆路3段221巷8弄2號前	121.56103	24.99402
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	2009	2013	臺北市文山區興隆路3段221巷4弄2號旁	121.56026	24.99412
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	2016	2021	臺北市文山區興隆路3段185巷15弄1號旁	121.56306	24.99547
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	2021	2023	臺北市文山區興隆路3段185巷11弄1號旁	121.56226	24.99551
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	2023	2026	臺北市文山區興隆路3段185巷7弄1號旁	121.56147	24.99559
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	2026	2029	臺北市文山區興隆路3段185巷3弄1號旁	121.5607	24.99568
文山區	興家里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	2029	2031	臺北市文山區興隆路3段185巷1弄1號旁	121.56053	24.99583
文山區	興光里	興隆分隊	111-G21	KEP-3602	興隆-3	第2車	2032	2035	臺北市文山區萬芳路63巷1號旁	121.56521	24.99834
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第3車	2135	2140	臺北市文山區萬美街2段21巷35號	121.55958	25.00361
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第3車	2145	2148	臺北市文山區辛亥路4段101巷93弄1號旁	121.56023	25.00657
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第3車	2149	2151	臺北市文山區辛亥路4段97號前	121.55871	25.00677
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第3車	2151	2156	臺北市文山區辛亥路4段77巷12號	121.55927	25.00735
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第3車	2156	2157	臺北市文山區辛亥路4段77巷29號	121.56068	25.00783
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第3車	2158	2200	臺北市文山區辛亥路4段77巷76號	121.5606	25.00837
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第3車	2200	2201	臺北市文山區辛亥路4段77巷96號	121.56041	25.00846
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第3車	2202	2203	臺北市文山區辛亥路4段21巷36號	121.55911	25.00958
文山區	興昌里	興隆分隊	111-G21	KEP-3602	興隆-3	第3車	2204	2205	臺北市文山區辛亥路4段21巷16號	121.55938	25.0091
內湖區	五分里	東湖分隊	94-S386	483-BH	東湖-3	第1車	1735	1745	臺北市內湖區康寧路3段245巷42號	121.6127	25.06669
內湖區	五分里	東湖分隊	94-S386	483-BH	東湖-3	第1車	1747	1750	臺北市內湖區安康路313號對面	121.61457	25.06654
內湖區	五分里	東湖分隊	94-S386	483-BH	東湖-3	第1車	1752	1757	臺北市內湖區安康路480號	121.61591	25.06785
內湖區	內溝里	東湖分隊	94-S386	483-BH	東湖-3	第1車	1803	1810	臺北市內湖區康樂街133號	121.6198	25.07392
內湖區	樂康里	東湖分隊	94-S386	483-BH	東湖-3	第1車	1813	1820	臺北市內湖區康樂街162巷19號	121.61874	25.07303
內湖區	蘆洲里	東湖分隊	94-S386	483-BH	東湖-3	第1車	1840	1910	臺北市內湖區安美街181號前200公尺	121.60283	25.06015
內湖區	五分里	東湖分隊	94-S386	483-BH	東湖-3	第2車	1940	1948	臺北市內湖區五分街35號對面	121.61339	25.06764
內湖區	樂康里	東湖分隊	94-S386	483-BH	東湖-3	第2車	1953	1957	臺北市內湖區康樂街61巷73弄34號	121.62109	25.07021
內湖區	樂康里	東湖分隊	94-S386	483-BH	東湖-3	第2車	2000	2005	臺北市內湖區康樂街111巷12號	121.61989	25.07071
內湖區	東湖里	東湖分隊	94-S386	483-BH	東湖-3	第2車	2007	2015	臺北市內湖區康樂街110巷16弄20號	121.61827	25.0704
內湖區	南湖里	東湖分隊	94-S386	483-BH	東湖-3	第3車	2130	2135	臺北市內湖區康寧路3段56巷35號	121.60942	25.07016
內湖區	南湖里	東湖分隊	94-S386	483-BH	東湖-3	第3車	2136	2143	臺北市內湖區康寧路3段70巷135號對面	121.60871	25.06713
內湖區	康寧里	東湖分隊	94-S386	483-BH	東湖-3	第3車	2147	2154	臺北市內湖區康寧路3段75巷177號	121.61177	25.07729
內湖區	安湖里	東湖分隊	94-S386	483-BH	東湖-3	第3車	2155	2159	臺北市內湖區東湖路113巷135號	121.61528	25.0739
內湖區	安湖里	東湖分隊	94-S386	483-BH	東湖-3	第3車	2200	2204	臺北市內湖區東湖路113巷113號	121.61523	25.07307
內湖區	安湖里	東湖分隊	94-S386	483-BH	東湖-3	第3車	2206	2212	臺北市內湖區東湖路113巷95弄17號對面	121.6151	25.0719
內湖區	東湖里	東湖分隊	94-S386	483-BH	東湖-3	第3車	2215	2220	臺北市內湖區東湖路119巷49弄30號對面	121.6165	25.06996
內湖區	蘆洲里	東湖分隊	94-S386	483-BH	東湖-3	第3車	2225	2235	臺北市內湖區安美街181號前200公尺	121.60283	25.06015
士林區	永倫里	社子分隊	94-S395	495-BH	社子-4	第1車	1619	1621	臺北市士林區延平北路6段387號後面	121.50096	25.09046
士林區	永倫里	社子分隊	94-S395	495-BH	社子-4	第1車	1622	1624	臺北市士林區延平北路6段511巷18號旁	121.49785	25.09188
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1625	1627	臺北市士林區延平北路7段42-7號(消防隊)旁	121.4953	25.09557
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1628	1630	臺北市士林區延平北路7段22號	121.49681	25.09514
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1631	1633	臺北市士林區延平北路7段48號旁	121.49615	25.0957
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1634	1637	臺北市士林區延平北路7段106巷30號	121.49497	25.09767
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1638	1645	臺北市士林區延平北路7段106巷50號	121.49514	25.09802
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1646	1649	臺北市士林區延平北路7段106巷120號	121.49562	25.09961
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1650	1700	臺北市士林區延平北路7段106巷154號	121.49376	25.10031
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1705	1708	臺北市士林區延平北路7段106巷327弄51號	121.49499	25.10613
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1709	1713	臺北市士林區延平北路7段106巷327弄70之1號	121.49477	25.10676
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1714	1716	臺北市士林區延平北路8段2巷200弄43號	121.49217	25.11047
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1717	1721	臺北市士林區延平北路8段2巷200弄7號	121.48962	25.10956
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1722	1725	臺北市士林區延平北路8段2巷192號	121.48941	25.10939
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1726	1730	臺北市士林區延平北路8段2巷150號	121.48634	25.11051
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1731	1734	臺北市士林區延平北路8段2巷153弄27號	121.48601	25.1105
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1735	1739	臺北市士林區延平北路8段2巷153弄49號	121.48483	25.11038
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1740	1742	臺北市士林區延平北路8段2巷153弄66號	121.48381	25.11036
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1745	1747	臺北市士林區延平北路8段2巷232號	121.48934	25.11065
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1748	1751	臺北市士林區延平北路8段2巷205號旁	121.49008	25.10984
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1755	1757	臺北市士林區延平北路7段106巷325之2號	121.4959	25.10443
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第1車	1758	1800	臺北市士林區延平北路7段106巷205號	121.49612	25.10167
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第2車	2015	2020	臺北市士林區延平北路7段27巷22號	121.49575	25.09512
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第2車	2021	2024	臺北市士林區延平北路7段101巷48弄7號	121.4947	25.09534
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第2車	2025	2028	臺北市士林區延平北路7段107巷28弄4號	121.49393	25.09618
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第2車	2029	2033	臺北市士林區延平北路7段177巷39號	121.49245	25.09768
士林區	福安里	社子分隊	94-S395	495-BH	社子-4	第2車	2034	2037	臺北市士林區延平北路7段179號	121.49189	25.09934
士林區	富洲里	社子分隊	94-S395	495-BH	社子-4	第2車	2050	2055	臺北市士林區延平北路8段2巷63弄1號	121.48668	25.10659
士林區	富洲里	社子分隊	94-S395	495-BH	社子-4	第2車	2056	2101	臺北市士林區延平北路8段2巷57弄1號	121.48679	25.10587
士林區	永倫里	社子分隊	94-S395	495-BH	社子-4	第2車	2105	2115	臺北市士林區延平北路6段479號	121.49897	25.09255
士林區	永倫里	社子分隊	94-S395	495-BH	社子-4	第2車	2118	2125	臺北市士林區延平北路6段258巷6號	121.50384	25.08952
士林區	永倫里	社子分隊	94-S395	495-BH	社子-4	第2車	2126	2131	臺北市士林區延平北路6段258巷34號	121.50379	25.09049
士林區	永倫里	社子分隊	94-S395	495-BH	社子-4	第2車	2132	2138	臺北市士林區延平北路6段258巷58號	121.50346	25.09104
士林區	永倫里	社子分隊	94-S395	495-BH	社子-4	第2車	2143	2150	臺北市士林區永平街90號對面	121.50509	25.09196
信義區	景勤里	六張犁分隊	95-022	468-BL	六張犁-3	第1車	1800	1820	臺北市信義區吳興街220巷59弄口	121.5613	25.0266
信義區	景勤里	六張犁分隊	95-022	468-BL	六張犁-3	第1車	1830	1850	臺北市信義區吳興街156巷6號前	121.56137	25.02901
信義區	景聯里	六張犁分隊	95-022	468-BL	六張犁-3	第1車	1855	1910	臺北市信義區吳興街156巷67號(含三興國小)	121.5589	25.02834
信義區	景勤里	六張犁分隊	95-022	468-BL	六張犁-3	第2車	2115	2130	臺北市信義區吳興街220巷59弄口	121.5613	25.0266
信義區	景勤里	六張犁分隊	95-022	468-BL	六張犁-3	第2車	2135	2150	臺北市信義區吳興街156巷6號前	121.56136	25.02901
信義區	景勤里	六張犁分隊	95-022	468-BL	六張犁-3	第2車	2155	2210	臺北市信義區吳興街156巷67號前	121.56068	25.0285
文山區	興豐里	福德坑停車場	96-039	527-BN	福德坑-1	第1車	1530	1700	臺北市文山區木柵路5段151號	121.59311	25.00704
文山區	興豐里	福德坑停車場	96-039	527-BN	福德坑-1	第2車	2000	2100	臺北市文山區木柵路5段151號	121.59311	25.00704
大同區	光能里	建成分隊	96-S400	302-TS	建成-3	第3車	2045	2049	臺北市大同區赤峰街19號	121.51934	25.05391
大同區	光能里	建成分隊	96-S400	302-TS	建成-3	第3車	2050	2053	臺北市大同區赤峰街39號之2	121.51966	25.05476
大同區	光能里	建成分隊	96-S400	302-TS	建成-3	第3車	2054	2056	臺北市大同區赤峰街49巷口	121.51966	25.05574
大同區	光能里	建成分隊	96-S400	302-TS	建成-3	第3車	2057	2100	臺北市大同區赤峰街53巷口	121.51969	25.05618
大同區	光能里	建成分隊	96-S400	302-TS	建成-3	第3車	2101	2103	臺北市大同區赤峰街71巷口	121.51972	25.05665
大同區	光能里	建成分隊	96-S400	302-TS	建成-3	第3車	2104	2107	臺北市大同區赤峰街77巷口	121.51974	25.05708
信義區	三犁里	吳興分隊	96-S405	442-BN	吳興-4	第1車	1830	1845	臺北市信義區信義路5段150巷14弄16號對面(中強公園高峰會旁)	121.56983	25.02838
信義區	三犁里	吳興分隊	96-S405	442-BN	吳興-4	第1車	1850	1930	臺北市信義區信義路5段150巷325弄2號左側(楓橋新村、大華營區)	121.56945	25.02679
信義區	泰和里	吳興分隊	96-S405	442-BN	吳興-4	第2車	2050	2110	臺北市信義區吳興街600巷100弄53號	121.57248	25.01733
信義區	泰和里	吳興分隊	96-S405	442-BN	吳興-4	第2車	2100	2115	臺北市信義區吳興街600巷76弄74號空地	121.57035	25.0198
信義區	泰和里	吳興分隊	96-S405	442-BN	吳興-4	第2車	2125	2150	臺北市信義區吳興街600巷86號(泰和公園)	121.57096	25.01877
信義區	黎順里	六張犁分隊	96-S406	443-BN	六張犁-4	第1車	1755	1805	臺北市信義區信安街103巷22之1號前	121.55975	25.02511
信義區	黎順里	六張犁分隊	96-S406	443-BN	六張犁-4	第1車	1810	1815	臺北市信義區信安街93號前	121.55698	25.02567
信義區	嘉興里	六張犁分隊	96-S406	443-BN	六張犁-4	第1車	1818	1825	臺北市信義區信安街52號前	121.55815	25.0269
信義區	黎順里	六張犁分隊	96-S406	443-BN	六張犁-4	第1車	1830	1840	臺北市信義區崇德街206巷口	121.55846	25.02302
信義區	黎安里	六張犁分隊	96-S406	443-BN	六張犁-4	第2車	1945	1948	臺北市信義區和平東路3段641號前	121.56352	25.01288
信義區	黎安里	六張犁分隊	96-S406	443-BN	六張犁-4	第2車	1949	1954	臺北市信義區和平東路3段631巷4-2號前	121.56678	25.0121
信義區	黎安里	六張犁分隊	96-S406	443-BN	六張犁-4	第2車	1955	2000	臺北市信義區和平東路3段627巷41弄口	121.56575	25.01285
信義區	黎安里	六張犁分隊	96-S406	443-BN	六張犁-4	第2車	2001	2004	臺北市信義區和平東路3段627巷5弄口	121.56495	25.01444
信義區	黎安里	六張犁分隊	96-S406	443-BN	六張犁-4	第2車	2006	2011	臺北市信義區和平東路3段599號	121.56238	25.01423
信義區	黎安里	六張犁分隊	96-S406	443-BN	六張犁-4	第2車	2012	2017	臺北市信義區和平東路3段575巷11號前	121.56233	25.01543
信義區	黎忠里	六張犁分隊	96-S406	443-BN	六張犁-4	第3車	2130	2140	臺北市信義區和平東路3段391巷56號前	121.55938	25.02096
信義區	黎忠里	六張犁分隊	96-S406	443-BN	六張犁-4	第3車	2142	2150	臺北市信義區和平東路3段435巷7弄27號前	121.55946	25.01949
信義區	黎安里	六張犁分隊	96-S406	443-BN	六張犁-4	第3車	2152	2200	臺北市信義區和平東路3段509巷口	121.56056	25.01727
內湖區	西康里	西湖分隊	96-S407	445-BN	西湖-5	第1車	1750	1800	臺北市內湖區內湖路1段59號	121.56002	25.08507
內湖區	西安里	西湖分隊	96-S407	445-BN	西湖-5	第1車	1830	1840	臺北市內湖區文湖街81巷12號	121.56409	25.08691
內湖區	西安里	西湖分隊	96-S407	445-BN	西湖-5	第1車	1845	1900	臺北市內湖區內湖路1段91巷25弄15號之1對面	121.56167	25.08696
內湖區	西湖里	西湖分隊	96-S407	445-BN	西湖-5	第2車	2010	2030	臺北市內湖區內湖路1段285巷69弄30號	121.5684	25.08486
內湖區	西湖里	西湖分隊	96-S407	445-BN	西湖-5	第2車	2035	2045	臺北市內湖區內湖路1段323巷21弄22號對面	121.56922	25.08443
內湖區	西安里	西湖分隊	96-S407	445-BN	西湖-5	第3車	2200	2220	臺北市內湖區內湖路1段91巷39弄35號旁	121.56161	25.08836
內湖區	西安里	西湖分隊	96-S407	445-BN	西湖-5	第3車	2225	2240	臺北市內湖區內湖路1段91巷35弄1號	121.56279	25.08739
士林區	後港里	後港分隊	96-S410	448-BN	後港-3	第1車	1630	1635	臺北市士林區承德路4段344號	121.5173	25.09015
士林區	後港里	後港分隊	96-S410	448-BN	後港-3	第1車	1636	1641	臺北市士林區承德路4段310號	121.51846	25.08966
士林區	後港里	後港分隊	96-S410	448-BN	後港-3	第1車	1642	1647	臺北市士林區承德路4段268號	121.51978	25.0894
士林區	前港里	後港分隊	96-S410	448-BN	後港-3	第1車	1648	1653	臺北市士林區承德路4段218號前	121.52174	25.08826
士林區	前港里	後港分隊	96-S410	448-BN	後港-3	第1車	1654	1659	臺北市士林區承德路4段188號前	121.52235	25.08711
士林區	福中里	後港分隊	96-S410	448-BN	後港-3	第2車	1815	1820	臺北市士林區通河東街1段168號	121.51577	25.08803
士林區	福中里	後港分隊	96-S410	448-BN	後港-3	第2車	1821	1826	臺北市士林區通河東街1段125號	121.51598	25.0867
士林區	福中里	後港分隊	96-S410	448-BN	後港-3	第2車	1827	1832	臺北市士林區通河東街1段106號	121.51615	25.08537
士林區	百齡里	後港分隊	96-S410	448-BN	後港-3	第2車	1833	1838	臺北市士林區通河東街1段91號	121.51632	25.08446
士林區	福華里	後港分隊	96-S410	448-BN	後港-3	第2車	1839	1844	臺北市士林區通河東街1段37號	121.51674	25.08321
士林區	福華里	後港分隊	96-S410	448-BN	後港-3	第2車	1845	1850	臺北市士林區通河東街1段17號	121.51707	25.0825
士林區	福華里	後港分隊	96-S410	448-BN	後港-3	第2車	1851	1856	臺北市士林區通河街325巷4號	121.51931	25.08233
士林區	福華里	後港分隊	96-S410	448-BN	後港-3	第2車	1857	1902	臺北市士林區通河街323巷3號	121.51946	25.08201
士林區	承德里	後港分隊	96-S410	448-BN	後港-3	第2車	1903	1915	臺北市士林區承德路4段80巷56號	121.52154	25.08314
士林區	前港里	後港分隊	96-S410	448-BN	後港-3	第3車	2025	2030	臺北市士林區前港街50號前	121.52033	25.08491
士林區	百齡里	後港分隊	96-S410	448-BN	後港-3	第3車	2031	2045	臺北市士林區福港街257號	121.51768	25.08389
士林區	福華里	後港分隊	96-S410	448-BN	後港-3	第3車	2046	2051	臺北市士林區和豐街31號	121.51831	25.08257
士林區	福華里	後港分隊	96-S410	448-BN	後港-3	第3車	2052	2100	臺北市士林區通河街179巷2號	121.51957	25.08184
士林區	後港里	後港分隊	96-S410	448-BN	後港-3	第3車	2106	2108	臺北市士林區通河東街2段26號	121.51425	25.09298
士林區	後港里	後港分隊	96-S410	448-BN	後港-3	第3車	2110	2115	臺北市士林區通河東街2段21號	121.51462	25.09251
士林區	後港里	後港分隊	96-S410	448-BN	後港-3	第3車	2116	2121	臺北市士林區通河東街2段15號前	121.51483	25.09198
士林區	後港里	後港分隊	96-S410	448-BN	後港-3	第3車	2122	2127	臺北市士林區通河東街2段11號	121.51509	25.09141
士林區	後港里	後港分隊	96-S410	448-BN	後港-3	第3車	2128	2135	臺北市士林區大南路391號	121.51561	25.08961
信義區	中行里	福德分隊	98-009	463-BP	福德-4	第1車	1730	1735	臺北市信義區福德街221巷189號之7(回收車收運)	121.58572	25.03065
信義區	大道里	福德分隊	98-009	463-BP	福德-4	第1車	1830	1900	臺北市信義區中坡南路58號(中坡南路協和工商側門)	121.58456	25.04192
信義區	中行里	福德分隊	98-009	463-BP	福德-4	第2車	2030	2045	臺北市信義區福德街268巷7弄1號前	121.58573	25.03968
信義區	中行里	福德分隊	98-009	463-BP	福德-4	第2車	2047	2050	臺北市信義區福德街251巷7弄1號前	121.58714	25.03825
信義區	松光里	福德分隊	98-009	463-BP	福德-4	第2車	2100	2130	臺北市信義區大道路28巷口對面（春光公園）	121.58141	25.04169
\.


--
-- Data for Name: patrol_criminal_case; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patrol_criminal_case ("破獲件數/總計[件]", "破獲率[%]", "犯罪人口率[人/十萬人]", "嫌疑犯[人]", "發生件數[件]", "破獲件數/他轄[件]", "破獲件數/積案[件]", _id, "破獲件數/當期[件]", "發生率[件/十萬人]", "實際員警人數[人]", "年月別", _ctime, _mtime, ogc_fid) FROM stdin;
2542	69.89	51.4	1336	3637	-	-	1	-	139.92	-	2022-01-01 00:00:00+00	2023-09-19 18:00:14.92278+00	2024-02-15 05:49:34.017761+00	30357
2847	76.99	64.25	1671	3698	-	-	2	-	142.2	-	2022-02-01 00:00:00+00	2023-09-19 18:00:14.933006+00	2024-02-15 05:49:34.017761+00	30358
3131	68.29	59.73	1555	4585	-	-	3	-	176.12	-	2022-03-01 00:00:00+00	2023-09-19 18:00:14.938244+00	2024-02-15 05:49:34.017761+00	30359
3148	73.07	59.79	1559	4308	-	-	4	-	165.23	-	2022-04-01 00:00:00+00	2023-09-19 18:00:14.943127+00	2024-02-15 05:49:34.017761+00	30360
3328	77.43	71.9	1877	4298	-	-	5	-	164.64	-	2022-05-01 00:00:00+00	2023-09-19 18:00:14.947897+00	2024-02-15 05:49:34.017761+00	30361
3379	78.51	69.65	1823	4304	-	-	6	-	164.45	-	2022-06-01 00:00:00+00	2023-09-19 18:00:14.952845+00	2024-02-15 05:49:34.017761+00	30362
3670	80.82	71.65	1881	4541	-	-	7	-	172.97	-	2022-07-01 00:00:00+00	2023-09-19 18:00:14.957895+00	2024-02-15 05:49:34.017761+00	30363
3537	75.69	73.81	1941	4673	-	-	8	-	177.7	-	2022-08-01 00:00:00+00	2023-09-19 18:00:14.962737+00	2024-02-15 05:49:34.017761+00	30364
3382	78.82	66.18	1742	4291	-	-	9	-	163.01	-	2022-09-01 00:00:00+00	2023-09-19 18:00:14.96857+00	2024-02-15 05:49:34.017761+00	30365
3014	74.57	64.11	1689	4042	-	-	10	-	153.43	-	2022-10-01 00:00:00+00	2023-09-19 18:00:14.973027+00	2024-02-15 05:49:34.017761+00	30366
3137	69.63	70.65	1863	4505	-	-	11	-	170.84	-	2022-11-01 00:00:00+00	2023-09-19 18:00:14.977989+00	2024-02-15 05:49:34.017761+00	30367
3205	65.73	64.53	1703	4876	-	-	12	-	184.75	-	2022-12-01 00:00:00+00	2023-09-19 18:00:14.982901+00	2024-02-15 05:49:34.017761+00	30368
4123	96.24	72.76	1921	4284	-	-	13	-	162.26	-	2023-01-01 00:00:00+00	2023-09-19 18:00:14.987317+00	2024-02-15 05:49:34.017761+00	30369
3030	94.25	72.3	1909	3215	-	-	14	-	121.77	-	2023-02-01 00:00:00+00	2023-09-19 18:00:14.99184+00	2024-02-15 05:49:34.017761+00	30370
2761	62.62	64.39	1700	4409	-	-	15	-	167	-	2023-03-01 00:00:00+00	2023-09-19 18:00:14.996997+00	2024-02-15 05:49:34.017761+00	30371
2745	69.95	60.11	1587	3924	-	-	16	-	148.62	-	2023-04-01 00:00:00+00	2023-09-19 18:00:15.002567+00	2024-02-15 05:49:34.017761+00	30372
2770	78.54	74.54	1968	3527	-	-	17	-	133.59	-	2023-05-01 00:00:00+00	2023-09-19 18:00:15.00915+00	2024-02-15 05:49:34.017761+00	30373
2793	75.79	77.15	2037	3685	-	-	18	-	139.57	-	2023-06-01 00:00:00+00	2023-09-19 18:00:15.01957+00	2024-02-15 05:49:34.017761+00	30374
3701	80.06	96.92	2559	4623	-	-	19	-	175.09	-	2023-07-01 00:00:00+00	2023-09-19 18:00:15.026468+00	2024-02-15 05:49:34.017761+00	30375
4109	90.63	95.54	2522	4534	-	-	20	-	171.76	-	2023-08-01 00:00:00+00	2023-09-19 18:00:15.059418+00	2024-02-15 05:49:34.017761+00	30376
\.


--
-- Data for Name: patrol_rain_floodgate; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.patrol_rain_floodgate (ogc_fid, station_no, station_name, rec_time, all_pumb_lights, pumb_num, door_num, river_basin, warning_level, start_pumping_level, lng, lat, _ctime, _mtime) FROM stdin;
3776892	62	康樂	2023-08-22 15:02:00+00	-	5	2	基隆河	4.8	5.0	121.617475	25.066575	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776893	51	南港	2023-08-22 14:03:00+00	-	5	3	基隆河	4.5	5.2	121.612422	25.062131	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776894	78	康寧	2023-08-22 15:01:00+00	-	7	4	基隆河	7.3	7.6	121.617475	25.064339	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776895	50	南湖	2023-08-22 15:01:00+00	-	3	1	基隆河	5.2	5.5	121.610806	25.063467	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776896	49	長壽	2023-08-22 15:01:00+00	-	4	1	基隆河	3.3	4.3	121.596286	25.060864	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776897	48	成功	2023-08-22 15:01:00+00	-	4	1	基隆河	2.8	3.6	121.596189	25.058636	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776898	42	成美	2023-09-20 12:55:00+00	-	3	1	基隆河	4.0	4.3	121.583492	25.055453	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776899	15	玉成	2023-08-22 14:02:00+00	-	11	5	基隆河	1.8	2.2	121.582547	25.052339	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776900	16	南京	2023-08-22 14:02:00+00	-	3	1	基隆河	3.4	3.7	121.572244	25.050686	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776901	17	松山	2023-08-22 15:00:00+00	-	3	1	基隆河	3.1	3.4	121.570169	25.054519	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776902	47	新民權	2023-08-22 14:02:00+00	-	10	2	基隆河	1.6	1.9	121.573431	25.058611	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776903	18	撫遠	2023-08-22 15:02:00+00	-	5	2	基隆河	1.9	2.2	121.568778	25.06225	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776904	46	陽光	2023-08-22 15:01:00+00	-	10	1	基隆河	2.5	2.8	121.573847	25.071375	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776905	45	港漧	2023-06-30 14:01:00+00	-	8	2	基隆河	3.22	3.3	121.572861	25.074403	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776906	44	環山	2023-08-22 15:01:00+00	-	6	2	基隆河	2.0	2.22	121.562683	25.076772	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776907	43	北安	2023-08-22 15:02:00+00	-	8	2	基隆河	2.01	2.31	121.555822	25.077814	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776908	19	濱江	2023-09-20 12:01:00+00	-	6	2	基隆河	0.6	0.9	121.549706	25.072508	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776909	20	大直	2023-09-20 12:01:00+00	-	12	6	基隆河	1.7	2.0	121.546972	25.077389	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776910	21	中山	2023-09-20 12:01:00+00	-	9	3	基隆河	1.6	1.8	121.534111	25.073978	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776911	22	建國	2023-09-20 12:01:00+00	-	9	4	基隆河	1.3	1.5	121.528911	25.072414	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776912	23	新生	2023-09-20 12:24:00+00	-	12	5	基隆河	2.7	3.0	121.528369	25.072197	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776913	76	新生二	2023-08-31 14:03:00+00	-	4	1	基隆河	2.7	3.0	121.528835	25.071711	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776914	24	圓山	2023-09-20 12:01:00+00	-	6	2	基隆河	1.0	1.2	121.527403	25.071344	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776915	26	劍潭	2023-09-20 12:02:00+00	-	5	3	基隆河	0.1	0.25	121.518283	25.081297	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776916	25	大龍	2023-09-20 12:55:00+00	-	4	3	基隆河	1.0	1.2	121.516164	25.078653	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776917	29	社子	2023-09-20 12:02:00+00	-	5	2	基隆河	0.7	1.0	121.508611	25.092756	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776918	27	士林	2023-08-29 10:40:00+00	-	10	5	基隆河	0.1	0.3	121.511178	25.096128	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776919	28	士林二	2023-09-20 12:01:00+00	-	2	6	基隆河	-0.2	0.01	121.511222	25.09611	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776920	70	社基下	2023-09-20 12:56:00+00	-	13	12	基隆河	2.0	2.1	121.495556	25.105611	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776921	71	社基上	2023-09-20 12:03:00+00	-	15	8	基隆河	2.0	2.1	121.495556	25.106611	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776922	67	洲美二	2023-09-20 12:04:00+00	-	2	2	基隆河	0.9	1.0	121.499392	25.107058	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776923	64	洲美一	2023-09-20 12:02:00+00	-	6	5	基隆河	0.1	0.3	121.498875	25.110122	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776924	72	大業二	2023-09-20 12:03:00+00	-	1	1	基隆河	1.0	1.1	121.495342	25.113561	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776925	77	大業東	2023-09-20 12:04:00+00	-	7	2	基隆河	0.9	1.5	121.500569	25.119675	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776926	73	下八仙	2023-09-20 12:03:00+00	-	5	2	基隆河	0.9	1.0	121.490594	25.116067	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776927	74	誠正	2023-08-22 15:01:00+00	-	7	3	大坑溪	6.2	6.7	121.620692	25.054306	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776928	81	木新	2023-08-22 15:00:00+00	-	2	1	景美溪	14.0	14.5	121.565647	24.981706	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776929	36	林森	2023-09-20 10:48:00+00	-	6	3	新生大排	1.5	1.8	121.531758	25.046064	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776930	82	文林	2023-09-20 09:49:00+00	-	3	0	磺港溪	0.7	1.0	121.517902	25.102625	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776931	53	新長安	2023-08-10 17:09:00+00	+	4	1	新生大排	1.1	1.3	121.527211	25.052667	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776932	83	文林二	2023-06-12 11:16:00+00	-	4	0	磺港溪	1.8	2.1	121.517733	25.102486	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776933	38	長春	2023-09-20 11:13:00+00	-	2	3	新生大排	2.0	2.3	121.527933	25.052792	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776934	39	民生	2023-09-20 12:00:00+00	-	5	2	新生大排	1.1	1.3	121.526906	25.058272	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776935	84	洲美	2023-09-20 12:00:00+00	-	5	3	基隆河	1.8	2.2	121.512083	25.099064	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776936	40	民權	2023-09-20 11:16:00+00	-	1	1	新生大排	1.4	1.7	121.527731	25.058828	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776937	41	錦州	2023-09-20 12:55:00+00	-	5	2	新生大排	1.2	1.5	121.527794	25.061417	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776938	07	景美	2023-08-22 14:04:00+00	-	5	2	新店溪	5.8	6.8	121.534983	25.009786	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776939	63	興隆	2023-08-20 15:00:00+00	-	9	2	\N	\N	\N	\N	\N	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776940	08	古亭	2023-08-22 14:03:00+00	-	4	1	新店溪	5.3	5.8	121.523597	25.019419	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776941	09	雙園	2023-08-22 14:03:00+00	-	10	2	新店溪	1.5	1.7	121.488786	25.030931	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776942	10	貴陽	2023-09-20 12:05:00+00	-	2	1	淡水河	2.0	2.3	121.498983	25.041836	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776943	11	忠孝	2023-08-04 05:00:00+00	-	9	5	淡水河	2.0	2.3	121.50635	25.049886	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776944	12	六館	2023-09-20 12:06:00+00	-	4	2	淡水河	1.4	1.5	121.508153	25.057253	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776945	13	迪化	2023-09-14 19:45:00+00	+	11	3	淡水河	0.5	0.75	121.507772	25.080181	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776946	68	社淡上	2023-09-20 12:05:00+00	-	4	12	淡水河	2.7	2.8	121.495556	25.109611	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776947	69	社淡下	2023-09-20 12:05:00+00	-	14	8	淡水河	0.5	0.7	121.495556	25.108611	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776948	14	中洲	2023-09-20 12:05:00+00	-	3	2	淡水河	0.5	0.7	121.473058	25.106197	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776949	01	萬芳	2023-09-20 12:55:00+00	-	4	1	景美溪	14.0	14.5	121.571597	24.995185	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776950	02	道南	2023-09-20 12:55:00+00	-	6	2	景美溪	13.85	14.2	121.573258	24.987883	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776951	54	老泉溪	2023-08-22 14:06:00+00	-	3	1	景美溪	13.5	14.0	121.559989	24.979156	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776952	55	無名溪	2023-08-10 14:16:00+00	-	3	1	景美溪	13.9	14.39	121.566242	24.980117	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776953	03	保儀	2023-09-20 12:55:00+00	-	2	1	景美溪	13.5	14.0	121.553811	24.9803	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776954	04	實踐	2023-08-22 15:00:00+00	-	3	3	景美溪	12.7	13.2	121.554275	24.983421	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776955	05	中港	2023-08-22 14:06:00+00	-	4	2	景美溪	11.8	12.3	121.553425	24.986499	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776956	06	埤腹	2023-08-22 15:00:00+00	-	3	3	景美溪	11.0	11.2	121.545419	24.986461	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776957	30	芝山	2023-09-20 11:44:00+00	-	5	2	雙溪	2.6	2.8	121.528161	25.101106	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776958	31	福德	2023-09-20 12:20:00+00	-	5	3	雙溪	2.0	2.25	121.528881	25.099369	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776959	32	福林	2023-09-20 08:46:00+00	-	7	6	雙溪	2.6	2.8	121.52625	25.102572	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776960	33	文昌	2023-09-20 08:42:00+00	-	3	2	雙溪	1.6	1.8	121.519675	25.100156	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776961	34	東華	2023-09-20 12:00:00+00	-	4	2	磺溪	3.3	3.8	121.522267	25.109842	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776962	35	奇岩	2023-09-20 10:47:00+00	-	4	1	磺港溪	2.4	2.8	121.503361	25.124125	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776963	65	北憲	2023-09-20 12:47:00+00	-	4	2	磺港溪	1.7	1.8	121.500808	25.117897	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776964	66	福山	2023-08-22 15:00:00+00	-	2	1	大坑溪	7.9	8.6	121.617172	25.046372	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
3776965	61	經貿	2023-08-22 13:39:00+00	-	2	1	大坑溪	7.5	8.23	121.620889	25.056294	2023-09-20 05:00:14.300246+00	2023-09-20 05:00:14.300246+00
\.


--
-- Data for Name: socl_welfare_organization_plc; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.socl_welfare_organization_plc (main_type, sub_type, name, address, lon, lat, _ctime, _mtime, ogc_fid) FROM stdin;
銀髮族服務	長期照護型	臺北市政府社會局附設臺北市東明住宿長照機構(委託財團法人台北市私立愛愛院經營管理)	臺北市南港區東明里南港路二段60巷17號2樓	121.60446167	25.05466652	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11009
銀髮族服務	長期照護型	臺北市兆如老人安養護中心	臺北市文山區政大二街129號	121.58419037	24.98931503	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11010
銀髮族服務	長期照護型	臺北市政府社會局附設臺北市廣智住宿長照機構(委託財團法人天主教失智老人社會福利基金會經營管理)	臺北市信義區大仁里福德街１	121.58127594	25.0371933	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11011
銀髮族服務	長期照護型	臺北市至善老人安養護中心	臺北市士林區永福里1鄰仰德大道二段2巷50號	121.54301453	25.10202217	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11012
銀髮族服務	長期照護型	臺北市私立華安老人長期照護中心	臺北市大安區光復南路116巷1、3、5號5樓及3號6樓	121.55654907	25.04299355	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11013
銀髮族服務	長期照護型	財團法人臺北市私立恆安老人長期照顧中心(長期照護型)	臺北市萬華區水源路187號	121.51077271	25.02360153	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11014
銀髮族服務	養護型	臺北市私立晨欣老人長期照顧中心(養護型)	臺北市中山區中山北路二段96巷19號3樓	121.52197266	25.05989265	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11015
銀髮族服務	養護型	臺北市私立怡靜老人長期照顧中心(養護型)	臺北市北投區致遠二路96巷3弄1、3號1樓	121.51274872	25.11644936	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11016
銀髮族服務	養護型	臺北市私立中山老人長期照顧中心(養護型)	臺北市萬華區峨眉街124、124之1號1樓	121.50235748	25.04452133	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11017
銀髮族服務	養護型	臺北市私立群仁老人長期照顧中心(養護型)	臺北市中山區民族東路512巷14號3~5樓	121.54194641	25.06735992	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11018
銀髮族服務	養護型	臺北市私立福成老人長期照顧中心(養護型)	臺北市中山區松江路374、380、382號4樓	121.53273773	25.06795311	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11019
銀髮族服務	養護型	臺北市私立福喜老人長期照顧中心(養護型)	臺北市中山區松江路374、380、382號7樓	121.53273773	25.06795311	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11020
銀髮族服務	養護型	臺北市私立龍江老人長期照顧中心(養護型)	臺北市中山區長安東路一段63號4樓	121.52721405	25.04865265	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11021
銀髮族服務	養護型	臺北市私立大園老人長期照顧中心(養護型)	臺北市中正區新生南路一段124之3號1~4樓	121.53248596	25.03775406	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11022
銀髮族服務	養護型	臺北市私立仁泰老人長期照顧中心(養護型)	臺北市中正區連雲街3號1、3樓、3之4號及新生南路1段124之3號5樓	121.53230286	25.03763771	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11023
銀髮族服務	養護型	臺北市私立明德老人長期照顧中心(養護型)	臺北市中正區詔安街220巷2、4號1樓	121.50917053	25.02619934	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11024
銀髮族服務	養護型	臺北市私立博愛長期照顧中心(養護型)	臺北市中正區汀州路三段56號2樓	121.53092194	25.01579475	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11025
銀髮族服務	養護型	臺北市私立文德老人長期照顧中心(養護型)	臺北市內湖區陽光街70-2、70-3、72、72-1號1樓	121.57635498	25.07274628	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11026
銀髮族服務	養護型	臺北市私立祥家老人養護所	臺北市內湖區內湖路二段253巷1弄1、3號1-2樓	121.58998108	25.08249664	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11027
銀髮族服務	養護型	臺北市私立湖濱老人長期照顧中心(養護型)	臺北市內湖區內湖路二段179巷58、60號1樓	121.58660126	25.08285332	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11028
銀髮族服務	養護型	臺北市私立童音老人長期照顧中心(養護型)	臺北市內湖區民權東路六段280巷19弄1、3、5、7號1樓	121.60499573	25.0715847	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11029
銀髮族服務	養護型	臺北市私立瑞安老人長期照顧中心(養護型)	臺北市內湖區成功路三段88、90、92號2樓、76巷9號2樓	121.59078217	25.08038139	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11030
銀髮族服務	養護型	臺北市私立銀髮族老人養護所	臺北市內湖區成功路二段488號2~5樓、490號2~4樓	121.58968353	25.07325363	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11031
銀髮族服務	養護型	臺北市私立建民老人長期照顧中心(養護型)	臺北市北投區建民路22、24、26、26之1號1樓	121.52160645	25.1136837	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11032
銀髮族服務	養護型	臺北市私立倚青園老人長期照顧中心(養護型)	臺北市北投區義理街63巷4弄7、11之1~3號1樓	121.51560974	25.11821747	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11033
銀髮族服務	養護型	臺北市私立高德老人長期照顧中心(養護型)	臺北市北投區磺港路156號1~3樓	121.50298309	25.12865257	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11034
銀髮族服務	養護型	臺北市私立崇順老人養護所	臺北市北投區知行路52巷1號及54號1~2樓	121.46742249	25.11811638	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11035
銀髮族服務	養護型	臺北市私立尊暉老人長期照顧中心(養護型)	臺北市北投區石牌路二段343巷17號1~2樓	121.52346802	25.12265968	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11036
銀髮族服務	養護型	臺北市私立陽明山老人長期照顧中心(養護型)	臺北市北投區紗帽路116號	121.54716492	25.15086746	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11037
銀髮族服務	養護型	臺北市私立聖心老人養護所	臺北市北投區稻香路321號1樓	121.48655701	25.1429348	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11038
銀髮族服務	養護型	臺北市私立賢暉老人長期照顧中心(養護型)	臺北市北投區石牌路二段315巷34弄14、16號1樓	121.52238464	25.12383652	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11039
銀髮族服務	養護型	財團法人臺灣基督教道生院附設臺北市私立道生院老人長期照顧中心(養護型)	臺北市北投區中和街錫安巷112號1-2樓及地下1樓	121.50085449	25.14749146	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11040
銀髮族服務	養護型	臺北市私立豪門老人長期照顧中心(養護型)	臺北市北投區大業路452巷2號6~9樓	121.49714661	25.1315155	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11041
銀髮族服務	養護型	臺北市私立貴族老人長期照顧中心(養護型)	臺北市北投區大業路452巷2號2~5樓	121.49714661	25.1315155	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11042
銀髮族服務	養護型	臺北市私立奇里岸老人長期照顧中心(養護型)	臺北市北投區西安街二段245號1.2樓	121.50823975	25.12014771	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11043
銀髮族服務	養護型	臺北市私立安安老人長期照顧中心(養護型)	臺北市北投區公舘路194、196號1樓	121.50726318	25.1280632	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11044
銀髮族服務	養護型	臺北市私立軒儀老人長期照顧中心(養護型)	臺北市萬華區和平西路三段384號1樓	121.4912796	25.03534126	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11045
銀髮族服務	養護型	臺北市私立葉爸爸老人長期照顧中心(養護型)	臺北市萬華區西園路二段243之14號1~4樓	121.49354553	25.02655029	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11046
銀髮族服務	養護型	臺北市私立葉媽媽老人長期照顧中心(養護型)	臺北市萬華區西園路二段243之13號1~4樓	121.49354553	25.02655029	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11047
銀髮族服務	養護型	臺北市私立建順老人長期照顧中心(養護型)	臺北市大同區甘州街55號3樓	121.5128479	25.05978012	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11048
銀髮族服務	養護型	臺北市文山老人養護中心	臺北市文山區興隆路二段95巷8號3樓	121.54688263	24.9999733	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11049
銀髮族服務	養護型	臺北市私立安安老人長期照顧中心(養護型)	臺北市北投區公舘路194、196號1樓	121.50195313	25.12042046	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11050
銀髮族服務	養護型	臺北市私立上美老人長期照顧中心(養護型)	臺北市士林區重慶北路四段162號1-4樓	121.51216888	25.0841217	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11051
銀髮族服務	養護型	臺北市私立天玉老人長期照顧中心(長期照護型)	臺北市士林區天玉街38巷18弄18號1-6樓	121.53032684	25.12012482	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11052
銀髮族服務	養護型	臺北市私立永青老人長期照顧中心(養護型)	臺北市士林區中山北路六段427巷8號1~4樓	121.52654266	25.11425209	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11053
銀髮族服務	養護型	臺北市私立松園老人長期照顧中心(養護型)	臺北市士林區德行東路61巷1、2、3號1、2樓	121.52713776	25.10788536	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11054
銀髮族服務	養護型	臺北市私立柏安老人養護所	臺北市士林區中山北路六段290巷52、54號1樓	121.52733612	25.10889626	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11055
銀髮族服務	養護型	臺北市私立祇福老人養護所	臺北市士林區忠誠路二段10巷11、13號1~2樓	121.52907562	25.10870934	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11056
銀髮族服務	養護型	臺北市私立祐心老人長期照顧中心(養護型)	臺北市士林區至誠路一段305巷3弄14號1-2樓	121.53173828	25.1014595	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11057
銀髮族服務	養護型	臺北市私立荷園老人長期照顧中心(養護型)	臺北市士林區葫蘆街33號2~3樓	121.50971985	25.07997704	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11058
銀髮族服務	養護型	臺北市私立璞園老人長期照顧中心(養護型)	臺北市士林區葫蘆街33號4、5、6樓	121.50971985	25.07997704	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11059
銀髮族服務	養護型	臺北市私立仁家老人長期照顧中心(養護型)	臺北市大同區甘州街55號5~6樓	121.5128479	25.05978012	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11060
銀髮族服務	養護型	臺北市私立永安老人養護所	臺北市大同區重慶北路三段284號2~4樓、286號1~4樓	121.51359558	25.07314873	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11061
銀髮族服務	養護型	臺北市私立建興老人長期照顧中心(養護型)	臺北市大同區甘州街55號2樓	121.5128479	25.05978012	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11062
銀髮族服務	養護型	臺北市私立晉安老人長期照顧中心(養護型)	臺北市大同區重慶北路三段175、177號1~4樓	121.51359558	25.07275963	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11063
銀髮族服務	養護型	臺北市私立祥安尊榮老人長期照顧中心(養護型)	臺北市大同區延平北路三段4號2樓	121.51104736	25.06343269	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11064
銀髮族服務	養護型	臺北市私立祥寶尊榮老人長期照顧中心(養護型)	臺北市大同區太原路97巷4、6號	121.51672363	25.0520649	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11065
銀髮族服務	養護型	臺北市私立敦煌老人長期照顧中心(養護型)	臺北市大同區敦煌路80巷3號及3-1號1樓	121.51746368	25.07487679	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11066
銀髮族服務	養護型	臺北市私立德寶老人養護所	臺北市大同區長安西路78巷4弄11號1~4樓	121.51855469	25.05000877	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11067
銀髮族服務	養護型	臺北市私立慧光老人養護所	臺北市大同區寧夏路32號5樓	121.51516724	25.05598068	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11068
銀髮族服務	養護型	臺北市私立上上老人養護所	臺北市大安區復興南路一段279巷14、16號1樓	121.54529572	25.035532	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11069
銀髮族服務	養護型	臺北市私立天恩老人長期照顧中心(養護型)	臺北市大安區新生南路三段7-4號、9-4號、9-5號	121.53501129	25.0255127	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11070
銀髮族服務	養護型	臺北市私立健全老人長期照顧中心(養護型)	臺北市大安區金山南路二段152號2、3、4、5、6樓	121.52611542	25.02870369	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11071
銀髮族服務	養護型	臺北市私立康寧老人長期照顧中心(養護型)	臺北市大安區仁愛路四段300巷20弄15號2樓、17號2樓	121.55350494	25.03634071	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11072
銀髮族服務	養護型	臺北市私立新常安老人長期照顧中心(養護型)	臺北市大安區安居街46巷14號1~3樓及臺北市大安區和平東路3段228巷39號2樓	121.55361938	25.02067757	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11073
銀髮族服務	養護型	臺北市私立嘉恩老人長期照顧中心(養護型)	臺北市大安區安居街27號4、6樓及29號4、5樓	121.55461884	25.02058411	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11074
銀髮族服務	養護型	臺北市私立仁群老人長期照顧中心(養護型)	臺北市中山區民族東路512巷14號1~2樓、16號2樓	121.54194641	25.06735992	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11075
銀髮族服務	養護型	臺北市私立松青園老人養護所	臺北市中山區民生西路30號2樓、2樓之1~4	121.52163696	25.05763626	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11076
銀髮族服務	養護型	臺北市私立松湛園老人養護所	臺北市中山區錦州街4巷1號2樓、2樓之1	121.52354431	25.05995941	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11077
銀髮族服務	養護型	臺北市私立法泉老人長期照顧中心(養護型)	臺北市中山區八德路二段251號2樓	121.54103851	25.046978	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11078
銀髮族服務	養護型	臺北市私立三園老人長期照顧中心(養護型)	臺北市文山區車前路12號3-4樓	121.54091644	24.99147224	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11079
銀髮族服務	養護型	臺北市私立心慈老人養護所	臺北市文山區辛亥路五段120-1號1~4樓	121.55229187	24.99760628	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11080
銀髮族服務	養護型	臺北市私立吉祥老人長期照顧中心(養護型)	臺北市文山區木柵路三段85巷8弄4-1、4-2號1樓及2、2-1、2-2、4、4-1、4-2號2樓	121.56678009	24.98968887	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11081
銀髮族服務	養護型	臺北市私立美安老人長期照顧中心(養護型)	臺北市文山區溪口街1巷5號	121.54077148	24.99481392	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11082
銀髮族服務	養護型	臺北市私立景安老人長期照顧中心(養護型)	臺北市文山區景仁里溪口街1巷5號1~2樓	121.54077148	24.99481392	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11083
銀髮族服務	養護型	臺北市私立景興老人長期照顧中心(養護型)	臺北市文山區景興路222號3樓	121.54328156	24.99110413	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11084
銀髮族服務	養護型	臺北市私立慈安老人長期照顧中心(養護型)	臺北市文山區興隆路一段2、4號1~4樓	121.54180908	25.00139236	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11085
銀髮族服務	養護型	臺北市私立萬芳老人長期照顧中心(養護型)	臺北市文山區萬和街8號3樓	121.56772614	25.00200844	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11086
銀髮族服務	養護型	臺北市私立慧華老人長期照顧中心(養護型)	臺北市文山區興隆路二段154巷11號1樓	121.55169678	25.00085831	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11087
銀髮族服務	養護型	臺北市私立慧誠老人長期照顧中心(養護型)	臺北市文山區木柵路二段163、165號1~5樓	121.56045532	24.98859215	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11088
銀髮族服務	養護型	臺北市私立蓮馨老人長期照顧中心(養護型)	臺北市文山區萬和街6號8樓	121.56735992	25.00193787	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11089
銀髮族服務	養護型	臺北市私立精英國際老人長期照顧中心(養護型)	臺北市北投區關渡路60之1、62之1號1樓	121.46882629	25.11966324	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11090
銀髮族服務	養護型	臺北市私立北投老人長期照顧中心(養護型)	臺北市北投區公舘路231巷20號1樓	121.5092392	25.12672234	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11091
銀髮族服務	養護型	臺北市私立北投老人長期照顧中心(養護型)	臺北市北投區公舘路231巷20號1樓	121.50924683	25.12665367	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11092
銀髮族服務	養護型	臺北市私立全泰老人長期照顧中心(養護型)	臺北市北投區行義路105號1~2樓	121.52842712	25.12771606	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11093
銀髮族服務	養護型	臺北市私立同德老人長期照顧中心(養護型)	臺北市北投區明德路306號1-7樓	121.52225494	25.11522484	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11094
銀髮族服務	養護型	臺北市私立義行老人長期照顧中心(養護型)	臺北市北投區石牌路二段357巷1號4~6樓	121.52487183	25.12366486	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11095
銀髮族服務	養護型	臺北市私立榮祥老人長期照顧中心(養護型)	臺北市北投區文林北路166巷5弄2號1~2樓、4號1樓	121.51622772	25.10718346	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11096
銀髮族服務	養護型	臺北市私立全民老人長期照顧中心(養護型)	臺北市北投區石牌路二段317號1~2樓	121.52329254	25.12182045	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11097
銀髮族服務	養護型	臺北市私立行義老人長期照顧中心(養護型)	臺北市北投區石牌路二段357巷1號1~3樓	121.52487183	25.12366486	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11098
銀髮族服務	養護型	臺北市私立全家老人長期照顧中心(養護型)	臺北市北投區行義路96巷1號1~2樓	121.52892303	25.12663078	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11099
銀髮族服務	養護型	臺北市私立全寶老人長期照顧中心(養護型)	臺北市北投區石牌路二段315巷16弄2、2-1號1樓	121.52196503	25.12274551	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11100
銀髮族服務	養護型	臺北市私立榮健老人長期照顧中心(養護型)	臺北市北投區文林北路94巷5弄13號1~2樓、15號2樓	121.51776886	25.10647392	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11101
銀髮族服務	養護型	臺北市私立仁仁老人長期照顧中心(養護型)	臺北市松山區南京東路五段356號2樓	121.56969452	25.05106735	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11102
銀髮族服務	養護型	臺北市私立台大老人長期照顧中心(養護型)	臺北市松山區敦化南路一段7號4樓之1	121.54930115	25.04692078	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11103
銀髮族服務	養護型	臺北市私立康壯老人長期照顧中心(養護型)	臺北市松山區八德路四段203、205號1、2樓	121.559021	25.04846382	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11104
銀髮族服務	養護型	臺北市私立群英老人長期照顧中心(養護型)	臺北市松山區敦化南路一段7號4樓	121.54930115	25.04692078	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11105
銀髮族服務	養護型	臺北市私立倚青苑老人養護所	臺北市信義區中坡北路21號1~2樓、23號2樓	121.58084106	25.04490471	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11106
銀髮族服務	養護型	臺北市私立康庭老人養護所	臺北市信義區信義路六段15巷16號1樓	121.57540894	25.03523827	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11107
銀髮族服務	養護型	臺北市私立福安老人長期照顧中心(養護型)	臺北市南港區玉成街140巷21、23號2樓	121.58300018	25.04468727	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11108
銀髮族服務	養護型	財團法人臺北市私立愛愛院	臺北市萬華區糖?里大理街175巷27號	121.49556732	25.03454208	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11109
銀髮族服務	養護型	財團法人臺北市私立愛愛院	臺北市萬華區糖?里大理街175巷27號	121.49555969	25.03454781	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11110
銀髮族服務	失智照顧型	財團法人台北市中國基督教靈糧堂世界佈道會士林靈糧堂附設臺北私立天母社區式服務類長期照顧服務服務機構	臺北市士林區德行東路338巷12之1號	121.54025269	25.10856056	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11111
銀髮族服務	失智照顧型	委託經營管理臺北市北投奇岩樂活大樓(北投老人服務中心)	臺北市北投區奇岩里三合街一段119號	121.50392914	25.12655258	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11112
銀髮族服務	失智照顧型	財團法人天主教失智老人社會福利基金會附設臺北市私立聖若瑟失智老人養護中心	臺北市萬華區德昌街125巷11號1~4樓、13號1樓	121.49700928	25.0240097	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11113
銀髮族服務	安養機構	臺北市政府社會局老人自費安養中心	臺北市文山區忠順里興隆路四段109巷30弄6號	121.56217957	24.98660851	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11114
銀髮族服務	安養機構	臺北市立浩然敬老院	臺北市北投區知行路75號	121.46777344	25.11834908	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11115
銀髮族服務	老人公寓/住宅	臺北市陽明老人公寓	臺北市士林區格致路7號3-6樓	121.54611969	25.13634491	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11116
銀髮族服務	老人公寓/住宅	臺北市大龍老人住宅	臺北市大同區民族西路105號4-9樓	121.5171051	25.06881142	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11117
銀髮族服務	老人公寓/住宅	臺北市朱崙老人公寓	臺北市中山區龍江路15號4-7樓	121.54055023	25.04742241	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11118
銀髮族服務	老人公寓/住宅	臺北市中山老人住宅暨服務中心	臺北市中山區新生北路二段101巷2號1-6樓	121.52846527	25.05727005	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11119
銀髮族服務	團體家屋	財團法人私立廣恩老人養護中心附設臺北市私立陽明山社區長照機構	臺北市士林區陽明里15鄰仁民路15號	121.54348755	25.13361931	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11120
銀髮族服務	日間照顧中心	臺北榮民總醫院附設遊詣居社區長照機構	臺北市北投區石牌路二段322號1樓	121.52296448	25.12080193	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11121
銀髮族服務	日間照顧中心	臺北市大同老人服務暨日間照顧中心	臺北市大同區重慶里重慶北路三段347號3樓	121.51407623	25.07478523	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11122
銀髮族服務	日間照顧中心	渥康國際股份有限公司附設臺北市私立康禾社區長照機構	臺北市松山區中正里26鄰南京東路三段２８５號3樓	121.5458374	25.05200577	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11123
銀髮族服務	日間照顧中心	臺北市復華長青多元服務中心	臺北市中山區遼寧街185巷11號	121.54276276	25.05342674	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11124
銀髮族服務	日間照顧中心	臺北市中正區多元照顧中心(小規模多機能)	臺北市中正區羅斯福路二段5號2樓	121.52108765	25.02924538	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11125
銀髮族服務	日間照顧中心	臺北市西松老人日間照顧中心(小規模多機能服務)	臺北市松山區南京東路五段251巷46弄5號1-3樓	121.56482697	25.05335236	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11126
銀髮族服務	日間照顧中心	臺北市士林老人服務暨日間照顧中心	臺北市士林區忠誠路二段53巷7號5樓及6樓	121.53237915	25.11142349	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11127
銀髮族服務	日間照顧中心	臺北市政府社會局委託經營管理臺北市大安老人服務暨日間照顧中心(小規模多機能)	臺北市大安區四維路76巷12號1-5樓	121.54721832	25.02786064	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11128
銀髮族服務	日間照顧中心	臺北市中正老人服務暨日間照顧中心	臺北市中正區貴陽街一段60號	121.50904083	25.03892899	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11129
銀髮族服務	日間照顧中心	臺北市立聯合醫院陽明院區得憶齋失智失能日間照顧中心	臺北市士林區雨聲街105號	121.53156281	25.10519791	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11130
銀髮族服務	日間照顧中心	臺北市松山老人服務暨日間照顧中心	臺北市松山區健康路317號1樓	121.56661224	25.05447006	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11131
銀髮族服務	日間照顧中心	臺北市政府社會局「委託辦理臺北市大安區老人日間照顧服務」	臺北市大安區新生南路三段52-5號5樓	121.53395844	25.02114677	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11132
銀髮族服務	日間照顧中心	臺北市政府委託經營管理信義老人服務暨日間照顧中心(廣慈B標)	臺北市信義區福德街尚未有明確地址	121.58127594	25.0371933	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11133
銀髮族服務	日間照顧中心	臺北市政府委託經營管理臺北市瑞光社區長照機構	臺北市內湖區瑞光路尚未有明確地址	121.56655121	25.08001518	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11134
銀髮族服務	日間照顧中心	臺北市大同昌吉老人社區長照機構	臺北市大同區昌吉街52號9-10樓	121.51634216	25.06581688	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11135
銀髮族服務	日間照顧中心	臺北市私立新生社區長照機構	臺北市大安區新生南路三段52-5號5樓	121.53395844	25.02114677	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11136
銀髮族服務	日間照顧中心	臺北市立聯合醫院附設仁愛護理之家日間照護仁鶴軒	臺北市大安區仁愛路四段10號5樓	121.54530334	25.03754616	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11137
銀髮族服務	日間照顧中心	臺北市私立安歆松江社區長照機構	臺北市中山區松江路50號3樓A室	121.53273773	25.04824448	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11138
銀髮族服務	日間照顧中心	臺北市私立雲朵社區長照機構	臺北市中正區杭州南路一段63號4樓之1	121.52592468	25.04044151	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11139
銀髮族服務	日間照顧中心	臺北市西湖老人日間照顧中心	臺北市內湖區內湖路一段285號6樓	121.56659698	25.08241653	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11140
銀髮族服務	日間照顧中心	臺北市興隆老人日間照顧中心	臺北市文山區興隆路四段105巷47號B棟2樓	121.56312561	24.98828125	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11141
銀髮族服務	日間照顧中心	臺北市興隆老人日間照顧中心	臺北市文山區興隆路四段105巷47號B棟2樓	121.56312561	24.98828125	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11142
銀髮族服務	日間照顧中心	臺北市私立頤福社區長照機構	臺北市北投區裕民六路120號3樓	121.51763153	25.11454582	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11143
銀髮族服務	日間照顧中心	臺北市信義老人服務暨日間照顧中心	臺北市信義區興雅里松隆路36號4、5樓	121.56754303	25.04339409	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11144
銀髮族服務	日間照顧中心	臺北市南港老人服務暨日間照顧中心	臺北市南港區重陽路187巷5號2樓	121.59870148	25.05772591	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11145
銀髮族服務	日間照顧中心	臺北市萬華龍山老人服務暨日間照顧中心	臺北市萬華區梧州街36號2樓、2樓之2、3樓、3樓之1	121.49748993	25.03737068	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11146
銀髮族服務	小規模多機能	社團法人中華民國士林靈糧堂社會福利協會附設臺北市私立內湖社區長照機構	臺北市內湖區康樂街136巷15弄1、3、5號1樓	121.61862183	25.07226944	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11147
銀髮族服務	老人服務中心	臺北市政府社會局委託經營管理臺北市內湖老人服務中心	臺北市內湖區康樂街110巷16弄20號5、6樓	121.61838531	25.07037354	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11148
銀髮族服務	老人服務中心	臺北市政府社會局委託經營管理臺北市文山老人服務中心	臺北市文山區萬壽路27號6樓	121.57657623	24.98863983	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11149
銀髮族服務	老人服務中心	臺北市政府社會局委託經營管理臺北市萬華老人服務中心	臺北市萬華區西寧南路4號A棟3樓	121.50704193	25.04793739	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11150
銀髮族服務	老人服務中心	臺北市政府社會局委託辦理臺北市中正國宅銀髮族服務中心	臺北市萬華區青年路52號1樓之2	121.50349426	25.02539635	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11151
銀髮族服務	石頭湯社區整合照顧服務	內湖區社區整合照顧服務中心	臺北市內湖區明湖里康寧路三段99巷6弄12號1樓	121.61032867	25.07165337	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11152
銀髮族服務	石頭湯社區整合照顧服務	文山區社區整合照顧服務中心	臺北市文山區木新里保儀路115號	121.56761932	24.98573112	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11153
銀髮族服務	石頭湯社區整合照顧服務	北投區社區整合照顧服務中心	臺北市北投區關渡里知行路245巷14號1樓	121.46643066	25.12083626	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11154
銀髮族服務	石頭湯社區整合照顧服務	松山區社區整合照顧服務中心	臺北市松山區民福里復興北路451號1樓	121.54444122	25.06399155	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11155
銀髮族服務	石頭湯社區整合照顧服務	信義區社區整合照顧服務中心	臺北市信義區黎平里和平東路三段341巷10號	121.55724335	25.02124214	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11156
銀髮族服務	石頭湯社區整合照顧服務	南港區社區整合照顧服務中心	臺北市南港區萬福里同德路85巷6號1樓	121.58552551	25.04639244	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11157
銀髮族服務	石頭湯社區整合照顧服務	萬華區社區整合照顧服務中心	臺北市萬華區忠德里德昌街180號	121.49555206	25.02378845	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11158
銀髮族服務	石頭湯社區整合照顧服務	士林區社區整合照顧服務中心	臺北市士林區福志里幸福街5巷25號1樓	121.52803802	25.09728241	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11159
銀髮族服務	石頭湯社區整合照顧服務	大同區社區整合照顧服務中心	臺北市大同區揚雅里昌吉街61巷41號1樓	121.51489258	25.06703949	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11160
銀髮族服務	石頭湯社區整合照顧服務	大安區社區整合照顧服務中心	臺北市大安區法治里通化街192號1樓	121.55292511	25.02616882	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11161
銀髮族服務	石頭湯社區整合照顧服務	中山區社區整合照顧服務中心	臺北市中山區江山里合江街73巷4號1樓	121.53985596	25.05870819	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11162
銀髮族服務	石頭湯社區整合照顧服務	中正區社區整合照顧服務中心	臺北市中正區新營里愛國東路110巷16號	121.52105713	25.03215218	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11163
銀髮族服務	家庭照顧者服務中心	北區家庭照顧者支持中心(士林靈糧堂承辦)	臺北市士林區忠誠路二段53巷7號5樓	121.53237915	25.11142349	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11164
銀髮族服務	家庭照顧者服務中心	東區家庭照顧者支持中心(健順養護中心承辦)	臺北市中山區吉林路312號4樓	121.53016663	25.06193161	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11165
銀髮族服務	家庭照顧者服務中心	西區家庭照顧者支持中心(台北市立心慈善基金會承辦)	臺北市萬華區萬大路329巷1之1號1樓	121.50053406	25.02407074	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11166
銀髮族服務	家庭照顧者服務中心	南區家庭照顧者支持中心(婦女新知承辦)	臺北市中正區重慶南路三段2號3樓304室	121.51516724	25.02960968	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11167
銀髮族服務	社區照顧關懷據點	臺北市北投老人服務據點	臺北市北投區中央北路一段12號3、4樓	121.50099945	25.13391304	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11168
銀髮族服務	長青學苑	臺北醫學大學進修推廣處	臺北市大安區基隆路二段172-1號13樓	121.55477142	25.02655983	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11169
銀髮族服務	長青學苑	臺北市中山社區大學	臺北市中山區新生北路三段55號	121.52857971	25.06537628	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11170
銀髮族服務	長青學苑	臺北市士林社區大學	臺北市士林區承德路四段177號（百齡高中）	121.5230484	25.08701706	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11171
銀髮族服務	長青學苑	臺北市松山社區大學	臺北市松山區八德路四段101號	121.5610733	25.04870796	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11172
銀髮族服務	長青學苑	臺北市信義社區大學	臺北市信義區松仁路158巷1號	121.56793213	25.02861404	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11173
銀髮族服務	長青學苑	國立臺灣戲曲學院	臺北市內湖區內湖路二段177號	121.586586	25.0814724	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11174
銀髮族服務	長青學苑	臺北市中正社區大學	臺北市中正區濟南路一段6號	121.52183533	25.04241371	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11175
銀髮族服務	長青學苑	臺北市立大學	臺北市中正區愛國西路1號	121.51358032	25.03556442	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11176
銀髮族服務	長青學苑	淡江大學進修推廣處	臺北市大安區金華街199巷5號	121.52857971	25.03101158	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11177
銀髮族服務	長青學苑	臺北市大同社區大學	臺北市大同區長安西路37-1號	121.5196991	25.05036736	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11178
銀髮族服務	長青學苑	臺北市萬華社區大學	臺北市萬華區南寧路46號	121.50460052	25.03606415	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11179
銀髮族服務	長青學苑	臺北市文山社區大學	臺北市文山區景中街27號	121.54294586	24.9930191	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11180
銀髮族服務	長青學苑	臺北市大安社區大學	臺北市大安區杭州南路二段1號(金甌女中)	121.52423859	25.03493118	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11181
銀髮族服務	長青學苑	臺北市內湖社區大學	臺北市內湖區文德路240號3樓	121.58873749	25.0788002	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11182
身障機構	住宿機構	臺北市私立文山創世清寒植物人安養院	臺北市文山區萬和街8號五樓	121.56772614	25.00200844	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11183
身障機構	住宿機構	崇愛發展中心	新北市中和區正行里7鄰圓通路143-1號	121.498909	24.99508858	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11184
身障機構	住宿機構	崇愛發展中心	新北市中和區正行里7鄰圓通路143-1號	121.498909	24.99508858	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11185
身障機構	住宿機構	臺北市三玉啟能中心	臺北市士林區忠誠路二段53巷7號3、4、7樓	121.53237915	25.11142349	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11186
身障機構	住宿機構	臺北市永福之家	臺北市士林區永福里5鄰莊頂路2號	121.54947662	25.11076546	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11187
身障機構	住宿機構	臺北市私立世美家園	臺北市文山區萬芳路51號	121.56383514	24.99812317	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11188
身障機構	住宿機構	臺北市私立彩虹村家園	臺北市北投區泉源路華南巷18號一樓	121.50702667	25.14027596	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11189
身障機構	住宿機構	臺北市私立陽明養護中心	臺北市北投區公舘路209巷18號	121.5087738	25.1275177	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11190
身障機構	住宿機構	臺北市私立陽明養護中心	臺北市北投區公舘路209巷18號	121.5087738	25.1275177	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11191
身障機構	住宿機構	臺北市私立永愛發展中心	臺北市信義區信義路五段150巷316號五樓	121.56960297	25.02690887	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11192
身障機構	住宿機構	臺北市南港養護中心	臺北市南港區松河街550號一樓	121.59855652	25.05801392	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11193
身障機構	住宿機構	臺北市東明扶愛家園	臺北市南港區南港路二段38巷8弄1號	121.60428619	25.05506134	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11194
身障機構	住宿機構	臺北市東明扶愛家園	臺北市南港區南港路二段38巷8弄1號	121.60427856	25.05506134	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11195
身障機構	住宿機構	臺北市一壽照顧中心	臺北市文山區樟新里5鄰一壽街22號三、四樓	121.55627441	24.97971535	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11196
身障機構	住宿機構	臺北市立陽明教養院(華岡院區)	臺北市士林區陽明里8鄰凱旋路61巷4弄9號	121.54120636	25.13517189	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11197
身障機構	住宿機構	臺北市廣愛家園	臺北市信義區大仁里福德街84巷	121.58076477	25.03858566	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11198
身障機構	住宿機構	臺北市私立聖安娜之家	臺北市士林區中山北路七段181巷1號	121.5322113	25.12449646	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11199
身障機構	住宿機構	臺北市大龍養護中心	臺北市大同區民族西路105號1-3樓	121.5171051	25.06881142	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11200
身障機構	住宿機構	臺北市私立育成和平發展中心	臺北市大安區臥龍街280號	121.55869293	25.01689339	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11201
身障機構	住宿機構	臺北市弘愛服務中心	臺北市中正區濟南路二段46號四樓	121.53089905	25.04035187	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11202
身障機構	住宿機構	臺北市私立創世清寒植物人安養院	臺北市中正區北平東路28號2樓	121.52537537	25.04586029	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11203
身障機構	住宿機構	臺北市金龍發展中心	臺北市內湖區金龍路136-1號	121.59009552	25.0857563	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11204
身障機構	住宿機構	臺北市興隆照顧中心	臺北市文山區興隆路四段105巷45號2樓	121.56251526	24.98816681	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11205
身障機構	住宿機構	臺北市興隆照顧中心	臺北市文山區興隆路四段105巷45號2樓	121.56251526	24.98816681	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11206
身障機構	社區居住	士林社區居住家園(德蘭家)	臺北市士林區0鄰中山北路七段146巷7、7-1號1樓	121.53314209	25.12323761	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11207
身障機構	社區居住	金南社區居住家園	臺北市大安區金山南路二段135號三樓	121.5267334	25.02968597	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11208
身障機構	社區居住	景仁社區居住(景仁家)	臺北市文山區羅斯福路六段276巷11號二樓	121.53927612	24.99145126	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11209
身障機構	社區居住	景仁社區居住(愛國家)	臺北市中正區愛國東路62號五樓	121.51902771	25.03349495	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11210
身障機構	社區居住	士林社區居住家園(聖露薏絲家)	臺北市士林區中山北路七段191巷9號1樓	121.53173065	25.12537384	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11211
身障機構	社區居住	建成社區居住家園	臺北市大同區承德路二段33號4、5樓	121.51842499	25.05458832	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11212
身障機構	社區居住	臺北市文林社區居住家園	臺北市北投區文林北路75巷51號/53號/63號	121.51718903	25.10387039	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11213
身障機構	社區居住	臺北市松德社區居住家園	臺北市信義區松德路25巷58號三樓	121.57752228	25.03782082	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11214
身障機構	社區居住	臺北市萬大社區居住家園	臺北市萬華區萬大路411、413號	121.50067902	25.03209686	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11215
身障機構	團體家庭	臺北市健軍團體家庭	臺北市中正區富水里4鄰汀州路三段60巷2弄6號	121.53071594	25.01549721	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11216
身障機構	團體家庭	臺北市興隆團體家庭	臺北市文山區木柵路二段138巷33號3樓	121.56230927	24.9880352	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11217
身障機構	團體家庭	臺北市三興團體家庭	臺北市信義區景勤里5鄰吳興街156巷6號3樓	121.56117249	25.0290184	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11218
身障機構	團體家庭	臺北市興隆團體家庭	臺北市文山區木柵路二段138巷33號3樓	121.56230927	24.9880352	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11219
身障機構	團體家庭	臺北市私立心路社區家園	臺北市文山區興旺里22鄰福興路63巷4弄29號一樓	121.5490036	25.00467873	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11220
身障機構	共融式遊戲場	立農公園	臺北市北投區承德路七段與吉利街口	121.51067352	25.11059761	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11367
身障機構	日間服務機構	臺北市私立陽光重建中心	臺北市中山區南京東路三段91號三樓	121.53896332	25.05215836	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11221
身障機構	日間服務機構	臺北市永明發展中心(兼辦早療服務)	臺北市北投區永明里4鄰石牌路二段115號四至六樓	121.51758575	25.11827469	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11222
身障機構	日間服務機構	臺北市私立心路兒童發展中心(兼辦早療服務)	臺北市中山區復興北路232號	121.54392242	25.0572319	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11223
身障機構	日間服務機構	臺北市城中發展中心	臺北市中正區汀州路二段172號	121.52207184	25.02377129	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11224
身障機構	日間服務機構	臺北市南海發展中心	臺北市中正區延平南路207號1-2樓	121.50766754	25.0328846	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11225
身障機構	日間服務機構	臺北市南海發展中心	臺北市中正區延平南路207號1-2樓	121.50766754	25.03288651	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11226
身障機構	日間服務機構	臺北市私立婦幼家園(兼辦早療服務)	臺北市內湖區民權東路六段180巷42弄6號	121.59233093	25.06734657	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11227
身障機構	日間服務機構	臺北市萬芳啟能中心	臺北市文山區萬美街一段51號1樓	121.56848145	25.00230408	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11228
身障機構	日間服務機構	臺北市萬芳發展中心(兼辦早療服務)	臺北市文山區萬美街一段55號二樓	121.56811523	25.00234032	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11229
身障機構	日間服務機構	臺北市私立至德聽語中心(提供早療服務)	臺北市中正區0鄰中華路一段77號三樓	121.50778198	25.03894234	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11230
身障機構	日間服務機構	臺北市私立育成裕民發展中心	臺北市北投區裕民一路41巷2弄18號	121.5185318	25.11671829	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11231
身障機構	日間服務機構	臺北市稻香發展中心	臺北市北投區稻香里0鄰稻香路81號2樓	121.48936462	25.14090347	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11232
身障機構	日間服務機構	臺北市私立自立社區學園	臺北市士林區德行西路93巷7號地下一樓之1	121.52088165	25.10487366	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11233
身障機構	日間服務機構	臺北市大同發展中心(兼辦早療服務)	臺北市大同區昌吉街52號六-七樓	121.51634216	25.06581688	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11234
身障機構	日間服務機構	臺北市博愛發展中心	臺北市中山區敬業三路160號	121.556633	25.07952881	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11235
身障機構	日間服務機構	臺北市慈祐發展中心	臺北市松山區八德路四段688號3-4樓	121.57688141	25.04985809	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11236
身障機構	日間服務機構	臺北市恆愛發展中心	臺北市信義區松隆路36號六樓	121.56754303	25.04339409	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11237
身障機構	日間服務機構	臺北市私立第一兒童發展中心(兼辦早療服務)	臺北市信義區信義路五段150巷316號一樓	121.56960297	25.02690887	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11238
身障機構	日間服務機構	臺北市私立育仁兒童發展中心(兼辦早療服務)	臺北市萬華區萬大路387巷15號	121.49967194	25.0221405	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11239
身障機構	日間服務機構	臺北市私立育仁啟能中心	臺北市萬華區柳州街41號四樓	121.50538635	25.03847122	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11240
身障機構	社區日間作業設施	內湖工坊	臺北市內湖區江南街71巷60號	121.5791626	25.07430649	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11241
身障機構	社區日間作業設施	萬華視障生活重建中心暨社區工坊	臺北市萬華區0鄰梧州街36號4樓	121.49748993	25.03737068	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11242
身障機構	社區日間作業設施	士林工坊	臺北市士林區忠誠路二段53巷7號9樓A	121.53237915	25.11142349	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11243
身障機構	社區日間作業設施	奇岩工坊	臺北市北投區三合街一段119號7樓	121.50392914	25.12655258	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11244
身障機構	社區日間作業設施	奇岩工坊	臺北市北投區三合街一段119號7樓	121.50392914	25.12655258	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11245
身障機構	社區日間作業設施	文山工坊	臺北市文山區興隆路四段105巷47號1樓(興隆公宅2區)	121.56312561	24.98828125	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11246
身障機構	社區日間作業設施	文山工坊	臺北市文山區興隆路四段105巷47號1樓(興隆公宅2區)	121.56312561	24.98828125	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11247
身障機構	社區日間作業設施	北投工坊	臺北市北投區石牌路二段99巷9號四樓	121.51663971	25.11792564	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11248
身障機構	社區日間作業設施	肯納行義坊	臺北市北投區行義路129號	121.52828217	25.12879944	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11249
身障機構	社區日間作業設施	聖文生樂活工坊	臺北市北投區石牌路二段90巷20號2樓	121.51741791	25.11698341	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11250
身障機構	社區日間作業設施	民生工坊	臺北市松山區敦化北路199巷5號三樓	121.55152893	25.05699539	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11251
身障機構	社區日間作業設施	健康工坊_A處	臺北市松山區健康路399號6樓	121.56886292	25.05460167	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11252
身障機構	社區日間作業設施	星扶工坊	臺北市松山區八德路四段306號四樓	121.56736755	25.04899979	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11253
身障機構	社區日間作業設施	信義工坊	臺北市信義區信義路五段15號三樓	121.56689453	25.03314972	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11254
身障機構	社區日間作業設施	心朋友工作坊	臺北市信義區和平東路三段391巷20弄16號	121.55817413	25.02076912	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11255
身障機構	社區日間作業設施	台北工坊	臺北市信義區信義路四段415號七樓	121.55923462	25.03330421	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11256
身障機構	社區日間作業設施	南港工坊(舊址，已停辦)	臺北市南港區南港路一段173號五樓	121.61297607	25.05520248	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11257
身障機構	社區日間作業設施	委託經營管理身心障礙者社區日間作業設施-瑞光工坊	臺北市內湖區瑞光路162號2樓之2	121.57926178	25.07343483	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11258
身障機構	社區日間作業設施	松山工坊	臺北市松山區新聚里3鄰南京東路五段356號6F-2	121.56969452	25.05106735	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11259
身障機構	社區日間作業設施	南港工坊	臺北市南港區八德路四段768-1號	121.57996368	25.05030441	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11260
身障機構	社區日間作業設施	南港工坊	臺北市南港區八德路四段768-1號	121.57996368	25.05030441	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11261
身障機構	社區日間作業設施	健康工坊_B處	臺北市松山區健康路399號6樓	121.56886292	25.05460167	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11262
身障機構	社區日間作業設施	委託經營管理身心障礙者社區日間作業設施-瑞光工坊	臺北市內湖區瑞光路162號2樓之2	121.57926178	25.07343483	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11263
身障機構	社區日間作業設施	委託經營管理身心障礙者社區日間作業設施-明倫工坊	臺北市大同區承德路三段285之5號	121.51941681	25.07311821	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11264
身障機構	社區日間作業設施	建成工坊	臺北市大同區承德路二段33號6樓	121.51842499	25.05458832	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11265
身障機構	社區日間作業設施	士林工坊(舊名，已停用)	臺北市士林區中山北路六段248號五樓	121.52549744	25.10923576	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11266
身障機構	社區日間作業設施	育成蘭興站	臺北市士林區磺溪街88巷5號一樓	121.52371979	25.10851097	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11267
身障機構	社區日間作業設施	心願工坊	臺北市大同區昌吉街52號八樓	121.51634216	25.06581688	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11268
身障機構	社區日間作業設施	大安工坊	臺北市大安區瑞安街73號三樓	121.54110718	25.02832413	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11269
身障機構	社區日間作業設施	天生我才大安站	臺北市大安區敦化南路二段200巷16號五樓	121.54759216	25.02278519	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11270
身障機構	社區日間作業設施	中山工坊	臺北市中山區建國北路二段260、262號3樓	121.53770447	25.06095505	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11271
身障機構	社區日間作業設施	古亭工坊	臺北市中正區羅斯福路二段150號	121.52320862	25.02566338	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11272
身障機構	社區日間作業設施	夢想工坊	臺北市中正區南昌路二段192號五樓之3	121.52384186	25.02423477	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11273
身障機構	社區日間作業設施	星兒工坊	臺北市中正區寧波西街62號三樓	121.51712799	25.03038788	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11274
身障機構	社區日間作業設施	肯納和平坊	臺北市中正區和平西路二段6號四樓	121.51416779	25.02775192	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11275
身障機構	身障社區長照機構（日間照顧）	財團法人廣青文教基金會附設臺北市私立士林身障社區長照機構(日間照顧)	臺北市士林區後港街189號一樓	121.52096558	25.08804512	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11276
身障機構	身障社區長照機構（日間照顧）	臺北市政府社會局委託財團法人喜憨兒社會福利基金會經營管理中山身障社區長照機構（日間照顧）	臺北市中山區長安西路5弄2號四樓	121.52077484	25.05050468	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11277
身障機構	身障社區長照機構（日間照顧）	臺北市政府社會局委託財團法人喜憨兒社會福利基金會經營管理中山身障社區長照機構（日間照顧）	臺北市中山區長安西路5弄2號四樓	121.52132416	25.04980659	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11278
身障機構	身障社區長照機構（日間照顧）	臺北市政府社會局委託財團法人伊甸社會福利基金會經營管理臺北市民生身障社區長照機構（日間照顧）	臺北市松山區民生東路五段163之1號七樓	121.56258392	25.05905724	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11279
身障機構	身障社區長照機構（日間照顧）	財團法人喜憨兒社會福利基金會附設臺北市私立松山身障社區長照機構(日間照顧)	臺北市松山區南京東路五段356號六樓之2	121.56969452	25.05106735	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11280
身障機構	身障社區長照機構（日間照顧）	臺北市政府社會局委託財團法人中華民國唐氏症基金會經營管理信義身障社區長照機構（日間照顧）	臺北市信義區信義路五段15號五樓	121.56689453	25.03314972	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11281
身障機構	身障社區長照機構（日間照顧）	臺北市政府社會局委託財團法人臺北市喜樂家族社會福利基金會經營管理大龍峒身障社區長照機構（日間照顧）	臺北市大同區老師里0鄰重慶北路三段320號3、4樓（社福大樓）	121.51358795	25.07470131	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11282
身障機構	身障社區長照機構（日間照顧）	臺北市政府社會局委託財團法人天主教白永恩神父社會福利基金會經營管理稻香身障社區長照機構（日間照顧）	臺北市北投區稻香里0鄰稻香路81號3樓之1	121.48936462	25.14090347	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11283
身障機構	身障社區長照機構（日間照顧）	臺北市政府社會局委託財團法人中華民國唐氏症基金會經營管理景新身障社區長照機構（日間照顧）	臺北市文山區景行里景後街151號4樓	121.54191589	24.98999786	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11284
身障機構	精神障礙者會所	星辰會所	臺北市士林區三玉里忠誠路二段53巷7號9樓	121.53237915	25.11142349	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11285
身障機構	精神障礙者會所	真福之家_公辦民營	臺北市大同區承德路二段33號3樓	121.51842499	25.05458832	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11286
身障機構	精神障礙者會所	興隆會所	臺北市文山區木柵路二段138巷33號1樓	121.56230927	24.9880352	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11287
身障機構	精神障礙者會所	興隆會所	臺北市文山區木柵路二段138巷33號1樓	121.56230927	24.9880352	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11288
身障機構	精神障礙者會所	真福之家_方案委託	臺北市松山區敦化北路145巷10之2號1樓	121.55015564	25.05389595	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11289
身障機構	精神障礙者會所	向陽會所	臺北市萬華區青年路152巷20號、22號1樓	121.50184631	25.02095222	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11290
身障機構	精神障礙者會所	臺北市精神障礙者會所-向陽會所	臺北市萬華區日祥里1鄰青年路152巷2號	121.50217438	25.02130318	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11291
身障機構	身心障礙者資源中心	臺北市士林、北投區身心障礙者資源中心	臺北市北投區奇岩里0鄰三合街一段119號7樓	121.50392914	25.12655258	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11292
身障機構	身心障礙者資源中心	臺北市士林、北投區身心障礙者資源中心	臺北市北投區奇岩里0鄰三合街一段119號7樓	121.50392914	25.12655258	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11293
身障機構	身心障礙者資源中心	臺北市大同、中山區身心障礙者資源中心	臺北市中山區長安西路5巷2號	121.52077484	25.05050659	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11294
身障機構	身心障礙者資源中心	臺北市中正、萬華區身心障礙者資源中心	臺北市中正區南門里延平南路207號3樓	121.50766754	25.0328846	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11295
身障機構	身心障礙者資源中心	臺北市中正、萬華區身心障礙者資源中心	臺北市中正區南門里延平南路207號3樓	121.50766754	25.03288651	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11296
身障機構	身心障礙者資源中心	大安、文山區身心障礙者資源中心	臺北市文山區辛亥路五段94號一樓	121.55312347	24.9984436	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11297
身障機構	身心障礙者資源中心	臺北市內湖、松山區身心障礙者資源中心	臺北市內湖區瑞光路162號2樓之3	121.57926178	25.07343483	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11298
身障機構	身心障礙者資源中心	臺北市內湖、松山區身心障礙者資源中心	臺北市內湖區瑞光路162號2樓之3	121.57926178	25.07343483	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11299
身障機構	身心障礙者資源中心	臺北市信義、南港區身心障礙者資源中心	臺北市信義區廣居里3鄰忠孝東路五段242號7樓	121.57232666	25.040802	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11300
身障機構	福利服務中心	臺北市私立活泉之家	臺北市文山區萬美街一段55號三樓	121.56811523	25.00234032	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11301
身障機構	福利服務中心	臺北市身心障礙者自立生活支持服務中心	臺北市大同區重慶北路三段347號3樓之2	121.51407623	25.07478523	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11302
身障機構	福利服務中心	臺北市身心障礙者自立生活支持服務中心	臺北市大同區重慶北路三段347號3樓之2	121.51407623	25.07478523	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11303
身障機構	福利服務中心	臺北市私立八德服務中心	臺北市松山區八德路三段155巷4弄35號	121.55560303	25.04892731	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11304
身障機構	輔具服務中心	臺北市合宜輔具中心(財團法人第一社會福利基金會承辦)	臺北市中山區玉門街1號	121.52050018	25.07036209	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11305
身障機構	輔具服務中心	臺北市西區輔具中心 (財團法人伊甸社會福利基金會承辦)	臺北市中山區長安西路2號5巷2號2樓	121.52077484	25.05050468	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11306
身障機構	輔具服務中心	臺北市西區輔具中心 (財團法人伊甸社會福利基金會承辦)	臺北市中山區長安西路2號5巷2號2樓	121.5203476	25.04982758	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11307
身障機構	輔具服務中心	臺北市南區輔具中心 (財團法人第一社會福利基金會承辦)	臺北市信義區信義路五段150巷310號	121.56950378	25.0270462	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11308
身障機構	身心障礙者社區日間活動據點	財團法人台北市私立雙連視障關懷基金會	臺北市中山區中山北路二段111號11樓	121.52317047	25.06012344	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11309
身障機構	身心障礙者社區日間活動據點	財團法人喜憨兒社會福利基金會	臺北市松山區民生東路五段163-1號7樓	121.56258392	25.05905724	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11310
身障機構	身心障礙者社區日間活動據點	財團法人中華民國自閉症基金會	臺北市士林區中山北路五段841號4樓之2	121.5253067	25.10217667	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11311
身障機構	身心障礙者社區日間活動據點	中華視障人福利協會	臺北市中山區撫順街6號6樓	121.52156067	25.06368637	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11312
身障機構	身心障礙者社區日間活動據點	財團法人心路社會福利基金會	臺北市文山區萬和街8號1樓(臺北社區生活支持中心)	121.56772614	25.00200844	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11313
身障機構	身心障礙者社區日間活動據點	中華民國腦性麻痺協會	臺北市北投區大業路166號5樓	121.49906921	25.12528992	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11314
身障機構	身心障礙者社區日間活動據點	社團法人台北生命勵樂活輔健會	臺北市松山區塔悠路臺北市觀山自行車租借站（塔悠路與民權東路交叉口，民權高架橋下，基六號疏散門進入，左轉直走往大直橋方向，約250公尺之高速公路橋下方彩色貨櫃屋）	121.56828308	25.06192589	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11315
身障機構	身心障礙者社區日間活動據點	台北市康復之友協會	臺北市松山區八德路四段604號2樓之3	121.57272339	25.04980087	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11316
身障機構	身心障礙者社區日間活動據點	財團法人伊甸社會福利基金會(附設台北市私立恩望身心障礙者人力資源服務中心)	臺北市南港區忠孝東路六段85號3樓	121.58466339	25.04817581	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11317
身障機構	身心障礙者社區日間活動據點	社團法人臺北市視障者家長協會	臺北市松山區敦化北路155巷76號4樓	121.55147552	25.0543232	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11318
身障機構	身心障礙者社區日間活動據點	台北市瞽者福利協進會	臺北市萬華區廣州街152巷10號3樓(新富民區民活動中心)	121.5005188	25.03620529	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11319
身障機構	共融式遊戲場	福志公園	臺北市士林區福林路251巷4弄	121.53466034	25.0984745	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11320
身障機構	共融式遊戲場	眷村文化公園	臺北市信義區莊敬路與松勤路交口,信義國小西側	121.56114197	25.03233337	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11321
身障機構	共融式遊戲場	福志公園	臺北市士林區福林路251巷4弄	121.53466034	25.0984726	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11322
身障機構	共融式遊戲場	士林4號廣場	臺北市士林區福林路與雨農路交叉口	121.53025055	25.09458733	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11323
身障機構	共融式遊戲場	士林4號廣場	臺北市士林區福林路與雨農路交叉口	121.53025055	25.09458733	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11324
身障機構	共融式遊戲場	兒童新樂園(機械式)	臺北市士林區承德路五段55號	121.51416779	25.09683609	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11325
身障機構	共融式遊戲場	兒童新樂園(非機械式)	臺北市士林區承德路五段55號	121.51416779	25.09683609	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11326
身障機構	共融式遊戲場	樹德公園	臺北市大同區大龍街129號	121.51611328	25.06715202	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11327
身障機構	共融式遊戲場	樹德公園	臺北市大同區大龍街129號	121.51611328	25.06715202	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11328
身障機構	共融式遊戲場	景化公園	臺北市大同區伊寧街9巷(景化街巷弄中)	121.5131073	25.06513214	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11329
身障機構	共融式遊戲場	朝陽公園	臺北市大同區重慶北路二段64巷口	121.51343536	25.05578804	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11330
身障機構	共融式遊戲場	建成公園	臺北市大同區承德路二段臺北市大同區承德路二段35號旁	121.51843262	25.0547924	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11331
身障機構	共融式遊戲場	眷村文化公園	臺北市信義區莊敬路與松勤路交口,信義國小西側	121.56114197	25.03233337	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11332
身障機構	共融式遊戲場	象山公園	臺北市信義區信義路五段150巷旁	121.57032013	25.02561569	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11333
身障機構	共融式遊戲場	聯成公園	臺北市南港區忠孝東路六段250巷1弄	121.58903503	25.04843712	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11334
身障機構	共融式遊戲場	玉成公園	臺北市南港區中坡南路55號	121.58575439	25.04187012	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11335
身障機構	共融式遊戲場	四分綠地	臺北市南港區研究院路二段182巷58弄旁	121.61441803	25.0363636	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11336
身障機構	共融式遊戲場	中研公園	臺北市南港區研究院路二段12巷58弄	121.6138916	25.04714584	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11337
身障機構	共融式遊戲場	山水綠生態公園	臺北市南港區南深路37號	121.62039948	25.03647423	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11338
身障機構	共融式遊戲場	山水綠生態公園	臺北市南港區南深路37號	121.62039948	25.03647614	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11339
身障機構	共融式遊戲場	和平青草公園	臺北市萬華區艋舺大道與號西園路二段交叉口	121.50521851	25.03445435	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11340
身障機構	共融式遊戲場	和平青草公園	臺北市萬華區艋舺大道與號西園路二段交叉口	121.50521851	25.03445435	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11341
身障機構	共融式遊戲場	建成公園	臺北市大同區承德路二段臺北市大同區承德路二段35號旁	121.51843262	25.05479431	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11342
身障機構	共融式遊戲場	大安國小	臺北市大安區臥龍街129號	121.54964447	25.01951027	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11343
身障機構	共融式遊戲場	和平實驗小學	臺北市大安區敦南街76巷28號	121.54666901	25.02072525	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11344
身障機構	共融式遊戲場	和平實驗小學	臺北市大安區敦南街76巷28號	121.54666901	25.02072525	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11345
身障機構	共融式遊戲場	建安國小	臺北市大安區大安路二段99號	121.54615021	25.02939034	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11346
身障機構	共融式遊戲場	古亭國小	臺北市大安區羅斯福路三段201號	121.52848816	25.02066994	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11347
身障機構	共融式遊戲場	明水公園	臺北市中山區北安路538巷1弄	121.54827118	25.07998466	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11348
身障機構	共融式遊戲場	永盛公園	臺北市中山區中山北路二段93巷26,40號間	121.52429199	25.05919838	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11349
身障機構	共融式遊戲場	大佳河濱公園	臺北市中山區濱江街　	121.53036499	25.07175255	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11350
身障機構	共融式遊戲場	中安公園	臺北市中山區中山北路二段65巷2弄內	121.52474213	25.05659676	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11351
身障機構	共融式遊戲場	花博公園美術園區	臺北市中山區民族東路以北中山北路以東(原民族公園)	121.52336121	25.06830025	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11352
身障機構	共融式遊戲場	花博公園美術園區	臺北市中山區民族東路以北中山北路以東(原民族公園)	121.52336121	25.06829834	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11353
身障機構	共融式遊戲場	石潭公園	臺北市內湖區成功路二段東側	121.59127045	25.06021118	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11354
身障機構	共融式遊戲場	大港墘公園	臺北市內湖區瑞光路393巷旁	121.57296753	25.07869911	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11355
身障機構	共融式遊戲場	碧湖公園	臺北市內湖區內湖路二段175號，國立臺灣戲曲學院旁	121.58579254	25.08116722	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11356
身障機構	共融式遊戲場	碧湖公園	臺北市內湖區內湖路二段175號，國立臺灣戲曲學院旁	121.58579254	25.08116913	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11357
身障機構	共融式遊戲場	潭美國小	臺北市內湖區新明路22號	121.59078979	25.06095314	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11358
身障機構	共融式遊戲場	萬芳4號公園	臺北市文山區萬和街1號對面	121.56757355	25.00131416	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11359
身障機構	共融式遊戲場	興隆公園	臺北市文山區興隆路二段154巷與仙岩路交口	121.55167389	25.00101662	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11360
身障機構	共融式遊戲場	興隆公園	臺北市文山區興隆路二段154巷與仙岩路交口	121.55167389	25.00101662	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11361
身障機構	共融式遊戲場	景華公園	臺北市文山區景興路與景華街交口	121.54488373	24.99845695	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11362
身障機構	共融式遊戲場	景華公園	臺北市文山區景興路與景華街交口	121.54488373	24.99845695	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11363
身障機構	共融式遊戲場	道南河濱公園	臺北市文山區恆光街景美恆光橋下游右側	121.5667038	24.98355865	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11364
身障機構	共融式遊戲場	榮華公園	臺北市北投區明德路150巷17-1號	121.52153778	25.11068535	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11365
身障機構	共融式遊戲場	石牌公園	臺北市北投區石牌路一段39巷內	121.50989532	25.118536	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11366
身障機構	共融式遊戲場	立農公園	臺北市北投區承德路七段與吉利街口	121.51073456	25.11044312	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11368
身障機構	共融式遊戲場	磺港公園	臺北市北投區磺港路與大興街交叉口	121.50196075	25.13333893	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11369
身障機構	共融式遊戲場	磺港公園	臺北市北投區磺港路與大興街交叉口	121.50196075	25.13333893	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11370
身障機構	共融式遊戲場	文林國小	臺北市北投區文林北路155號	121.51473999	25.10593414	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11371
身障機構	共融式遊戲場	榮富公園	臺北市北投區榮華三路及磺溪旁(過天母橋)	121.52153015	25.11384583	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11372
身障機構	共融式遊戲場	三民公園	臺北市松山區三民路、撫遠街298號	121.56399536	25.05328369	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11373
兒童與少年服務	兒童及少年安置機構	財團法人台北市私立體惠育幼院	臺北市士林區中山北路七段141巷43號	121.53018951	25.12454033	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11374
兒童與少年服務	兒童及少年安置機構	財團法人台北市愛慈社會福利基金會附設恩典之家寶寶照護中心	臺北市中正區公園路20巷12號4樓	121.5165863	25.04507828	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11375
兒童與少年服務	兒童及少年安置機構	臺北市私立義光育幼院	臺北市萬華區和平西路三段382巷11弄17號	121.49207306	25.03457069	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11376
兒童與少年服務	兒童及少年安置機構	財團法人台北市私立非拉鐵非兒少之家	臺北市士林區愛富二街7號	121.54443359	25.13857269	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11377
兒童與少年服務	兒童及少年安置機構	財團法人忠義社會福利事業基金會附設台北市私立忠義育幼院	臺北市文山區景興路85巷12號	121.54556274	24.99618721	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11378
兒童與少年服務	兒童及少年安置機構	財團法人基督教聖道兒少福利基金會附屬台北市私立聖道兒童之家	臺北市北投區承德路七段388號1樓	121.50209045	25.11964607	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11379
兒童與少年服務	兒童及少年安置機構	臺北市選擇家園(臺北市少年緊急短期安置庇護家園)	臺北市內湖區康樂街16號(內湖東湖郵局第6-151號信箱)	121.61789703	25.06816483	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11380
兒童與少年服務	兒童及少年安置機構	財團法人忠義社會福利事業基金會心棧家園	臺北市文山區萬和街6號11樓之1	121.56735992	25.00193787	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11381
兒童與少年服務	兒童及少年安置機構	財團法人基督教臺北市私立伯大尼兒少家園	臺北市文山區保儀路129號	121.56707001	24.98495674	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11382
兒童與少年服務	兒童及少年安置機構	臺北市向晴家園	臺北市文山區順興里003鄰興隆路四段145巷9弄15號	121.56182098	24.9857502	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11383
兒童與少年服務	兒童及少年安置機構	臺北市綠洲家園	新北市深坑區北深路２段155號	121.61414337	25.00211525	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11384
兒童與少年服務	兒童及少年安置機構	財團法人臺北市私立華興育幼院	臺北市士林區仰德大道一段101號	121.53820801	25.10460472	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11385
兒童與少年服務	兒童及少年安置機構	財團法人中華文化社會福利事業基金會台北兒童福利中心	臺北市信義區虎林街120巷270號	121.5708847	25.04220772	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11386
兒童與少年服務	兒童及少年安置機構	財團法人台灣關愛基金會附設台北市私立關愛之子家園	臺北市南港區南港路一段173號4樓	121.61297607	25.05520248	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11387
兒童與少年服務	兒童及少年安置機構	臺北市培立家園(大同區)	臺北市大同區光能里5鄰承德路二段33號11-12樓	121.51842499	25.05458832	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11388
兒童與少年服務	兒童及少年安置機構	臺北市培立家園	臺北市北投區中和街399-8號	121.49840546	25.14273262	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11389
兒童與少年服務	兒童及少年安置機構	臺北市希望家園	臺北市中山區松江路362巷22號	121.5322113	25.06189728	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11390
兒童與少年服務	青少年自立住宅	臺北市青少年自立住宅(得力住宅)	臺北市文山區木柵路二段138巷33號4樓之8	121.56230927	24.9880352	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11391
兒童與少年服務	兒童福利服務中心	臺北市福安兒童服務中心	臺北市中正區汀州路一段123號	121.50945282	25.02817535	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11392
兒童與少年服務	兒童福利服務中心	臺北市萬華兒童服務中心	臺北市萬華區東園街19號3樓、8樓	121.4956665	25.02791405	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11393
兒童與少年服務	少年福利服務中心	臺北市北區少年服務中心	臺北市北投區中央北路一段12號5樓	121.50099945	25.13391304	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11394
兒童與少年服務	少年福利服務中心	臺北市中山、大同區少年服務中心	臺北市中山區聚盛里林森北路381號4樓	121.52565765	25.05848885	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11395
兒童與少年服務	少年福利服務中心	臺北市南區少年服務中心	臺北市大安區延吉街246巷10號4樓	121.555336	25.0353241	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11396
兒童與少年服務	少年福利服務中心	臺北市東區少年服務中心	臺北市松山區敦化北路199巷5號3樓	121.55152893	25.05699539	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11397
兒童與少年服務	少年福利服務中心	臺北市南港、信義區少年服務中心	臺北市信義區信義路六段12巷21號1樓	121.57520294	25.03305435	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11398
兒童與少年服務	少年福利服務中心	臺北市西區少年服務中心	臺北市萬華區東園街19號1樓	121.4956665	25.02791405	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11399
兒童與少年服務	兒童及少年收出養服務資源中心	臺北市兒童及少年收出養服務資源中心	臺北市中正區延平南路207號5樓	121.50766754	25.0328846	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11400
兒童與少年服務	親職教育輔導中心	臺北市親職教育輔導中心	臺北市中正區延平南路207號5樓	121.50766754	25.0328846	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11401
兒童與少年服務	早期療育社區資源中心	大安、文山早期療育社區資源中心（萬隆東營區）	臺北市文山區興隆路二段88號5樓	121.5490799	25.00047112	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11402
兒童與少年服務	早期療育社區資源中心	財團法人天主教白永恩神父社會福利基金會附設臺北市私立聖文生兒童發展中心	臺北市北投區石牌路二段90巷20號	121.51741791	25.11698341	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11403
兒童與少年服務	早期療育社區資源中心	大安、文山區早療社區資源中心-財團法人心路社會福利基金會	臺北市大安區辛亥路一段40號2樓	121.53017426	25.02003098	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11404
兒童與少年服務	早期療育社區資源中心	大同、中山區早療社區資源中心-財團法人天主教光仁社會福利基金會	臺北市中山區林森北路77號4樓	121.52485657	25.04954529	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11405
兒童與少年服務	早期療育社區資源中心	松山、內湖區早療社區資源中心-財團法人伊甸社會福利基金會	臺北市內湖區民權東路六段90巷16弄1號3樓	121.5854187	25.06788063	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11406
兒童與少年服務	早期療育社區資源中心	士林、北投區早療社區資源中心-財團法人育成社會福利基金會	臺北市北投區中央北路一段6號4樓之2	121.50121307	25.13376808	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11407
兒童與少年服務	早期療育社區資源中心	信義、南港區早療社區資源中心-財團法人第一社會福利基金會	臺北市信義區莊敬路418號5樓	121.56639862	25.02712059	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11408
兒童與少年服務	早期療育社區資源中心	中正、萬華區早療社區資源中心-財團法人中華民國發展遲緩兒童基金會	臺北市萬華區西園路一段150號3樓	121.49941254	25.03749847	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11409
兒童與少年服務	友善兒童少年福利服務據點	財團法人基督教救世軍-友善兒少福利服務據點	臺北市內湖區內湖路一段285巷63弄7號1樓	121.56732941	25.08409309	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11410
兒童與少年服務	友善兒童少年福利服務據點	大橋友善兒童少年福利服務據點	臺北市大同區迪化街二段67號	121.50945282	25.06493759	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11411
兒童與少年服務	友善兒童少年福利服務據點	財團法人台北市中國基督教靈糧世界佈道會士林靈糧堂	臺北市北投區1鄰大業路大業路721號2樓	121.50223541	25.13728714	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11412
兒童與少年服務	友善兒童少年福利服務據點	社團法人臺北市基督教大內之光協會	臺北市內湖區康寧路一段128號	121.59368134	25.07933044	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11413
兒童與少年服務	友善兒童少年福利服務據點	社團法人中華社區厝邊頭尾營造協會「拉他們一把」社區弱勢家庭服務計畫	臺北市中山區建國北路一段33巷45號	121.53987885	25.04782104	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11414
兒童與少年服務	友善兒童少年福利服務據點	財團法人台北市基督教勵友中心-新興友善兒童少年福利服務據點	臺北市中山區雙城街43巷2號	121.52490997	25.06742096	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11415
兒童與少年服務	友善兒童少年福利服務據點	社團法人台北市原住民關懷協會-Lokah Laqi中山區友善兒少福利服務據點	臺北市中山區中山北路二段137巷18-12號B1	121.52423859	25.06165314	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11416
兒童與少年服務	友善兒童少年福利服務據點	「小星光陪讀班」友善兒童少年福利服務據點計畫	臺北市中正區杭州南路一段15-1號B1	121.52674866	25.04314613	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11417
兒童與少年服務	友善兒童少年福利服務據點	社團法人中華青少年純潔運動協會務-純潔古亭據點	臺北市中正區水源路臨28號	121.52282715	25.01967812	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11418
兒童與少年服務	友善兒童少年福利服務據點	南機場學苑-友善兒少福利服務據點	臺北市中正區中華路二段315巷18號 (據點)	121.5070343	25.02846336	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11419
兒童與少年服務	友善兒童少年福利服務據點	迎曦學園-接觸點友善兒童少年福利服務據點	臺北市內湖區內湖路二段355巷19號 1樓(據點)	121.59236145	25.08438301	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11420
兒童與少年服務	友善兒童少年福利服務據點	天使之家創造希望、迎向多元	臺北市內湖區成功路二段242號1樓	121.5901413	25.06586647	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11421
兒童與少年服務	友善兒童少年福利服務據點	社團法人台北市基督教萬芳浸信會-萬芳地區兒少服務計畫	臺北市文山區萬美街一段19巷5號1樓	121.5694046	25.00199318	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11422
兒童與少年服務	友善兒童少年福利服務據點	臺北市樂服社區關懷協會-友善兒少福利服務據點	臺北市文山區羅斯福路五段176巷26號	121.53729248	25.0043335	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11423
兒童與少年服務	友善兒童少年福利服務據點	臺北市文山區 明興社區發展協會-明興白屋童趣練功坊	臺北市文山區明興里秀明路一段17號2樓	121.56394196	24.98950005	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11424
兒童與少年服務	友善兒童少年福利服務據點	順興有福「童」享兒少服務據點	臺北市文山區興隆路四段165巷11號1樓	121.56249237	24.98421478	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11425
兒童與少年服務	友善兒童少年福利服務據點	愛鄰木柵舊社區兒少據點	臺北市文山區木柵路三段77號6樓	121.56716919	24.98875618	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11426
兒童與少年服務	友善兒童少年福利服務據點	社團法人台灣社區 鴻羽關懷協會-兒少夢想力學苑	臺北市萬華區萬大路322巷39號3樓	121.49914551	25.0245533	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11427
兒童與少年服務	友善兒童少年福利服務據點	牧人學堂(銀河班) 友善兒童少年福利服務據點	臺北市大同區寧夏路139號2樓	121.51441193	25.06093025	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11428
兒童與少年服務	友善兒童少年福利服務據點	台北市朱厝崙社區發展協會	臺北市中山區龍江路45巷6號	121.5411377	25.04913521	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11429
兒童與少年服務	友善兒童少年福利服務據點	社團法人中華民國我願意全人關懷協會- I Do友善兒童少年福利服務據點	臺北市南港區同德路85巷12號1樓	121.58542633	25.04656601	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11430
兒童與少年服務	友善兒童少年福利服務據點	臺北市南港區久如社區發展協會-久如社區友善兒少服務據點(國高中)	臺北市南港區研究院路二段208號1樓	121.61710358	25.03666878	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11431
兒童與少年服務	友善兒童少年福利服務據點	財團法人伊甸社會福利基金會	臺北市松山區八德路三段155巷4弄35號1樓	121.55560303	25.04892731	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11432
兒童與少年服務	友善兒童少年福利服務據點	財團法人味全文化教育基金會	臺北市中山區松江路125號4樓	121.53325653	25.05302811	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11433
兒童與少年服務	友善兒童少年福利服務據點	臺灣兒少玩心教育協會	臺北市文山區興隆路四段145巷9弄3號1樓	121.56201172	24.98526382	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11434
兒童與少年服務	友善兒童少年福利服務據點	社團法人台北市基督教活水江河全人關懷協會-社區兒童少年關懷服務據點計畫	臺北市信義區松信路163號地下室	121.5721283	25.04297829	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11435
兒童與少年服務	友善兒童少年福利服務據點	臺北市南港區久如社區發展協會(國小)	臺北市南港區研究院路二段169號1樓	121.61737823	25.0374794	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11436
兒童與少年服務	友善兒童少年福利服務據點	財團法人台北市立心慈善基金會「小荳荳關懷園地」社區兒童照顧	臺北市萬華區東園街19號3樓	121.4956665	25.02791405	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11437
兒童與少年服務	友善兒童少年福利服務據點	社團法人台灣社區實踐協會-萬華青年次分區兒少友善據點	臺北市萬華區萬大路137巷16號	121.50132751	25.02901459	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11438
兒童與少年服務	友善兒童少年福利服務據點	社團法人中華青少年純潔運動協會-萬華社區兒少關懷據點	臺北市萬華區寶興街80巷25號	121.49385834	25.02557373	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11439
兒童與少年服務	友善兒童少年福利服務據點	立心青春痘關懷園地社區少年照顧計畫	臺北市萬華區東園街19號8樓	121.4956665	25.02791405	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11440
兒童與少年服務	友善兒童少年福利服務據點	社團法人臺灣好學協會-好學空間友善兒少福利據點	臺北市中山區松江路360號5樓	121.53298187	25.0618763	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11441
兒童與少年服務	友善兒童少年福利服務據點	社團法人 中華牧人關懷協會-星光班	臺北市大同區重慶北路二段57巷4號1樓	121.514534	25.05554962	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11442
兒童與少年服務	友善兒童少年福利服務據點	616幸福工作站	臺北市松山區民生東路五段36巷8弄7號1樓	121.55944824	25.05732727	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11443
兒童與少年服務	兒少活動小站	台北市彩虹全人關懷發展協會-彩虹小棧-兒少活動小站	臺北市內湖區文德路208巷16號B1	121.58349609	25.07766533	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11444
兒童與少年服務	兒少活動小站	財團法人台北市中國基督教靈糧世界佈道會台北靈糧堂-快樂學習列車	臺北市大同區承德路三段93號	121.51856995	25.06630516	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11445
兒童與少年服務	兒少活動小站	社團法人中華牧人關懷協會-星光小屋-兒少活動小站	臺北市文山區福興路78巷20弄2號1樓	121.55102539	25.00422859	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11446
兒童與少年服務	兒少活動小站	社團法人國際奔享體驗教育協會-吉利真光-兒少活動小站	臺北市北投區石牌路一段39巷80弄41號1樓	121.51094055	25.11594009	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11447
兒童與少年服務	兒少活動小站	社團法人台灣基督教展翔天地全人發展協會-小太陽歡樂園地活動小站	臺北市中正區汀州路三段101號2樓	121.52953339	25.01712608	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11448
兒童與少年服務	兒少活動小站	財團法人新北市基督教新希望教會-「花盛開福中」新希望教會福中萬花塢活動小站	臺北市士林區福港街129巷10弄12號1樓	121.51851654	25.08764839	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11449
兒童與少年服務	兒少活動小站	社團法人臺灣翔愛公益慈善協會-翻轉吧~孩子-兒少活動小站	臺北市士林區美崙街53號	121.52238464	25.09703255	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11450
兒童與少年服務	兒少活動小站	社團法人台北市文山區明興社區發展協會-明興巷弄兒少活動小站	臺北市文山區興隆路四段61號	121.55999756	24.98944283	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11451
兒童與少年服務	兒少活動小站	社團法人台灣守護有祢生命關懷協會-守護有祢兒童少年活動八禱活動小站	臺北市北投區奇岩里公舘路376巷2弄9號1樓	121.5039444	25.12334824	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11452
兒童與少年服務	兒少活動小站	社團法人台北市歐伊寇斯OIKOS社區關懷協會-小星光兒童少年活動小站	臺北市中正區杭州南路一段15-1號B1	121.52674866	25.04314613	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11453
兒童與少年服務	兒少活動小站	臺北市大安區古莊 社區發展協會-古莊兒童少年活動小站	臺北市大安區浦城街13巷20號	121.52778625	25.02440071	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11454
兒童與少年服務	兒少活動小站	社團法人中華民國基督教榮耀福音協會-勇士總動員-兒少活動小站	臺北市中山區成功里明水路636號	121.55134583	25.08284378	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11455
兒童與少年服務	兒少活動小站	臺北市南港區久如社區發展協會-活動小站	臺北市南港區九如里研究院路二段208號1樓	121.61710358	25.03666878	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11456
兒童與少年服務	兒少活動小站	財團法人基督教中華循理會內湖教會-社區弱勢兒少課業輔導暨品格成長營活動小站	臺北市內湖區環山路三段12號1樓	121.57907104	25.08468819	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11457
兒童與少年服務	兒少活動小站	社團法人臺北市放心窩社會互助協會-放心窩在社子島兒少活動小站	臺北市士林區延平北路八段93巷2號	121.48377228	25.10573959	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11458
兒童與少年服務	兒少活動小站	臺北市南港區聯成社區發展協會-歡樂窩.自在窩.安心窩-聯成兒少小站	臺北市南港區東新街77巷29號1樓	121.58834076	25.04766464	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11459
兒童與少年服務	兒少活動小站	財團法人台北市敦安社會福利基金會-「敦」親睦鄰「安」你心	臺北市中正區羅斯福路一段36號4樓	121.519104	25.03123856	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11460
兒童與少年服務	兒少活動小站	社團法人台北市士林全人關懷協會-士林兒少v小站	臺北市士林區文林路421巷30號2樓	121.52322388	25.09421349	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11461
兒童與少年服務	兒少活動小站	社團法人臺北市放心窩社會互助協會-放心窩在「放心窩」活動小站	臺北市大同區迪化街二段172巷11號1樓	121.50994873	25.06722832	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11462
兒童與少年服務	兒少活動小站	中華民國愛之語全人關懷教育協會-古亭兒童少年活動小站	臺北市中正區羅斯福路二段44號2樓	121.52152252	25.02796173	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11463
兒童與少年服務	兒少活動小站	社團法人臺北市臻佶祥社會服務協會-書屋花甲的咖啡夢想	臺北市中正區中華路二段307巷82號1樓	121.5056076	25.02884865	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11464
婦女服務	婦女館	臺北市婦女館	臺北市萬華區艋舺大道101號3樓	121.50138092	25.03347778	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11465
婦女服務	婦女暨家庭服務中心	士林婦女暨家庭服務中心	臺北市士林區基河路140號	121.52230835	25.08888054	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11466
婦女服務	婦女暨家庭服務中心	臺北市文山婦女支持培力中心	臺北市文山區興安里0鄰興隆路二段88號5樓	121.5490799	25.00047112	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11467
婦女服務	婦女暨家庭服務中心	臺北市松山南港婦女支持培力中心	臺北市松山區南京東路五段251巷46弄5號7樓	121.56482697	25.05335236	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11468
婦女服務	婦女暨家庭服務中心	臺北市大同士林婦女支持培力中心	臺北市大同區迪化街一段21號7樓	121.51032257	25.05449867	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11469
婦女服務	婦女暨家庭服務中心	臺北市新移民家庭服務中心	臺北市大同區迪化街一段21號7樓	121.51032257	25.05449867	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11470
婦女服務	婦女暨家庭服務中心	臺北市大安婦女支持培力中心	臺北市大安區延吉街246巷10號5樓	121.555336	25.0353241	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11471
婦女服務	婦女暨家庭服務中心	臺北市大直婦女支持培力中心	臺北市中山區大直街1號2樓	121.54698181	25.08029556	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11472
婦女服務	婦女暨家庭服務中心	臺北市內湖婦女支持培力中心	臺北市內湖區康樂街110巷16弄20號7樓	121.61838531	25.07037354	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11473
婦女服務	婦女暨家庭服務中心	臺北市文山婦女支持培力中心（景新）	臺北市文山區景行里17鄰景後街151號3樓	121.54191589	24.98999786	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11474
婦女服務	婦女暨家庭服務中心	臺北市北投婦女支持培力中心	臺北市北投區長安里1鄰中央北路一段12號6樓	121.50099945	25.13391304	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11475
婦女服務	婦女暨家庭服務中心	臺北市松德婦女暨家庭服務中心	臺北市信義區松德路25巷60號1樓	121.57752991	25.03779411	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11476
婦女服務	婦女暨家庭服務中心	臺北市萬華婦女支持培力中心	臺北市萬華區東園街19號4樓	121.4956665	25.02791405	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11477
婦女服務	婦女暨家庭服務中心	臺北市西區單親家庭服務中心	臺北市大同區迪化街一段21號7樓	121.51032257	25.05449867	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11478
婦女服務	婦女暨家庭服務中心	臺北市東區單親家庭服務中心	臺北市松山區南京東路五段251巷46弄5號7樓	121.56482697	25.05335236	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11479
婦女服務	婦女暨家庭服務中心	臺北市中正婦女支持培力中心	臺北市中正區南門里12鄰延平南路207號4樓	121.50766754	25.0328846	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11480
婦女服務	婦女暨家庭服務中心	臺北市信義婦女支持培力中心	臺北市信義區大仁里27鄰大道路116號8樓	121.58288574	25.03861618	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11481
婦女服務	新移民社區關懷據點	臺北市北區新移民社區關懷據點	臺北市士林區蘭雅里8鄰中山北路六段290巷7弄5號1樓	121.5262146	25.11043358	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11482
婦女服務	新移民社區關懷據點	臺北市西區新移民社區關懷據點	臺北市中正區延平南路270號4樓	121.50717926	25.03229904	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11483
婦女服務	新移民社區關懷據點	臺北市東區新移民社區關懷據點	臺北市南港區向陽路252號1樓	121.59337616	25.05799294	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11484
婦女服務	新移民社區關懷據點	臺北市南區新移民社區關懷據點	臺北市文山區萬祥里5鄰羅斯福路五段211巷23號1樓	121.53981018	25.00259972	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11485
婦女服務	新移民社區關懷據點	臺北市北區新移民社區關懷據點	臺北市北投區清江里清江路177巷12號1樓	121.50223541	25.12792397	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11486
貧困危機家庭服務	平價住宅	延吉平宅	臺北市大安區延吉街236巷17號	121.55516052	25.03639793	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11487
貧困危機家庭服務	平價住宅	安康平宅	臺北市文山區興隆路四段103號3樓	121.56060028	24.98800468	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11488
貧困危機家庭服務	平價住宅	大同之家	臺北市北投區東昇路12巷4號	121.52305603	25.14614296	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11489
貧困危機家庭服務	平價住宅	福民平宅	臺北市萬華區西園路二段320巷57號	121.49098969	25.02757835	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11490
貧困危機家庭服務	社會福利服務中心	臺北市政府社會局士林社會福利服務中心	臺北市士林區基河路140號1樓	121.52230835	25.08888054	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11491
貧困危機家庭服務	社會福利服務中心	臺北市政府社會局大同社會福利服務中心	臺北市大同區昌吉街57號6樓	121.51514435	25.06601906	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11492
貧困危機家庭服務	社會福利服務中心	臺北市政府社會局大安社會福利服務中心	臺北市大安區四維路198巷30弄5號2樓之9	121.54590607	25.02657509	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11493
貧困危機家庭服務	社會福利服務中心	臺北市政府社會局中山社會福利服務中心	臺北市中山區合江街137號3樓	121.53932953	25.06165504	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11494
貧困危機家庭服務	社會福利服務中心	臺北市政府社會局中正社會福利服務中心	臺北市中正區延平南路207號6樓	121.50766754	25.0328846	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11495
貧困危機家庭服務	社會福利服務中心	臺北市政府社會局內湖社會福利服務中心	臺北市內湖區星雲街161巷3號4樓	121.59613037	25.0811367	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11496
貧困危機家庭服務	社會福利服務中心	臺北市政府社會局文山社會福利服務中心	臺北市文山區興隆路二段160號6樓	121.55140686	25.00157356	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11497
貧困危機家庭服務	社會福利服務中心	臺北市政府社會局北投社會福利服務中心	臺北市北投區新市街30號5樓	121.50241089	25.13248253	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11498
貧困危機家庭服務	社會福利服務中心	臺北市政府社會局松山社會福利服務中心	臺北市松山區民生東路五段163之1號9樓	121.56258392	25.05905724	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11499
貧困危機家庭服務	社會福利服務中心	臺北市政府社會局信義社會福利服務中心	臺北市信義區松隆路36號5樓	121.56754303	25.04339409	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11500
貧困危機家庭服務	社會福利服務中心	臺北市政府社會局南港社會福利服務中心	臺北市南港區市民大道八段367號3樓	121.60793304	25.05376053	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11501
貧困危機家庭服務	社會福利服務中心	臺北市政府社會局萬華社會福利服務中心	臺北市萬華區梧州街36號5樓	121.49748993	25.03737068	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11502
貧困危機家庭服務	培力基地	轉角培力基地	臺北市中正區南陽街23巷1號	121.51654816	25.04381371	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11503
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」樟林社區據點	臺北市文山區光輝路87巷3號2樓	121.55719757	24.98562622	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11504
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」榮光社區據點	臺北市北投區石牌路一段166巷43弄15號1樓	121.51500702	25.11403084	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11505
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」奇岩社區據點	臺北市北投區公舘路315號1樓	121.50579071	25.1240406	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11506
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」吉慶社區據點	臺北市北投區實踐街34號3樓	121.50863647	25.11506462	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11507
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」立賢社區據點	臺北市北投區承德路七段232巷16號3樓	121.50737	25.11572647	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11508
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」立群社區據點	臺北市北投區尊賢街251巷18號1樓	121.5056839	25.11770058	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11509
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」秀山社區據點	臺北市北投區秀山里中和街502巷2弄15號1樓	121.4949646	25.14557076	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11510
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」清江社區據點	臺北市北投區清江里崇仁路一段83號5樓之1 	121.50174713	25.12591171	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11511
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」復建社區據點	臺北市松山區光復南路6巷26弄3號	121.55704498	25.04741478	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11512
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」雙和社區據點	臺北市信義區吳興街284巷24弄12號	121.56310272	25.02431679	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11513
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」永安社區據點	臺北市信義區忠孝東路五段236巷10弄10號3樓	121.5714035	25.04012871	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11514
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」舊莊社區據點	臺北市南港區舊莊街一段145巷6弄39號	121.62221527	25.03961754	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11515
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」好厝邊社區據點	臺北市南港區研究院路二段12巷57弄38號1樓	121.61360168	25.04813957	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11516
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」鴻福社區據點	臺北市南港區鴻福里成福路82號	121.58655548	25.04385185	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11517
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」久如社區據點	臺北市南港區研究院路二段208號	121.61710358	25.03666878	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11518
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」華江社區據點	臺北市萬華區華江里長順街14巷1弄2號	121.48970795	25.03133774	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11519
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」保德社區據點	臺北市萬華區東園街154巷9弄2號	121.49708557	25.02282715	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11520
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」孝德社區據點	臺北市萬華區德昌街185巷68號	121.49302673	25.0224247	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11521
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」馬場町社區據點	臺北市萬華區水源路195號4樓之4 	121.50919342	25.02322769	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11522
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」青年社區據點	臺北市萬華區新和里中華路二段416巷11之2號	121.50418854	25.02662277	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11523
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」朱厝崙社區據點	臺北市中山區龍江路12號	121.54027557	25.04766655	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11524
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」新力行社區據點	臺北市中山區長安東路二段163-1號	121.54016113	25.0484333	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11525
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」中原社區據點	臺北市中山區新生北路二段77巷1-1號2樓	121.5280838	25.05690002	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11526
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」泰和社區據點	臺北市信義區泰和里松仁路308巷60號	121.57008362	25.0212841	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11527
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」大道社區據點	臺北市信義區大道里忠孝東路五段790巷23弄12號2樓	121.58282471	25.0428009	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11528
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」安康社區據點	臺北市信義區安康里虎林街232巷63號	121.57596588	25.03573227	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11529
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」國慶社區據點	臺北市大同區重慶北路三段136巷20號	121.51289368	25.06767082	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11530
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」淡水河邊社區據點	臺北市大同區延平北路三段124號	121.51083374	25.0675602	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11531
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」林泉社區據點	臺北市北投區林泉里中心街27巷17號1樓	121.51035309	25.13833237	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11532
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」學府社區據點	臺北市大安區學府里羅斯福路四段119巷68弄15號	121.53972626	25.00936127	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11533
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」岩山社區據點	臺北市士林區岩山里芝玉路一段197巷1號	121.53339386	25.10755539	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11534
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」明勝社區據點	臺北市士林區明勝里承德路四段12巷57號3樓	121.51957703	25.08098221	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11535
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」灣仔社區據點	臺北市內湖區民權東路六段180巷72弄6號10樓之1	121.59210205	25.06613922	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11536
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」聯成社區據點	臺北市南港區聯成里東新街77巷29號1樓	121.58834076	25.04766464	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11537
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」幸福永和社區據點	臺北市北投區永和里行義路96巷25號3樓	121.52900696	25.12726212	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11538
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」忠駝社區據點	臺北市信義區西村里基隆路一段364巷24號7樓	121.55903625	25.03491211	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11539
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」我愛石牌社區據點	臺北市北投區石牌里明德路89號4樓	121.51880646	25.10899734	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11540
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」新忠社區據點	臺北市萬華區新忠里西藏路125巷15號3樓	121.50246429	25.02822685	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11541
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」挹翠社區據點	臺北市信義區六合里紫雲街23號1樓	121.57436371	25.01861191	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11542
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」松友社區據點	臺北市信義區松友里信義路六段76巷2弄22號	121.57613373	25.03439522	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11543
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」富洲社區據點	臺北市士林區延平北路八段86號	121.48439026	25.1058197	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11544
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」福佳社區據點	臺北市士林區美崙街49巷19號1樓	121.52204132	25.09667206	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11545
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」溪山社區據點	臺北市士林區至善路三段87號	121.5670166	25.11364174	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11546
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」幸福名山社區據點	臺北市士林區雨聲街53巷6號7樓	121.52832031	25.1026001	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11547
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」慶安社區據點	臺北市大同區重慶北路三段383巷3號4樓	121.514328	25.0759716	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11548
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」圓環社區據點	臺北市大同區重慶北路一段83巷37號6樓	121.51546478	25.05294609	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11549
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」錦華社區據點	臺北市大安區羅斯福路二段35巷19弄6號	121.52294922	25.02820969	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11550
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」安東社區據點	臺北市大安區安東街28號1樓	121.54244995	25.04427338	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11551
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」古風社區據點	臺北市大安區泰順街60巷2-1號	121.53092194	25.02227592	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11552
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」欣龍陣社區據點	臺北市大安區瑞安街65-1號4樓	121.54161072	25.02877426	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11553
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」新民炤社區據點	臺北市大安區建國南路一段286巷35號1樓	121.53580475	25.03619957	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11554
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」古莊社區據點	臺北市大安區羅斯福路二段81巷16弄1-2號2樓	121.52474213	25.02535057	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11555
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」大直社區據點	臺北市中山區北安路573巷6號	121.54754639	25.08128738	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11556
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」文祥社區據點	臺北市中正區金山南路一段100號1樓	121.52740479	25.03572273	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11557
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」南機場社區據點	臺北市中正區中華路二段303巷14號	121.50532532	25.02950668	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11558
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」新永昌社區據點	臺北市中正區汀州路一段232號4樓	121.51004791	25.02744102	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11559
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」新營社區據點	臺北市中正區寧波東街16巷2號	121.52065277	25.03236198	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11560
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」白石湖社區據點	臺北市內湖區碧山路40-3號	121.58834839	25.10344887	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11561
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」碧湖社區據點	臺北市內湖區內湖路三段294號	121.58493042	25.08917046	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11562
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」忠順社區據點	臺北市文山區興隆路四段145巷30號1樓	121.56311798	24.9851799	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11563
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」順興社區據點	臺北市文山區興隆路四段165巷12號2樓	121.56257629	24.98407173	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11564
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」明興社區據點	臺北市文山區木柵路二段109巷34號2樓	121.56375885	24.99076462	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11565
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」景慶社區據點	臺北市文山區景福街147-1號1樓	121.53639221	24.99567032	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11566
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」硫磺谷社區據點	臺北市北投區豐年里中央北路二段17號4樓	121.49612427	25.13641167	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11567
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」振華社區據點	臺北市北投區振華里裕民一路40巷29號3樓	121.51780701	25.11546516	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11568
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」永寬社區據點	臺北市中正區永昌里寧波西街181巷-8號1樓	121.51040649	25.02660179	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11569
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」中正新城社區據點	臺北市萬華區忠貞里青年路66號4樓之3	121.50273132	25.02424431	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11570
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」萬大社區據點	臺北市萬華區萬大路387巷39號3樓	121.49986267	25.02173424	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11571
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」住安社區據點	臺北市大安區住安里信義路四段60-12號1樓	121.54562378	25.03313446	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11572
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」愛在大學里社區據點	臺北市大安區大學里新生南路三段68之4號	121.53366089	25.01968575	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11573
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」芝山岩社區據點	臺北市士林區雨聲街8巷1-1號2樓	121.52948761	25.1014576	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11574
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」康福社區據點	臺北市士林區承德路四段40巷73號2樓	121.52111816	25.08145523	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11575
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」德行繽紛社區據點	臺北市士林區德行里福國路58號1樓	121.52336884	25.10216522	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11576
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」紫雲社區據點	臺北市內湖區紫雲里康寧路一段206號	121.59539795	25.07849312	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11577
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」大湖居安社區據點	臺北市內湖區大湖里大湖山莊街219巷29號	121.59983826	25.08901978	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11578
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」萬和社區據點	臺北市文山區溪洲街12號5樓之10	121.534729	25.00635529	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11579
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」德芳社區據點	臺北市文山區興邦里興隆路二段153巷6弄5號	121.54814148	25.001297	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11580
社區服務、NPO	「咱ㄟ社區」服務據點	「咱ㄟ社區」中央社區據點	臺北市北投區中央里光明路56號1樓	121.49977875	25.1327076	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11581
社區服務、NPO	NPO培力基地	台北NPO聚落	臺北市中正區龍光里13鄰重慶南路三段2號	121.51516724	25.02960968	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11582
社區服務、NPO	志願服務推廣中心	臺北市志願服務推廣中心	臺北市信義區信義路五段5段15號5樓	121.56689453	25.03314781	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11583
保護性服務	男士成長暨家庭服務中心	臺北市男士成長暨家庭服務中心-城男舊事心驛站	臺北市松山區敦化北路199巷5號3樓	121.55152893	25.05699539	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11584
保護性服務	親子會面中心	同心園臺北市親子會面中心	臺北市中正區新生南路一段54巷5弄2號	121.5321579	25.04141235	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11585
保護性服務	家庭暴力暨性侵害防治中心-分區辦公室	分區辦公室-臺北市政府駐地方法院處理家庭暴力暨家事事件聯合服務中心	臺北市士林區忠誠路二段53巷7號	121.53237915	25.11142349	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11586
保護性服務	家庭暴力暨性侵害防治中心-分區辦公室	分區辦公室-財團法人天主教善牧社會福利基金會(兒童少年保護及監護個案家庭處遇服務方案)	臺北市士林區忠誠路二段53巷7號	121.53237915	25.11142349	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11587
保護性服務	家庭暴力暨性侵害防治中心-分區辦公室	分區辦公室-台北市婦女救援基金會/目睹家暴兒少輔導方案	臺北市士林區忠誠路二段53巷7號8樓	121.53237915	25.11142349	2023-09-18 07:43:15.420088+00	2023-09-18 07:43:15.420088+00	11588
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: speeddata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.speeddata ("編號", "功能", "設置路段", "設置地點", "經度", "緯度", "轄區", "拍攝方向", "速度限制") FROM stdin;
1	測速	環河北路3段	葫蘆街	121.5073719	25.08245929	士林分隊	南向北	50
2	測速	仰德大道2段	115巷口	121.5460187	25.10824082	士林分隊	下山方向	40
3	測速	仰德大道4段75號	格致中學前	121.5464555	25.13206152	士林分隊	上下山雙向	40
4	測速	承德路4段	百齡高中前	121.5229866	25.08651629	士林分隊	南向北	50
5	闖紅燈	中正路	與基河路口	121.5198312	25.09323	士林分隊	西向東	50
6	闖紅燈	中正路	重慶北路口	121.5112072	25.08707284	士林分隊	西向東	50
7	闖紅燈	中山北路5段	378巷(消防隊)	121.5275728	25.08998891	士林分隊	南向北	50
8	測速	仰德大道2段	29巷口	121.5425043	25.10405783	士林分隊	下山方向	40
9	測速	環河北路2段	近敦煌路	121.5082596	25.07897186	大同分隊	北向南	60
10	測速	承德路4段	通河街	121.5222158	25.08035547	大同分隊	北向南	50
11	測速	承德路3段	敦煌路	121.5199333	25.07450558	大同分隊	南北雙向	50
12	闖紅燈	承德路2段	錦西街口	121.5182331	25.06042103	大同分隊	北向南	50
13	測速(兼闖紅燈)	台北橋機車道下橋	民權西路  延平北路	121.5108324	25.06287864	大同分隊	西向東	50
14	闖紅燈	承德路	市民大道口(東北)	121.5167646	25.04887127	大同分隊	東向西	40
15	測速	基隆高架道	下敦化南路段	121.5459226	25.01850222	大安分隊	南向北	60
16	測速	辛亥路3段	157巷(下北二高)	121.548786	25.01722043	大安分隊	東向西	50
17	測速	新生南路	金華街口	121.5336904	25.03034497	大安分隊	北向南	50
18	測速	和平東路1段	國立師範大學前	121.5267673	25.02673255	大安分隊	西向東	50
19	測速	建國南路2段	179號往北	121.5378418	25.02772621	大安分隊	南向北	50
20	測速	市民大道3段	214號前	121.5399541	25.0444703	大安分隊	西向東	40
21	測速	基隆路3段	長興街	121.5438055	25.01659683	直三分隊	南向北	50
22	測速	建國高架道	和平東路上方	121.5376363	25.02612189	直三分隊	北向南	70
23	測速	新生南路3段	58號台大側門	121.534073	25.02003322	直三分隊	南向北	50
24	闖紅燈	辛亥路2段	台大語文中心(快車道)	121.5410337	25.02125585	大安分隊	西向東	50
25	闖紅燈	辛亥路2段	復興南路口	121.5430271	25.02104591	大安分隊	西向東	50
26	闖紅燈	和平東路3段	228巷	121.554377	25.02259143	大安分隊	西向東	50
27	闖紅燈	敦化南路2段	和平東路	121.5486589	25.02492164	大安分隊	北向南	50
28	測速	建國高架道	長春路入口	121.5367159	25.05268643	中山分隊	北向南	70
29	測速	新生北路高架道	民族東路入口(往南)	121.527737	25.066527	中山分隊	北向南	70
30	測速	復興北路	車行地下道北出口處	121.5443293	25.07178967	中山分隊	南向北	40
31	測速	樂群一路	基湖路口西往東天橋下(金泰公園)	121.5663528	25.07656613	中山分隊	西向東	50
32	測速	明水路	325號	121.5407676	25.07762563	中山分隊	東西雙向	50
33	測速	市民高架道	下建國南路	121.5424435	25.04463181	中正一分隊	東西雙向	80
34	測速	北安路	海軍司令部前	121.5363861	25.07790066	中山分隊	東西雙向	50
35	闖紅燈	民權東路	建國北路口	121.5371673	25.06208253	中山分隊	南向北	50
36	闖紅燈	民生東路3段	遼寧街口（台北大學前）	121.5418913	25.05779164	中山分隊	西向東	50
37	闖紅燈	北安路	明水路（劍南路口前端）	121.5530596	25.08565489	中山分隊	東向西	50
38	闖紅燈	松江路	民族東路	121.5331012	25.06849636	中山分隊	北向南	50
39	闖紅燈	建國北路1段	長安東路口	121.5368553	25.0481484	中山分隊	南向北	50
40	闖紅燈	復興北路	民生東路	121.5441309	25.0581323	中山分隊	北向南	50
41	闖紅燈	中山北路2段	民生西路	121.522798	25.05835785	中山分隊	北向南	50
42	闖紅燈、測速	中山北路2段	長春路口	121.5227702	25.05473185	中山分隊	南往北	50
43	闖紅燈	松江路	農安街口	121.5332619	25.06446188	中山分隊	南向北	50
44	測速(兼闖紅燈)	建國北路	農安街口	121.5365678	25.06500011	中山分隊	北向南	50
45	測速	中華路1段	５３號前	121.508633	25.04308855	中正一分隊	南向北	50
46	測速	仁愛路2段	(61號前右車道)臨沂街口	121.5301224	25.03827359	中正一分隊	東向西	50
47	測速	市民大道(高架道)	京站百貨前	121.5198336	25.04820806	中正一分隊	西向東	80
48	測速	行義路	241號	121.5286791	25.13483514	北投分隊	北向南	40
49	闖紅燈	中山南路	濟南路口	121.5189036	25.04299561	中正一分隊	南向北	50
50	闖紅燈	金山南路	銅山街口	121.5286872	25.03927407	中正一分隊	南向北	50
51	闖紅燈	中華路1段	貴陽路口	121.507326	25.03895031	中正一分隊	南向北	50
52	闖紅燈	忠孝東路1段	林森南路口	121.5236733	25.0447496	中正一分隊	東向西	50
53	測速	重慶南路3段	27巷口	121.5156319	25.02855774	中正二分隊	南北雙向	50
54	測速	水源快速道路	同安街口	121.5201766	25.02085895	中正二分隊	南向北	60
55	闖紅燈	和平西路2段	寧波西街口	121.5125242	25.02882606	中正二分隊	東向西	50
56	闖紅燈	重慶南路3段	和平西路口	121.5158286	25.0277892	中正二分隊	北向南	50
57	闖紅燈	和平西路	寧波西街口	121.5118	25.0291821	中正二分隊	西向東	50
58	測速(兼闖紅燈)	仰德大道3段	陽明山國小前	121.5529741	25.1198821	士林分隊	往下山方向	40
59	測速	金湖路	200號前	121.6002407	25.07784255	內湖分隊	南向北	50
60	測速	文德路	66巷口	121.5809448	25.07845548	內湖分隊	西向東	50
61	測速	環東大道	(南京東路6段368巷口上方)	121.5863778	25.05977875	內湖分隊	東向西	80
62	測速	潭美街	新明路460巷	121.5785384	25.05339912	內湖分隊	西向東	40
63	測速	行善路233號	行善路231向巷	121.5832953	25.06103681	內湖分隊	西向東	50
64	測速	成功路2段	373號	121.5899919	25.07465666	內湖分隊	北向南	50
65	測速	內湖路1段	324號	121.5700568	25.08177943	內湖分隊	西向東	50
66	測速	成功路5段	152巷口	121.6040906	25.08303808	內湖分隊	西向東	50
67	闖紅燈	瑞光路	199號前(陽光街口)	121.5794224	25.07356672	內湖分隊	南向北	50
68	闖紅燈	成功路2段	250巷口	121.5904926	25.06581593	內湖分隊	往內湖方向	50
69	闖紅燈	環山路1段	136巷口	121.5692319	25.08647666	內湖分隊	東向西	50
70	闖紅燈	內湖路1段	120巷（西向東）	121.5632405	25.08334131	內湖分隊	西向東	50
71	闖紅燈	南京東路6段	新明路426巷口	121.5788821	25.05560475	內湖分隊	西向東	40
72	闖紅燈	民權東路6段	136巷（東向西）	121.5880359	25.06908817	內湖分隊	西向東	50
73	測速	民權東路6段	423巷口	121.6042394	25.07128214	內湖分隊	東向西	50
74	測速	信義快速道路	文山隧道往南出口處	121.5811719	25.00894152	文山一分隊	北向南	70
75	測速	木柵路5段	木柵路5段近100之1號	121.5913957	24.99909565	文山一分隊	西向東	50
76	測速	辛亥路6段	懷恩隧道出口處（往木柵）	121.551479	24.99169061	文山一分隊	北向南	50
77	闖紅燈	辛亥路7段	光輝路50巷口	121.5540591	24.98503531	文山一分隊	北向南	50
78	闖紅燈	木柵路1段	和興路	121.5457883	24.98669111	文山一分隊	西向東	50
79	闖紅燈	木柵路5段	萬福橋頭	121.5844065	25.00307399	文山一分隊	東向西	50
80	測速	水源快速道路	下(離開水快)景福匝道口(上層)(水南)	121.535252	24.9993046	中正二分隊	北向南	60
81	測速	羅斯福路6段	226號前	121.5407211	24.99258379	文山二分隊	北向南	50
82	測速	辛亥路4段	辛亥隧道出口	121.5573735	25.0097526	文山二分隊	北向南	50
83	測速	羅斯福路5段	240號前(近興隆路口)	121.5391158	25.00150067	文山二分隊	北向南	50
84	測速	羅斯福路6段	469巷前(近育英街口)	121.5396629	24.98975499	文山二分隊	南向北	50
85	測速	陽金公路53號燈桿後方	竹子湖路2-2號對面	121.5437191	25.16491378	北投分隊	往臺北市區	40
86	測速	承德路6段	承德路6段1	121.5119366	25.10519124	北投分隊	北向南	60
87	測速	洲美快速道路(南向避車彎處)	洲美快速道路(南向避車彎處)	121.4987819	25.10799039	北投分隊	北向南	80
88	測速	承德路6段	承德路6段2	121.5120888	25.10394721	北投分隊	南往北	60
89	測速	洲美快速道路(北向避車彎處)	洲美快速道路(北向避車彎處)	121.4989647	25.10597159	北投分隊	南向北	80
90	測速	大業路	412號前	121.4967385	25.13033974	北投分隊	南向北	60
91	測速	大度路	往台北方向	121.4777581	25.12242044	北投分隊	北向南	70
92	測速	大度路	往淡水方向	121.4803609	25.12239283	北投分隊	南向北	70
93	測速	學園路(往關渡)	臺北藝術大學大門口	121.4659106	25.13011342	北投分隊	下山方向	40
94	測速	立賢路101號前	立賢路101號前	121.5025111	25.11441174	北投分隊	南往北	50
95	闖紅燈	承德路7段	吉利街口	121.5036323	25.11760608	北投分隊	北向南	60
96	闖紅燈	文林北路	明德路口	121.5163087	25.10638054	北投分隊	北向南	50
97	闖紅燈	大度路	大業路口	121.4993992	25.12158936	北投分隊	北向南	50
98	測速	民生東路4段	97巷口	121.5518524	25.05794115	松山分隊	西向東	50
99	測速	復興北路	車行地下道南出口處	121.5443102	25.06684145	松山分隊	北向南	40
100	測速	健康路	300號	121.5656356	25.05426405	松山分隊	東西雙向	50
101	測速	塔悠路	近撫遠街261巷口	121.5684999	25.06200353	松山分隊	北向南	50
102	測速	民權東路4段	民權公園前	121.5574655	25.06210619	松山分隊	東西雙向	50
103	闖紅燈	敦化南路	八德路口	121.5489474	25.04785991	松山分隊	南往北	50
104	闖紅燈	民權東路4段	三民路	121.563371	25.0628743	松山分隊	東向西	50
105	測速	市民高架道	下光復南路	121.552151	25.04447883	中正一分隊	東西雙向	80
106	測速	市民大道5段	50號前(近東寧路口)	121.5639723	25.04762719	信義分隊	西向東	50
107	測速	忠孝東路4段 	近逸仙路口	121.5598827	25.04131564	信義分隊	東西雙向	50
108	闖紅燈	永吉路	松信路口	121.5724454	25.0456259	中正一分隊	東向西	50
109	闖紅燈	松仁路	松壽路口	121.568355	25.03614952	信義分隊	北向南	50
110	闖紅燈	基隆路	與松壽路口	121.5613352	25.03620119	信義分隊	北向南	50
111	闖紅燈	光復南路	456巷	121.5574887	25.03577554	信義分隊	北向南	50
112	測速	市民大道8段	東南街口	121.6132704	25.05418829	南港分隊	東向西	50
113	測速	忠孝東路7段	511號前	121.6115478	25.05263792	南港分隊	西向東	50
114	測速	市民大道7段	近昆陽街口	121.5917964	25.0509968	南港分隊	東往西	50
115	測速	三重路	19-5號前	121.6140194	25.0573762	南港分隊	北向南	50
116	測速	市民大道7段	東新街  往東約100公尺處(忠孝東路6段159巷口)　	121.586234	25.04997103	南港分隊	西向東	50
117	測速	市民大道8段	500號	121.6123379	25.05393791	南港分隊	西往東	50
118	測速(兼闖紅燈)	忠孝東路6段	159巷	121.5868439	25.0487819	南港分隊	東向西	50
119	測速	水源路	205號前	121.5029526	25.01935386	萬華分隊	東向西	60
120	測速	艋舺大道	297號台糖公司前	121.4966843	25.03301693	萬華分隊	東向西	50
121	測速	萬板大橋	台北端引道	121.4897124	25.03051254	萬華分隊	往台北市	50
122	測速	環河南路快速道路	中興橋匝道(環河南路2段250巷口)	121.5004223	25.04378495	萬華分隊	北向南	60
123	測速	和平西路3段	199號前	121.4971925	25.03531226	萬華分隊	西向東	50
124	測速	環河南路1段	77號對面	121.501135	25.04454625	萬華分隊	北向南	50
125	測速	華中橋頭(往北、往南)	萬大路	121.4971515	25.01908628	萬華分隊	南北雙向	50
126	測速	中華路1段	往南(萬華406號廣場前）	121.5074916	25.04001469	萬華分隊	北向南	50
127	闖紅燈	艋舺大道	120巷口	121.5025393	25.03328791	萬華分隊	東向西	50
128	闖紅燈	艋舺大道	雙園街	121.4932307	25.03027803	萬華分隊	西向東	50
129	測速	承德路4段	福港街	121.5181826	25.08986347	士林分隊	北往南	50
130	闖紅燈	西園路2段	140巷	121.4962426	25.02990258	萬華分隊	南向北	50
131	闖紅燈及路口淨空	南京東路3段	復興北路口	121.5441607	25.05137764	松山分隊	南向北	\\
132	闖紅燈及路口淨空	中山北路4段	通河街口	121.5245334	25.07951372	士林分隊	南向北	\\
133	闖紅燈及路口淨空	民生西路	承德路2段口	121.5181914	25.0569504	大同分隊	南向北	\\
134	闖紅燈及路口淨空	光復南路	信義路4段口北側	121.5569768	25.0331966	大安分隊	西向東	\\
135	測速	環河北路2段	昌吉街口	121.5088674	25.06589275	大同分隊	南北雙向	50
136	測速	南京東路4段	健康路口	121.5530366	25.05169217	松山分隊	東西雙向	50
137	測速	中山南路	近濟南路1段口	121.5189067	25.04297255	中正一分隊	北向南	50
138	區間測速及跨越雙白線	自強隧道	\N	121.5492556	25.09060141	\N	南北雙向	50
139	區間測速及跨越雙白線	辛亥隧道	\N	121.5553515	25.01171385	\N	南北雙向	50
140	測速	潭美街223號對面	潭美街223號對面	121.5856236	25.0561559	內湖分隊	東西雙向	40
141	測速	基隆路二段109號前往北	基隆路二段109號前往北	121.5573087	25.02906139	信義分隊	南往北	50
142	測速	民權東路6段	228號前	121.5996961	25.06679101	內湖分隊	西向東	50
143	闖紅燈、測速	中山北路5段	中正路口	121.5277694	25.0961568	中山分隊	北向南	50
144	闖紅燈、測速	西園路2段	光復橋頭往新北市	121.4927469	25.02610889	萬華分隊	東西雙向	50
145	測速	基隆路1段49號前	基隆路1段49號前	121.5684952	25.04768719	信義分隊	南向北	50
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
-- Name:  building_publand_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public." building_publand_ogc_fid_seq"', 1, true);


--
-- Name: SOCL_export_filter_ppl_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."SOCL_export_filter_ppl_ogc_fid_seq"', 1, true);


--
-- Name: app_calcu_daily_sentiment_voice1999_109_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_daily_sentiment_voice1999_109_ogc_fid_seq', 67090, true);


--
-- Name: app_calcu_hour_traffic_info_histories_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_hour_traffic_info_histories_ogc_fid_seq', 15701, true);


--
-- Name: app_calcu_hour_traffic_youbike_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_hour_traffic_youbike_ogc_fid_seq', 22724, true);


--
-- Name: app_calcu_hourly_it_5g_smart_all_pole_device_log_dev13_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_hourly_it_5g_smart_all_pole_device_log_dev13_seq', 4172815, true);


--
-- Name: app_calcu_month_traffic_info_histories_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_month_traffic_info_histories_ogc_fid_seq', 1128, true);


--
-- Name: app_calcu_monthly_socl_welfare_people_ppl_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_monthly_socl_welfare_people_ppl_seq', 247, true);


--
-- Name: app_calcu_patrol_rainfall_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_patrol_rainfall_ogc_fid_seq', 612676, true);


--
-- Name: app_calcu_sentiment_dispatch_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_sentiment_dispatch_ogc_fid_seq', 1, true);


--
-- Name: app_calcu_traffic_todaywork_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_traffic_todaywork_ogc_fid_seq', 4690, true);


--
-- Name: app_calcu_weekly_dispatching_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_weekly_dispatching_ogc_fid_seq', 8615, true);


--
-- Name: app_calcu_weekly_hellotaipei_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_weekly_hellotaipei_ogc_fid_seq', 35582, true);


--
-- Name: app_calcu_weekly_metro_capacity_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_weekly_metro_capacity_ogc_fid_seq', 1, true);


--
-- Name: app_calcu_weekly_metro_capacity_threshould_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcu_weekly_metro_capacity_threshould_ogc_fid_seq', 1937419, true);


--
-- Name: app_calcul_weekly_hellotaipei_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_calcul_weekly_hellotaipei_ogc_fid_seq', 50276, true);


--
-- Name: app_traffic_lives_accident_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_traffic_lives_accident_ogc_fid_seq', 223, true);


--
-- Name: app_traffic_metro_capacity_realtime_stat_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.app_traffic_metro_capacity_realtime_stat_ogc_fid_seq', 391928384, true);


--
-- Name: building_age_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_age_ogc_fid_seq', 258569, true);


--
-- Name: building_cadastralmap_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_cadastralmap_ogc_fid_seq', 3438485, true);


--
-- Name: building_landuse_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_landuse_ogc_fid_seq', 1, true);


--
-- Name: building_license_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_license_history_ogc_fid_seq', 1, true);


--
-- Name: building_license_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_license_ogc_fid_seq', 1, true);


--
-- Name: building_permit_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_permit_history_ogc_fid_seq', 14018365, true);


--
-- Name: building_permit_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_permit_ogc_fid_seq', 869836, true);


--
-- Name: building_publand_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_publand_history_ogc_fid_seq', 1259841, true);


--
-- Name: building_publand_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_publand_ogc_fid_seq', 31804304, true);


--
-- Name: building_renewarea_10_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_renewarea_10_history_ogc_fid_seq', 136717, true);


--
-- Name: building_renewarea_10_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_renewarea_10_ogc_fid_seq', 131927, true);


--
-- Name: building_renewarea_40_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_renewarea_40_history_ogc_fid_seq', 33825, true);


--
-- Name: building_renewarea_40_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_renewarea_40_ogc_fid_seq', 33105, true);


--
-- Name: building_renewunit_12_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_renewunit_12_history_ogc_fid_seq', 407217, true);


--
-- Name: building_renewunit_12_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_renewunit_12_ogc_fid_seq', 392433, true);


--
-- Name: building_renewunit_20_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_renewunit_20_history_ogc_fid_seq', 16936, true);


--
-- Name: building_renewunit_20_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_renewunit_20_ogc_fid_seq', 4088, true);


--
-- Name: building_renewunit_30_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_renewunit_30_history_ogc_fid_seq', 51238740, true);


--
-- Name: building_renewunit_30_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_renewunit_30_ogc_fid_seq', 51190290, true);


--
-- Name: building_social_house_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_social_house_history_ogc_fid_seq', 46646, true);


--
-- Name: building_social_house_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_social_house_ogc_fid_seq', 41822, true);


--
-- Name: building_unsued_land_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_unsued_land_history_ogc_fid_seq', 19384, true);


--
-- Name: building_unsued_land_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_unsued_land_ogc_fid_seq', 19429, true);


--
-- Name: building_unsued_nonpublic_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_unsued_nonpublic_history_ogc_fid_seq', 2464, true);


--
-- Name: building_unsued_nonpublic_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_unsued_nonpublic_ogc_fid_seq', 2452, true);


--
-- Name: building_unsued_public_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_unsued_public_history_ogc_fid_seq', 20418, true);


--
-- Name: building_unsued_public_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.building_unsued_public_ogc_fid_seq', 19, true);


--
-- Name: cvil_public_opinion_evn_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cvil_public_opinion_evn_ogc_fid_seq', 8501, true);


--
-- Name: cvil_public_opinion_maintype_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cvil_public_opinion_maintype_ogc_fid_seq', 8, true);


--
-- Name: cvil_public_opinion_subtype_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cvil_public_opinion_subtype_ogc_fid_seq', 41, true);


--
-- Name: cwb_city_weather_forecast_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cwb_city_weather_forecast_history_ogc_fid_seq', 234168, true);


--
-- Name: cwb_city_weather_forecast_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cwb_city_weather_forecast_ogc_fid_seq', 234168, true);


--
-- Name: cwb_daily_weather_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cwb_daily_weather_ogc_fid_seq', 653280, true);


--
-- Name: cwb_hourly_weather_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cwb_hourly_weather_ogc_fid_seq', 15256546, true);


--
-- Name: cwb_now_weather_auto_station_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cwb_now_weather_auto_station_history_ogc_fid_seq', 2533563, true);


--
-- Name: cwb_now_weather_auto_station_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cwb_now_weather_auto_station_ogc_fid_seq', 2533563, true);


--
-- Name: cwb_now_weather_bureau_station_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cwb_now_weather_bureau_station_history_ogc_fid_seq', 1387607, true);


--
-- Name: cwb_now_weather_bureau_station_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cwb_now_weather_bureau_station_ogc_fid_seq', 1387607, true);


--
-- Name: cwb_rainfall_station_location_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cwb_rainfall_station_location_history_ogc_fid_seq', 25222, true);


--
-- Name: cwb_rainfall_station_location_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cwb_rainfall_station_location_ogc_fid_seq', 25222, true);


--
-- Name: cwb_town_weather_forecast_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cwb_town_weather_forecast_history_ogc_fid_seq', 258050, true);


--
-- Name: cwb_town_weather_forecast_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cwb_town_weather_forecast_ogc_fid_seq', 241344, true);


--
-- Name: edu_elementary_school_district_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_elementary_school_district_history_ogc_fid_seq', 1584, true);


--
-- Name: edu_elementary_school_district_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_elementary_school_district_ogc_fid_seq', 1584, true);


--
-- Name: edu_eleschool_dist_by_administrative_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_eleschool_dist_by_administrative_history_ogc_fid_seq', 6147, true);


--
-- Name: edu_eleschool_dist_by_administrative_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_eleschool_dist_by_administrative_ogc_fid_seq', 6147, true);


--
-- Name: edu_jhschool_dist_by_administrative_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_jhschool_dist_by_administrative_history_ogc_fid_seq', 5380, true);


--
-- Name: edu_jhschool_dist_by_administrative_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_jhschool_dist_by_administrative_ogc_fid_seq', 5380, true);


--
-- Name: edu_junior_high_school_district_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_junior_high_school_district_history_ogc_fid_seq', 891, true);


--
-- Name: edu_junior_high_school_district_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_junior_high_school_district_ogc_fid_seq', 891, true);


--
-- Name: edu_school_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_school_history_ogc_fid_seq', 5704, true);


--
-- Name: edu_school_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_school_ogc_fid_seq', 5704, true);


--
-- Name: edu_school_romm_status_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_school_romm_status_history_ogc_fid_seq', 1, true);


--
-- Name: edu_school_romm_status_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.edu_school_romm_status_ogc_fid_seq', 1, true);


--
-- Name: eoc_accommodate_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eoc_accommodate_history_ogc_fid_seq', 1, true);


--
-- Name: eoc_accommodate_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eoc_accommodate_ogc_fid_seq', 1, true);


--
-- Name: eoc_disaster_case_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eoc_disaster_case_history_ogc_fid_seq', 1, true);


--
-- Name: eoc_disaster_case_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eoc_disaster_case_ogc_fid_seq', 1, true);


--
-- Name: eoc_leave_house_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eoc_leave_house_history_ogc_fid_seq', 1, true);


--
-- Name: eoc_leave_house_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.eoc_leave_house_ogc_fid_seq', 1, true);


--
-- Name: ethc_building_check_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ethc_building_check_ogc_fid_seq', 25135, true);


--
-- Name: ethc_check_calcu_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ethc_check_calcu_ogc_fid_seq', 9685, true);


--
-- Name: ethc_check_summary_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ethc_check_summary_ogc_fid_seq', 651, true);


--
-- Name: ethc_fire_check_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ethc_fire_check_ogc_fid_seq', 9385, true);


--
-- Name: fire_hydrant_location_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fire_hydrant_location_history_ogc_fid_seq', 29966, true);


--
-- Name: fire_hydrant_location_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fire_hydrant_location_ogc_fid_seq', 1, true);


--
-- Name: fire_to_hospital_ppl_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fire_to_hospital_ppl_ogc_fid_seq', 2519111, true);


--
-- Name: heal_aed_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.heal_aed_history_ogc_fid_seq', 25751, true);


--
-- Name: heal_aed_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.heal_aed_ogc_fid_seq', 25751, true);


--
-- Name: heal_clinic_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.heal_clinic_history_ogc_fid_seq', 39851, true);


--
-- Name: heal_clinic_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.heal_clinic_ogc_fid_seq', 39851, true);


--
-- Name: heal_hospital_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.heal_hospital_history_ogc_fid_seq', 380, true);


--
-- Name: heal_hospital_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.heal_hospital_ogc_fid_seq', 380, true);


--
-- Name: heal_suicide_evn_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.heal_suicide_evn_ogc_fid_seq', 7091, true);


--
-- Name: it_5G_smart_pole_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."it_5G_smart_pole_ogc_fid_seq"', 1, true);


--
-- Name: it_5g_smart_all_pole_device_log_history_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_5g_smart_all_pole_device_log_history_seq', 6783542, true);


--
-- Name: it_5g_smart_all_pole_device_log_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_5g_smart_all_pole_device_log_ogc_fid_seq', 9384108, true);


--
-- Name: it_5g_smart_all_pole_log_history_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_5g_smart_all_pole_log_history_seq', 644, true);


--
-- Name: it_5g_smart_all_pole_log_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_5g_smart_all_pole_log_seq', 644, true);


--
-- Name: it_5g_smart_pole_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_5g_smart_pole_ogc_fid_seq', 6893026, true);


--
-- Name: it_signal_population_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_signal_population_history_ogc_fid_seq', 6078536, true);


--
-- Name: it_signal_population_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_signal_population_ogc_fid_seq', 6078536, true);


--
-- Name: it_signal_tourist_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_signal_tourist_history_ogc_fid_seq', 16738, true);


--
-- Name: it_signal_tourist_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_signal_tourist_ogc_fid_seq', 16720, true);


--
-- Name: it_taipeiexpo_people_flow_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_taipeiexpo_people_flow_history_ogc_fid_seq', 4314, true);


--
-- Name: it_taipeiexpo_people_flow_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_taipeiexpo_people_flow_ogc_fid_seq', 4314, true);


--
-- Name: it_tpe_ticket_event_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_tpe_ticket_event_ogc_fid_seq', 26437, true);


--
-- Name: it_tpe_ticket_member_hold_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_tpe_ticket_member_hold_ogc_fid_seq', 110050, true);


--
-- Name: it_tpe_ticket_place_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_tpe_ticket_place_ogc_fid_seq', 10702, true);


--
-- Name: it_tpe_ticket_ticket_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_tpe_ticket_ticket_ogc_fid_seq', 12670, true);


--
-- Name: it_tpefree_daily_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_tpefree_daily_history_ogc_fid_seq', 6478334, true);


--
-- Name: it_tpefree_daily_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_tpefree_daily_ogc_fid_seq', 100814877, true);


--
-- Name: it_tpefree_location_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_tpefree_location_history_ogc_fid_seq', 3802, true);


--
-- Name: it_tpefree_location_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_tpefree_location_ogc_fid_seq', 4142, true);


--
-- Name: it_tpefree_realtime_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_tpefree_realtime_history_ogc_fid_seq', 50558539, true);


--
-- Name: it_tpefree_realtime_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_tpefree_realtime_ogc_fid_seq', 92942265, true);


--
-- Name: it_tpmo_poc_location_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_tpmo_poc_location_history_ogc_fid_seq', 31968, true);


--
-- Name: it_tpmo_poc_location_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_tpmo_poc_location_ogc_fid_seq', 31968, true);


--
-- Name: it_venue_people_flow_history_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_venue_people_flow_history_seq', 647366, true);


--
-- Name: it_venue_people_flow_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.it_venue_people_flow_ogc_fid_seq', 1, true);


--
-- Name: mrtp_carweight_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mrtp_carweight_history_ogc_fid_seq', 7475523, true);


--
-- Name: mrtp_carweight_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mrtp_carweight_ogc_fid_seq', 7475523, true);


--
-- Name: patrol_artificial_slope_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_artificial_slope_history_ogc_fid_seq', 1, true);


--
-- Name: patrol_artificial_slope_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_artificial_slope_ogc_fid_seq', 383867, true);


--
-- Name: patrol_box_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_box_ogc_fid_seq', 18491, true);


--
-- Name: patrol_camera_hls_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_camera_hls_ogc_fid_seq', 1717, true);


--
-- Name: patrol_car_theft_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_car_theft_ogc_fid_seq', 518, true);


--
-- Name: patrol_criminal_case_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_criminal_case_ogc_fid_seq', 30376, true);


--
-- Name: patrol_debris_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_debris_history_ogc_fid_seq', 24204, true);


--
-- Name: patrol_debris_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_debris_ogc_fid_seq', 1726, true);


--
-- Name: patrol_debrisarea_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_debrisarea_history_ogc_fid_seq', 20521, true);


--
-- Name: patrol_debrisarea_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_debrisarea_ogc_fid_seq', 22384, true);


--
-- Name: patrol_designate_place_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_designate_place_history_ogc_fid_seq', 103170, true);


--
-- Name: patrol_designate_place_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_designate_place_ogc_fid_seq', 103748, true);


--
-- Name: patrol_district_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_district_ogc_fid_seq', 90, true);


--
-- Name: patrol_eoc_case_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_eoc_case_history_ogc_fid_seq', 10132, true);


--
-- Name: patrol_eoc_case_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_eoc_case_ogc_fid_seq', 9321, true);


--
-- Name: patrol_eoc_designate_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_eoc_designate_history_ogc_fid_seq', 1066, true);


--
-- Name: patrol_eoc_designate_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_eoc_designate_ogc_fid_seq', 1066, true);


--
-- Name: patrol_fire_brigade_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_fire_brigade_history_ogc_fid_seq', 19090, true);


--
-- Name: patrol_fire_brigade_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_fire_brigade_ogc_fid_seq', 19136, true);


--
-- Name: patrol_fire_disqualified_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_fire_disqualified_history_ogc_fid_seq', 7815, true);


--
-- Name: patrol_fire_disqualified_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_fire_disqualified_ogc_fid_seq', 7778, true);


--
-- Name: patrol_fire_rescure_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_fire_rescure_history_ogc_fid_seq', 416367, true);


--
-- Name: patrol_fire_rescure_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_fire_rescure_ogc_fid_seq', 415225, true);


--
-- Name: patrol_flood_100_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_flood_100_ogc_fid_seq', 3, true);


--
-- Name: patrol_flood_130_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_flood_130_ogc_fid_seq', 3, true);


--
-- Name: patrol_flood_78_8_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_flood_78_8_ogc_fid_seq', 3, true);


--
-- Name: patrol_motorcycle_theft_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_motorcycle_theft_ogc_fid_seq', 702, true);


--
-- Name: patrol_old_settlement_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_old_settlement_history_ogc_fid_seq', 1, true);


--
-- Name: patrol_old_settlement_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_old_settlement_ogc_fid_seq', 340, true);


--
-- Name: patrol_police_region_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_police_region_ogc_fid_seq', 90, true);


--
-- Name: patrol_police_station_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_police_station_history_ogc_fid_seq', 15488, true);


--
-- Name: patrol_police_station_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_police_station_ogc_fid_seq', 215783, true);


--
-- Name: patrol_police_station_ogc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_police_station_ogc_id_seq', 1, true);


--
-- Name: patrol_rain_floodgate_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_rain_floodgate_history_ogc_fid_seq', 3784767, true);


--
-- Name: patrol_rain_floodgate_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_rain_floodgate_ogc_fid_seq', 3776990, true);


--
-- Name: patrol_rain_rainfall_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_rain_rainfall_history_ogc_fid_seq', 15653401, true);


--
-- Name: patrol_rain_rainfall_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_rain_rainfall_ogc_fid_seq', 13849310, true);


--
-- Name: patrol_rain_sewer_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_rain_sewer_history_ogc_fid_seq', 8206620, true);


--
-- Name: patrol_rain_sewer_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_rain_sewer_ogc_fid_seq', 7905081, true);


--
-- Name: patrol_rain_sewer_ogc_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_rain_sewer_ogc_id_seq', 1, true);


--
-- Name: patrol_random_robber_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_random_robber_ogc_fid_seq', 20, true);


--
-- Name: patrol_random_snatch_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_random_snatch_ogc_fid_seq', 31, true);


--
-- Name: patrol_residential_burglary_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.patrol_residential_burglary_ogc_fid_seq', 3231, true);


--
-- Name: poli_traffic_violation_evn_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.poli_traffic_violation_evn_ogc_fid_seq', 1331036, true);


--
-- Name: poli_traffic_violation_mapping_code_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.poli_traffic_violation_mapping_code_ogc_fid_seq', 6, true);


--
-- Name: record_db_mtime_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.record_db_mtime_ogc_fid_seq', 227, true);


--
-- Name: sentiment_councillor_109_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sentiment_councillor_109_ogc_fid_seq', 8645017, true);


--
-- Name: sentiment_dispatching_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sentiment_dispatching_ogc_fid_seq', 2354258, true);


--
-- Name: sentiment_hello_taipei_109_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sentiment_hello_taipei_109_ogc_fid_seq', 841010535, true);


--
-- Name: sentiment_hello_taipei_109_test_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sentiment_hello_taipei_109_test_ogc_fid_seq', 9601315, true);


--
-- Name: sentiment_hotnews_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sentiment_hotnews_ogc_fid_seq', 2147485712, true);


--
-- Name: sentiment_voice1999_109_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sentiment_voice1999_109_ogc_fid_seq', 38542042, true);


--
-- Name: socl_case_study_ppl_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_case_study_ppl_ogc_fid_seq', 210, true);


--
-- Name: socl_dept_epidemic_info_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_dept_epidemic_info_ogc_fid_seq', 15600, true);


--
-- Name: socl_domestic_violence_evn_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_domestic_violence_evn_ogc_fid_seq', 28494, true);


--
-- Name: socl_export_filter_ppl_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_export_filter_ppl_ogc_fid_seq', 1186, true);


--
-- Name: socl_order_concern_mapping_code_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_order_concern_mapping_code_ogc_fid_seq', 42, true);


--
-- Name: socl_order_concern_ppl_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_order_concern_ppl_ogc_fid_seq', 270588, true);


--
-- Name: socl_welfare_dis_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_welfare_dis_history_ogc_fid_seq', 2232259, true);


--
-- Name: socl_welfare_dis_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_welfare_dis_ogc_fid_seq', 9490987, true);


--
-- Name: socl_welfare_dislow_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_welfare_dislow_history_ogc_fid_seq', 90324, true);


--
-- Name: socl_welfare_dislow_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_welfare_dislow_ogc_fid_seq', 158138, true);


--
-- Name: socl_welfare_low_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_welfare_low_history_ogc_fid_seq', 711436, true);


--
-- Name: socl_welfare_low_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_welfare_low_ogc_fid_seq', 1254473, true);


--
-- Name: socl_welfare_midlow_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_welfare_midlow_history_ogc_fid_seq', 248365, true);


--
-- Name: socl_welfare_midlow_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_welfare_midlow_ogc_fid_seq', 432236, true);


--
-- Name: socl_welfare_organization_plc_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_welfare_organization_plc_history_ogc_fid_seq', 15277, true);


--
-- Name: socl_welfare_organization_plc_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_welfare_organization_plc_ogc_fid_seq', 11588, true);


--
-- Name: socl_welfare_people_ppl_history_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_welfare_people_ppl_history_seq', 2906301, true);


--
-- Name: socl_welfare_people_ppl_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.socl_welfare_people_ppl_ogc_fid_seq', 3626525, true);


--
-- Name: tdx_bus_live_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tdx_bus_live_ogc_fid_seq', 413748703, true);


--
-- Name: tdx_bus_route_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tdx_bus_route_history_ogc_fid_seq', 1, true);


--
-- Name: tdx_bus_route_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tdx_bus_route_ogc_fid_seq', 764, true);


--
-- Name: tdx_bus_station_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tdx_bus_station_history_ogc_fid_seq', 1, true);


--
-- Name: tdx_bus_station_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tdx_bus_station_ogc_fid_seq', 1, true);


--
-- Name: tdx_metro_line_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tdx_metro_line_ogc_fid_seq', 1, true);


--
-- Name: tdx_metro_station_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tdx_metro_station_ogc_fid_seq', 1, true);


--
-- Name: tour_2023_lantern_festival_mapping_table_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tour_2023_lantern_festival_mapping_table_ogc_fid_seq', 9873, true);


--
-- Name: tour_2023_lantern_festival_zone_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tour_2023_lantern_festival_zone_ogc_fid_seq', 1289, true);


--
-- Name: tour_2023_latern_festival_mapping_table_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tour_2023_latern_festival_mapping_table_ogc_fid_seq', 1036, true);


--
-- Name: tour_2023_latern_festival_point_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tour_2023_latern_festival_point_ogc_fid_seq', 463, true);


--
-- Name: tour_lantern_festival_sysmemorialhall_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tour_lantern_festival_sysmemorialhall_ogc_fid_seq', 21940, true);


--
-- Name: tp_building_bim_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tp_building_bim_ogc_fid_seq', 124557, true);


--
-- Name: tp_building_height_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tp_building_height_ogc_fid_seq', 373532, true);


--
-- Name: tp_cht_grid_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tp_cht_grid_ogc_fid_seq', 1, true);


--
-- Name: tp_district_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tp_district_history_ogc_fid_seq', 1, true);


--
-- Name: tp_fet_age_hr_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tp_fet_age_hr_ogc_fid_seq', 76311, true);


--
-- Name: tp_fet_hourly_popu_by_vil_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tp_fet_hourly_popu_by_vil_ogc_fid_seq', 2147052, true);


--
-- Name: tp_fet_work_live_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tp_fet_work_live_ogc_fid_seq', 3329, true);


--
-- Name: tp_road_center_line_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tp_road_center_line_ogc_fid_seq', 42483, true);


--
-- Name: tp_village_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tp_village_history_ogc_fid_seq', 1, true);


--
-- Name: tp_village_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tp_village_ogc_fid_seq', 7752, true);


--
-- Name: traffic_accident_location_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_accident_location_ogc_fid_seq', 14617253, true);


--
-- Name: traffic_accident_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_accident_ogc_fid_seq', 626605, true);


--
-- Name: traffic_bus_route_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_bus_route_history_ogc_fid_seq', 1, true);


--
-- Name: traffic_bus_route_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_bus_route_ogc_fid_seq', 382, true);


--
-- Name: traffic_bus_station_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_bus_station_history_ogc_fid_seq', 281151, true);


--
-- Name: traffic_bus_station_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_bus_station_ogc_fid_seq', 191699, true);


--
-- Name: traffic_bus_stop_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_bus_stop_ogc_fid_seq', 14574913, true);


--
-- Name: traffic_info_histories_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_info_histories_ogc_fid_seq', 1, true);


--
-- Name: traffic_lives_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_lives_history_ogc_fid_seq', 39323006, true);


--
-- Name: traffic_lives_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_lives_ogc_fid_seq', 39327120, true);


--
-- Name: traffic_metro_capacity_realtime_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_metro_capacity_realtime_history_ogc_fid_seq', 14664414, true);


--
-- Name: traffic_metro_capacity_realtime_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_metro_capacity_realtime_ogc_fid_seq', 15176475, true);


--
-- Name: traffic_metro_capacity_rtime_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_metro_capacity_rtime_ogc_fid_seq', 622005, true);


--
-- Name: traffic_metro_line_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_metro_line_history_ogc_fid_seq', 89, true);


--
-- Name: traffic_metro_line_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_metro_line_ogc_fid_seq', 59, true);


--
-- Name: traffic_metro_realtime_position_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_metro_realtime_position_history_ogc_fid_seq', 57265982, true);


--
-- Name: traffic_metro_realtime_position_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_metro_realtime_position_ogc_fid_seq', 56605498, true);


--
-- Name: traffic_metro_station_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_metro_station_history_ogc_fid_seq', 4995, true);


--
-- Name: traffic_metro_station_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_metro_station_ogc_fid_seq', 1620, true);


--
-- Name: traffic_metro_unusual_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_metro_unusual_history_ogc_fid_seq', 21399, true);


--
-- Name: traffic_metro_unusual_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_metro_unusual_ogc_fid_seq', 40, true);


--
-- Name: traffic_todayworks_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_todayworks_history_ogc_fid_seq', 1773800, true);


--
-- Name: traffic_youbike_one_realtime_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_youbike_one_realtime_history_ogc_fid_seq', 17226614, true);


--
-- Name: traffic_youbike_realtime_histories_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_youbike_realtime_histories_ogc_fid_seq', 3422686, true);


--
-- Name: traffic_youbike_station_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_youbike_station_ogc_fid_seq', 9444, true);


--
-- Name: traffic_youbike_two_realtime_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.traffic_youbike_two_realtime_history_ogc_fid_seq', 17768215, true);


--
-- Name: tran_parking_capacity_realtime_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tran_parking_capacity_realtime_history_ogc_fid_seq', 82499677, true);


--
-- Name: tran_parking_capacity_realtime_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tran_parking_capacity_realtime_ogc_fid_seq', 82499677, true);


--
-- Name: tran_parking_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tran_parking_history_ogc_fid_seq', 72536, true);


--
-- Name: tran_parking_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tran_parking_ogc_fid_seq', 73972, true);


--
-- Name: tran_ubike_realtime_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tran_ubike_realtime_history_ogc_fid_seq', 54669867, true);


--
-- Name: tran_ubike_realtime_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tran_ubike_realtime_ogc_fid_seq', 54669867, true);


--
-- Name: tran_ubike_station_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tran_ubike_station_history_ogc_fid_seq', 27533, true);


--
-- Name: tran_ubike_station_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tran_ubike_station_ogc_fid_seq', 27533, true);


--
-- Name: tran_urban_bike_path_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tran_urban_bike_path_history_ogc_fid_seq', 8516, true);


--
-- Name: tran_urban_bike_path_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tran_urban_bike_path_ogc_fid_seq', 8516, true);


--
-- Name: tw_village_center_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tw_village_center_ogc_fid_seq', 7965, true);


--
-- Name: tw_village_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tw_village_ogc_fid_seq', 7965, true);


--
-- Name: work_eco_park_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_eco_park_history_ogc_fid_seq', 184, true);


--
-- Name: work_eco_park_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_eco_park_ogc_fid_seq', 184, true);


--
-- Name: work_floodgate_location_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_floodgate_location_history_ogc_fid_seq', 817, true);


--
-- Name: work_floodgate_location_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_floodgate_location_ogc_fid_seq', 1, true);


--
-- Name: work_garden_city_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_garden_city_history_ogc_fid_seq', 6796, true);


--
-- Name: work_garden_city_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_garden_city_ogc_fid_seq', 6796, true);


--
-- Name: work_goose_sanctuary_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_goose_sanctuary_history_ogc_fid_seq', 9, true);


--
-- Name: work_goose_sanctuary_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_goose_sanctuary_ogc_fid_seq', 9, true);


--
-- Name: work_nature_reserve_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_nature_reserve_history_ogc_fid_seq', 12, true);


--
-- Name: work_nature_reserve_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_nature_reserve_ogc_fid_seq', 12, true);


--
-- Name: work_park_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_park_history_ogc_fid_seq', 7632, true);


--
-- Name: work_park_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_park_ogc_fid_seq', 7632, true);


--
-- Name: work_pumping_station_location_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_pumping_station_location_history_ogc_fid_seq', 88, true);


--
-- Name: work_pumping_station_location_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_pumping_station_location_ogc_fid_seq', 1, true);


--
-- Name: work_rainfall_station_location_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_rainfall_station_location_history_ogc_fid_seq', 164, true);


--
-- Name: work_rainfall_station_location_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_rainfall_station_location_ogc_fid_seq', 164, true);


--
-- Name: work_riverside_bike_path_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_riverside_bike_path_history_ogc_fid_seq', 741, true);


--
-- Name: work_riverside_bike_path_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_riverside_bike_path_ogc_fid_seq', 749, true);


--
-- Name: work_riverside_park_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_riverside_park_history_ogc_fid_seq', 742962, true);


--
-- Name: work_riverside_park_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_riverside_park_ogc_fid_seq', 742962, true);


--
-- Name: work_school_greening_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_school_greening_history_ogc_fid_seq', 270, true);


--
-- Name: work_school_greening_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_school_greening_ogc_fid_seq', 270, true);


--
-- Name: work_sewer_location_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_sewer_location_history_ogc_fid_seq', 1, true);


--
-- Name: work_sewer_location_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_sewer_location_ogc_fid_seq', 1, true);


--
-- Name: work_sidewalk_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_sidewalk_history_ogc_fid_seq', 122105, true);


--
-- Name: work_sidewalk_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_sidewalk_ogc_fid_seq', 122105, true);


--
-- Name: work_soil_liquefaction_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_soil_liquefaction_history_ogc_fid_seq', 1088, true);


--
-- Name: work_soil_liquefaction_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_soil_liquefaction_ogc_fid_seq', 1088, true);


--
-- Name: work_street_light_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_street_light_history_ogc_fid_seq', 34997771, true);


--
-- Name: work_street_light_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_street_light_ogc_fid_seq', 34997771, true);


--
-- Name: work_street_tree_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_street_tree_history_ogc_fid_seq', 1035349, true);


--
-- Name: work_street_tree_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_street_tree_ogc_fid_seq', 1075704, true);


--
-- Name: work_underpass_location_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_underpass_location_history_ogc_fid_seq', 1, true);


--
-- Name: work_underpass_location_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_underpass_location_ogc_fid_seq', 1, true);


--
-- Name: work_urban_agricultural_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_urban_agricultural_history_ogc_fid_seq', 441, true);


--
-- Name: work_urban_agricultural_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_urban_agricultural_ogc_fid_seq', 441, true);


--
-- Name: work_urban_reserve_history_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_urban_reserve_history_ogc_fid_seq', 4086, true);


--
-- Name: work_urban_reserve_ogc_fid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.work_urban_reserve_ogc_fid_seq', 4086, true);


--
-- Name: topology_id_seq; Type: SEQUENCE SET; Schema: topology; Owner: postgres
--

SELECT pg_catalog.setval('topology.topology_id_seq', 1, false);


--
-- Name: app_calcu_monthly_socl_welfare_people_ppl app_calcu_monthly_socl_welfare_people_ppl_seq_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.app_calcu_monthly_socl_welfare_people_ppl
    ADD CONSTRAINT app_calcu_monthly_socl_welfare_people_ppl_seq_pkey PRIMARY KEY (ogc_fid);


--
-- Name: building_unsued_land building_unsued_land_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.building_unsued_land
    ADD CONSTRAINT building_unsued_land_pkey PRIMARY KEY (ogc_fid);


--
-- Name: patrol_criminal_case patrol_criminal_case_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patrol_criminal_case
    ADD CONSTRAINT patrol_criminal_case_pkey PRIMARY KEY (ogc_fid);


--
-- Name: patrol_rain_floodgate patrol_rain_floodgate_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.patrol_rain_floodgate
    ADD CONSTRAINT patrol_rain_floodgate_pkey PRIMARY KEY (ogc_fid);


--
-- Name: socl_welfare_organization_plc socl_welfare_organization_plc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.socl_welfare_organization_plc
    ADD CONSTRAINT socl_welfare_organization_plc_pkey PRIMARY KEY (ogc_fid);


--
-- Name: app_calcu_monthly_socl_welfare_people_ppl auto_app_calcu_monthly_socl_welfare_people_ppl_mtime; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER auto_app_calcu_monthly_socl_welfare_people_ppl_mtime BEFORE INSERT OR UPDATE ON public.app_calcu_monthly_socl_welfare_people_ppl FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: building_unsued_land auto_building_unsued_land_mtime; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER auto_building_unsued_land_mtime BEFORE INSERT OR UPDATE ON public.building_unsued_land FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: building_unsued_public auto_building_unsued_public_mtime; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER auto_building_unsued_public_mtime BEFORE INSERT OR UPDATE ON public.building_unsued_public FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: patrol_criminal_case auto_patrol_criminal_case_mtime; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER auto_patrol_criminal_case_mtime BEFORE INSERT OR UPDATE ON public.patrol_criminal_case FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- Name: socl_welfare_organization_plc auto_socl_welfare_organization_plc_mtime; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER auto_socl_welfare_organization_plc_mtime BEFORE INSERT OR UPDATE ON public.socl_welfare_organization_plc FOR EACH ROW EXECUTE FUNCTION public.trigger_set_timestamp();


--
-- PostgreSQL database dump complete
--

