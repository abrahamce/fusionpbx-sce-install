CREATE TABLE json_store (
	name varchar(255) not null,
	data text,
	json_store_uuid uuid PRIMARY KEY default gen_random_uuid()
	);

ALTER TABLE json_store OWNER TO fusionpbx;

CREATE TABLE agents (
    name character varying(255),
    system character varying(255),
    uuid character varying(255),
    type character varying(255),
    contact character varying(255),
    status character varying(255),
    state character varying(255),
    max_no_answer integer DEFAULT 0 NOT NULL,
    wrap_up_time integer DEFAULT 0 NOT NULL,
    reject_delay_time integer DEFAULT 0 NOT NULL,
    busy_delay_time integer DEFAULT 0 NOT NULL,
    no_answer_delay_time integer DEFAULT 0 NOT NULL,
    last_bridge_start integer DEFAULT 0 NOT NULL,
    last_bridge_end integer DEFAULT 0 NOT NULL,
    last_offered_call integer DEFAULT 0 NOT NULL,
    last_status_change integer DEFAULT 0 NOT NULL,
    no_answer_count integer DEFAULT 0 NOT NULL,
    calls_answered integer DEFAULT 0 NOT NULL,
    talk_time integer DEFAULT 0 NOT NULL,
    ready_time integer DEFAULT 0 NOT NULL,
    agent_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE agents OWNER TO fusionpbx;

CREATE TABLE aliases (
    sticky integer,
    alias character varying(128),
    command character varying(4096),
    hostname character varying(256),
    alias_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE aliases OWNER TO fusionpbx;

CREATE TABLE calls (
    call_uuid uuid PRIMARY KEY default gen_random_uuid(),
    call_created character varying(128),
    call_created_epoch integer,
    caller_uuid character varying(256),
    callee_uuid character varying(256),
    hostname character varying(256)
);


ALTER TABLE calls OWNER TO fusionpbx;

--
-- Name: channels; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE channels (
    uuid uuid PRIMARY KEY default gen_random_uuid(),
    direction character varying(32),
    created character varying(128),
    created_epoch integer,
    name character varying(1024),
    state character varying(64),
    cid_name character varying(1024),
    cid_num character varying(256),
    ip_addr character varying(256),
    dest character varying(1024),
    application character varying(128),
    application_data character varying(4096),
    dialplan character varying(128),
    context character varying(128),
    read_codec character varying(128),
    read_rate character varying(32),
    read_bit_rate character varying(32),
    write_codec character varying(128),
    write_rate character varying(32),
    write_bit_rate character varying(32),
    secure character varying(64),
    hostname character varying(256),
    presence_id character varying(4096),
    presence_data character varying(4096),
    accountcode character varying(256),
    callstate character varying(64),
    callee_name character varying(1024),
    callee_num character varying(256),
    callee_direction character varying(5),
    call_uuid character varying(256),
    sent_callee_name character varying(1024),
    sent_callee_num character varying(256),
    initial_cid_name character varying(1024),
    initial_cid_num character varying(256),
    initial_ip_addr character varying(256),
    initial_dest character varying(1024),
    initial_dialplan character varying(128),
    initial_context character varying(128)
);


ALTER TABLE channels OWNER TO fusionpbx;

CREATE VIEW basic_calls AS
 SELECT a.uuid,
    a.direction,
    a.created,
    a.created_epoch,
    a.name,
    a.state,
    a.cid_name,
    a.cid_num,
    a.ip_addr,
    a.dest,
    a.presence_id,
    a.presence_data,
    a.accountcode,
    a.callstate,
    a.callee_name,
    a.callee_num,
    a.callee_direction,
    a.call_uuid,
    a.hostname,
    a.sent_callee_name,
    a.sent_callee_num,
    b.uuid AS b_uuid,
    b.direction AS b_direction,
    b.created AS b_created,
    b.created_epoch AS b_created_epoch,
    b.name AS b_name,
    b.state AS b_state,
    b.cid_name AS b_cid_name,
    b.cid_num AS b_cid_num,
    b.ip_addr AS b_ip_addr,
    b.dest AS b_dest,
    b.presence_id AS b_presence_id,
    b.presence_data AS b_presence_data,
    b.accountcode AS b_accountcode,
    b.callstate AS b_callstate,
    b.callee_name AS b_callee_name,
    b.callee_num AS b_callee_num,
    b.callee_direction AS b_callee_direction,
    b.sent_callee_name AS b_sent_callee_name,
    b.sent_callee_num AS b_sent_callee_num,
    c.call_created_epoch
   FROM ((channels a
     LEFT JOIN calls c ON ((((a.uuid)::text = (c.caller_uuid)::text) AND ((a.hostname)::text = (c.hostname)::text))))
     LEFT JOIN channels b ON ((((b.uuid)::text = (c.callee_uuid)::text) AND ((b.hostname)::text = (c.hostname)::text))))
  WHERE (((a.uuid)::text = (c.caller_uuid)::text) OR (NOT ((a.uuid)::text IN ( SELECT calls.callee_uuid
           FROM calls))));


ALTER TABLE basic_calls OWNER TO fusionpbx;

CREATE TABLE complete (
    sticky integer,
    a1 character varying(128),
    a2 character varying(128),
    a3 character varying(128),
    a4 character varying(128),
    a5 character varying(128),
    a6 character varying(128),
    a7 character varying(128),
    a8 character varying(128),
    a9 character varying(128),
    a10 character varying(128),
    hostname character varying(256),
    complete_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE complete OWNER TO fusionpbx;

--
-- Name: db_data; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE db_data (
    hostname character varying(255),
    realm character varying(255),
    data_key character varying(255),
    data character varying(255),
    db_data_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE db_data OWNER TO fusionpbx;

CREATE VIEW detailed_calls AS
 SELECT a.uuid,
    a.direction,
    a.created,
    a.created_epoch,
    a.name,
    a.state,
    a.cid_name,
    a.cid_num,
    a.ip_addr,
    a.dest,
    a.application,
    a.application_data,
    a.dialplan,
    a.context,
    a.read_codec,
    a.read_rate,
    a.read_bit_rate,
    a.write_codec,
    a.write_rate,
    a.write_bit_rate,
    a.secure,
    a.hostname,
    a.presence_id,
    a.presence_data,
    a.accountcode,
    a.callstate,
    a.callee_name,
    a.callee_num,
    a.callee_direction,
    a.call_uuid,
    a.sent_callee_name,
    a.sent_callee_num,
    b.uuid AS b_uuid,
    b.direction AS b_direction,
    b.created AS b_created,
    b.created_epoch AS b_created_epoch,
    b.name AS b_name,
    b.state AS b_state,
    b.cid_name AS b_cid_name,
    b.cid_num AS b_cid_num,
    b.ip_addr AS b_ip_addr,
    b.dest AS b_dest,
    b.application AS b_application,
    b.application_data AS b_application_data,
    b.dialplan AS b_dialplan,
    b.context AS b_context,
    b.read_codec AS b_read_codec,
    b.read_rate AS b_read_rate,
    b.read_bit_rate AS b_read_bit_rate,
    b.write_codec AS b_write_codec,
    b.write_rate AS b_write_rate,
    b.write_bit_rate AS b_write_bit_rate,
    b.secure AS b_secure,
    b.hostname AS b_hostname,
    b.presence_id AS b_presence_id,
    b.presence_data AS b_presence_data,
    b.accountcode AS b_accountcode,
    b.callstate AS b_callstate,
    b.callee_name AS b_callee_name,
    b.callee_num AS b_callee_num,
    b.callee_direction AS b_callee_direction,
    b.call_uuid AS b_call_uuid,
    b.sent_callee_name AS b_sent_callee_name,
    b.sent_callee_num AS b_sent_callee_num,
    c.call_created_epoch
   FROM ((channels a
     LEFT JOIN calls c ON ((((a.uuid)::text = (c.caller_uuid)::text) AND ((a.hostname)::text = (c.hostname)::text))))
     LEFT JOIN channels b ON ((((b.uuid)::text = (c.callee_uuid)::text) AND ((b.hostname)::text = (c.hostname)::text))))
  WHERE (((a.uuid)::text = (c.caller_uuid)::text) OR (NOT ((a.uuid)::text IN ( SELECT calls.callee_uuid
           FROM calls))));


ALTER TABLE detailed_calls OWNER TO fusionpbx;

CREATE TABLE fifo_bridge (
    fifo_name character varying(1024) NOT NULL,
    caller_uuid character varying(255) NOT NULL,
    caller_caller_id_name character varying(255),
    caller_caller_id_number character varying(255),
    consumer_uuid character varying(255) NOT NULL,
    consumer_outgoing_uuid character varying(255),
    bridge_start integer,
    fifo_bridge_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE fifo_bridge OWNER TO fusionpbx;

--
-- Name: fifo_callers; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE fifo_callers (
    fifo_name character varying(255) NOT NULL,
    uuid character varying(255) NOT NULL,
    caller_caller_id_name character varying(255),
    caller_caller_id_number character varying(255),
    "timestamp" integer,
    fifo_caller_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE fifo_callers OWNER TO fusionpbx;

--
-- Name: fifo_outbound; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE fifo_outbound (
    uuid character varying(255),
    fifo_name character varying(255),
    originate_string character varying(255),
    simo_count integer,
    use_count integer,
    timeout integer,
    lag integer,
    next_avail integer DEFAULT 0 NOT NULL,
    expires integer DEFAULT 0 NOT NULL,
    static integer DEFAULT 0 NOT NULL,
    outbound_call_count integer DEFAULT 0 NOT NULL,
    outbound_fail_count integer DEFAULT 0 NOT NULL,
    hostname character varying(255),
    taking_calls integer DEFAULT 1 NOT NULL,
    status character varying(255),
    outbound_call_total_count integer DEFAULT 0 NOT NULL,
    outbound_fail_total_count integer DEFAULT 0 NOT NULL,
    active_time integer DEFAULT 0 NOT NULL,
    inactive_time integer DEFAULT 0 NOT NULL,
    manual_calls_out_count integer DEFAULT 0 NOT NULL,
    manual_calls_in_count integer DEFAULT 0 NOT NULL,
    manual_calls_out_total_count integer DEFAULT 0 NOT NULL,
    manual_calls_in_total_count integer DEFAULT 0 NOT NULL,
    ring_count integer DEFAULT 0 NOT NULL,
    start_time integer DEFAULT 0 NOT NULL,
    stop_time integer DEFAULT 0 NOT NULL,
    fifo_outbound_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE fifo_outbound OWNER TO fusionpbx;


CREATE TABLE group_data (
    hostname character varying(255),
    groupname character varying(255),
    url character varying(255),
    group_data_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE group_data OWNER TO fusionpbx;

--
-- Name: interfaces; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE interfaces (
    type character varying(128),
    name character varying(1024),
    description character varying(4096),
    ikey character varying(1024),
    filename character varying(4096),
    syntax character varying(4096),
    hostname character varying(256),
    interace_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE interfaces OWNER TO fusionpbx;

--
-- Name: limit_data; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE limit_data (
    hostname character varying(255),
    realm character varying(255),
    id character varying(255),
    uuid character varying(255),
    limit_data_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE limit_data OWNER TO fusionpbx;


CREATE TABLE members (
    queue character varying(255),
    system character varying(255),
    uuid character varying(255) DEFAULT ''::character varying NOT NULL,
    session_uuid character varying(255) DEFAULT ''::character varying NOT NULL,
    cid_number character varying(255),
    cid_name character varying(255),
    system_epoch integer DEFAULT 0 NOT NULL,
    joined_epoch integer DEFAULT 0 NOT NULL,
    rejoined_epoch integer DEFAULT 0 NOT NULL,
    bridge_epoch integer DEFAULT 0 NOT NULL,
    abandoned_epoch integer DEFAULT 0 NOT NULL,
    base_score integer DEFAULT 0 NOT NULL,
    skill_score integer DEFAULT 0 NOT NULL,
    serving_agent character varying(255),
    serving_system character varying(255),
    state character varying(255),
    member_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE members OWNER TO fusionpbx;

--
-- Name: nat; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE nat (
    sticky integer,
    port integer,
    proto integer,
    hostname character varying(256),
    nat_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE nat OWNER TO fusionpbx;

--
-- Name: recovery; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE recovery (
    runtime_uuid character varying(255),
    technology character varying(255),
    profile_name character varying(255),
    hostname character varying(255),
    uuid uuid PRIMARY KEY default gen_random_uuid(),
    metadata text
);


ALTER TABLE recovery OWNER TO fusionpbx;



CREATE TABLE registrations (
    reg_user character varying(256),
    realm character varying(256),
    token character varying(256),
    url text,
    expires integer,
    network_ip character varying(256),
    network_port character varying(256),
    network_proto character varying(256),
    hostname character varying(256),
    metadata character varying(256),
    registration_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE registrations OWNER TO fusionpbx;

--
-- Name: sip_authentication; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE sip_authentication (
    nonce character varying(255),
    expires bigint,
    profile_name character varying(255),
    hostname character varying(255),
    last_nc integer,
    sip_authentication_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE sip_authentication OWNER TO fusionpbx;

--
-- Name: sip_dialogs; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE sip_dialogs (
    call_id character varying(255),
    uuid character varying(255),
    sip_to_user character varying(255),
    sip_to_host character varying(255),
    sip_from_user character varying(255),
    sip_from_host character varying(255),
    contact_user character varying(255),
    contact_host character varying(255),
    state character varying(255),
    direction character varying(255),
    user_agent character varying(255),
    profile_name character varying(255),
    hostname character varying(255),
    contact character varying(255),
    presence_id character varying(255),
    presence_data character varying(255),
    call_info character varying(255),
    call_info_state character varying(255) DEFAULT ''::character varying,
    expires bigint DEFAULT 0,
    status character varying(255),
    rpid character varying(255),
    sip_to_tag character varying(255),
    sip_from_tag character varying(255),
    rcd integer DEFAULT 0 NOT NULL,
    sip_dialog_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE sip_dialogs OWNER TO fusionpbx;



CREATE TABLE sip_presence (
    sip_user character varying(255),
    sip_host character varying(255),
    status character varying(255),
    rpid character varying(255),
    expires bigint,
    user_agent character varying(255),
    profile_name character varying(255),
    hostname character varying(255),
    network_ip character varying(255),
    network_port character varying(6),
    open_closed character varying(255),
    sip_presence_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE sip_presence OWNER TO fusionpbx;

--
-- Name: sip_registrations; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE sip_registrations (
    call_id character varying(255),
    sip_user character varying(255),
    sip_host character varying(255),
    presence_hosts character varying(255),
    contact character varying(1024),
    status character varying(255),
    ping_status character varying(255),
    ping_count integer,
    ping_time bigint,
    force_ping integer,
    rpid character varying(255),
    expires bigint,
    ping_expires integer DEFAULT 0 NOT NULL,
    user_agent character varying(255),
    server_user character varying(255),
    server_host character varying(255),
    profile_name character varying(255),
    hostname character varying(255),
    network_ip character varying(255),
    network_port character varying(6),
    sip_username character varying(255),
    sip_realm character varying(255),
    mwi_user character varying(255),
    mwi_host character varying(255),
    orig_server_host character varying(255),
    orig_hostname character varying(255),
    sub_host character varying(255),
    sip_registration_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE sip_registrations OWNER TO fusionpbx;

--
-- Name: sip_shared_appearance_dialogs; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE sip_shared_appearance_dialogs (
    profile_name character varying(255),
    hostname character varying(255),
    contact_str character varying(255),
    call_id character varying(255),
    network_ip character varying(255),
    expires bigint,
    sip_shared_appearance_dialog_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE sip_shared_appearance_dialogs OWNER TO fusionpbx;


CREATE TABLE sip_shared_appearance_subscriptions (
    subscriber character varying(255),
    call_id character varying(255),
    aor character varying(255),
    profile_name character varying(255),
    hostname character varying(255),
    contact_str character varying(255),
    network_ip character varying(255),
    sip_shared_appearance_subscription_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE sip_shared_appearance_subscriptions OWNER TO fusionpbx;

--
-- Name: sip_subscriptions; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE sip_subscriptions (
    proto character varying(255),
    sip_user character varying(255),
    sip_host character varying(255),
    sub_to_user character varying(255),
    sub_to_host character varying(255),
    presence_hosts character varying(255),
    event character varying(255),
    contact character varying(1024),
    call_id character varying(255),
    full_from character varying(255),
    full_via character varying(255),
    expires bigint,
    user_agent character varying(255),
    accept character varying(255),
    profile_name character varying(255),
    hostname character varying(255),
    network_port character varying(6),
    network_ip character varying(255),
    version integer DEFAULT 0 NOT NULL,
    orig_proto character varying(255),
    full_to character varying(255),
    sip_subscription_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE sip_subscriptions OWNER TO fusionpbx;

--
-- Name: tasks; Type: TABLE; Schema: public; Owner: fusionpbx; Tablespace:
--

CREATE TABLE tasks (
    task_id integer,
    task_desc character varying(4096),
    task_group character varying(1024),
    task_runtime bigint,
    task_sql_manager integer,
    hostname character varying(256),
    task_uuid uuid PRIMARY KEY default gen_random_uuid()
);

ALTER TABLE tasks OWNER TO fusionpbx;

CREATE TABLE tiers (
    queue character varying(255),
    agent character varying(255),
    state character varying(255),
    level integer DEFAULT 1 NOT NULL,
    "position" integer DEFAULT 1 NOT NULL,
    tier_uuid uuid PRIMARY KEY default gen_random_uuid()
);


ALTER TABLE tiers OWNER TO fusionpbx;

CREATE INDEX alias1 ON aliases USING btree (alias);
CREATE INDEX calls1 ON calls USING btree (hostname);
CREATE INDEX callsidx1 ON calls USING btree (hostname);
CREATE INDEX channels1 ON channels USING btree (hostname);
CREATE INDEX chidx1 ON channels USING btree (hostname);
CREATE INDEX complete1 ON complete USING btree (a1, hostname);
CREATE INDEX complete10 ON complete USING btree (a10, hostname);
CREATE INDEX complete11 ON complete USING btree (a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, hostname);
CREATE INDEX complete2 ON complete USING btree (a2, hostname);
CREATE INDEX complete3 ON complete USING btree (a3, hostname);
CREATE INDEX complete4 ON complete USING btree (a4, hostname);
CREATE INDEX complete5 ON complete USING btree (a5, hostname);
CREATE INDEX complete6 ON complete USING btree (a6, hostname);
CREATE INDEX complete7 ON complete USING btree (a7, hostname);
CREATE INDEX complete8 ON complete USING btree (a8, hostname);
CREATE INDEX complete9 ON complete USING btree (a9, hostname);
CREATE UNIQUE INDEX dd_data_key_realm ON db_data USING btree (data_key, realm);
CREATE INDEX dd_realm ON db_data USING btree (realm);
CREATE INDEX eeuuindex ON calls USING btree (callee_uuid);
CREATE INDEX eeuuindex2 ON calls USING btree (call_uuid);
CREATE INDEX eruuindex ON calls USING btree (caller_uuid, hostname);
CREATE INDEX gd_groupname ON group_data USING btree (groupname);
CREATE INDEX gd_url ON group_data USING btree (url);
CREATE INDEX ld_hostname ON limit_data USING btree (hostname);
CREATE INDEX ld_id ON limit_data USING btree (id);
CREATE INDEX ld_realm ON limit_data USING btree (realm);
CREATE INDEX ld_uuid ON limit_data USING btree (uuid);
CREATE INDEX nat_map_port_proto ON nat USING btree (port, proto, hostname);
CREATE INDEX recovery1 ON recovery USING btree (technology);
CREATE INDEX recovery2 ON recovery USING btree (profile_name);
CREATE INDEX recovery3 ON recovery USING btree (uuid);
CREATE INDEX regindex1 ON registrations USING btree (reg_user, realm, hostname);
CREATE INDEX sa_expires ON sip_authentication USING btree (expires);
CREATE INDEX sa_hostname ON sip_authentication USING btree (hostname);
CREATE INDEX sa_last_nc ON sip_authentication USING btree (last_nc);
CREATE INDEX sa_nonce ON sip_authentication USING btree (nonce);
CREATE INDEX sd_call_id ON sip_dialogs USING btree (call_id);
CREATE INDEX sd_call_info ON sip_dialogs USING btree (call_info);
CREATE INDEX sd_call_info_state ON sip_dialogs USING btree (call_info_state);
CREATE INDEX sd_expires ON sip_dialogs USING btree (expires);
CREATE INDEX sd_hostname ON sip_dialogs USING btree (hostname);
CREATE INDEX sd_presence_data ON sip_dialogs USING btree (presence_data);
CREATE INDEX sd_presence_id ON sip_dialogs USING btree (presence_id);
CREATE INDEX sd_rcd ON sip_dialogs USING btree (rcd);
CREATE INDEX sd_sip_from_host ON sip_dialogs USING btree (sip_from_host);
CREATE INDEX sd_sip_from_tag ON sip_dialogs USING btree (sip_from_tag);
CREATE INDEX sd_sip_from_user ON sip_dialogs USING btree (sip_from_user);
CREATE INDEX sd_sip_to_host ON sip_dialogs USING btree (sip_to_host);
CREATE INDEX sd_sip_to_tag ON sip_dialogs USING btree (sip_to_tag);
CREATE INDEX sd_uuid ON sip_dialogs USING btree (uuid);
CREATE INDEX sp_expires ON sip_presence USING btree (expires);
CREATE INDEX sp_hostname ON sip_presence USING btree (hostname);
CREATE INDEX sp_open_closed ON sip_presence USING btree (open_closed);
CREATE INDEX sp_profile_name ON sip_presence USING btree (profile_name);
CREATE INDEX sp_sip_host ON sip_presence USING btree (sip_host);
CREATE INDEX sp_sip_user ON sip_presence USING btree (sip_user);
CREATE INDEX sr_call_id ON sip_registrations USING btree (call_id);
CREATE INDEX sr_contact ON sip_registrations USING btree (contact);
CREATE INDEX sr_expires ON sip_registrations USING btree (expires);
CREATE INDEX sr_hostname ON sip_registrations USING btree (hostname);
CREATE INDEX sr_mwi_host ON sip_registrations USING btree (mwi_host);
CREATE INDEX sr_mwi_user ON sip_registrations USING btree (mwi_user);
CREATE INDEX sr_network_ip ON sip_registrations USING btree (network_ip);
CREATE INDEX sr_network_port ON sip_registrations USING btree (network_port);
CREATE INDEX sr_orig_hostname ON sip_registrations USING btree (orig_hostname);
CREATE INDEX sr_orig_server_host ON sip_registrations USING btree (orig_server_host);
CREATE INDEX sr_ping_expires ON sip_registrations USING btree (ping_expires);
CREATE INDEX sr_ping_status ON sip_registrations USING btree (ping_status);
CREATE INDEX sr_presence_hosts ON sip_registrations USING btree (presence_hosts);
CREATE INDEX sr_profile_name ON sip_registrations USING btree (profile_name);
CREATE INDEX sr_sip_host ON sip_registrations USING btree (sip_host);
CREATE INDEX sr_sip_realm ON sip_registrations USING btree (sip_realm);
CREATE INDEX sr_sip_user ON sip_registrations USING btree (sip_user);
CREATE INDEX sr_sip_username ON sip_registrations USING btree (sip_username);
CREATE INDEX sr_status ON sip_registrations USING btree (status);
CREATE INDEX sr_sub_host ON sip_registrations USING btree (sub_host);
CREATE INDEX ss_call_id ON sip_subscriptions USING btree (call_id);
CREATE INDEX ss_contact ON sip_subscriptions USING btree (contact);
CREATE INDEX ss_event ON sip_subscriptions USING btree (event);
CREATE INDEX ss_expires ON sip_subscriptions USING btree (expires);
CREATE INDEX ss_full_from ON sip_subscriptions USING btree (full_from);
CREATE INDEX ss_hostname ON sip_subscriptions USING btree (hostname);
CREATE INDEX ss_multi ON sip_subscriptions USING btree (call_id, profile_name, hostname);
CREATE INDEX ss_network_ip ON sip_subscriptions USING btree (network_ip);
CREATE INDEX ss_network_port ON sip_subscriptions USING btree (network_port);
CREATE INDEX ss_orig_proto ON sip_subscriptions USING btree (orig_proto);
CREATE INDEX ss_presence_hosts ON sip_subscriptions USING btree (presence_hosts);
CREATE INDEX ss_profile_name ON sip_subscriptions USING btree (profile_name);
CREATE INDEX ss_proto ON sip_subscriptions USING btree (proto);
CREATE INDEX ss_sip_host ON sip_subscriptions USING btree (sip_host);
CREATE INDEX ss_sip_user ON sip_subscriptions USING btree (sip_user);
CREATE INDEX ss_sub_to_host ON sip_subscriptions USING btree (sub_to_host);
CREATE INDEX ss_sub_to_user ON sip_subscriptions USING btree (sub_to_user);
CREATE INDEX ss_version ON sip_subscriptions USING btree (version);
CREATE INDEX ssa_aor ON sip_shared_appearance_subscriptions USING btree (aor);
CREATE INDEX ssa_hostname ON sip_shared_appearance_subscriptions USING btree (hostname);
CREATE INDEX ssa_network_ip ON sip_shared_appearance_subscriptions USING btree (network_ip);
CREATE INDEX ssa_profile_name ON sip_shared_appearance_subscriptions USING btree (profile_name);
CREATE INDEX ssa_subscriber ON sip_shared_appearance_subscriptions USING btree (subscriber);
CREATE INDEX ssd_call_id ON sip_shared_appearance_dialogs USING btree (call_id);
CREATE INDEX ssd_contact_str ON sip_shared_appearance_dialogs USING btree (contact_str);
CREATE INDEX ssd_expires ON sip_shared_appearance_dialogs USING btree (expires);
CREATE INDEX ssd_hostname ON sip_shared_appearance_dialogs USING btree (hostname);
CREATE INDEX ssd_profile_name ON sip_shared_appearance_dialogs USING btree (profile_name);
CREATE INDEX tasks1 ON tasks USING btree (hostname, task_id);
CREATE INDEX uuindex ON channels USING btree (uuid, hostname);
CREATE INDEX uuindex2 ON channels USING btree (call_uuid);

