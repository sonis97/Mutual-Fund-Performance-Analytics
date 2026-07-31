-- =====================================================
-- Bluestock Mutual Fund Analytics Project
-- Database Schema (PostgreSQL)
-- Author: Saurabh Soni
-- =====================================================






-- Table: public.fund_master

-- DROP TABLE IF EXISTS public.fund_master;

CREATE TABLE IF NOT EXISTS public.fund_master
(
    amfi_code integer NOT NULL,
    fund_house character varying(100) COLLATE pg_catalog."default",
    scheme_name character varying(255) COLLATE pg_catalog."default",
    category character varying(50) COLLATE pg_catalog."default",
    sub_category character varying(100) COLLATE pg_catalog."default",
    plan character varying(30) COLLATE pg_catalog."default",
    launch_date date,
    benchmark character varying(100) COLLATE pg_catalog."default",
    expense_ratio_pct numeric(5,2),
    exit_load_pct numeric(5,2),
    min_sip_amount integer,
    min_lumpsum_amount integer,
    fund_manager character varying(100) COLLATE pg_catalog."default",
    risk_category character varying(50) COLLATE pg_catalog."default",
    sebi_category_code character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT fund_master_pkey PRIMARY KEY (amfi_code)
)










-- Table: public.aum_by_fund_house

-- DROP TABLE IF EXISTS public.aum_by_fund_house;

CREATE TABLE IF NOT EXISTS public.aum_by_fund_house
(
    date date,
    fund_house character varying(100) COLLATE pg_catalog."default",
    aum_lakh_crore numeric(10,2),
    aum_crore bigint,
    num_schemes integer
)









-- Table: public.benchmark_indices

-- DROP TABLE IF EXISTS public.benchmark_indices;

CREATE TABLE IF NOT EXISTS public.benchmark_indices
(
    date date,
    index_name character varying(100) COLLATE pg_catalog."default",
    close_value numeric(12,2)
)









-- Table: public.category_inflows

-- DROP TABLE IF EXISTS public.category_inflows;

CREATE TABLE IF NOT EXISTS public.category_inflows
(
    month date,
    category character varying(100) COLLATE pg_catalog."default",
    net_inflow_crore numeric(12,2)
)







-- Table: public.industry_folio_count

-- DROP TABLE IF EXISTS public.industry_folio_count;

CREATE TABLE IF NOT EXISTS public.industry_folio_count
(
    month date,
    total_folios_crore numeric(10,2),
    equity_folios_crore numeric(10,2),
    debt_folios_crore numeric(10,2),
    hybrid_folios_crore numeric(10,2),
    others_folios_crore numeric(10,2)
)









-- Table: public.investor_transactions

-- DROP TABLE IF EXISTS public.investor_transactions;

CREATE TABLE IF NOT EXISTS public.investor_transactions
(
    investor_id character varying(30) COLLATE pg_catalog."default",
    transaction_date date,
    amfi_code integer,
    transaction_type character varying(30) COLLATE pg_catalog."default",
    amount_inr integer,
    state character varying(50) COLLATE pg_catalog."default",
    city character varying(100) COLLATE pg_catalog."default",
    city_tier character varying(10) COLLATE pg_catalog."default",
    age_group character varying(20) COLLATE pg_catalog."default",
    gender character varying(20) COLLATE pg_catalog."default",
    annual_income_lakh numeric(8,2),
    payment_mode character varying(50) COLLATE pg_catalog."default",
    kyc_status character varying(30) COLLATE pg_catalog."default",
    CONSTRAINT investor_transactions_amfi_code_fkey FOREIGN KEY (amfi_code)
        REFERENCES public.fund_master (amfi_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)









-- Table: public.monthly_sip_inflows

-- DROP TABLE IF EXISTS public.monthly_sip_inflows;

CREATE TABLE IF NOT EXISTS public.monthly_sip_inflows
(
    month date,
    sip_inflow_crore integer,
    active_sip_accounts_crore numeric(10,2),
    new_sip_accounts_lakh numeric(10,2),
    sip_aum_lakh_crore numeric(10,2),
    yoy_growth_pct numeric(10,2)
)








-- Table: public.nav_history

-- DROP TABLE IF EXISTS public.nav_history;

CREATE TABLE IF NOT EXISTS public.nav_history
(
    amfi_code integer,
    date date,
    nav numeric(10,4),
    CONSTRAINT nav_history_amfi_code_fkey FOREIGN KEY (amfi_code)
        REFERENCES public.fund_master (amfi_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)









-- Table: public.portfolio_holdings

-- DROP TABLE IF EXISTS public.portfolio_holdings;

CREATE TABLE IF NOT EXISTS public.portfolio_holdings
(
    amfi_code integer,
    stock_symbol character varying(30) COLLATE pg_catalog."default",
    stock_name character varying(255) COLLATE pg_catalog."default",
    sector character varying(100) COLLATE pg_catalog."default",
    weight_pct numeric(6,2),
    market_value_cr numeric(12,2),
    current_price_inr numeric(12,2),
    portfolio_date date,
    CONSTRAINT portfolio_holdings_amfi_code_fkey FOREIGN KEY (amfi_code)
        REFERENCES public.fund_master (amfi_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)









-- Table: public.scheme_performance

-- DROP TABLE IF EXISTS public.scheme_performance;

CREATE TABLE IF NOT EXISTS public.scheme_performance
(
    amfi_code integer NOT NULL,
    scheme_name character varying(255) COLLATE pg_catalog."default",
    fund_house character varying(100) COLLATE pg_catalog."default",
    category character varying(50) COLLATE pg_catalog."default",
    plan character varying(30) COLLATE pg_catalog."default",
    return_1yr_pct numeric(6,2),
    return_3yr_pct numeric(6,2),
    return_5yr_pct numeric(6,2),
    benchmark_3yr_pct numeric(6,2),
    alpha numeric(6,2),
    beta numeric(6,2),
    sharpe_ratio numeric(6,2),
    sortino_ratio numeric(6,2),
    std_dev_ann_pct numeric(6,2),
    max_drawdown_pct numeric(6,2),
    aum_crore bigint,
    expense_ratio_pct numeric(5,2),
    morningstar_rating integer,
    risk_grade character varying(30) COLLATE pg_catalog."default",
    CONSTRAINT scheme_performance_pkey PRIMARY KEY (amfi_code),
    CONSTRAINT scheme_performance_amfi_code_fkey FOREIGN KEY (amfi_code)
        REFERENCES public.fund_master (amfi_code) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

