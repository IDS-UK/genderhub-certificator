<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>

	<title><cfoutput>Certificator - #pageTitle#</cfoutput></title>

	<link rel="stylesheet" href="http://yui.yahooapis.com/pure/0.6.0/pure-min.css">
	<link rel="stylesheet" href="main.css">
	<!---
	<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js"></script>
	--->
</head>
<body>

<div class="pure-menu pure-menu-horizontal"">

<ul class="pure-menu-list">
	<li class="pure-menu-item"><a class="pure-button pure-button-primary" href="index.cfm">Home</a></li>
	<li class="pure-menu-item" style="background-color: #ddd; padding: 1px 2px 1px 2px; border-radius: 3px;">
	
	<cfquery name="getActiveSets" datasource="certificates">
		SELECT set_name, count(set_name) as RecepientCount
		FROM people
		WHERE status = 0
		GROUP BY set_name
	</cfquery>
	<cfquery name="getCompletedSets" datasource="certificates">
		SELECT set_name, count(set_name) as RecepientCount
		FROM people
		WHERE status = 1
		GROUP BY set_name
	</cfquery>
	<form method="get" class="pure-form pure-form-aligned" action="index.cfm">
	<select name="GetSet" id="GetSet">
		<option value="0">Select Set</option>
		<cfif getActiveSets.recordcount GTE 1>
			<option value="0">Active Sets <cfoutput>#chr(8628)#</cfoutput></option>
		</cfif>
		<cfoutput query="getActiveSets">
			<cfif isDefined("url.GetSet")>
				<cfif url.GetSet IS set_name>
					<option value="#set_name#" selected="selected"> &nbsp; #set_name#, #dateformat(getSetDate(set_name),"d-mmm-yy")# (#RecepientCount#)</option>
				<cfelse>
					<option value="#set_name#"> &nbsp; #set_name#, #dateformat(getSetDate(set_name),"d-mmm-yy")# (#RecepientCount#)</option>
				</cfif>
			<cfelse>
				<option value="#set_name#"> &nbsp; #set_name#, #dateformat(getSetDate(set_name),"d-mmm-yy")# (#RecepientCount#)</option>
			</cfif>
		</cfoutput>
		<option value="0">Completed Sets <cfoutput>#chr(8628)#</cfoutput></option>
		<cfoutput query="getCompletedSets">
			<option value="#set_name#"> &nbsp; #set_name#, #dateformat(getSetDate(set_name),"d-mmm-yy")# (#RecepientCount#)</option>
		</cfoutput>
	</select>
	<input type="submit" name="submit" id="submit" value="Load" class="pure-button pure-button-primary">
	</form>
	</li>
	<!---
	<cfif isDefined("url.GetSet")>
		<cfquery name="getCertificates" datasource="certificates">
			SELECT [uid],[cert_path],[cert_domain],[admin_email],[email_template],[set_name]
			FROM certificates 
			WHERE set_name = '#trim(url.GetSet)#'
		</cfquery>
		<cfif getCertificates.recordcount IS 0>
			<cfoutput><li class="pure-menu-item"><a class="pure-button pure-button-primary" href="SetDetails.cfm?GetSet=#url.GetSet#&action=add">Add Set Details</a></li></cfoutput>
		<cfelse>
			<cfoutput><li class="pure-menu-item"><a class="pure-button pure-button-primary" href="SetDetails.cfm?GetSet=#url.GetSet#&action=edit">Edit Set Details</a></li></cfoutput>
		</cfif>
	</cfif>
	--->
</div>