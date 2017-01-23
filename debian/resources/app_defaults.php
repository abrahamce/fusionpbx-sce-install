<?php
/*
	FusionPBX
	Version: MPL 1.1

	The contents of this file are subject to the Mozilla Public License Version
	1.1 (the "License"); you may not use this file except in compliance with
	the License. You may obtain a copy of the License at
	http://www.mozilla.org/MPL/

	Software distributed under the License is distributed on an "AS IS" basis,
	WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
	for the specific language governing rights and limitations under the
	License.

	The Original Code is FusionPBX

	The Initial Developer of the Original Code is
	Mark J Crane <markjcrane@fusionpbx.com>
	Portions created by the Initial Developer are Copyright (C) 2008-2012
	the Initial Developer. All Rights Reserved.

	Contributor(s):
	Mark J Crane <markjcrane@fusionpbx.com>
*/

if ($domains_processed == 1) {

//create a json string
$vars = <<<EOD
[
{"var_name":"domain","var_value":"\$\${local_ip_v4}","var_cat":"Domain","var_enabled":"true","var_description":"U2V0cyB0aGUgZGVmYXVsdCBkb21haW4u"},
{"var_name":"domain_name","var_value":"\$\${domain}","var_cat":"Domain","var_enabled":"true","var_description":""},
{"var_name":"sound_prefix","var_value":"\$\${sounds_dir}/en/us/callie","var_cat":"Sound","var_enabled":"true","var_description":"U2V0cyB0aGUgc291bmQgZGlyZWN0b3J5Lg=="},
{"var_name":"hold_music","var_value":"local_stream://default","var_cat":"Music on Hold","var_enabled":"true","var_description":""},
{"var_name":"global_codec_prefs","var_value":"G7221@32000h,G7221@16000h,G722,PCMU,PCMA,GSM","var_cat":"Codecs","var_enabled":"true","var_description":"RzcyMjFAMzIwMDBoLEc3MjIxQDE2MDAwaCxHNzIyLFBDTVUsUENNQSxpTEJDLEdTTSxIMjYzLEgyNjQ="},
{"var_name":"outbound_codec_prefs","var_value":"PCMU,PCMA,GSM","var_cat":"Codecs","var_enabled":"true","var_description":"ZGVmYXVsdDogUENNVSxQQ01BLEdTTQ=="},
{"var_name":"media_mix_inbound_outbound_codecs","var_value":"true","var_cat":"Codecs","var_enabled":"true","var_description":""},
{"var_name":"xmpp_client_profile","var_value":"xmppc","var_cat":"Dingaling","var_enabled":"true","var_description":"eG1wcF9jbGllbnRfcHJvZmlsZSBhbmQgeG1wcF9zZXJ2ZXJfcHJvZmlsZSB4bXBwX2NsaWVudF9wcm9maWxlIGNhbiBiZSBhbnkgc3RyaW5nLiB4bXBwX3NlcnZlcl9wcm9maWxlIGlzIGFwcGVuZGVkIHRvICJkaW5nYWxpbmdfIiB0byBmb3JtIHRoZSBkYXRhYmFzZSBuYW1lIGNvbnRhaW5pbmcgdGhlICJzdWJzY3JpcHRpb25zIiB0YWJsZS4gdXNlZCBieTogZGluZ2FsaW5nLmNvbmYueG1sIGVudW0uY29uZi54bWw="},
{"var_name":"xmpp_server_profile","var_value":"xmpps","var_cat":"Dingaling","var_enabled":"true","var_description":""},
{"var_name":"bind_server_ip","var_value":"auto","var_cat":"Dingaling","var_enabled":"true","var_description":"Q2FuIGJlIGFuIGlwIGFkZHJlc3MsIGEgZG5zIG5hbWUsIG9yICJhdXRvIi4gVGhpcyBkZXRlcm1pbmVzIGFuIGlwIGFkZHJlc3MgYXZhaWxhYmxlIG9uIHRoaXMgaG9zdCB0byBiaW5kLiBJZiB5b3UgYXJlIHNlcGFyYXRpbmcgUlRQIGFuZCBTSVAgdHJhZmZpYywgeW91IHdpbGwgd2FudCB0byBoYXZlIHVzZSBkaWZmZXJlbnQgYWRkcmVzc2VzIHdoZXJlIHRoaXMgdmFyaWFibGUgYXBwZWFycy4gVXNlZCBieTogZGluZ2FsaW5nLmNvbmYueG1s"},
{"var_name":"external_rtp_ip","var_value":"\$\${local_ip_v4}","var_cat":"IP Address","var_enabled":"true","var_description":"KElmIHlvdScncmUgZ29pbmcgdG8gbG9hZCB0ZXN0IHRoZW4gcGxlYXNlIGlucHV0IHJlYWwgSVAgYWRkcmVzc2VzIGZvciBleHRlcm5hbF9ydHBfaXAgYW5kIGV4dGVybmFsX3NpcF9pcCkNCg0KQ2FuIGJlIGFuIG9uZSBvZjoNCiAgIGlwIGFkZHJlc3M6ICIxMi4zNC41Ni43OCINCiAgIGEgc3R1biBzZXJ2ZXIgbG9va3VwOiAic3R1bjpzdHVuLnNlcnZlci5jb20iDQogICBhIEROUyBuYW1lOiAiaG9zdDpob3N0LnNlcnZlci5jb20iDQoNCndoZXJlIGZzLm15ZG9tYWluLmNvbSBpcyBhIEROUyBBIHJlY29yZC11c2VmdWwgd2hlbiBmcyBpcyBvbiBhIGR5bmFtaWMgSVAgYWRkcmVzcywgYW5kIHVzZXMgYSBkeW5hbWljIEROUyB1cGRhdGVyLiBJZiB1bnNwZWNpZmllZCwgdGhlIGJpbmRfc2VydmVyX2lwIHZhbHVlIGlzIHVzZWQuIFVzZWQgYnk6IHNvZmlhLmNvbmYueG1sIGRpbmdhbGluZy5jb25mLnhtbA=="},
{"var_name":"external_sip_ip","var_value":"\$\${local_ip_v4}","var_cat":"IP Address","var_enabled":"true","var_description":"VXNlZCBhcyB0aGUgcHVibGljIElQIGFkZHJlc3MgZm9yIFNEUC4NCg0KQ2FuIGJlIGFuIG9uZSBvZjoNCiAgIGlwIGFkZHJlc3M6ICIxMi4zNC41Ni43OCINCiAgIGEgc3R1biBzZXJ2ZXIgbG9va3VwOiAic3R1bjpzdHVuLnNlcnZlci5jb20iDQogICBhIEROUyBuYW1lOiAiaG9zdDpob3N0LnNlcnZlci5jb20iDQoNCndoZXJlIGZzLm15ZG9tYWluLmNvbSBpcyBhIEROUyBBIHJlY29yZC11c2VmdWwgd2hlbiBmcyBpcyBvbiBhIGR5bmFtaWMgSVAgYWRkcmVzcywgYW5kIHVzZXMgYSBkeW5hbWljIEROUyB1cGRhdGVyLiBJZiB1bnNwZWNpZmllZCwgdGhlIGJpbmRfc2VydmVyX2lwIHZhbHVlIGlzIHVzZWQuIFVzZWQgYnk6IHNvZmlhLmNvbmYueG1sIGRpbmdhbGluZy5jb25mLnhtbA=="},
{"var_name":"hangup_on_subscriber_absent","var_value":"true","var_cat":"SIP","var_enabled":"false","var_description":"SGFuZ3VwIG9uIFNVQlNDUklCRVJfQUJTRU5U"},
{"var_name":"hangup_on_call_reject","var_value":"true","var_cat":"SIP","var_enabled":"false","var_description":"SGFuZ3VwIG9uIENBTExfUkVKRUNU"},
{"var_name":"unroll_loops","var_value":"true","var_cat":"SIP","var_enabled":"true","var_description":"VXNlZCB0byB0dXJuIG9uIHNpcCBsb29wYmFjayB1bnJvbGxpbmcu"},
{"var_name":"call_debug","var_value":"false","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"console_loglevel","var_value":"info","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"default_areacode","var_value":"208","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"dsn","var_value":"pgsql://hostaddr=127.0.0.1 port=5432 dbname=freeswitch user=freeswitch password=dsn_switch_password options='''' application_name=''freeswitch''","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"us-ring","var_value":"%(2000,4000,440,480)","var_cat":"Ringtones","var_enabled":"true","var_description":"RGVmYXVsdCByaW5ndG9uZSAoVVMp"},
{"var_name":"sit","var_value":"%(274,0,913.8);%(274,0,1370.6);%(380,0,1776.7)","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"sip_tls_version","var_value":"tlsv1","var_cat":"SIP","var_enabled":"true","var_description":"U0lQIGFuZCBUTFMgc2V0dGluZ3Mu"},
{"var_name":"internal_auth_calls","var_value":"true","var_cat":"SIP Profile: Internal","var_enabled":"true","var_description":""},
{"var_name":"internal_sip_port","var_value":"5060","var_cat":"SIP Profile: Internal","var_enabled":"true","var_description":""},
{"var_name":"internal_tls_port","var_value":"5061","var_cat":"SIP Profile: Internal","var_enabled":"true","var_description":""},
{"var_name":"internal_ssl_enable","var_value":"false","var_cat":"SIP Profile: Internal","var_enabled":"true","var_description":""},
{"var_name":"internal_ssl_dir","var_value":"\$\${conf_dir}/tls","var_cat":"SIP Profile: Internal","var_enabled":"true","var_description":""},
{"var_name":"external_auth_calls","var_value":"false","var_cat":"SIP Profile: External","var_enabled":"true","var_description":""},
{"var_name":"external_sip_port","var_value":"5080","var_cat":"SIP Profile: External","var_enabled":"true","var_description":""},
{"var_name":"external_tls_port","var_value":"5081","var_cat":"SIP Profile: External","var_enabled":"true","var_description":""},
{"var_name":"external_ssl_enable","var_value":"false","var_cat":"SIP Profile: External","var_enabled":"true","var_description":""},
{"var_name":"external_ssl_dir","var_value":"\$\${conf_dir}/tls","var_cat":"SIP Profile: External","var_enabled":"true","var_description":""},
{"var_name":"use_profile","var_value":"internal","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"default_language","var_value":"en","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"default_dialect","var_value":"us","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"default_voice","var_value":"callie","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"ajax_refresh_rate","var_value":"3000","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"xml_cdr_archive","var_value":"dir","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"ringback","var_value":"\$\${us-ring}","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"transfer_ringback","var_value":"\$\${us-ring}","var_cat":"Defaults","var_enabled":"true","var_description":""},
{"var_name":"record_ext","var_value":"wav","var_cat":"Defaults","var_enabled":"true","var_description":""}
]
EOD;

	// Set country depend variables as country code and international direct dialing code (exit code)
		if (!function_exists('set_country_vars')) {
			function set_country_vars($db, $x) {
				require "resources/countries.php";
	
				//$country_iso=$_SESSION['domain']['country']['iso_code'];
	
				$sql = "select default_setting_value as value from v_default_settings ";
				$sql .= "where default_setting_name = 'iso_code' ";
				$sql .= "and default_setting_category = 'domain' ";
				$sql .= "and default_setting_subcategory = 'country' ";
				$sql .= "and default_setting_enabled = 'true';";
				$prep_statement = $db->prepare(check_sql($sql));
				if ($prep_statement) {
					$prep_statement->execute();
					$result = $prep_statement->fetchAll(PDO::FETCH_ASSOC);
					if ( count($result)> 0) {
						$country_iso = $result[0]["value"];
					}
				}
				unset($prep_statement, $sql, $result);

				if ( $country_iso===NULL ) {
					return;
				}

				if(isset($countries[$country_iso])){
					$country = $countries[$country_iso];

					// Set default Country ISO code
					$sql = "select count(*) as num_rows from v_vars ";
					$sql .= "where var_name = 'default_country' ";
					$sql .= "and var_cat = 'Defaults' ";
					$prep_statement = $db->prepare(check_sql($sql));
					if ($prep_statement) {
						$prep_statement->execute();
						$row = $prep_statement->fetch(PDO::FETCH_ASSOC);
	
						if ($row['num_rows'] == 0) {
							$sql = "insert into v_vars ";
							$sql .= "(";
							$sql .= "var_uuid, ";
							$sql .= "var_name, ";
							$sql .= "var_value, ";
							$sql .= "var_cat, ";
							$sql .= "var_enabled, ";
							$sql .= "var_order, ";
							$sql .= "var_description ";
							$sql .= ")";
							$sql .= "values ";
							$sql .= "(";
							$sql .= "'".uuid()."', ";
							$sql .= "'default_country', ";
							$sql .= "'".$country["isocode"]."', ";
							$sql .= "'Defaults', ";
							$sql .= "'true', ";
							$sql .= "'".$x."', ";
							$sql .= "'' ";
							$sql .= ");";
							$db->exec(check_sql($sql));
							unset($sql, $row);
							$x++;
						}
					}
					unset($prep_statement, $sql);

					//Set default Country code
					$sql = "select count(*) as num_rows from v_vars ";
					$sql .= "where var_name = 'default_countrycode' ";
					$sql .= "and var_cat = 'Defaults' ";
					$prep_statement = $db->prepare(check_sql($sql));
					if ($prep_statement) {
						$prep_statement->execute();
						$row = $prep_statement->fetch(PDO::FETCH_ASSOC);
						if ($row['num_rows'] == 0) {
							$sql = "insert into v_vars ";
							$sql .= "(";
							$sql .= "var_uuid, ";
							$sql .= "var_name, ";
							$sql .= "var_value, ";
							$sql .= "var_cat, ";
							$sql .= "var_enabled, ";
							$sql .= "var_order, ";
							$sql .= "var_description ";
							$sql .= ")";
							$sql .= "values ";
							$sql .= "(";
							$sql .= "'".uuid()."', ";
							$sql .= "'default_countrycode', ";
							$sql .= "'".$country["countrycode"]."', ";
							$sql .= "'Defaults', ";
							$sql .= "'true', ";
							$sql .= "'".$x."', ";
							$sql .= "'' ";
							$sql .= ");";
							$db->exec(check_sql($sql));
							unset($sql, $row);
							$x++;
						}
					}
					unset($prep_statement, $sql);

					// Set default International Direct Dialing code
					$sql = "select count(*) as num_rows from v_vars ";
					$sql .= "where var_name = 'default_exitcode' ";
					$sql .= "and var_cat = 'Defaults' ";
					$prep_statement = $db->prepare(check_sql($sql));
					if ($prep_statement) {
						$prep_statement->execute();
						$row = $prep_statement->fetch(PDO::FETCH_ASSOC);
						if ($row['num_rows'] == 0) {
							$sql = "insert into v_vars ";
							$sql .= "(";
							$sql .= "var_uuid, ";
							$sql .= "var_name, ";
							$sql .= "var_value, ";
							$sql .= "var_cat, ";
							$sql .= "var_enabled, ";
							$sql .= "var_order, ";
							$sql .= "var_description ";
							$sql .= ")";
							$sql .= "values ";
							$sql .= "(";
							$sql .= "'".uuid()."', ";
							$sql .= "'default_exitcode', ";
							$sql .= "'".$country["exitcode"]."', ";
							$sql .= "'Defaults', ";
							$sql .= "'true', ";
							$sql .= "'".$x."', ";
							$sql .= "'' ";
							$sql .= ");";
							$db->exec(check_sql($sql));
							unset($sql, $row);
							$x++;
						}
					}
					unset($prep_statement, $sql);
	
					unset($countries);
				}
			}
		}

	//import default variables
		$result = json_decode($vars, true);

	//import ringtones from vars.xml
		$vars_xml = simplexml_load_file($_SERVER["PROJECT_ROOT"] . "/resources/templates/conf/vars.xml");
		foreach($vars_xml->{'X-PRE-PROCESS'} as $item) {
			if($item->attributes()->cmd == 'set') {
				$value = explode('=', $item->attributes()->data, 2);
				if(preg_match("/-ring/", $value[0])){
					$row = Array();
					$row['var_cat'] = 'Ringtones';
					$row['var_name'] = $value[0];
					$row['var_value'] = $value[1];
					$row['var_enabled'] = $item->attributes()->enabled;
					if(!isset($row['var_enabled'])){
						$row['var_enabled'] = 'true';
					}
					$row['var_description'] = $item->attributes()->description;
					if(!isset($row['var_description'])){
						$row['var_description'] = base64_encode('Imported from vars.xml');
					}
					$result[] = $row;
				}
				elseif(preg_match("/-tone/", $value[0])){
					$row = Array();
					$row['var_cat'] = 'Tones';
					$row['var_name'] = $value[0];
					$row['var_value'] = $value[1];
					$row['var_enabled'] = $item->attributes()->enabled;
					if(!isset($row['var_enabled'])){
						$row['var_enabled'] = 'true';
					}
					$row['var_description'] = $item->attributes()->description;
					if(!isset($row['var_description'])){
						$row['var_description'] = base64_encode('Imported from vars.xml');
					}
					$result[] = $row;
				}
			}
		}

	//migrate old ringtones
		$sql = "update v_vars ";
		$sql .= "set var_cat = 'Ringtones' ";
		$sql .= "where var_name like '%-ring' ";
		$sql .= "and var_cat = 'Defaults' ";
		$sql .= "and var_description = '' ";
		$prep_statement = $db->prepare(check_sql($sql));
		if ($prep_statement) {
			$prep_statement->execute();
		}
		
		$sql = "update v_vars ";
		$sql .= "set var_cat = 'Ringtones' ";
		$sql .= "where var_name like '%-ring' ";
		$sql .= "and var_cat = 'Defaults' ";
		$prep_statement = $db->prepare(check_sql($sql));
		if ($prep_statement) {
			$prep_statement->execute();
		}
		unset($prep_statement, $sql);

	//add missing variables
		$x = 1;
		foreach($result as $row) {

			$sql = "select count(*) as num_rows from v_vars ";
			$sql .= "where var_name = '".$row['var_name']."' ";
			$sql .= "and var_cat = '".$row['var_cat']."' ";
			$prep_statement = $db->prepare(check_sql($sql));
			if ($prep_statement) {
				$prep_statement->execute();
				$row2 = $prep_statement->fetch(PDO::FETCH_ASSOC);
				if ($row2['num_rows'] == 0) {

					$sql = "insert into v_vars ";
					$sql .= "(";
					$sql .= "var_uuid, ";
					$sql .= "var_name, ";
					$sql .= "var_value, ";
					$sql .= "var_cat, ";
					$sql .= "var_enabled, ";
					$sql .= "var_order, ";
					$sql .= "var_description ";
					$sql .= ") ";
					$sql .= "values ";
					$sql .= "(";
					$sql .= "'".uuid()."', ";
					$sql .= "'".$row['var_name']."', ";
					$sql .= "'".$row['var_value']."', ";
					$sql .= "'".$row['var_cat']."', ";
					$sql .= "'".$row['var_enabled']."', ";
					$sql .= "'".$x."', ";
					$sql .= "'".$row['var_description']."' ";
					$sql .= ");";
					$db->exec($sql);
					unset($sql);
					$x++;
				}
			}
			unset($prep_statement, $row2);
		}
		unset($result, $row);

	//adjust the variables required variables
		//set variables that depend on the number of domains
			if (count($_SESSION['domains']) > 1) {
				//disable the domain and domain_uuid for systems with multiple domains
					$sql = "update v_vars set ";
					$sql .= "var_enabled = 'false' ";
					$sql .= "where (var_name = 'domain' or var_name = 'domain_uuid') ";
					$db->exec(check_sql($sql));
					unset($sql);
			}
			else {
				//set the domain_uuid
					$sql = "select count(*) as num_rows from v_vars ";
					$sql .= "where var_name = 'domain_uuid' ";
					$prep_statement = $db->prepare($sql);
					if ($prep_statement) {
						$prep_statement->execute();
						$row = $prep_statement->fetch(PDO::FETCH_ASSOC);
						if ($row['num_rows'] == 0) {
							$sql = "insert into v_vars ";
							$sql .= "(";
							$sql .= "var_uuid, ";
							$sql .= "var_name, ";
							$sql .= "var_value, ";
							$sql .= "var_cat, ";
							$sql .= "var_enabled, ";
							$sql .= "var_order, ";
							$sql .= "var_description ";
							$sql .= ")";
							$sql .= "values ";
							$sql .= "(";
							$sql .= "'".uuid()."', ";
							$sql .= "'domain_uuid', ";
							$sql .= "'".$domain_uuid."', ";
							$sql .= "'Defaults', ";
							$sql .= "'true', ";
							$sql .= "'999', ";
							$sql .= "'' ";
							$sql .= ");";
							$db->exec(check_sql($sql));
							unset($sql);
						}
						unset($prep_statement, $row);
					}
			}

		//set country code variables
			set_country_vars($db, $x);

		//save the vars.xml file
			save_var_xml();
}
?>